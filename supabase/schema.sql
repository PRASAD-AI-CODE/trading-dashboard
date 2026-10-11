-- TradeJournal database schema for Supabase/PostgreSQL
create extension if not exists "pgcrypto";

create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  full_name text,
  avatar_url text,
  timezone text default 'Asia/Kolkata',
  currency text default 'INR',
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

create table if not exists public.strategies (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  name text not null,
  created_at timestamptz default now(),
  unique(user_id,name)
);

create table if not exists public.trades (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  trade_date date not null default current_date,
  entry_time time,
  exit_time time,
  instrument text not null default 'NIFTY',
  symbol text not null,
  option_type text check (option_type in ('CE','PE')),
  strike_price numeric,
  market text not null default 'Options',
  trade_type text not null default 'BUY' check (trade_type in ('BUY','SELL')),
  quantity numeric not null check (quantity > 0),
  entry_price numeric not null check (entry_price > 0),
  exit_price numeric,
  stop_loss numeric,
  target numeric,
  fees numeric default 0,
  brokerage numeric default 0,
  other_charges numeric default 0,
  status text not null default 'Closed' check (status in ('Open','Closed')),
  current_price numeric,
  realised_pnl numeric default 0,
  unrealised_pnl numeric default 0,
  strategy text,
  notes text,
  screenshot_url text,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

create table if not exists public.psychology_notes (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  trade_id uuid references public.trades(id) on delete cascade,
  emotion text,
  confidence integer check (confidence between 1 and 10),
  followed_plan boolean default true,
  reason_for_entry text,
  mistakes text,
  lessons text,
  journal_note text,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

create table if not exists public.journal_entries (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  entry_date date not null default current_date,
  mood text,
  summary text,
  mistakes text,
  lessons text,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

create index if not exists trades_user_date_idx on public.trades(user_id,trade_date desc);
create index if not exists psych_user_idx on public.psychology_notes(user_id,created_at desc);
create index if not exists journal_user_date_idx on public.journal_entries(user_id,entry_date desc);

alter table public.profiles enable row level security;
alter table public.strategies enable row level security;
alter table public.trades enable row level security;
alter table public.psychology_notes enable row level security;
alter table public.journal_entries enable row level security;

drop policy if exists profiles_self on public.profiles;
create policy profiles_self on public.profiles for all using (auth.uid()=id) with check (auth.uid()=id);

drop policy if exists strategies_self on public.strategies;
create policy strategies_self on public.strategies for all using (auth.uid()=user_id) with check (auth.uid()=user_id);

drop policy if exists trades_self on public.trades;
create policy trades_self on public.trades for all using (auth.uid()=user_id) with check (auth.uid()=user_id);

drop policy if exists psych_self on public.psychology_notes;
create policy psych_self on public.psychology_notes for all using (auth.uid()=user_id) with check (auth.uid()=user_id);

drop policy if exists journal_self on public.journal_entries;
create policy journal_self on public.journal_entries for all using (auth.uid()=user_id) with check (auth.uid()=user_id);

-- Create a profile automatically when a Supabase Auth user signs up.
create or replace function public.handle_new_user()
returns trigger language plpgsql security definer set search_path = public
as $$ begin
  insert into public.profiles(id,full_name) values(new.id,new.raw_user_meta_data->>'full_name') on conflict (id) do nothing;
  return new;
end; $$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created after insert on auth.users for each row execute procedure public.handle_new_user();

-- Storage bucket for trade screenshots.
insert into storage.buckets (id,name,public) values ('trade-screenshots','trade-screenshots',true) on conflict (id) do nothing;

drop policy if exists screenshot_select_own on storage.objects;
create policy screenshot_select_own on storage.objects for select using (bucket_id='trade-screenshots' and (storage.foldername(name))[1]=auth.uid()::text);
drop policy if exists screenshot_insert_own on storage.objects;
create policy screenshot_insert_own on storage.objects for insert with check (bucket_id='trade-screenshots' and (storage.foldername(name))[1]=auth.uid()::text);
drop policy if exists screenshot_update_own on storage.objects;
create policy screenshot_update_own on storage.objects for update using (bucket_id='trade-screenshots' and (storage.foldername(name))[1]=auth.uid()::text);
drop policy if exists screenshot_delete_own on storage.objects;
create policy screenshot_delete_own on storage.objects for delete using (bucket_id='trade-screenshots' and (storage.foldername(name))[1]=auth.uid()::text);
