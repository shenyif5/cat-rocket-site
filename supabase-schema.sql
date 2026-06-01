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

delete from public.scores a
using public.scores b
where a.name = b.name
  and (
    a.score < b.score
    or (a.score = b.score and a.created_at > b.created_at)
    or (a.score = b.score and a.created_at = b.created_at and a.id > b.id)
  );

create unique index if not exists scores_name_key
on public.scores (name);

create or replace function public.submit_score(player_name text, player_score integer)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  clean_name text := left(regexp_replace(trim(player_name), '\s+', ' ', 'g'), 16);
  clean_score integer := greatest(0, least(player_score, 10000000));
begin
  if clean_name = '' then
    clean_name := '匿名猫咪';
  end if;

  insert into public.scores (name, score)
  values (clean_name, clean_score)
  on conflict (name) do update
  set
    score = greatest(public.scores.score, excluded.score),
    created_at = case
      when excluded.score > public.scores.score then now()
      else public.scores.created_at
    end;
end;
$$;

grant execute on function public.submit_score(text, integer) to anon;
