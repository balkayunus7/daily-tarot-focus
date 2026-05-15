import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { createClient } from "jsr:@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Methods": "GET, POST, OPTIONS",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") {
    return json({ ok: true });
  }

  try {
    const authHeader = req.headers.get("authorization");
    if (!authHeader) {
      return json({ error: "Missing authorization header" }, 401);
    }

    const supabase = createClient(
      Deno.env.get("SUPABASE_URL") ?? "",
      Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? "",
    );

    const token = authHeader.replace("Bearer ", "");
    const { data: { user }, error: userError } = await supabase.auth.getUser(token);

    if (userError || !user) {
      return json({ error: "Unauthorized" }, 401);
    }

    const body = await req.json();
    const cardId = body.card_id as string | undefined;

    if (!cardId) {
      return json({ error: "card_id is required" }, 400);
    }

    const date = typeof body.date === "string" ? new Date(body.date) : new Date();
    const readingDate = Number.isNaN(date.getTime())
      ? new Date().toISOString().slice(0, 10)
      : date.toISOString().slice(0, 10);

    const { data, error } = await supabase
      .from("daily_tarot_records")
      .insert({
        user_id: user.id,
        card_id: cardId,
        is_reversed: Boolean(body.is_reversed),
        locale: typeof body.locale === "string" ? body.locale : "en",
        reading_date: readingDate,
        general_text: typeof body.general_text === "string" ? body.general_text : null,
        daily_advice: typeof body.daily_advice === "string" ? body.daily_advice : null,
        categories: Array.isArray(body.categories) ? body.categories : [],
      })
      .select()
      .single();

    if (error) {
      console.error("Database error:", error);
      return json({ error: error.message }, 500);
    }

    return json(data);
  } catch (error) {
    console.error("Function error:", error);
    return json(
      { error: error instanceof Error ? error.message : "Internal server error" },
      500,
    );
  }
});

function json(body: unknown, status = 200): Response {
  return new Response(JSON.stringify(body), {
    status,
    headers: { ...corsHeaders, "Content-Type": "application/json" },
  });
}
