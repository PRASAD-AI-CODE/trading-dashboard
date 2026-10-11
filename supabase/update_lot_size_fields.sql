-- Add lot-based quantity tracking while preserving quantity as total contract units.
-- Run once in the existing Supabase project SQL Editor.
alter table public.trades add column if not exists lots integer;
alter table public.trades add column if not exists lot_size integer;

-- Existing rows intentionally remain NULL in these columns so the app can preserve
-- their original quantity. New/edited rows save both lots and lot_size.
