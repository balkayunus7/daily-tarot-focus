import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

interface DailyPickRequest {
  locale?: string;
  date?: string;
  is_reversed: boolean;
  card: {
    id: string;
    name: string;
    category?: string;
    description?: string;
    upright_keywords?: string[];
    reversed_keywords?: string[];
    upright?: Record<string, string>;
    reversed?: Record<string, string>;
    correspondences?: Record<string, string>;
  };
}

interface CategoryResult {
  description: string;
}

interface ParsedDailyPick {
  general_text: string;
  categories: CategoryResult[];
  daily_advice: string;
}

const LANGUAGE_INSTRUCTIONS: Record<string, string> = {
  tr: "IMPORTANT: You MUST write ALL text content entirely in Turkish (Türkçe). Do not use any other language.",
  en: "Write all text content in English.",
};

const CATEGORY_COUNT = 5;
const CATEGORY_NAMES = ["Love", "Finance", "Career", "Health", "Family"] as const;

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

    const { card, is_reversed, date, locale = "en" } = await req.json() as DailyPickRequest;
    const normalizedLocale = normalizeLocale(locale);

    if (!card?.id || !card.name || typeof is_reversed !== "boolean") {
      return json({ error: "card and is_reversed are required" }, 400);
    }

    const { data: profile } = await supabaseAdmin
      .from("users")
      .select(
        "name, zodiac_sign, moon_sign, rising_sign, relationship_status, career_status, birth_date, location",
      )
      .eq("id", user.id)
      .maybeSingle();

    const readingDate = date ? new Date(date) : new Date();
    const readingDateLabel = Number.isNaN(readingDate.getTime())
      ? new Date().toISOString().slice(0, 10)
      : readingDate.toISOString().slice(0, 10);

    const orientation = is_reversed ? "reversed" : "upright";
    const activeMeanings = is_reversed ? card.reversed : card.upright;
    const activeKeywords = is_reversed ? card.reversed_keywords : card.upright_keywords;

    const profileParts = [
      profile?.name ? `Name: ${profile.name}` : null,
      profile?.zodiac_sign ? `Zodiac Sign: ${profile.zodiac_sign}` : null,
      profile?.moon_sign ? `Moon Sign: ${profile.moon_sign}` : null,
      profile?.rising_sign ? `Rising Sign: ${profile.rising_sign}` : null,
      profile?.relationship_status ? `Relationship Status: ${profile.relationship_status}` : null,
      profile?.career_status ? `Career Status: ${profile.career_status}` : null,
      profile?.birth_date ? `Birth Date: ${profile.birth_date}` : null,
      profile?.location ? `Location: ${profile.location}` : null,
    ].filter(Boolean).join("\n");

    const cardParts = [
      `Card: ${card.name}`,
      `Orientation: ${orientation}`,
      card.category ? `Category: ${card.category}` : null,
      card.description ? `Card description: ${card.description}` : null,
      activeKeywords?.length ? `Active keywords: ${activeKeywords.join(", ")}` : null,
      activeMeanings?.General ? `General meaning: ${activeMeanings.General}` : null,
      activeMeanings?.Love ? `Love meaning: ${activeMeanings.Love}` : null,
      activeMeanings?.Career ? `Career meaning: ${activeMeanings.Career}` : null,
      activeMeanings?.Finances ? `Finance meaning: ${activeMeanings.Finances}` : null,
      card.correspondences?.astrology ? `Astrology: ${card.correspondences.astrology}` : null,
      card.correspondences?.element ? `Element: ${card.correspondences.element}` : null,
    ].filter(Boolean).join("\n");

    const expectedSchema = JSON.stringify(
      {
        general_text:
          "<2-3 sentence daily tarot reading shaped by the card orientation and profile>",
        categories: CATEGORY_NAMES.map((name) => ({
          description: `<1-2 sentence practical insight for ${name}>`,
        })),
        daily_advice: "<one short practical daily advice sentence>",
      },
      null,
      2,
    );

    const languageInstruction =
      LANGUAGE_INSTRUCTIONS[normalizedLocale] ?? LANGUAGE_INSTRUCTIONS.en;

    const dailyContext = `
There is no user question here.

This is the user's daily card.

The primary lens is:
- what this card says about today's emotional tone
- what the user should notice today
- where energy flows easily
- where energy may be blocked or delayed
- what small practical choice would help today

The user should feel:
"This reading is clearly about my day."
`;

    const orientationContext = is_reversed
      ? `
The card is REVERSED.

Do not treat reversed as simply negative.

Read it as:
- blocked or delayed energy
- something internalized
- a pattern asking for awareness
- a warning to slow down, soften, or reconsider
- a place where the card's normal energy is harder to access today
`
      : `
The card is UPRIGHT.

Read it as:
- accessible energy
- something ready to move
- support, clarity, or momentum
- a place where the user can act with more confidence today
`;

    const systemPrompt = `
You are a professional tarot reader creating a concise personalized daily pick.

==================================================
DAILY PICK PRIORITY
==================================================

${dailyContext}

==================================================
CARD ORIENTATION
==================================================

${orientationContext}

The orientation must be clearly felt in every section.

==================================================
NATURAL HUMAN READING STYLE
==================================================

Do not sound like AI.
Do not sound like a coach.
Do not sound like a textbook.

Speak like a real tarot reader who is genuinely observing the card.

Sometimes naturally start with:

"The first thing I notice here..."
"What stands out today..."
"Honestly..."
"Something about this card feels..."

Do not force these every time.

Be natural.

==================================================
WRITING RULES
==================================================

Keep every section short.

general_text: 2-3 sentences.
Each category description: 1-2 sentences.
daily_advice: one short practical sentence.

Do not overexplain.
Do not use scores or percentages.
Do not use robotic phrases.

Avoid phrases like:
- The main obstacle is...
- The best action is...
- You need to master...
- Practical action...

Keep it:
- natural
- personal
- clear
- emotionally intelligent

==================================================
PERSONALIZATION
==================================================

Use the user's profile naturally.

Do not explicitly list profile data unless truly relevant.

==================================================
LANGUAGE
==================================================

${languageInstruction}

==================================================
OUTPUT RULES
==================================================

Return ONLY valid JSON.

Fill all placeholder strings.
No placeholders.
No markdown.
No explanations.
`;

    const userPrompt = [
      `Reading date: ${readingDateLabel}`,
      `The person's profile:\n${profileParts || "No profile details available."}`,
      `The selected tarot card:\n${cardParts}`,
      `Generate a daily pick interpretation with exactly 5 category items in this order: ${CATEGORY_NAMES.join(", ")}.`,
      `Do not include scores or percentages.`,
      `Each section must reflect that the card is ${orientation}.`,
      `Each category description must be 1-2 concise sentences. The daily_advice must be short and actionable.`,
      `Respond with ONLY the following JSON. Replace every <...> placeholder:\n${expectedSchema}`,
    ].join("\n\n");

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
            max_tokens: 1600,
            temperature: 0.72,
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

    return json(extractJson(rawOutput));
  } catch (err) {
    console.error("generate-daily-pick error:", err);
    return json(
      { error: err instanceof Error ? err.message : "Internal server error" },
      500,
    );
  }
});

