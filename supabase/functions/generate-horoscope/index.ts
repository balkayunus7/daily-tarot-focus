import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

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

const PERIOD_LABELS: Record<string, Record<HoroscopeRequest["period"], string>> = {
  en: { daily: "today", weekly: "this week", monthly: "this month" },
  tr: { daily: "bugün", weekly: "bu hafta", monthly: "bu ay" },
  es: { daily: "hoy", weekly: "esta semana", monthly: "este mes" },
  pt: { daily: "hoje", weekly: "esta semana", monthly: "este mês" },
  fr: { daily: "aujourd'hui", weekly: "cette semaine", monthly: "ce mois-ci" },
  de: { daily: "heute", weekly: "diese Woche", monthly: "diesen Monat" },
  it: { daily: "oggi", weekly: "questa settimana", monthly: "questo mese" },
  ja: { daily: "今日", weekly: "今週", monthly: "今月" },
  ko: { daily: "오늘", weekly: "이번 주", monthly: "이번 달" },
  th: { daily: "วันนี้", weekly: "สัปดาห์นี้", monthly: "เดือนนี้" },
  "zh-TW": { daily: "今天", weekly: "本週", monthly: "本月" },
  "zh-CN": { daily: "今天", weekly: "本周", monthly: "本月" },
  ru: { daily: "сегодня", weekly: "на этой неделе", monthly: "в этом месяце" },
};

const RELATIONSHIP_LABELS: Record<string, Record<string, string>> = {
  tr: {
    single: "Bekar",
    "in a relationship": "İlişkisi var",
    engaged: "Nişanlı",
    married: "Evli",
    "its complicated": "Karışık",
    "it's complicated": "Karışık",
    dating: "Flört ediyor",
    "open relationship": "Açık ilişki",
    separated: "Ayrı",
    divorced: "Boşanmış",
    healing: "İyileşme sürecinde",
    "manifesting love": "Aşkı hayatına çekmeye odaklı",
    "prefer not to say": "Belirtmek istemiyor",
  },
};

const CAREER_LABELS: Record<string, Record<string, string>> = {
  tr: {
    student: "Öğrenci",
    employed: "Çalışan",
    "self-employed": "Serbest çalışan",
    freelancer: "Bağımsız çalışan",
    entrepreneur: "Girişimci",
    looking: "İş arıyor",
    "career break": "Kariyer molasında",
    homemaker: "Ev işleriyle ilgileniyor",
    retired: "Emekli",
    skip: "Belirtmek istemiyor",
  },
};

