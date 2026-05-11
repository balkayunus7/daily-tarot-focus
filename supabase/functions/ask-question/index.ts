import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

interface CardRequest {
  card_id: string;
  position_index: number;
  is_reversed: boolean;
}

interface SpreadPosition {
  index: number;
  title: string;
  question: string;
}

interface CardMeanings {
  General?: string;
  general?: string;
  [key: string]: string | undefined;
}

interface CardRow {
  id: string;
  name: string;
  upright: CardMeanings;
  reversed: CardMeanings;
}

interface ParsedReading {
  card_interpretations: {
    position_index: number;
    card_id: string;
    card_name: string;
    is_reversed: boolean;
    interpretation: string;
  }[];
  general_interpretation: string;
}

const LANGUAGE_INSTRUCTIONS: Record<string, string> = {
  tr: "IMPORTANT: You MUST write ALL text content entirely in Turkish (Türkçe). Every interpretation, description, and summary must be in Turkish. Do not use any other language.",
  en: "Write all text content in English.",
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

    const { spread_category_id: _ignored, spread_id, reader_id, question, cards, locale = "en" } =
      await req.json() as {
        spread_category_id?: string;
        spread_id: string;
        reader_id: string;
        question?: string | null;
        cards: CardRequest[];
        locale?: string;
      };

    if (!spread_id || !reader_id || !Array.isArray(cards) || cards.length === 0) {
      return json({ error: "spread_id, reader_id, and cards are required" }, 400);
    }

    const cardIds = cards.map((c) => c.card_id);

    const [readerRes, spreadRes, profileRes, cardsRes] = await Promise.all([
      supabaseAdmin.from("readers").select("id, name, title, ai_prompt").eq("id", reader_id).single(),
      supabaseAdmin.from("spreads").select("id, title, description, positions").eq("id", spread_id).single(),
      supabaseAdmin.from("users").select("zodiac_sign, relationship_status, career_status").eq("id", user.id).maybeSingle(),
      supabaseAdmin.from("tarot_cards").select("id, name, upright, reversed").in("id", cardIds),
    ]);

    if (readerRes.error) throw new Error(`Reader not found: ${readerRes.error.message}`);
    if (spreadRes.error) throw new Error(`Spread not found: ${spreadRes.error.message}`);
    if (cardsRes.error) throw new Error(`Cards fetch failed: ${cardsRes.error.message}`);

    const reader = readerRes.data;
    const spread = spreadRes.data;
    const profile = profileRes.data;
    const cardMap = new Map<string, CardRow>(
      (cardsRes.data ?? []).map((c: CardRow) => [c.id, c]),
    );

    const positions: SpreadPosition[] =
      typeof spread.positions === "string" ? JSON.parse(spread.positions) : (spread.positions ?? []);

    const cardBlocks = cards.map((c) => {
      const cardData = cardMap.get(c.card_id);
      const position = positions.find((p) => p.index === c.position_index);
      const rawMeaning = c.is_reversed ? cardData?.reversed : cardData?.upright;
      const meaning =
        typeof rawMeaning === "object" && rawMeaning !== null
          ? (rawMeaning.General ?? rawMeaning.general ?? Object.values(rawMeaning)[0] ?? "")
          : String(rawMeaning ?? "");

      return `Position ${c.position_index} — ${position?.title ?? ""}` +
        (position?.question ? `\nPosition question: "${position.question}"` : "") +
        `\nCard: ${cardData?.name ?? c.card_id} (${c.is_reversed ? "Reversed" : "Upright"})` +
        `\nMeaning: ${meaning}`;
    }).join("\n\n");

    const profileParts = [
      profile?.zodiac_sign ? `Zodiac Sign: ${profile.zodiac_sign}` : null,
      profile?.relationship_status ? `Relationship: ${profile.relationship_status}` : null,
      profile?.career_status ? `Career: ${profile.career_status}` : null,
    ].filter(Boolean).join("\n");

    const expectedSchema = JSON.stringify({
      card_interpretations: cards.map((c) => ({
        position_index: c.position_index,
        card_id: c.card_id,
        card_name: cardMap.get(c.card_id)?.name ?? c.card_id,
        is_reversed: c.is_reversed,
        interpretation: "<2-3 sentence personalized interpretation for this position>",
      })),
      general_interpretation: "<4-5 sentence cohesive reading tying all cards together>",
    }, null, 2);

    const languageInstruction = LANGUAGE_INSTRUCTIONS[locale] ?? LANGUAGE_INSTRUCTIONS["en"];

    const systemPrompt = reader.ai_prompt +
      `\n\n${languageInstruction}` +
      "\n\nCRITICAL: Your entire response must be raw JSON only. No markdown, no code fences, no preamble, no explanation. The response must be directly parseable by JSON.parse().";

    const userPrompt = [
      profileParts ? `The person's profile:\n${profileParts}` : null,
      question ? `Their question: "${question}"` : null,
      `Spread: ${spread.title}`,
      `Spread description: ${spread.description}`,
      `\nCards drawn:\n\n${cardBlocks}`,
      `\nRespond with ONLY the following JSON. Do not add any text before or after it. Replace every <...> placeholder with your interpretation:\n${expectedSchema}`,
    ].filter(Boolean).join("\n\n");

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
      throw new Error(`Unexpected Replicate state: ${prediction.status} — ${prediction.error ?? ""}`);
    }

    const parsed = extractJson(rawOutput, cards);

    const { data: reading, error: insertError } = await supabaseAdmin
      .from("readings")
      .insert({
        user_id: user.id,
        reader_id,
        spread_id,
        question: question ?? null,
        cards,
        card_interpretations: parsed.card_interpretations,
        general_interpretation: parsed.general_interpretation,
      })
      .select("id")
      .single();

    if (insertError) {
      console.error("Failed to persist reading:", insertError.message);
    }

    return json({
      id: reading?.id ?? crypto.randomUUID(),
      spread_id,
      card_interpretations: parsed.card_interpretations,
      general_interpretation: parsed.general_interpretation,
    });
  } catch (err) {
    console.error("ask-question error:", err);
    return json({ error: err instanceof Error ? err.message : "Internal server error" }, 500);
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

function extractJson(raw: string, cards: CardRequest[]): ParsedReading {
  let cleaned = raw.replace(/```(?:json)?[\s]*/gi, "").replace(/```[\s]*/gi, "").trim();

  try {
    const parsed = JSON.parse(cleaned) as ParsedReading;
    if (isValidReading(parsed)) return parsed;
  } catch { /* continue */ }

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
            const parsed = JSON.parse(cleaned.slice(start, i + 1)) as ParsedReading;
            if (isValidReading(parsed)) return parsed;
          } catch { /* fall through */ }
          break;
        }
      }
    }
  }

  console.error("JSON extraction failed. Raw:", cleaned.slice(0, 500));
  return {
    card_interpretations: cards.map((c) => ({
      position_index: c.position_index,
      card_id: c.card_id,
      card_name: "",
      is_reversed: c.is_reversed,
      interpretation: "",
    })),
    general_interpretation: cleaned,
  };
}

function isValidReading(v: unknown): v is ParsedReading {
  if (typeof v !== "object" || v === null) return false;
  const r = v as ParsedReading;
  return (
    Array.isArray(r.card_interpretations) &&
    r.card_interpretations.length > 0 &&
    typeof r.general_interpretation === "string" &&
    r.general_interpretation.length > 0
  );
}

function json(body: unknown, status = 200): Response {
  return new Response(JSON.stringify(body), {
    status,
    headers: { ...corsHeaders, "Content-Type": "application/json" },
  });
}
