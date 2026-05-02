import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    const supabaseAdmin = createClient(
      Deno.env.get("SUPABASE_URL")!,
      Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
    );

    const jwt = req.headers.get("Authorization")?.replace("Bearer ", "");
    if (!jwt) return json({ error: "Missing authorization" }, 401);

    const { data: { user }, error: authError } = await supabaseAdmin.auth.getUser(jwt);
    if (authError || !user) return json({ error: "Unauthorized" }, 401);

    const { reading_id, note } = await req.json() as {
      reading_id: string;
      note?: string | null;
    };

    if (!reading_id) {
      return json({ error: "reading_id is required" }, 400);
    }

    const { data, error } = await supabaseAdmin
      .from("readings")
      .update({
        is_saved: true,
        note: note ?? null,
        saved_at: new Date().toISOString(),
      })
      .eq("id", reading_id)
      .eq("user_id", user.id)
      .select("id")
      .single();

    if (error) {
      console.error("Save reading error:", error.message);
      return json({ error: "Failed to save reading" }, 500);
    }

    return json({ id: data.id });
  } catch (err) {
    console.error("save-reading error:", err);
    return json({ error: err instanceof Error ? err.message : "Internal server error" }, 500);
  }
});

function json(body: unknown, status = 200): Response {
  return new Response(JSON.stringify(body), {
    status,
    headers: { ...corsHeaders, "Content-Type": "application/json" },
  });
}