const ZODIAC_LABELS: Record<string, Record<string, string>> = {
  tr: {
    aries: "Koç",
    taurus: "Boğa",
    gemini: "İkizler",
    cancer: "Yengeç",
    leo: "Aslan",
    virgo: "Başak",
    libra: "Terazi",
    scorpio: "Akrep",
    sagittarius: "Yay",
    capricorn: "Oğlak",
    aquarius: "Kova",
    pisces: "Balık",
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

    const { sign, period, locale = "en" } = await req.json() as HoroscopeRequest;
    const normalizedLocale = normalizeLocale(locale);

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

    const profileSign = localizeKnownValue(
      profile?.zodiac_sign ?? sign,
      normalizedLocale,
      ZODIAC_LABELS,
    );
    const profileParts = [
      localizedProfileLine("zodiac", profileSign, normalizedLocale),
      profile?.relationship_status
        ? localizedProfileLine(
          "relationship",
          localizeKnownValue(
            profile.relationship_status,
            normalizedLocale,
            RELATIONSHIP_LABELS,
          ),
          normalizedLocale,
        )
        : null,
      profile?.career_status
        ? localizedProfileLine(
          "career",
          localizeKnownValue(profile.career_status, normalizedLocale, CAREER_LABELS),
          normalizedLocale,
        )
        : null,
    ].filter(Boolean).join("\n");

    const categoryLabels = localizedCategoryLabels(normalizedLocale);
    const expectedSchema = JSON.stringify(
      {
        general_text: placeholder(
          normalizedLocale,
          "Bu dönem için 3-4 cümlelik genel burç yorumu",
          `3-4 sentence general horoscope reading in ${languageName(normalizedLocale)}`,
        ),
        categories: categoryLabels.map((name) => ({
          score: 0,
          description: placeholder(
            normalizedLocale,
            `${name} için 1-2 cümlelik Türkçe açıklama`,
            `1-2 sentence ${languageName(normalizedLocale)} description for ${name}`,
          ),
        })),
        tips: [
          {
            is_advice: true,
            text: placeholder(
              normalizedLocale,
              "Bu dönem için uygulanabilir Türkçe öneri",
              `practical advice in ${languageName(normalizedLocale)} for this period`,
            ),
          },
          {
            is_advice: false,
            text: placeholder(
              normalizedLocale,
              "Bu dönem dikkat edilmesi gereken Türkçe uyarı",
              `warning in ${languageName(normalizedLocale)} for this period`,
            ),
          },
        ],
        critical_days: {
          challenging: placeholder(normalizedLocale, "Talimatlara göre Türkçe zorlu gün bilgisi", "see instructions"),
          highlight: placeholder(normalizedLocale, "Talimatlara göre Türkçe öne çıkan gün bilgisi", "see instructions"),
        },
      },
      null,
      2,
    );

    const systemPrompt = localizedSystemPrompt(normalizedLocale);
    const userPrompt = [
      localizedPromptLine("profile", normalizedLocale, profileParts),
      localizedPromptLine("generate", normalizedLocale, `${period}|${profileSign}`),
      localizedPromptLine(
        "critical_days",
        normalizedLocale,
        localizedCriticalDaysInstruction(period, normalizedLocale),
      ),
      localizedPromptLine("categories", normalizedLocale, categoryLabels.join(", ")),
      localizedPromptLine("scores", normalizedLocale),
      localizedPromptLine("tips", normalizedLocale),
      localizedPromptLine("json", normalizedLocale, expectedSchema),
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
        `Unexpected Replicate state: ${prediction.status} - ${prediction.error ?? ""}`,
      );
    }

    return json(extractJson(rawOutput, normalizedLocale));
  } catch (err) {
    console.error("generate-horoscope error:", err);
    return json(
      { error: err instanceof Error ? err.message : "Internal server error" },
      500,
    );
  }
});

function localizedCategoryLabels(locale: string): string[] {
  return CATEGORY_LABELS[locale] ?? CATEGORY_LABELS.en;
}

function localizedSystemPrompt(locale: string): string {
  const targetLanguage = languageName(locale);
  if (locale === "tr") {
    return [
      "Kişiselleştirilmiş burç yorumları sunan profesyonel bir astrologsun.",
      "Yorumların sezgili, empatik, uygulanabilir ve doğal Türkçe olmalı.",
      "Varsa kişinin ilişki ve kariyer bağlamını yoruma yedir.",
      languageInstruction(locale),
      "KRİTİK: Yanıtın yalnızca ham JSON olmalı. Markdown, kod bloğu, giriş cümlesi veya açıklama ekleme.",
      "Yanıt doğrudan JSON.parse() ile okunabilir olmalı.",
      "Tüm score alanları string değil JSON sayısı olmalı.",
    ].join("\n\n");
  }

  return [
    "You are a professional astrologer providing personalized horoscope readings.",
    "Your readings should be insightful, empathetic, practical, and natural.",
    "Tailor your interpretation to the person's life context (relationship, career) when available.",
    languageInstruction(locale),
    `The target language is ${targetLanguage}.`,
    "CRITICAL: Your entire response must be raw JSON only. No markdown, no code fences, no preamble, no explanation.",
    "The response must be directly parseable by JSON.parse().",
    "All score fields must be JSON numbers, never strings.",
  ].join("\n\n");
}

function languageInstruction(locale: string): string {
  const targetLanguage = languageName(locale);
  if (locale === "tr") {
    return "IMPORTANT: You MUST write ALL user-visible text entirely in Turkish (Turkiye Turkish). Do not copy English words from the input into the output. Translate relationship, career, period, category, weekday, astrology, and planet terms into Turkish. Use conventional Turkish spellings for astrology names, for example Saturn = Satürn and Pluto = Plüton. Only preserve true personal names if a person's name is explicitly provided.";
  }
  return `IMPORTANT: You MUST write ALL user-visible text entirely in ${targetLanguage}. Do not copy English words from the input into the output. Translate relationship, career, period, category, weekday, astrology, zodiac, and planet terms into ${targetLanguage}. Only preserve true personal names if a person's name is explicitly provided.`;
}

