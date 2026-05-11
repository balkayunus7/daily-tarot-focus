import "jsr:@supabase/functions-js/edge-runtime.d.ts"
import { createClient } from "jsr:@supabase/supabase-js@2"

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Methods": "GET, POST, OPTIONS",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
}

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders })
  }

  try {
    const authHeader = req.headers.get("authorization")
    if (!authHeader) {
      return new Response(JSON.stringify({ error: "Missing authorization header" }), {
        status: 401,
        headers: corsHeaders,
      })
    }

    const token = authHeader.replace("Bearer ", "")
    const [, payload] = token.split(".")
    const { sub: userId } = JSON.parse(atob(payload))

    if (!userId) {
      return new Response(JSON.stringify({ error: "Unauthorized" }), {
        status: 401,
        headers: corsHeaders,
      })
    }

    const supabase = createClient(
      Deno.env.get("SUPABASE_URL") ?? "",
      Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? "",
    )

    const body = await req.json().catch(() => ({}))
    const locale: string = body?.locale ?? "en"

    const [categoriesRes, spreadsRes] = await Promise.all([
      supabase.from("spread_categories").select("id, title, translations"),
      supabase.from("spreads").select(
        "id, title, description, card_count, positions, layout_type, category_id, translations",
      ),
    ])

    if (categoriesRes.error) {
      console.error("Categories error:", categoriesRes.error)
      return new Response(JSON.stringify({ error: categoriesRes.error.message }), {
        status: 500,
        headers: corsHeaders,
      })
    }

    if (spreadsRes.error) {
      console.error("Spreads error:", spreadsRes.error)
      return new Response(JSON.stringify({ error: spreadsRes.error.message }), {
        status: 500,
        headers: corsHeaders,
      })
    }

    const spreadsByCategory = (spreadsRes.data ?? []).reduce((acc, spread) => {
      const { translations, ...rest } = spread

      const rawPositions = typeof rest.positions === "string"
        ? JSON.parse(rest.positions)
        : rest.positions

      let parsed = { ...rest, positions: rawPositions }

      const parsedTranslations = typeof translations === "string"
        ? JSON.parse(translations)
        : translations

      if (locale !== "en" && parsedTranslations?.[locale]) {
        const tr = parsedTranslations[locale]

        let updatedPositions = parsed.positions
        if (tr.positions && Array.isArray(tr.positions)) {
          updatedPositions = parsed.positions.map((origPos: any) => {
            const translatedPos = tr.positions.find((tPos: any) => tPos.index === origPos.index)
            if (translatedPos) {
              return {
                ...origPos,
                ...(translatedPos.title && { title: translatedPos.title }),
                ...(translatedPos.question && { question: translatedPos.question }),
              }
            }
            return origPos
          })
        }

        parsed = {
          ...parsed,
          ...(tr.title && { title: tr.title }),
          ...(tr.description && { description: tr.description }),
          positions: updatedPositions,
        }
      }

      if (!acc[spread.category_id]) acc[spread.category_id] = []
      acc[spread.category_id].push(parsed)
      return acc
    }, {} as Record<string, unknown[]>)

    const result = Object.fromEntries(
      (categoriesRes.data ?? []).map((cat) => {
        const { translations, ...rest } = cat
        const parsedTranslations = typeof translations === "string"
          ? JSON.parse(translations)
          : translations

        const title = locale !== "en" && parsedTranslations?.[locale]?.title
          ? parsedTranslations[locale].title
          : rest.title

        return [
          cat.id,
          {
            id: cat.id,
            title,
            spreads: spreadsByCategory[cat.id] ?? [],
          },
        ]
      }),
    )

    return new Response(JSON.stringify(result), {
      status: 200,
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    })
  } catch (error) {
    console.error("Function error:", error)
    return new Response(JSON.stringify({ error: error.message }), {
      status: 500,
      headers: corsHeaders,
    })
  }
})
