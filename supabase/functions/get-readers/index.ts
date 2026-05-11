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

    const supabase = createClient(
      Deno.env.get("SUPABASE_URL") ?? "",
      Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? "",
    )

    const token = authHeader.replace("Bearer ", "")
    const { data: { user }, error: userError } = await supabase.auth.getUser(token)

    if (userError || !user) {
      return new Response(JSON.stringify({ error: "Unauthorized" }), {
        status: 401,
        headers: corsHeaders,
      })
    }

    const body = await req.json().catch(() => ({}))
    const locale: string = body?.locale ?? "en"

    const { data, error } = await supabase
      .from("readers")
      .select("id, name, title, bio, tags, ai_prompt, image_url, translations")

    if (error) {
      console.error("Database error:", error)
      return new Response(JSON.stringify({ error: error.message }), {
        status: 500,
        headers: corsHeaders,
      })
    }

    const mapped = Object.fromEntries(
      (data ?? []).map((reader) => {
        const { translations, ...rest } = reader

        if (locale !== "en" && translations?.[locale]) {
          const tr = translations[locale]
          return [reader.id, {
            ...rest,
            ...(tr.title && { title: tr.title }),
            ...(tr.bio   && { bio:   tr.bio }),
            ...(tr.tags  && { tags:  tr.tags }),
          }]
        }

        return [reader.id, rest]
      }),
    )

    return new Response(JSON.stringify(mapped), {
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
