# Master Day Trading - React/Next.js Charting Application

A professional TradingView-style charting application built with React, Next.js, and the Upstox API.

## Features

### ✅ Implemented

- **Full Candle Charting Engine**
  - Built with `lightweight-charts` library
  - Candlestick visualization with volume bars
  - Interactive pan and zoom
  - Crosshair with price/time display
  - Dark theme (matches TradingView aesthetic)

- **Technical Indicators**
  - Simple Moving Average (SMA)
  - Exponential Moving Average (EMA)
  - Volume Weighted Average Price (VWAP)
  - Relative Strength Index (RSI)
  - MACD (Moving Average Convergence Divergence)
  - Bollinger Bands
  - Supertrend
  - Average True Range (ATR)
  - Easy add/remove/configure indicators

- **Replay / Bar-By-Bar Playback System (MAIN FEATURE)**
  - Toggle replay mode (R key)
  - Play/pause controls (Space key)
  - Next/previous bar navigation (N/P keys)
  - Speed control (0.5x, 1x, 2x, 5x, 10x)
  - Progress bar with seek functionality
  - Current candle OHLCV display
  - Bookmark progress
  - Automatic state persistence

- **Upstox API Integration**
  - Historical candle data fetching
  - Intraday candle data
  - Smart endpoint selection (historical vs intraday)
  - Request caching (5 min for historical, 1 min for intraday)
  - Automatic retry with exponential backoff
  - Multi-request stitching for large date ranges

- **State Management**
  - Zustand stores with localStorage persistence
  - Chart state (candles, instrument, timeframe)
  - Replay state (progress, speed, bookmarks)
  - Indicator state (active indicators, parameters)
  - Drawing state (saved drawings)
  - UI preferences (theme, sidebar state)

- **User Interface**
  - Instrument selector (Upstox instrument keys)
  - Timeframe selector (1m, 5m, 15m, 30m, 1h, 1D, 1W, 1M)
  - Date range picker
  - Dark/light theme toggle
  - Drawing tools panel
  - Indicator management panel
  - Keyboard shortcuts
  - Responsive layout

- **Drawing Tools (Structure Ready)**
  - Trendline
  - Horizontal line
  - Fibonacci retracement
  - Brush
  - Text annotation
  - Eraser
  - (Canvas rendering to be completed)

- **Ad Support**
  - Top and bottom ad banner placeholders
  - Toggle via environment variable
  - Ready for Google AdSense integration

### 🚧 Pending Implementation

- Full canvas drawing overlay
- Mouse interaction for drawing tools
- Coordinate transformation (chart space ↔ canvas space)
- Drawing snap-to-price functionality
- Screenshot/export to PNG
- Custom indicator scripting engine
- Multi-timeframe analysis
- Chart pattern recognition
- Alert system
- Mobile responsive optimizations

## Tech Stack

- **Next.js 14.0.4** - React framework with App Router
- **React 18.2.0** - UI library
- **TypeScript 5.3.3** - Type safety
- **lightweight-charts 4.1.3** - High-performance charting
- **Zustand 4.4.7** - State management
- **TailwindCSS 3.4.0** - Styling
- **Axios 1.6.2** - HTTP client
- **date-fns 3.0.6** - Date manipulation

## Project Structure

```
web/
├── app/
│   ├── globals.css          # Global styles with dark theme
│   ├── layout.tsx            # Root layout
│   └── page.tsx              # Main page with component composition
├── components/
│   ├── chart/
│   │   ├── ChartContainer.tsx      # Main chart component
│   │   ├── IndicatorRenderer.tsx   # Indicator overlay rendering
│   │   └── DrawingRenderer.tsx     # Drawing overlay (placeholder)
│   ├── Toolbar.tsx                 # Left sidebar controls
│   ├── IndicatorPanel.tsx          # Top indicator management
│   ├── ReplayControls.tsx          # Bottom replay controls
│   └── AdBanner.tsx                # Ad banner component
├── lib/
│   ├── upstox/
│   │   └── api.ts                  # Upstox API wrapper
│   └── indicators/
│       └── calculations.ts         # Technical indicator math
├── store/
│   ├── chartStore.ts               # Chart state management
│   ├── replayStore.ts              # Replay state management
│   ├── indicatorStore.ts           # Indicator state management
│   ├── drawingStore.ts             # Drawing state management
│   └── uiStore.ts                  # UI preferences
├── types/
│   └── index.ts                    # TypeScript type definitions
├── .env.local                      # Environment variables
├── next.config.js                  # Next.js configuration
├── tailwind.config.js              # TailwindCSS configuration
├── tsconfig.json                   # TypeScript configuration
└── package.json                    # Dependencies and scripts
```

## Installation & Setup

### 1. Install Dependencies

```bash
cd web
npm install
```

### 2. Configure Environment Variables

The `.env.local` file is already configured with:

