import "jsr:@supabase/functions-js/edge-runtime.d.ts"
import { createClient } from "jsr:@supabase/supabase-js@2"

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
}

function getPeriodFromProductId(productId: string): string {
  if (productId.includes("weekly")) return "1w"
  if (productId.includes("monthly")) return "1m"
  if (productId.includes("yearly")) return "1y"
  return "1m"
}

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders })
  }

  try {
    const authHeader = req.headers.get("authorization")
    const webhookSecret = Deno.env.get("REVENUECAT_WEBHOOK_SECRET") ?? ""

    console.log(`Auth header received: "${authHeader}"`)
    console.log(`Webhook secret configured: "${webhookSecret ? webhookSecret.substring(0, 8) + "..." : "NOT SET"}"`)

    // RevenueCat sends the secret directly without "Bearer" prefix
    if (webhookSecret && authHeader !== webhookSecret) {
      console.log("Auth mismatch — returning 401")
      return new Response(
        JSON.stringify({ error: "Unauthorized" }),
        { status: 401, headers: corsHeaders }
      )
    }

    const supabaseUrl = Deno.env.get("SUPABASE_URL") ?? ""
    const supabaseServiceKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? ""
    const supabase = createClient(supabaseUrl, supabaseServiceKey)

    const body = await req.json()
    const event = body.event

    if (!event) {
      return new Response(
        JSON.stringify({ error: "No event in body" }),
        { status: 400, headers: corsHeaders }
      )
    }

    const eventType = event.type
    const appUserId = event.app_user_id
    const productId = event.product_id

    console.log(`Webhook received: ${eventType} for user ${appUserId}, product: ${productId}`)

    const activateEvents = [
      "INITIAL_PURCHASE",
      "RENEWAL",
      "UNCANCELLATION",
      "NON_RENEWING_PURCHASE",
    ]

    const deactivateEvents = [
      "EXPIRATION",
      "CANCELLATION",
    ]

    if (activateEvents.includes(eventType)) {
      const premiumInfo = {
        plan: "premium",
        period: getPeriodFromProductId(productId),
        method: event.environment === "SANDBOX" ? "sandbox" : "paid",
        expires_at: event.expiration_at_ms
          ? new Date(event.expiration_at_ms).toISOString()
          : null,
        renews_at: event.expiration_at_ms
          ? new Date(event.expiration_at_ms).toISOString()
          : null,
      }

      const { error } = await supabase
        .from("users")
        .update({
          premium_info: premiumInfo,
          updated_at: new Date().toISOString(),
        })
        .eq("revenuecat_id", appUserId)

      if (error) {
        console.error("DB update error:", error)
        return new Response(
          JSON.stringify({ error: error.message }),
          { status: 500, headers: corsHeaders }
        )
      }

      console.log(`Premium activated for user ${appUserId}`)

    } else if (deactivateEvents.includes(eventType)) {
      const { error } = await supabase
        .from("users")
        .update({
          premium_info: null,
          updated_at: new Date().toISOString(),
        })
        .eq("revenuecat_id", appUserId)

      if (error) {
        console.error("DB update error:", error)
        return new Response(
          JSON.stringify({ error: error.message }),
          { status: 500, headers: corsHeaders }
        )
      }

      console.log(`Premium deactivated for user ${appUserId}`)
    }

    return new Response(JSON.stringify({ success: true }), {
      status: 200,
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    })

  } catch (error) {
    console.error("Webhook error:", error)
    return new Response(
      JSON.stringify({ error: error.message }),
      { status: 500, headers: corsHeaders }
    )
  }
})
