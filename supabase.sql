-- Plata Clara: tabla única donde se guardan tus datos. Pégalo en Supabase > SQL Editor y dale Run.
create table if not exists public.docs (
  user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
  col text not null,
  id text not null,
  data jsonb not null,
  updated_at timestamptz not null default now(),
  primary key (user_id, col, id)
);
alter table public.docs enable row level security;
drop policy if exists "solo mis datos" on public.docs;
create policy "solo mis datos" on public.docs
  for all to authenticated
  using ((select auth.uid()) = user_id)
  with check ((select auth.uid()) = user_id);