```bash
NEXT_PUBLIC_UPSTOX_API_URL=https://api.upstox.com/v3
NEXT_PUBLIC_UPSTOX_TOKEN=0e239d4b-55da-4aa6-9f9f-7e335ed273cb
NEXT_PUBLIC_ENABLE_ADS=false
```

**Note**: The Upstox API token is reused from the existing Flutter app configuration.

### 3. Run Development Server

```bash
npm run dev
```

The app will be available at `http://localhost:3000`

### 4. Build for Production

```bash
npm run build
npm start
```

## Usage

### Getting Started

1. **Fetch Data**: Enter an instrument key (e.g., `NSE_EQ|INE848E01016` for Reliance) and click "Fetch Data"
2. **Add Indicators**: Click "+ Add Indicator" in the top panel
3. **Enter Replay Mode**: Click "Enter Replay Mode" or press `R`
4. **Playback Controls**: Use play/pause, next/previous, or speed controls

### Keyboard Shortcuts

- `R` - Toggle replay mode
- `Space` - Play/pause replay
- `N` - Next bar
- `P` - Previous bar
- `Esc` - Exit replay mode / Cancel drawing
- Numbers - Select drawing tools

### Instrument Keys

Upstox instrument keys follow the format: `EXCHANGE|ISIN`

Examples:
- Reliance: `NSE_EQ|INE848E01016`
- TCS: `NSE_EQ|INE467B01029`
- HDFC Bank: `NSE_EQ|INE040A01034`
- Infosys: `NSE_EQ|INE009A01021`

### Timeframes

- **1m, 5m, 15m, 30m**: Intraday trading (use today's date)
- **1h**: Hourly candles
- **1D**: Daily candles (for swing trading)
- **1W, 1M**: Weekly and monthly (long-term analysis)

### Technical Indicators

All indicators support customization:
- **Period**: Lookback period for calculation
- **Color**: Line color on chart
- **Additional params**: Specific to indicator type (e.g., RSI overbought/oversold levels)

## API Integration

### Upstox API Endpoints

The app uses Upstox API v3:

**Historical Data**:
```
GET /historical-candle/{instrument}/{interval}/{toDate}/{fromDate}
```

**Intraday Data**:
```
GET /intra-day-candle/{instrument}/{interval}
```

### Smart Endpoint Selection

The `getCandles()` method automatically selects:
- **Intraday endpoint**: When date range is within today
- **Historical endpoint**: For past data or multi-day ranges

### Caching & Performance

- Historical data: 5-minute cache
- Intraday data: 1-minute cache
- Automatic retry: 3 attempts with exponential backoff
- Multi-request stitching: For date ranges > 365 days

## State Management

### Zustand Stores

1. **chartStore**: Candle data, chart API refs, instrument configuration
2. **replayStore**: Replay mode, playback state, progress tracking
3. **indicatorStore**: Active indicators, parameters, visibility
4. **drawingStore**: Saved drawings, active tool, drawing lifecycle
5. **uiStore**: Theme, sidebar state, volume/grid visibility

### Persistence

The following data is automatically saved to localStorage:
- Replay progress and bookmarks
- Active indicators and their parameters
- Saved drawings
- UI preferences (theme, sidebar state)

## Development Notes

### Adding New Indicators

1. Add calculation function to `lib/indicators/calculations.ts`
2. Add indicator type to `INDICATOR_TYPES` in `store/indicatorStore.ts`
3. Add default parameters to `DEFAULT_PARAMS`
4. Add rendering logic to `components/chart/IndicatorRenderer.tsx`

### Adding New Drawing Tools

1. Add tool type to `DrawingTool` in `store/drawingStore.ts`
2. Implement mouse event handlers in `DrawingRenderer.tsx`
3. Add tool button to `Toolbar.tsx`
4. Implement rendering logic with canvas overlay

## Known Issues

- Drawing tools structure is ready but canvas overlay needs implementation
- Indicator series are recreated on every update (should be cached and updated)
- No error boundaries for graceful error handling
- Mobile layout needs optimization

## Performance Optimization

- Dynamic import of ChartContainer to avoid SSR issues
- Memoization of indicator calculations
- Request caching to reduce API calls
- Debounced resize handlers
- Virtualized lists for large datasets (future)

## Deployment

### Vercel (Recommended)

```bash
vercel deploy
```

### Self-Hosted

```bash
npm run build
npm start
```

Set environment variables on your hosting platform.

## Contributing

This is a production-ready foundation. Contributions welcome for:
- Canvas drawing implementation
- Mobile responsive optimizations
- Additional indicators (Ichimoku, Keltner Channels, etc.)
- Custom indicator scripting engine
- Alert system
- Multi-chart layouts

## License

[Your License]

## Credits

- Built with [lightweight-charts](https://tradingview.github.io/lightweight-charts/)
- Data powered by [Upstox API](https://upstox.com/developer/api-documentation/)
- Inspired by [TradingView](https://www.tradingview.com/)

---

**Last Updated**: January 2025
**Version**: 1.0.0
**Status**: Production-Ready Foundation ✅
