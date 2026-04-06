# Master Day Trading (Next.js)

Historical replay web app for deliberate chart practice.

## Goals

- Keep URL compatibility from Flutter app:
  - `/`
  - `/chart-page`
- Focus only on historical candles (no intraday live feed)
- Replay one candle at a time with play/pause, speed, and step controls
- Real historical data source: Upstox V3 historical candle API (server-side proxy)

## Environment

Create a `.env.local` (or use the existing one) with:

```bash
UPSTOX_BASE_URL=https://api.upstox.com/v3
UPSTOX_ACCESS_TOKEN=your_token_here
```

The token stays server-side in `app/api/candles/route.ts` and is not exposed to the browser.

## Run locally

```bash
npm install
npm run dev
```

Open http://localhost:3000

## Build

```bash
npm run build
npm run start
```
