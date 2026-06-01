create table if not exists public.scores (
  id bigint generated always as identity primary key,
  name text not null check (char_length(name) between 1 and 16),
  score integer not null check (score >= 0 and score <= 10000000),
  created_at timestamptz not null default now()
);

alter table public.scores enable row level security;

drop policy if exists "scores are readable by everyone" on public.scores;
create policy "scores are readable by everyone"
on public.scores for select
to anon
using (true);

drop policy if exists "players can submit scores" on public.scores;
create policy "players can submit scores"
on public.scores for insert
to anon
with check (
  char_length(name) between 1 and 16
  and score >= 0
  and score <= 10000000
);

create index if not exists scores_score_created_at_idx
on public.scores (score desc, created_at asc);
