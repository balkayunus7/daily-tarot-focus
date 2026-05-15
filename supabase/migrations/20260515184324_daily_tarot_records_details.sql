create extension if not exists pgcrypto;

create table if not exists public.daily_tarot_records (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  card_id text not null,
  is_reversed boolean not null default false,
  locale text not null default 'en',
  reading_date date not null default current_date,
  general_text text,
  daily_advice text,
  categories jsonb not null default '[]'::jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

alter table public.daily_tarot_records
  add column if not exists is_reversed boolean not null default false,
  add column if not exists locale text not null default 'en',
  add column if not exists reading_date date not null default current_date,
  add column if not exists general_text text,
  add column if not exists daily_advice text,
  add column if not exists categories jsonb not null default '[]'::jsonb,
  add column if not exists updated_at timestamptz not null default now();

create index if not exists daily_tarot_records_user_created_at_idx
  on public.daily_tarot_records (user_id, created_at desc);

create index if not exists daily_tarot_records_user_reading_date_idx
  on public.daily_tarot_records (user_id, reading_date desc);

create or replace function public.set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

drop trigger if exists set_daily_tarot_records_updated_at on public.daily_tarot_records;
create trigger set_daily_tarot_records_updated_at
before update on public.daily_tarot_records
for each row execute function public.set_updated_at();