function localizedPeriod(period: HoroscopeRequest["period"], locale: string): string {
  return PERIOD_LABELS[locale]?.[period] ?? PERIOD_LABELS.en[period];
}

function localizedCriticalDaysInstruction(
  period: HoroscopeRequest["period"],
  locale: string,
): string {
  const targetLanguage = languageName(locale);
  if (locale === "tr") {
    if (period === "daily") {
      return '"challenging" ve "highlight" alanlarının her biri bugünle ilgili kısa birer Türkçe cümle olmalı.';
    }
    if (period === "weekly") {
      return '"challenging" belirli Türkçe gün adlarını listelemeli (örn. "Pazartesi, Salı, Cumartesi"). "highlight" da belirli Türkçe gün adlarını listelemeli.';
    }
    return '"challenging" belirli gün numaralarını listelemeli (örn. "1, 2, 3, 8"). "highlight" da belirli gün numaralarını listelemeli.';
  }

  if (period === "daily") {
    return `"challenging" and "highlight" should each be a single short sentence about today, written in ${targetLanguage}.`;
  }
  if (period === "weekly") {
    return `"challenging" should list specific weekday names in ${targetLanguage}. "highlight" should also list specific weekday names in ${targetLanguage}.`;
  }
  return '"challenging" should list specific day numbers (e.g. "1, 2, 3, 8"). "highlight" should also list specific day numbers.';
}

function localizedProfileLine(
  field: "zodiac" | "relationship" | "career",
  value: string,
  locale: string,
): string {
  if (locale === "tr") {
    const labels = {
      zodiac: "Burç",
      relationship: "İlişki durumu",
      career: "Kariyer durumu",
    };
    return `${labels[field]}: ${value}`;
  }

  const labels = {
    zodiac: "Zodiac Sign",
    relationship: "Relationship Status",
    career: "Career Status",
  };
  return `${labels[field]}: ${value}`;
}

function localizedPromptLine(key: string, locale: string, value = ""): string {
  if (locale === "tr") {
    switch (key) {
      case "profile":
        return `Kişinin profili:\n${value}`;
      case "generate": {
        const [period, sign] = value.split("|") as [HoroscopeRequest["period"], string];
        const periodPhrase = period === "daily"
          ? "bugün için"
          : period === "weekly"
          ? "bu hafta için"
          : "bu ay için";
        return `${sign} burcu için ${periodPhrase} kişiselleştirilmiş bir burç yorumu üret.`;
      }
      case "critical_days":
        return `critical_days alanı için: ${value}`;
      case "categories":
        return `categories tam olarak 5 öğe içermeli ve açıklamalar şu sıraya göre yazılmalı: ${value}.`;
      case "scores":
        return "Her kategori puanı 0 ile 100 arasında JSON sayısı olmalı, tırnak içinde string olmamalı.";
      case "tips":
        return "tips tam olarak 2 öğe içermeli: biri öneri (is_advice: true), biri uyarı (is_advice: false).";
      case "json":
        return "Yalnızca aşağıdaki JSON ile yanıt ver. Öncesine veya sonrasına hiçbir metin ekleme. Her <...> yer tutucusunu Türkçe içerikle " +
          `değiştir:\n${value}`;
    }
  }

  const targetLanguage = languageName(locale);
  switch (key) {
    case "profile":
      return `The person's profile:\n${value}`;
    case "generate": {
      const [period, sign] = value.split("|") as [HoroscopeRequest["period"], string];
      return `Generate a personalized horoscope for ${sign} for ${localizedPeriod(period, locale)}. Write it in ${targetLanguage}.`;
    }
    case "critical_days":
      return `For the critical_days field: ${value}`;
    case "categories":
      return `Categories must be exactly 5 items in this order: ${value}. Write category descriptions in ${targetLanguage}.`;
    case "scores":
      return "Each category score must be a JSON number between 0 and 100, not a quoted string.";
    case "tips":
      return `Tips must have exactly 2 items written in ${targetLanguage}: one advice (is_advice: true) and one warning (is_advice: false).`;
    case "json":
      return `Respond with ONLY the following JSON. Do not add any text before or after it. Replace every <...> placeholder with ${targetLanguage} content:\n${value}`;
    default:
      return value;
  }
}

function placeholder(locale: string, tr: string, other: string): string {
  return `<${locale === "tr" ? tr : other}>`;
}