async function pollPrediction(url: string, token: string, maxAttempts = 30): Promise<string> {
  for (let attempt = 0; attempt < maxAttempts; attempt++) {
    await new Promise((resolve) => setTimeout(resolve, 2000));
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

function extractJson(raw: string): ParsedDailyPick {
  const cleaned = raw
    .replace(/```(?:json)?[\s]*/gi, "")
    .replace(/```[\s]*/gi, "")
    .trim();

  try {
    return normalizeDailyPick(JSON.parse(cleaned));
  } catch {
    // Continue with balanced-brace extraction.
  }

  const start = cleaned.indexOf("{");
  if (start !== -1) {
    let depth = 0;
    let inString = false;
    let escaped = false;

    for (let i = start; i < cleaned.length; i++) {
      const ch = cleaned[i];
      if (escaped) {
        escaped = false;
        continue;
      }
      if (ch === "\\" && inString) {
        escaped = true;
        continue;
      }
      if (ch === '"') {
        inString = !inString;
        continue;
      }
      if (inString) continue;

      if (ch === "{") depth++;
      if (ch === "}") {
        depth--;
        if (depth === 0) {
          try {
            return normalizeDailyPick(JSON.parse(cleaned.slice(start, i + 1)));
          } catch {
            break;
          }
        }
      }
    }
  }

  console.error("JSON extraction failed. Raw:", cleaned.slice(0, 500));
  return fallbackDailyPick(cleaned);
}

function normalizeDailyPick(value: unknown): ParsedDailyPick {
  if (typeof value !== "object" || value === null) {
    throw new Error("Daily pick response is not an object");
  }

  const input = value as Record<string, unknown>;
  const rawCategories = Array.isArray(input.categories) ? input.categories : [];
  const categories = Array.from({ length: CATEGORY_COUNT }, (_, index) => {
    const raw = typeof rawCategories[index] === "object" && rawCategories[index] !== null
      ? rawCategories[index] as Record<string, unknown>
      : {};
    return { description: normalizeText(raw.description) };
  });

  const normalized = {
    general_text: normalizeText(input.general_text),
    categories,
    daily_advice: normalizeText(input.daily_advice),
  };

  if (!isValidDailyPick(normalized)) {
    throw new Error("Daily pick response failed validation");
  }

  return normalized;
}

function normalizeText(value: unknown): string {
  return typeof value === "string" ? value.trim() : "";
}

function normalizeLocale(locale: string): string {
  return locale.toLowerCase().split(/[-_]/)[0] || "en";
}

function isValidDailyPick(value: ParsedDailyPick): boolean {
  return (
    value.general_text.length > 0 &&
    value.categories.length === CATEGORY_COUNT &&
    value.categories.every((category) => typeof category.description === "string") &&
    value.daily_advice.length > 0
  );
}

function fallbackDailyPick(generalText: string): ParsedDailyPick {
  return {
    general_text: generalText || "Daily pick could not be generated clearly. Please try again.",
    categories: Array.from({ length: CATEGORY_COUNT }, () => ({ description: "" })),
    daily_advice: "",
  };
}

function json(body: unknown, status = 200): Response {
  return new Response(JSON.stringify(body), {
    status,
    headers: { ...corsHeaders, "Content-Type": "application/json" },
  });
}
