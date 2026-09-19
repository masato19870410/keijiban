-- messages テーブル作成
create table if not exists public.messages (
  id uuid primary key default gen_random_uuid(),
  name text,
  body text not null,
  created_at timestamptz not null default now()
);

-- RLS を有効化
alter table public.messages enable row level security;

-- 既存の匿名ポリシーがあれば削除して、認証必須のポリシーに置き換え
drop policy if exists "Allow anonymous select" on public.messages;
drop policy if exists "Allow anonymous insert" on public.messages;

-- 誰でも閲覧可能（ログイン不要）
create policy "Allow public select"
  on public.messages
  for select
  to anon, authenticated
  using (true);

-- 投稿はログイン済みユーザーのみ
create policy "Allow authenticated insert"
  on public.messages
  for insert
  to authenticated
  with check (true);
