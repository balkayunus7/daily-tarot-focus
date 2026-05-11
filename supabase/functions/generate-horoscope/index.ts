import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

// ── Types ───────────────────────────────────────────────────────────────────

interface HoroscopeRequest {
  sign: string;
  period: "daily" | "weekly" | "monthly";
  locale?: string;
}

interface CategoryResult {
  score: number;
  description: string;
}

interface TipResult {
  is_advice: boolean;
  text: string;
}

interface CriticalDaysResult {
  challenging: string;
  highlight: string;
}

interface ParsedHoroscope {
  general_text: string;
  categories: CategoryResult[];
  tips: TipResult[];
  critical_days: CriticalDaysResult;
}

const LANGUAGE_INSTRUCTIONS: Record<string, string> = {
  tr: "IMPORTANT: You MUST write ALL text content entirely in Turkish (Türkçe). Every description, tip, and interpretation must be in Turkish. Do not use any other language.",
  en: "Write all text content in English.",
};

// ── Main Handler ────────────────────────────────────────────────────────────

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

    const { sign, period, locale = "en" } = (await req.json()) as HoroscopeRequest;

    if (!sign || !period) {
      return json({ error: "sign and period are required" }, 400);
    }

    if (!["daily", "weekly", "monthly"].includes(period)) {
      return json({ error: "period must be daily, weekly, or monthly" }, 400);
    }

    const { data: profile } = await supabaseAdmin
      .from("users")
      .select("zodiac_sign, relationship_status, career_status")
      .eq("id", user.id)
      .maybeSingle();

    // ── Build prompt ──────────────────────────────────────────────────────

    const periodLabel =
      period === "daily" ? "today" : period === "weekly" ? "this week" : "this month";

    const criticalDaysInstruction =
      period === "daily"
        ? '"challenging" and "highlight" should each be a single short sentence about today.'
        : period === "weekly"
          ? '"challenging" should list specific day names (e.g. "Monday, Tuesday, Saturday"). "highlight" should also list specific day names.'
          : '"challenging" should list specific day numbers (e.g. "1, 2, 3, 8"). "highlight" should also list specific day numbers.';

    const profileParts = [
      profile?.zodiac_sign ? `Zodiac Sign: ${profile.zodiac_sign}` : `Zodiac Sign: ${sign}`,
      profile?.relationship_status ? `Relationship Status: ${profile.relationship_status}` : null,
      profile?.career_status ? `Career Status: ${profile.career_status}` : null,
    ]
      .filter(Boolean)
      .join("\n");

    const expectedSchema = JSON.stringify(
      {
        general_text: "<3-4 sentence general horoscope reading for this period>",
        categories: [
          { score: "<number 0-100>", description: "<1-2 sentence description for Love>" },
          { score: "<number 0-100>", description: "<1-2 sentence description for Finance>" },
          { score: "<number 0-100>", description: "<1-2 sentence description for Career>" },
          { score: "<number 0-100>", description: "<1-2 sentence description for Health>" },
          { score: "<number 0-100>", description: "<1-2 sentence description for Family>" },
        ],
        tips: [
          { is_advice: true, text: "<practical advice for this period>" },
          { is_advice: false, text: "<a warning to be cautious about for this period>" },
        ],
        critical_days: {
          challenging: "<see instructions>",
          highlight: "<see instructions>",
        },
      },
      null,
      2,
    );

    const languageInstruction = LANGUAGE_INSTRUCTIONS[locale] ?? LANGUAGE_INSTRUCTIONS["en"];

    const systemPrompt =
      `You are a professional astrologer providing personalized horoscope readings. ` +
      `Your readings should be insightful, empathetic, and practical. ` +
      `Tailor your interpretation to the person's life context (relationship, career) when available.\n\n` +
      `${languageInstruction}\n\n` +
      `CRITICAL: Your entire response must be raw JSON only. No markdown, no code fences, no preamble, no explanation. ` +
      `The response must be directly parseable by JSON.parse().`;

    const userPrompt = [
      `The person's profile:\n${profileParts}`,
      `Generate a personalized ${period} horoscope for ${sign} for ${periodLabel}.`,
      `\nFor the critical_days field: ${criticalDaysInstruction}`,
      `\nCategories must be exactly 5 items in this order: Love, Finance, Career, Health, Family.`,
      `Each category score must be a number between 0 and 100.`,
      `Tips should have exactly 2 items: one advice (is_advice: true) and one warning (is_advice: false).`,
      `\nRespond with ONLY the following JSON. Do not add any text before or after it. Replace every <...> placeholder:\n${expectedSchema}`,
    ].join("\n\n");

    // ── Call Replicate ────────────────────────────────────────────────────

    const replicateToken = Deno.env.get("REPLICATE_API_TOKEN");
    if (!replicateToken) throw new Error("REPLICATE_API_TOKEN is not configured");

    const replicateRes = await fetch(
      "https://api.replicate.com/v1/models/openai/gpt-5-nano/predictions",
      {
        method: "POST",
        headers: {
          Authorization: `Bearer ${replicateToken}`,
          "Content-Type": "application/json",
          Prefer: "wait=60",
        },
        body: JSON.stringify({
          input: {
            system_prompt: systemPrompt,
            prompt: userPrompt,
            max_tokens: 2048,
            temperature: 0.7,
          },
        }),
      },
    );

    if (!replicateRes.ok) {
      const errBody = await replicateRes.text();
      throw new Error(`Replicate error (${replicateRes.status}): ${errBody}`);
    }

    const prediction = await replicateRes.json();

    let rawOutput = "";
    if (prediction.status === "succeeded") {
      rawOutput = Array.isArray(prediction.output)
        ? prediction.output.join("")
        : String(prediction.output ?? "");
    } else if (prediction.urls?.get) {
      rawOutput = await pollPrediction(prediction.urls.get, replicateToken);
    } else {
      throw new Error(
        `Unexpected Replicate state: ${prediction.status} — ${prediction.error ?? ""}`,
      );
    }

    const parsed = extractJson(rawOutput);

    return json(parsed);
  } catch (err) {
    console.error("generate-horoscope error:", err);
    return json(
      { error: err instanceof Error ? err.message : "Internal server error" },
      500,
    );
  }
});

