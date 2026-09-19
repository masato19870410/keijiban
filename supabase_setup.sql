-- messages テーブル作成
create table if not exists public.messages (
  id uuid primary key default gen_random_uuid(),
  name text,
  body text not null,
  created_at timestamptz not null default now()
);

-- RLS を有効化
alter table public.messages enable row level security;

-- 匿名ユーザーの select を許可
create policy "Allow anonymous select"
  on public.messages
  for select
  to anon
  using (true);

-- 匿名ユーザーの insert を許可
create policy "Allow anonymous insert"
  on public.messages
  for insert
  to anon
  with check (true);

-- Realtime購読を使う場合は、Supabaseダッシュボードの
-- Database > Replication で messages テーブルを有効化してください
