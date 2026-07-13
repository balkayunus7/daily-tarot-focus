// ============================================================================
// delete-user
//
// Deletes the authenticated user's rows from all user-owned tables, then
// removes the auth user itself. Called by the app via
// supabaseClient.functions.invoke('delete-user') with the user's JWT.
//
// Deploy: supabase functions deploy delete-user --project-ref wcokelgolrodijdxtvjn
// ============================================================================

import { createClient } from "npm:@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
};

// Every public table that stores user data, with its user-id column.
// Verified against the live schema (no FK cascades exist, so each table
// must be deleted explicitly).
const USER_TABLES: { table: string; column: string }[] = [
  { table: "daily_tarot_records", column: "user_id" },
  { table: "saved_readings", column: "user_id" },
  { table: "users", column: "user_id" },
];

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }
  if (req.method !== "POST") {
    return json({ error: "method not allowed" }, 405);
  }

  const authHeader = req.headers.get("Authorization") ?? "";
  const anonClient = createClient(
    Deno.env.get("SUPABASE_URL")!,
    Deno.env.get("SUPABASE_ANON_KEY")!,
    { global: { headers: { Authorization: authHeader } } },
  );

  const { data: { user }, error: authError } = await anonClient.auth.getUser();
  if (authError || !user) {
    return json({ error: "unauthorized" }, 401);
  }

  const admin = createClient(
    Deno.env.get("SUPABASE_URL")!,
    Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
  );

  for (const { table, column } of USER_TABLES) {
    const { error } = await admin.from(table).delete().eq(column, user.id);
    if (error) {
      console.error(`[delete-user] ${table}: ${error.message}`);
      return json({ error: `failed to delete ${table}` }, 500);
    }
  }

  const { error: deleteError } = await admin.auth.admin.deleteUser(user.id);
  if (deleteError) {
    console.error(`[delete-user] auth delete: ${deleteError.message}`);
    return json({ error: "failed to delete auth user" }, 500);
  }

  return json({ success: true });
});

function json(body: unknown, status = 200): Response {
  return new Response(JSON.stringify(body), {
    status,
    headers: { ...corsHeaders, "Content-Type": "application/json" },
  });
}
