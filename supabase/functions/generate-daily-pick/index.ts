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

const CATEGORY_COUNT = 5;
const CATEGORY_NAMES = ["Love", "Finance", "Career", "Health", "Family"] as const;

const LANGUAGE_NAMES: Record<string, string> = {
  en: "English",
  tr: "Turkish (Turkiye Turkish)",
  es: "Spanish",
  pt: "Portuguese",
  fr: "French",
  de: "German",
  it: "Italian",
  ja: "Japanese",
  ko: "Korean",
  th: "Thai",
  "zh-TW": "Traditional Chinese",
  "zh-CN": "Simplified Chinese",
  ru: "Russian",
};

const CATEGORY_LABELS: Record<string, string[]> = {
  en: [...CATEGORY_NAMES],
  tr: ["Aşk", "Finans", "Kariyer", "Sağlık", "Aile"],
  es: ["Amor", "Finanzas", "Carrera", "Salud", "Familia"],
  pt: ["Amor", "Finanças", "Carreira", "Saúde", "Família"],
  fr: ["Amour", "Finances", "Carrière", "Santé", "Famille"],
  de: ["Liebe", "Finanzen", "Karriere", "Gesundheit", "Familie"],
  it: ["Amore", "Finanze", "Carriera", "Salute", "Famiglia"],
  ja: ["恋愛", "金運", "仕事", "健康", "家族"],
  ko: ["사랑", "재정", "직업", "건강", "가족"],
  th: ["ความรัก", "การเงิน", "อาชีพ", "สุขภาพ", "ครอบครัว"],
  "zh-TW": ["愛情", "財務", "事業", "健康", "家庭"],
  "zh-CN": ["爱情", "财务", "事业", "健康", "家庭"],
  ru: ["Любовь", "Финансы", "Карьера", "Здоровье", "Семья"],
};

const PROFILE_LABELS: Record<string, Record<string, string>> = {
  en: {
    name: "Name",
    zodiac_sign: "Zodiac Sign",
    moon_sign: "Moon Sign",
    rising_sign: "Rising Sign",
    relationship_status: "Relationship Status",
    career_status: "Career Status",
    birth_date: "Birth Date",
    location: "Location",
  },
  tr: {
    name: "Ad",
    zodiac_sign: "Burç",
    moon_sign: "Ay burcu",
    rising_sign: "Yükselen burç",
    relationship_status: "İlişki durumu",
    career_status: "Kariyer durumu",
    birth_date: "Doğum tarihi",
    location: "Konum",
  },
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

    const { card, is_reversed, date, locale = "en" } = await req.json() as DailyPickRequest;
    const normalizedLocale = normalizeLocale(locale);
    const targetLanguage = languageName(normalizedLocale);

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

    const profileParts = buildProfileParts(profile ?? {}, normalizedLocale);
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

    const categoryLabels = localizedCategoryLabels(normalizedLocale);
    const expectedSchema = JSON.stringify(
      {
        general_text: `<2-3 sentence daily tarot reading in ${targetLanguage} shaped by the card orientation and profile>`,
        categories: categoryLabels.map((name) => ({
          description: `<1-2 sentence practical ${targetLanguage} insight for ${name}>`,
        })),
        daily_advice: `<one short practical daily advice sentence in ${targetLanguage}>`,
      },
      null,
      2,
    );

    const systemPrompt = localizedSystemPrompt(normalizedLocale, is_reversed);
    const userPrompt = [
      `Reading date: ${readingDateLabel}`,
      `The person's profile:\n${profileParts || "No profile details available."}`,
      `The selected tarot card:\n${cardParts}`,
      `Generate a daily pick interpretation with exactly 5 category items in this order: ${categoryLabels.join(", ")}.`,
      `Write every user-visible value in ${targetLanguage}.`,
      "Do not include scores or percentages.",
      `Each section must reflect that the card is ${orientation}.`,
      "Each category description must be 1-2 concise sentences. The daily_advice must be short and actionable.",
      `Respond with ONLY the following JSON. Replace every <...> placeholder with ${targetLanguage} content:\n${expectedSchema}`,
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
        `Unexpected Replicate state: ${prediction.status} - ${prediction.error ?? ""}`,
      );
    }

    return json(extractJson(rawOutput, normalizedLocale));
  } catch (err) {
    console.error("generate-daily-pick error:", err);
    return json(
      { error: err instanceof Error ? err.message : "Internal server error" },
      500,
    );
  }
});

