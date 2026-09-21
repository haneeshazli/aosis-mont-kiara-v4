-- Leads table for the AOSIS Mont Kiara V4 registration form.
-- Lives in the same Supabase project as the v1 site's `leads` table.

create table if not exists public.leads_v4 (
  id           bigint generated always as identity primary key,
  created_at   timestamptz not null default now(),
  salutation   text check (char_length(salutation) <= 20),
  name         text not null check (char_length(name) between 1 and 200),
  country      text check (char_length(country) <= 50),
  mobile       text not null check (char_length(mobile) between 3 and 40),
  email        text check (char_length(email) <= 320),
  heard_from   text[] check (cardinality(heard_from) <= 20),
  units        text[] check (cardinality(units) <= 20),
  is_agent     boolean not null default false,
  consent      boolean not null default false,
  page_url     text check (char_length(page_url) <= 2000),
  referrer     text check (char_length(referrer) <= 2000),
  utm_source   text check (char_length(utm_source) <= 200),
  utm_medium   text check (char_length(utm_medium) <= 200),
  utm_campaign text check (char_length(utm_campaign) <= 200)
);

alter table public.leads_v4 enable row level security;

-- Public key may only INSERT; leads are readable only from the Supabase dashboard.
drop policy if exists "public can submit leads" on public.leads_v4;
create policy "public can submit leads"
  on public.leads_v4 for insert
  to anon
  with check (consent = true);

grant insert on public.leads_v4 to anon;