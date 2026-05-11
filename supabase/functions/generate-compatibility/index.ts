import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const REPLICATE_API_TOKEN = Deno.env.get("REPLICATE_API_TOKEN")!;
const SUPABASE_URL = Deno.env.get("SUPABASE_URL")!;
const SUPABASE_SERVICE_ROLE_KEY = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

const LANGUAGE_INSTRUCTIONS: Record<string, string> = {
  tr: "IMPORTANT: You MUST write ALL text content entirely in Turkish (Türkçe). Every description and summary must be in Turkish. Do not use any other language.",
  en: "Write all text content in English.",
};

async function pollPrediction(predictionId: string): Promise<string> {
  const url = `https://api.replicate.com/v1/predictions/${predictionId}`;
  for (let i = 0; i < 60; i++) {
    await new Promise((r) => setTimeout(r, 2000));
    const res = await fetch(url, {
      headers: { Authorization: `Token ${REPLICATE_API_TOKEN}` },
    });
    const data = await res.json();
    if (data.status === "succeeded") return (data.output as string[]).join("");
    if (data.status === "failed") throw new Error("Prediction failed");
  }
  throw new Error("Prediction timed out");
}

function extractJson(raw: string): unknown {
  const start = raw.indexOf("{");
  const end = raw.lastIndexOf("}");
  if (start === -1 || end === -1) throw new Error("No JSON found in output");
  return JSON.parse(raw.slice(start, end + 1));
}

function isValid(data: unknown): boolean {
  if (typeof data !== "object" || data === null) return false;
  const d = data as Record<string, unknown>;
  if (typeof d.summary !== "string") return false;
  if (typeof d.overall_score !== "number") return false;
  if (!Array.isArray(d.categories) || d.categories.length !== 5) return false;
  return d.categories.every(
    (c) =>
      typeof c === "object" &&
      c !== null &&
      typeof (c as Record<string, unknown>).score === "number" &&
      typeof (c as Record<string, unknown>).description === "string",
  );
}

Deno.serve(async (req: Request) => {
  if (req.method === "OPTIONS") return new Response("ok", { headers: corsHeaders });

  try {
    const authHeader = req.headers.get("Authorization");
    if (!authHeader) return new Response("Unauthorized", { status: 401, headers: corsHeaders });

    const supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY);
    const { data: { user }, error } = await supabase.auth.getUser(authHeader.replace("Bearer ", ""));
    if (error || !user) return new Response("Unauthorized", { status: 401, headers: corsHeaders });

    const { my_sign, my_gender, partner_sign, partner_gender, locale = "en" } = await req.json();

    const languageInstruction = LANGUAGE_INSTRUCTIONS[locale] ?? LANGUAGE_INSTRUCTIONS["en"];

    const systemPrompt =
      `You are an expert astrologer specializing in zodiac compatibility.
Analyze the romantic compatibility between two signs and return ONLY valid JSON matching this exact structure.

${languageInstruction}

IMPORTANT INSTRUCTIONS FOR SCORING:
- Calculate genuine, realistic compatibility scores based on actual astrological principles.
- DO NOT use round numbers or multiples of 5 or 10 (e.g., strictly avoid 70, 75, 80, 85, 90). Use highly specific integers (e.g., 34, 47, 58, 68, 89).
- Break the "politeness bias". Not all pairings are good matches.
- For notoriously incompatible, clashing, or challenging pairings, drop the scores into the 30s and 40s.
- The absolute minimum score for any category or overall score should be around 30. Do not go below 30.
- Do not sugarcoat fundamental incompatibilities, but maintain a constructive astrological tone.

{
  "summary": "<4-5 sentence overall compatibility summary. Be honest about red flags and challenges if the match is bad, but keep it constructive.>",
  "overall_score": <CALCULATE_PRECISE_INTEGER_30_100>,
  "categories": [
    { "score": <CALCULATE_PRECISE_INTEGER_30_100>, "description": "<intimacy/sexuality description>" },
    { "score": <CALCULATE_PRECISE_INTEGER_30_100>, "description": "<trust description>" },
    { "score": <CALCULATE_PRECISE_INTEGER_30_100>, "description": "<communication description>" },
    { "score": <CALCULATE_PRECISE_INTEGER_30_100>, "description": "<emotions description>" },
    { "score": <CALCULATE_PRECISE_INTEGER_30_100>, "description": "<values description>" }
  ]
}

Categories must be in this exact order: Intimacy, Trust, Communication, Emotions, Values.
Ensure all <CALCULATE_PRECISE_INTEGER_30_100> placeholders are replaced by actual integer numbers.`;

    const userPrompt = `${my_gender} ${my_sign} and ${partner_gender} ${partner_sign} compatibility analysis.`;

    const predRes = await fetch("https://api.replicate.com/v1/models/openai/gpt-5-nano/predictions", {
      method: "POST",
      headers: {
        Authorization: `Token ${REPLICATE_API_TOKEN}`,
        "Content-Type": "application/json",
        Prefer: "wait",
      },
      body: JSON.stringify({
        input: {
          prompt: userPrompt,
          system_prompt: systemPrompt,
          max_tokens: 800,
        },
      }),
    });

    const predData = await predRes.json();
    let rawOutput: string;

    if (predData.status === "succeeded") {
      rawOutput = (predData.output as string[]).join("");
    } else if (predData.id) {
      rawOutput = await pollPrediction(predData.id);
    } else {
      throw new Error("Failed to start prediction");
    }

    const parsed = extractJson(rawOutput);
    if (!isValid(parsed)) throw new Error("Invalid response schema");

    return new Response(JSON.stringify(parsed), {
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  } catch (err) {
    console.error(err);
    return new Response(JSON.stringify({ error: String(err) }), {
      status: 500,
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  }
});
