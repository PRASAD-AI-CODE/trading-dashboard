-- Adds the product-type classification used by P&L Details filters.
alter table public.trades
  add column if not exists product_type text not null default 'Intraday';

-- Existing rows default to Intraday so the P&L filter remains usable immediately.