function localizeKnownValue(
  value: string,
  locale: string,
  dictionaries: Record<string, Record<string, string>>,
): string {
  return dictionaries[locale]?.[normalizeLookupKey(value)] ?? value;
}

function normalizeLookupKey(value: string): string {
  return value.trim().toLowerCase();
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

function extractJson(raw: string, locale: string): ParsedHoroscope {
  const cleaned = raw
    .replace(/```(?:json)?[\s]*/gi, "")
    .replace(/```[\s]*/gi, "")
    .trim();

  try {
    return normalizeHoroscope(JSON.parse(cleaned));
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
            return normalizeHoroscope(JSON.parse(cleaned.slice(start, i + 1)));
          } catch {
            break;
          }
        }
      }
    }
  }

  console.error("JSON extraction failed. Raw:", cleaned.slice(0, 500));
  return fallbackHoroscope(cleaned, locale);
}

function normalizeHoroscope(value: unknown): ParsedHoroscope {
  if (typeof value !== "object" || value === null) {
    throw new Error("Horoscope response is not an object");
  }

  const input = value as Record<string, unknown>;
  const rawCategories = Array.isArray(input.categories) ? input.categories : [];
  const rawTips = Array.isArray(input.tips) ? input.tips : [];
  const rawCriticalDays =
    typeof input.critical_days === "object" && input.critical_days !== null
      ? input.critical_days as Record<string, unknown>
      : {};

  const categories = Array.from({ length: CATEGORY_COUNT }, (_, index) => {
    const raw = typeof rawCategories[index] === "object" && rawCategories[index] !== null
      ? rawCategories[index] as Record<string, unknown>
      : {};
    return {
      score: normalizeScore(raw.score),
      description: normalizeText(raw.description),
    };
  });

  const tips = [
    normalizeTip(rawTips[0], true),
    normalizeTip(rawTips[1], false),
  ];

  const normalized = {
    general_text: normalizeText(input.general_text),
    categories,
    tips,
    critical_days: {
      challenging: normalizeText(rawCriticalDays.challenging),
      highlight: normalizeText(rawCriticalDays.highlight),
    },
  };

  if (!isValidHoroscope(normalized)) {
    throw new Error("Horoscope response failed validation");
  }

  return normalized;
}

function normalizeTip(value: unknown, fallbackAdvice: boolean): TipResult {
  const raw = typeof value === "object" && value !== null ? value as Record<string, unknown> : {};
  return {
    is_advice: typeof raw.is_advice === "boolean" ? raw.is_advice : fallbackAdvice,
    text: normalizeText(raw.text),
  };
}

function normalizeScore(value: unknown): number {
  const number = typeof value === "number"
    ? value
    : typeof value === "string"
    ? Number.parseInt(value, 10)
    : 0;

  if (!Number.isFinite(number)) return 0;
  return Math.min(100, Math.max(0, Math.round(number)));
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

function isValidHoroscope(value: ParsedHoroscope): boolean {
  return (
    value.general_text.length > 0 &&
    value.categories.length === CATEGORY_COUNT &&
    value.categories.every((category) =>
      Number.isInteger(category.score) &&
      category.score >= 0 &&
      category.score <= 100 &&
      typeof category.description === "string"
    ) &&
    value.tips.length === 2 &&
    value.tips.every((tip) => typeof tip.is_advice === "boolean" && typeof tip.text === "string") &&
    typeof value.critical_days.challenging === "string" &&
    typeof value.critical_days.highlight === "string"
  );
}

function fallbackHoroscope(generalText: string, locale: string): ParsedHoroscope {
  return {
    general_text: generalText || fallbackMessage(locale),
    categories: Array.from({ length: CATEGORY_COUNT }, () => ({ score: 0, description: "" })),
    tips: [
      { is_advice: true, text: "" },
      { is_advice: false, text: "" },
    ],
    critical_days: { challenging: "", highlight: "" },
  };
}

function fallbackMessage(locale: string): string {
  if (locale === "tr") return "Burç yorumu net şekilde oluşturulamadı. Lütfen tekrar deneyin.";
  return "Horoscope could not be generated clearly. Please try again.";
}

function json(body: unknown, status = 200): Response {
  return new Response(JSON.stringify(body), {
    status,
    headers: { ...corsHeaders, "Content-Type": "application/json" },
  });
}
