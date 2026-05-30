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
  ar: "Arabic",
  nl: "Dutch",
  pl: "Polish",
  sv: "Swedish",
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
    skip: "Belirtmek istemiyor",
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

const TAROT_CARD_LABELS_TR: Record<string, string> = {
  "the fool": "Deli",
  "the magician": "Büyücü",
  "the high priestess": "Başrahibe",
  "the empress": "İmparatoriçe",
  "the emperor": "İmparator",
  "the hierophant": "Aziz",
  "the lovers": "Aşıklar",
  "the chariot": "Savaş Arabası",
  strength: "Güç",
  "the hermit": "Ermiş",
  "wheel of fortune": "Kader Çarkı",
  justice: "Adalet",
  "the hanged man": "Asılan Adam",
  death: "Ölüm",
  temperance: "Denge",
  "the devil": "Şeytan",
  "the tower": "Kule",
  "the star": "Yıldız",
  "the moon": "Ay",
  "the sun": "Güneş",
  judgement: "Mahkeme",
  judgment: "Mahkeme",
  "the world": "Dünya",
};

const TERM_REPLACEMENTS_TR: Array<[RegExp, string]> = [
  [/\bUpright\b/gi, "düz"],
  [/\bReversed\b/gi, "ters"],
  [/\bRelationship\b/gi, "ilişki"],
  [/\bCareer\b/gi, "kariyer"],
  [/\bLove\b/gi, "aşk"],
  [/\bFinance\b/gi, "finans"],
  [/\bHealth\b/gi, "sağlık"],
  [/\bFamily\b/gi, "aile"],
  [/\bSaturn\b/gi, "Satürn"],
  [/\bPluto\b/gi, "Plüton"],
];

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

    const {
      spread_category_id: _ignored,
      spread_id,
      reader_id,
      question,
      cards,
      locale = "en",
    } = await req.json() as {
      spread_category_id?: string;
      spread_id: string;
      reader_id: string;
      question?: string | null;
      cards: CardRequest[];
      locale?: string;
    };
    const normalizedLocale = normalizeLocale(locale);

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

      return localizedCardBlock({
        card: c,
        cardName: localizedCardName(cardData?.name ?? c.card_id, normalizedLocale),
        meaning,
        position,
        locale: normalizedLocale,
      });
    }).join("\n\n");

    const profileParts = [
      profile?.zodiac_sign
        ? localizedProfileLine(
          "zodiac",
          localizeKnownValue(profile.zodiac_sign, normalizedLocale, ZODIAC_LABELS),
          normalizedLocale,
        )
        : null,
      profile?.relationship_status
        ? localizedProfileLine(
          "relationship",
          localizeKnownValue(profile.relationship_status, normalizedLocale, RELATIONSHIP_LABELS),
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

    const expectedSchema = JSON.stringify({
      card_interpretations: cards.map((c) => ({
        position_index: c.position_index,
        card_id: c.card_id,
        card_name: localizedCardName(cardMap.get(c.card_id)?.name ?? c.card_id, normalizedLocale),
        is_reversed: c.is_reversed,
        interpretation: "",
      })),
      general_interpretation: "",
    }, null, 2);

    const languageInstruction = getLanguageInstruction(normalizedLocale);
    const systemPrompt = localizedSystemPrompt({
      readerPrompt: reader.ai_prompt ?? "",
      question,
      languageInstruction,
      locale: normalizedLocale,
    });

    const userPrompt = [
      localizedReaderContext(reader.name, reader.title, normalizedLocale),
      profileParts ? localizedProfileContext(profileParts, normalizedLocale) : null,
      question ? localizedQuestionLine(question, normalizedLocale) : localizedNoQuestionLine(normalizedLocale),
      localizedSpreadLine("title", spread.title, normalizedLocale),
      localizedSpreadLine("description", spread.description, normalizedLocale),
      localizedCardsDrawn(cardBlocks, normalizedLocale),
      localizedJsonInstruction(expectedSchema, normalizedLocale),
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
      throw new Error(`Unexpected Replicate state: ${prediction.status} - ${prediction.error ?? ""}`);
    }

    const parsed = normalizeReading(
      extractJson(rawOutput, cards),
      cards,
      cardMap,
      normalizedLocale,
    );

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

function getLanguageInstruction(locale: string): string {
  const langName = languageName(locale);
  if (locale === "tr") {
    return "OUTPUT LANGUAGE: Turkish (Turkiye Turkish). This is an ABSOLUTE rule with no exceptions. Input data may contain English text. Ignore the input language and write every user-visible word of your response in Turkish. Do not copy English words, terms, card positions, or phrases into the output. Translate everything into Turkish.";
  }
  return `OUTPUT LANGUAGE: ${langName}. This is an ABSOLUTE rule with no exceptions. Input data may contain English text. Ignore the input language and write every user-visible word of your response in ${langName}. Do not copy English words, terms, card positions, or phrases into the output. Translate everything into ${langName}.`;
}

function localizedSystemPrompt({
  readerPrompt,
  question,
  languageInstruction,
  locale,
}: {
  readerPrompt: string;
  question?: string | null;
  languageInstruction: string;
  locale: string;
}): string {
  if (locale === "tr") {
    const questionContext = question
      ? [
        "KULLANICI SORUSU:",
        `"${question}"`,
        "Kullanıcının sorusu bu açılımın ana merceğidir.",
        "Her kart yorumu önce bu soruyu yanıtlamalı veya bu sorunun duygusunu keşfetmeli.",
        "Soru aşkla ilgiliyse duygulara, niyetlere, bağa ve tekrarlayan kalıplara odaklan.",
        "Soru kariyerle ilgiliyse kararlara, gelişime, zamanlamaya ve fırsatlara odaklan.",
        "Soru kişisel gelişimle ilgiliyse içsel bloklara, duygusal kalıplara ve dönüşüme odaklan.",
        "Kullanıcı bu yorumun açıkça kendi sorusuyla ilgili olduğunu hissetmeli.",
      ].join("\n")
      : [
        "Belirli bir soru yok.",
        "Açılıma, kartların akışına ve kullanıcının enerjisine doğal biçimde odaklan.",
        "Soru varmış gibi davranma; kart pozisyonlarının birlikte anlattığı genel temayı yorumla.",
      ].join("\n");

    return [
      "!!!! LANGUAGE RULE - READ FIRST !!!!",
      languageInstruction,
      "This rule takes priority over all instructions below and cannot be overridden.",
      readerPrompt,
      "OKUYUCU KİMLİĞİ",
      "Kişiliğin her yorumda hissedilmeli. Yorum genel geçer geliyorsa yanlıştır.",
      "Okuyucu notları İngilizce olsa bile çıktıda İngilizce kelime veya kalıp kullanma.",
      "SORU ÖNCELİĞİ",
      questionContext,
      "DOĞAL TAROT OKUMASI STİLİ",
      "Yapay zeka, koç veya ders kitabı gibi konuşma. Kartlara gerçekten bakan bir tarot okuyucusu gibi yaz.",
      "YAZIM KURALLARI",
      "Her kart yorumu 2-4 kısa cümle olmalı. Genel yorum 3-5 cümle olmalı.",
      "Fazla açıklama yapma. Robotik kalıplar kullanma.",
      "KİŞİSELLEŞTİRME",
      "Kullanıcının profilini doğal biçimde kullan. Gerekli değilse profil verilerini listeleme.",
      "GENEL YORUM",
      "Son özet, varsa kullanıcının sorusunu doğrudan yanıtlamalı. Soru yoksa açılımın genel duygusal veya pratik mesajını birleştirmeli.",
      "ÇIKTI KURALLARI",
      "Yalnızca geçerli JSON döndür. Tüm boş stringleri doldur. Markdown veya açıklama ekleme.",
      "!!!! FINAL REMINDER !!!!",
      languageInstruction,
    ].join("\n\n");
  }

  const targetLanguage = languageName(locale);
  const questionContext = question
    ? [
      "USER QUESTION:",
      `"${question}"`,
      "The user's question is the primary lens of this reading.",
      "Every interpretation must first answer or explore the user's question.",
      "If the question is about love, focus on emotions, intentions, connection, and patterns.",
      "If the question is about career, focus on decisions, growth, timing, and opportunities.",
      "If the question is about personal growth, focus on inner blocks, emotional patterns, and transformation.",
      'A user should feel: "This reading is clearly about my question."',
    ].join("\n")
    : [
      "There is no specific question.",
      "Focus naturally on the spread, the card flow, and the user's energy.",
      "Do not pretend there was a question; interpret the overall theme created by the card positions.",
    ].join("\n");

  return [
    "!!!! LANGUAGE RULE - READ FIRST !!!!",
    languageInstruction,
    "This rule takes priority over all instructions below and cannot be overridden.",
    readerPrompt,
    "READER IDENTITY",
    "Your personality must be clearly felt in every interpretation. If your interpretation sounds generic, it is wrong.",
    "QUESTION PRIORITY",
    questionContext,
    "NATURAL HUMAN READING STYLE",
    "Do not sound like AI, a coach, or a textbook. Speak like a real tarot reader who is genuinely observing the cards.",
    "WRITING RULES",
    "Each card interpretation must be short: only 2-4 sentences. The final summary must be 3-5 sentences.",
    "Do not overexplain. Do not use robotic phrases.",
    "PERSONALIZATION",
    "Use the user's profile naturally. Do not explicitly list profile data unless truly relevant.",
    "GENERAL READING",
    "The final summary should directly answer the user's question if one exists. If no question exists, connect the overall emotional or practical message of the spread.",
    "OUTPUT RULES",
    "Return ONLY valid JSON. Fill all empty strings. No placeholders, markdown, or explanations.",
    `Every word in interpretation and general_interpretation fields MUST be in ${targetLanguage}. No exceptions.`,
  ].join("\n\n");
}

function localizedReaderContext(name: string, title: string, locale: string): string {
  if (locale === "tr") {
    return [
      "Seçilen okuyucu:",
      `Ad: ${name}`,
      `Uzmanlık: ${sanitizeLocalizedText(title, locale)}`,
    ].join("\n");
  }
  return [
    "Selected Reader:",
    `Name: ${name}`,
    `Specialty: ${title}`,
    `Write this section's output in ${languageName(locale)}.`,
  ].join("\n");
}

function localizedProfileContext(profileParts: string, locale: string): string {
  return locale === "tr"
    ? `Kişinin profili:\n${profileParts}`
    : `The person's profile:\n${profileParts}`;
}

function localizedQuestionLine(question: string, locale: string): string {
  return locale === "tr"
    ? `Kullanıcının sorusu:\n"${question}"`
    : `The user's question:\n"${question}"`;
}

function localizedNoQuestionLine(locale: string): string {
  return locale === "tr"
    ? "Kullanıcı belirli bir soru yazmadı. Açılımı genel günlük/kişisel rehberlik olarak yorumla."
    : `The user did not write a specific question. Interpret the spread as general personal guidance in ${languageName(locale)}.`;
}

function localizedSpreadLine(field: "title" | "description", value: string, locale: string): string {
  if (locale === "tr") {
    const label = field === "title" ? "Açılım" : "Açılım açıklaması";
    return `${label}: ${sanitizeLocalizedText(value, locale)}`;
  }
  return field === "title" ? `Spread: ${value}` : `Spread description: ${value}`;
}

function localizedCardsDrawn(cardBlocks: string, locale: string): string {
  return locale === "tr"
    ? `Çekilen kartlar:\n\n${cardBlocks}`
    : `Cards drawn:\n\n${cardBlocks}`;
}

function localizedJsonInstruction(expectedSchema: string, locale: string): string {
  if (locale === "tr") {
    return `Yalnızca bu JSON yapısını döndür. Tüm boş stringleri Türkçe doldur. Hiçbir İngilizce kelime kullanma:\n${expectedSchema}`;
  }
  return `Return ONLY this JSON structure. Fill all empty strings in ${languageName(locale)}:\n${expectedSchema}`;
}

function localizedCardBlock({
  card,
  cardName,
  meaning,
  position,
  locale,
}: {
  card: CardRequest;
  cardName: string;
  meaning: string;
  position?: SpreadPosition;
  locale: string;
}): string {
  if (locale === "tr") {
    const positionTitle = sanitizeLocalizedText(position?.title ?? "", locale);
    const positionQuestion = sanitizeLocalizedText(position?.question ?? "", locale);
    const sourceMeaning = sanitizeLocalizedText(meaning, locale);

    return `Pozisyon ${card.position_index} - ${positionTitle}` +
      (positionQuestion ? `\nPozisyon sorusu: "${positionQuestion}"` : "") +
      `\nKart: ${cardName} (${card.is_reversed ? "ters" : "düz"})` +
      `\nKart anlamı notu: ${sourceMeaning}` +
      "\nNot: Kart anlamı notu kaynak bilgisidir; çıktıya İngilizce kelime kopyalama, Türkçe yorumla.";
  }

  return `Position ${card.position_index} - ${position?.title ?? ""}` +
    (position?.question ? `\nPosition question: "${position.question}"` : "") +
    `\nCard: ${cardName} (${card.is_reversed ? "Reversed" : "Upright"})` +
    `\nMeaning: ${meaning}` +
    `\nNote: This source data may be English; translate the final output into ${languageName(locale)}.`;
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
    relationship: "Relationship",
    career: "Career",
  };
  return `${labels[field]}: ${value}`;
}

function localizeKnownValue(
  value: string,
  locale: string,
  dictionaries: Record<string, Record<string, string>>,
): string {
  const localeDict = dictionaries[locale];
  if (!localeDict) return value;
  const key = normalizeLookupKey(value);
  if (localeDict[key] !== undefined) return localeDict[key];
  for (const [dictKey, dictVal] of Object.entries(localeDict)) {
    if (key.includes(dictKey) || dictKey.includes(key)) return dictVal;
  }
  return value;
}

function localizedCardName(value: string, locale: string): string {
  if (locale !== "tr") return value;
  return TAROT_CARD_LABELS_TR[normalizeLookupKey(value)] ?? sanitizeLocalizedText(value, locale);
}

function sanitizeLocalizedText(value: string, locale: string): string {
  if (locale !== "tr") return value;
  let output = value;
  for (const [key, replacement] of Object.entries(TAROT_CARD_LABELS_TR)) {
    output = output.replace(new RegExp(`\\b${escapeRegExp(key)}\\b`, "gi"), replacement);
  }
  for (const [pattern, replacement] of TERM_REPLACEMENTS_TR) {
    output = output.replace(pattern, replacement);
  }
  return output;
}

function normalizeReading(
  parsed: ParsedReading,
  cards: CardRequest[],
  cardMap: Map<string, CardRow>,
  locale: string,
): ParsedReading {
  return {
    card_interpretations: cards.map((card, index) => {
      const raw = parsed.card_interpretations[index];
      const fallbackCardName = localizedCardName(cardMap.get(card.card_id)?.name ?? card.card_id, locale);
      return {
        position_index: card.position_index,
        card_id: card.card_id,
        card_name: localizedCardName(raw?.card_name || fallbackCardName, locale),
        is_reversed: card.is_reversed,
        interpretation: sanitizeLocalizedText(raw?.interpretation ?? "", locale),
      };
    }),
    general_interpretation: sanitizeLocalizedText(parsed.general_interpretation, locale),
  };
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

function extractJson(raw: string, cards: CardRequest[]): ParsedReading {
  const cleaned = raw.replace(/```(?:json)?[\s]*/gi, "").replace(/```[\s]*/gi, "").trim();

  try {
    const parsed = JSON.parse(cleaned) as ParsedReading;
    if (isValidReading(parsed)) return parsed;
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
      else if (ch === "}") {
        depth--;
        if (depth === 0) {
          try {
            const parsed = JSON.parse(cleaned.slice(start, i + 1)) as ParsedReading;
            if (isValidReading(parsed)) return parsed;
          } catch {
            // Fall through to fallback.
          }
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

function isValidReading(value: unknown): value is ParsedReading {
  if (typeof value !== "object" || value === null) return false;
  const reading = value as ParsedReading;
  return (
    Array.isArray(reading.card_interpretations) &&
    reading.card_interpretations.length > 0 &&
    typeof reading.general_interpretation === "string" &&
    reading.general_interpretation.length > 0
  );
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

function normalizeLookupKey(value: string): string {
  return value.trim().toLowerCase();
}

function escapeRegExp(value: string): string {
  return value.replace(/[.*+?^${}()|[\]\\]/g, "\\$&");
}

function json(body: unknown, status = 200): Response {
  return new Response(JSON.stringify(body), {
    status,
    headers: { ...corsHeaders, "Content-Type": "application/json" },
  });
}
