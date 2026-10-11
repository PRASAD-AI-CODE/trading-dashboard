# TradeJournal

A full-stack personal trading journal built with React, Vite, Tailwind-style CSS, Recharts and Supabase.

## Features

- Email/password authentication through Supabase Auth
- Dashboard with date ranges and KPI cards
- Add, edit, view and delete trades
- BUY/SELL P&L calculations for closed and open trades
- Options/equity/futures/crypto/forex fields
- Trade screenshot upload through Supabase Storage
- Psychology notes attached to trades
- Daily journal
- Strategy library
- Analytics and equity curve
- User-specific Row Level Security
- Responsive layout for desktop and mobile

## 1. Requirements

Install Node.js LTS. In VS Code, open this folder in the terminal.

```bash
npm install
```

## 2. Supabase

1. Create a Supabase project.
2. Open SQL Editor.
3. Copy everything from `supabase/schema.sql` and run it.
4. Open Project Settings -> API.
5. Copy the Project URL and anon/publishable key.

## 3. Environment

Copy `.env.example` to `.env.local` and fill:

```text
VITE_SUPABASE_URL=...
VITE_SUPABASE_ANON_KEY=...
```

Restart Vite after changing `.env.local`.

## 4. Run in VS Code

```bash
npm run dev
```

Open the local URL printed by Vite, normally `http://localhost:5173`.

## 5. Authentication

Create an account from the app. If email confirmation is enabled in Supabase, confirm the email before logging in.

## Notes

The first version intentionally calculates prices from data entered into the journal. It does not claim to provide live market prices. Live broker/market-data integration can be added later.


### Existing Supabase project: update for options fields
If you already ran the original `schema.sql`, open Supabase SQL Editor and run `supabase/update_options_fields.sql` once. This adds the `option_type` and `strike_price` columns without deleting existing trades. The Add Trade form no longer asks for entry/exit times. For Options, enter Instrument, BUY/SELL Direction, Strike price and CE/PE; the symbol is composed automatically (for example `NIFTY 25000 CE`). The Entry price is the option premium, not the strike price.


## Lot-based quantities update

For lot-based tracking, run `supabase/update_lot_size_fields.sql` in the existing Supabase SQL Editor. The app stores total contract units in `quantity` for P&L math, and stores the entered number of lots and units per lot in `lots` and `lot_size`. Preset lot sizes are convenience defaults only; verify them against the applicable exchange contract information and edit the units-per-lot field if needed. Unrealised P&L is recalculated from trade side, entry price, current price, and total units whenever displayed.


### Market classification and quantity rules
- Options and Futures use **Lots** × **Units per lot** to calculate total contract units.
- Equity, Crypto, Forex, and Other use a direct **Quantity (units)** field; lot inputs are hidden.
- The Trades page includes a market filter for Equity, Options, Futures, and Other.
- For an open trade, enter a positive **Current price**; unrealised P&L is recalculated as `(current price - entry price) × quantity` for BUY, or `(entry price - current price) × quantity` for SELL. Charges are applied to realised P&L.
- The app does not receive live market prices automatically; current price must be entered/updated manually.

### P&L Details and product classification

The dashboard's Unrealised P&L card opens the P&L Details view. It includes date-range controls, segment/product filters, monthly realised P&L summaries, open-position unrealised P&L, and CSV statement export. Run `supabase/update_pnl_details.sql` once in the existing Supabase SQL Editor to add the `product_type` field used by Intraday, Delivery, and MTF filters. Keep your existing `.env.local` file when replacing project files.
