-- Run this once in Supabase SQL Editor for the existing Trading Journal project.
alter table public.trades
  add column if not exists option_type text check (option_type in ('CE', 'PE')) ,
  add column if not exists strike_price numeric;