function localizedSystemPrompt(locale: string, isReversed: boolean): string {
  return [
    "You are a professional tarot reader creating a concise personalized daily pick.",
    dailyContext(locale),
    orientationContext(locale, isReversed),
    naturalReadingStyle(locale),
    writingRules(locale),
    personalizationRules(locale),
    languageInstruction(locale),
    outputRules(locale),
  ].join("\n\n");
}

function dailyContext(locale: string): string {
  if (locale === "tr") {
    return [
      "GÜNLÜK KART ÖNCELİĞİ",
      "Burada kullanıcı sorusu yok.",
      "Bu, kullanıcının günlük kartı.",
      "Ana mercek: kartın bugünün duygusal tonu hakkında ne söylediği, kullanıcının bugün neyi fark etmesi gerektiği, enerjinin nerede kolay aktığı, nerede blokaj veya gecikme olabileceği ve bugün hangi küçük pratik seçimin yardımcı olacağı.",
      'Kullanıcı şunu hissetmeli: "Bu yorum gerçekten benim günümle ilgili."',
    ].join("\n");
  }

  return [
    "DAILY PICK PRIORITY",
    "There is no user question here.",
    "This is the user's daily card.",
    "The primary lens is what this card says about today's emotional tone, what the user should notice today, where energy flows easily, where energy may be blocked or delayed, and what small practical choice would help today.",
    'The user should feel: "This reading is clearly about my day."',
  ].join("\n");
}

function orientationContext(locale: string, isReversed: boolean): string {
  if (locale === "tr") {
    return isReversed
      ? [
        "KART YÖNÜ",
        "Kart TERS.",
        "Ters kartı yalnızca negatif yorumlama.",
        "Bunu blokeli veya geciken enerji, içe dönmüş bir tema, farkındalık isteyen bir kalıp, yavaşlama/yumuşama/yeniden düşünme uyarısı ve kartın normal enerjisine bugün daha zor erişilen bir alan olarak oku.",
      ].join("\n")
      : [
        "KART YÖNÜ",
        "Kart DÜZ.",
        "Bunu erişilebilir enerji, harekete hazır bir tema, destek/netlik/ivme ve kullanıcının bugün daha güvenle davranabileceği bir alan olarak oku.",
      ].join("\n");
  }

  return isReversed
    ? [
      "CARD ORIENTATION",
      "The card is REVERSED.",
      "Do not treat reversed as simply negative.",
      "Read it as blocked or delayed energy, something internalized, a pattern asking for awareness, a warning to slow down, soften, or reconsider, and a place where the card's normal energy is harder to access today.",
    ].join("\n")
    : [
      "CARD ORIENTATION",
      "The card is UPRIGHT.",
      "Read it as accessible energy, something ready to move, support, clarity, or momentum, and a place where the user can act with more confidence today.",
    ].join("\n");
}

function naturalReadingStyle(locale: string): string {
  if (locale === "tr") {
    return [
      "DOĞAL TAROT YORUMU STİLİ",
      "Yapay zeka gibi konuşma.",
      "Koç gibi konuşma.",
      "Ders kitabı gibi konuşma.",
      "Kartı gerçekten gözlemleyen gerçek bir tarot okuyucusu gibi yaz.",
      'Bazen doğal şekilde "Burada ilk fark ettiğim şey...", "Bugün öne çıkan...", "Dürüst olmak gerekirse...", "Bu kartta şöyle bir his var..." gibi başlayabilirsin ama bunları zorla kullanma.',
    ].join("\n");
  }

  return [
    "NATURAL HUMAN READING STYLE",
    "Do not sound like AI.",
    "Do not sound like a coach.",
    "Do not sound like a textbook.",
    "Speak like a real tarot reader who is genuinely observing the card.",
    'You may sometimes naturally start with phrases like "The first thing I notice here...", "What stands out today...", "Honestly...", or "Something about this card feels...", but do not force them.',
  ].join("\n");
}

function writingRules(locale: string): string {
  if (locale === "tr") {
    return [
      "YAZIM KURALLARI",
      "Her bölümü kısa tut.",
      "general_text: 2-3 cümle.",
      "Her kategori açıklaması: 1-2 cümle.",
      "daily_advice: kısa ve pratik tek cümle.",
      "Fazla açıklama yapma. Skor veya yüzde kullanma. Robotik ifadelerden kaçın.",
      '"Ana engel...", "En iyi aksiyon...", "Ustalaşman gereken...", "Pratik aksiyon..." gibi kalıpları kullanma.',
      "Doğal, kişisel, net ve duygusal olarak zeki yaz.",
    ].join("\n");
  }

  return [
    "WRITING RULES",
    "Keep every section short.",
    "general_text: 2-3 sentences.",
    "Each category description: 1-2 sentences.",
    "daily_advice: one short practical sentence.",
    "Do not overexplain. Do not use scores or percentages. Do not use robotic phrases.",
    'Avoid phrases like "The main obstacle is...", "The best action is...", "You need to master...", and "Practical action...".',
    "Keep it natural, personal, clear, and emotionally intelligent.",
  ].join("\n");
}