// ── Helpers ─────────────────────────────────────────────────────────────────

async function pollPrediction(url: string, token: string, maxAttempts = 30): Promise<string> {
  for (let attempt = 0; attempt < maxAttempts; attempt++) {
    await new Promise((r) => setTimeout(r, 2000));
    const res = await fetch(url, { headers: { Authorization: `Bearer ${token}` } });
    const prediction = await res.json();
    if (prediction.status === "succeeded") {
      return Array.isArray(prediction.output)
        ? prediction.output.join("")
        : String(prediction.output ?? "");
    }
    if (prediction.status === "failed" || prediction.status === "canceled") {
      throw new Error(`Replicate prediction ${prediction.status}: ${prediction.error ?? ""}`);
    }
  }
  throw new Error("Replicate prediction timed out");
}

function extractJson(raw: string): ParsedHoroscope {
  const cleaned = raw
    .replace(/```(?:json)?[\s]*/gi, "")
    .replace(/```[\s]*/gi, "")
    .trim();

  try {
    const parsed = JSON.parse(cleaned) as ParsedHoroscope;
    if (isValidHoroscope(parsed)) return parsed;
  } catch {
    /* continue */
  }

  const start = cleaned.indexOf("{");
  if (start !== -1) {
    let depth = 0;
    let inString = false;
    let escaped = false;

    for (let i = start; i < cleaned.length; i++) {
      const ch = cleaned[i];
      if (escaped) { escaped = false; continue; }
      if (ch === "\\" && inString) { escaped = true; continue; }
      if (ch === '"') { inString = !inString; continue; }
      if (inString) continue;

      if (ch === "{") depth++;
      else if (ch === "}") {
        depth--;
        if (depth === 0) {
          try {
            const parsed = JSON.parse(cleaned.slice(start, i + 1)) as ParsedHoroscope;
            if (isValidHoroscope(parsed)) return parsed;
          } catch {
            /* fall through */
          }
          break;
        }
      }
    }
  }

  console.error("JSON extraction failed. Raw:", cleaned.slice(0, 500));

  return {
    general_text: cleaned,
    categories: [
      { score: 0, description: "" },
      { score: 0, description: "" },
      { score: 0, description: "" },
      { score: 0, description: "" },
      { score: 0, description: "" },
    ],
    tips: [
      { is_advice: true, text: "" },
      { is_advice: false, text: "" },
    ],
    critical_days: { challenging: "", highlight: "" },
  };
}

function isValidHoroscope(v: unknown): v is ParsedHoroscope {
  if (typeof v !== "object" || v === null) return false;
  const h = v as ParsedHoroscope;
  return (
    typeof h.general_text === "string" &&
    h.general_text.length > 0 &&
    Array.isArray(h.categories) &&
    h.categories.length === 5 &&
    Array.isArray(h.tips) &&
    h.tips.length > 0 &&
    typeof h.critical_days === "object" &&
    h.critical_days !== null
  );
}

function json(body: unknown, status = 200): Response {
  return new Response(JSON.stringify(body), {
    status,
    headers: { ...corsHeaders, "Content-Type": "application/json" },
  });
}
