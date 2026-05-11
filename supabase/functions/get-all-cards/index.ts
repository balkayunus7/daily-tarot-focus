import { createClient } from 'jsr:@supabase/supabase-js@2'

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
  'Cache-Control': 'public, max-age=86400',
}

// Maps Turkish translation keys back to the English keys the Flutter client expects
const TR_READING_KEY_MAP: Record<string, string> = {
  'Aşk': 'Love',
  'Kariyer': 'Career',
  'Eylemler': 'Actions',
  'Genel': 'General',
  'Duygular': 'Feelings',
  'Finans': 'Finances',
}

function remapReadingKeys(
  obj: Record<string, unknown> | null,
): Record<string, unknown> | null {
  if (!obj) return null
  return Object.fromEntries(
    Object.entries(obj).map(([k, v]) => [TR_READING_KEY_MAP[k] ?? k, v]),
  )
}

Deno.serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    const supabase = createClient(
      Deno.env.get('SUPABASE_URL')!,
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!,
    )

    const body = await req.json().catch(() => ({}))
    const locale: string = body?.locale ?? 'en'

    const { data, error } = await supabase
      .from('tarot_cards')
      .select('*')

    if (error) throw error

    const map = Object.fromEntries(
      data.map((card) => {
        const { translations, ...rest } = card

        if (locale !== 'en' && translations?.[locale]) {
          const tr = translations[locale]
          return [card.id, {
            ...rest,
            ...(tr.name             && { name: tr.name }),
            ...(tr.description      && { description: tr.description }),
            ...(tr.correspondences  && { correspondences: tr.correspondences }),
            ...(tr.symbols          && { symbols: tr.symbols }),
            ...(tr.upright_keywords && { upright_keywords: tr.upright_keywords }),
            ...(tr.reversed_keywords && { reversed_keywords: tr.reversed_keywords }),
            ...(tr.upright  && { upright:  remapReadingKeys(tr.upright) }),
            ...(tr.reversed && { reversed: remapReadingKeys(tr.reversed) }),
          }]
        }

        return [card.id, rest]
      }),
    )

    return new Response(
      JSON.stringify(map),
      {
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        status: 200,
      },
    )
  } catch (err) {
    return new Response(
      JSON.stringify({ error: err.message }),
      {
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        status: 500,
      },
    )
  }
})