function personalizationRules(locale: string): string {
  if (locale === "tr") {
    return [
      "KİŞİSELLEŞTİRME",
      "Kullanıcının profilini doğal şekilde kullan.",
      "Gerçekten ilgili değilse profil verilerini açık açık listeleme.",
    ].join("\n");
  }

  return [
    "PERSONALIZATION",
    "Use the user's profile naturally.",
    "Do not explicitly list profile data unless truly relevant.",
  ].join("\n");
}

function languageInstruction(locale: string): string {
  const targetLanguage = languageName(locale);
  if (locale === "tr") {
    return "DİL\nIMPORTANT: Tüm kullanıcıya görünen metni tamamen Türkçe yaz. İngilizce kelimeleri inputtan kopyalama. Tarot, astroloji, kategori, ilişki, kariyer, yön ve tavsiye terimlerini Türkçeye çevir. Yalnızca açıkça verilen gerçek kişi adlarını koru.";
  }
  return `LANGUAGE\nIMPORTANT: You MUST write ALL user-visible text entirely in ${targetLanguage}. Do not copy English words from the input into the output. Translate tarot, astrology, category, relationship, career, orientation, and advice terms into ${targetLanguage}. Only preserve true personal names if a person's name is explicitly provided.`;
}

function outputRules(locale: string): string {
  if (locale === "tr") {
    return [
      "ÇIKTI KURALLARI",
      "Yalnızca geçerli JSON döndür.",
      "Tüm yer tutucuları doldur.",
      "Yer tutucu bırakma.",
      "Markdown veya açıklama ekleme.",
    ].join("\n");
  }

  return [
    "OUTPUT RULES",
    "Return ONLY valid JSON.",
    "Fill all placeholder strings.",
    "No placeholders.",
    "No markdown.",
    "No explanations.",
  ].join("\n");
}

function localizedCategoryLabels(locale: string): string[] {
  return CATEGORY_LABELS[locale] ?? CATEGORY_LABELS.en;
}

function buildProfileParts(profile: Record<string, unknown>, locale: string): string {
  const labels = PROFILE_LABELS[locale] ?? PROFILE_LABELS.en;
  const fields = [
    "name",
    "zodiac_sign",
    "moon_sign",
    "rising_sign",
    "relationship_status",
    "career_status",
    "birth_date",
    "location",
  ];

  return fields
    .map((field) => {
      const value = profile[field];
      return typeof value === "string" && value.trim().length > 0
        ? `${labels[field] ?? field}: ${value.trim()}`
        : null;
    })
    .filter(Boolean)
    .join("\n");
}

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

function extractJson(raw: string, locale: string): ParsedDailyPick {
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
  return fallbackDailyPick(cleaned, locale);
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
  const value = locale.trim().replace("_", "-").toLowerCase();
  if (value === "zh-tw" || value === "zh-hant") return "zh-TW";
  if (value === "zh-cn" || value === "zh-hans" || value === "zh") return "zh-CN";
  const language = value.split("-")[0] || "en";
  return LANGUAGE_NAMES[language] ? language : "en";
}

function languageName(locale: string): string {
  return LANGUAGE_NAMES[locale] ?? LANGUAGE_NAMES.en;
}

function isValidDailyPick(value: ParsedDailyPick): boolean {
  return (
    value.general_text.length > 0 &&
    value.categories.length === CATEGORY_COUNT &&
    value.categories.every((category) => typeof category.description === "string") &&
    value.daily_advice.length > 0
  );
}

function fallbackDailyPick(generalText: string, locale: string): ParsedDailyPick {
  return {
    general_text: generalText || fallbackMessage(locale),
    categories: Array.from({ length: CATEGORY_COUNT }, () => ({ description: "" })),
    daily_advice: "",
  };
}

function fallbackMessage(locale: string): string {
  if (locale === "tr") return "Günlük kart yorumu net şekilde oluşturulamadı. Lütfen tekrar deneyin.";
  return "Daily pick could not be generated clearly. Please try again.";
}

function json(body: unknown, status = 200): Response {
  return new Response(JSON.stringify(body), {
    status,
    headers: { ...corsHeaders, "Content-Type": "application/json" },
  });
}
