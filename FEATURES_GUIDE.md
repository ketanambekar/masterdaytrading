# Master Day Trading - Features Guide

## 🎯 Quick Start

### 1. Accessing the Chart
- Navigate to `/chart-page` route
- Default loads: Last 7 days, 5-minute candles

### 2. Loading Data

#### Option A: Intraday (Today's Data)
1. Leave date fields empty
2. Select "Minutes" or "Hours"
3. Choose interval (1, 3, 5, 15, 30, 60)
4. Click "Fetch Data" or change parameters (auto-fetches)

#### Option B: Historical Data
1. Enter dates: `YYYY-MM-DD` format
   - From: `2024-12-01`
   - To: `2024-12-12`
2. Select timeframe: Minutes, Hours, Days, Weeks, Months
3. Choose interval
4. Auto-fetches on valid date entry

### 3. Autoplay Feature

#### Enable Autoplay
Desktop:
- Check "Auto-play" checkbox in toolbar

Mobile:
- Tap Settings icon (gear)
- Enable "Auto-play on Load"

#### How It Works
1. Load data (historical or intraday)
2. If autoplay enabled, chart automatically starts plotting candles one by one
3. Default speed: 300ms per candle

#### Adjust Speed
Desktop:
- Use speed dropdown: 100ms - 2000ms

Mobile:
- Tap Settings → Adjust slider

**Speed Guide**:
- `100ms` = Very Fast (10 candles/second)
- `300ms` = Normal (3 candles/second)
- `500ms` = Slow (2 candles/second)
- `1000ms` = Very Slow (1 candle/second)
- `2000ms` = Ultra Slow (1 candle/2 seconds)

### 4. Playback Controls

| Button | Action | Shortcut |
|--------|--------|----------|
| ▶️ Play | Start/Resume replay | - |
| ⏸️ Pause | Pause replay | - |
| ⏹️ Stop | Stop & reset | - |

**Behavior**:
- Play: Starts from selected date
- Pause: Freezes at current candle
- Stop: Clears chart, ready for new replay

### 5. Adding Indicators

#### Desktop
Click indicator buttons:
- **SMA** - Simple Moving Average (20 periods, Yellow)
- **EMA** - Exponential Moving Average (20 periods, Cyan)
- **RSI** - Relative Strength Index (14 periods, Pink, separate pane)
- **VWAP** - Volume Weighted Avg Price (Orange)
- **BB** - Bollinger Bands (20 periods, Orange bands)

#### Mobile
1. Tap "Show Chart" icon
2. Select indicators from dialog
3. Tap to toggle on/off

**Toggle Behavior**: Click same indicator again to remove it

### 6. Timeframes & Intervals

#### Minutes
- Intervals: 1, 3, 5, 15, 30, 60
- Best for: Intraday scalping
- Data: Current day (intraday) or historical

#### Hours
- Intervals: 1, 2, 4
- Best for: Swing trading
- Data: Current day (intraday) or historical

#### Days
- Interval: 1
- Best for: Daily analysis
- Data: Historical only (requires date range)

#### Weeks
- Interval: 1
- Best for: Weekly trends
- Data: Historical only

#### Months
- Interval: 1
- Best for: Long-term analysis
- Data: Historical only

## 🎨 Responsive Layouts

### Desktop (>1024px)
```
┌────────────────────────────────────────────────┐
│ [From] [To] [M][H][D][W][M] [1][3][5] [Fetch] │
│ [▶️][⏸️][⏹️] Speed: [300ms▼] ☑️Auto [Indicators] │
├────────────────────────────────────────────────┤
│                                                │
│            CHART AREA                          │
│                                                │
└────────────────────────────────────────────────┘
```

### Tablet (600-1024px)
- Similar to desktop
- Slightly compact spacing
- All controls visible

### Mobile (<600px)
```
┌──────────────────────┐
│ [From Date] [To Date]│
│ [Unit▼] [Int▼] [🔄]  │
│ [▶️] [⏸️] [⏹️] [📊] [⚙️]│
├──────────────────────┤
│                      │
│    CHART AREA        │
│                      │
└──────────────────────┘
```

## 🔧 Advanced Features

### 1. Smart API Selection
App automatically chooses:
- **Intraday API**: Minutes/Hours without dates
- **Historical API**: All other cases

**Why?**
- Intraday API: Faster, current day only
- Historical API: More flexible, requires dates

### 2. Error Handling

#### Common Errors & Solutions

**"Date Required"**
- Solution: Enter both From and To dates
- Format: `YYYY-MM-DD`

**"Connection timeout"**
- Solution: Check internet connection
- Retry after few seconds

**"Server error: 401"**
- Solution: Update API token in code
- Location: `lib/services/api_controller.dart`

**"No candles found"**
- Reasons:
  - Market holiday
  - Weekend
  - Invalid instrument key
  - Future date selected

### 3. Loading States

**Visual Feedback**:
- Loading: Semi-transparent overlay with spinner
- Success: Green snackbar with candle count
- Error: Red snackbar with error message

**Auto-dismiss**: 2-4 seconds

### 4. Data Optimization

**Automatic Features**:
- Data reversal (oldest first)
- Type conversion (num → double/int)
- Timezone handling (IST)
- Error boundaries

## 📊 Chart Interpretation

### Candlestick Colors
- 🟢 **Green**: Close > Open (Bullish)
- 🔴 **Red**: Close < Open (Bearish)

### Volume
- Shows at bottom (0-15% of chart height)
- Color matches candle (green/red)

### Indicators

#### SMA (Yellow Line)
- Smooth average of last 20 closes
- Above price = potential resistance
- Below price = potential support

#### EMA (Cyan Line)
- Faster response than SMA
- Crossover strategies popular
- More weight to recent prices

#### RSI (Pink Line, Bottom Pane)
- Range: 0-100
- > 70 = Overbought
- < 30 = Oversold
- 50 = Neutral

#### VWAP (Orange Line)
- Institution benchmark
- Above VWAP = bullish
- Below VWAP = bearish

#### Bollinger Bands (Orange Bands)
- Middle = SMA(20)
- Upper = SMA + 2*StdDev
- Lower = SMA - 2*StdDev
- Price touching bands = potential reversal

## 🎯 Use Cases

### 1. Backtesting Strategy
```
1. Set historical date range (e.g., last month)
2. Select 5-minute interval
3. Add indicators (SMA, EMA, RSI)
4. Enable autoplay
5. Observe strategy performance
```

### 2. Live Market Analysis
```
1. Leave dates empty
2. Select "Minutes" → "5"
3. Click Fetch (gets today's data)
4. Disable autoplay
5. See real-time candles (manual refresh)
```

### 3. Pattern Recognition Training
```
1. Historical data (any range)
2. Slower speed (1000ms)
3. Pause at interesting patterns
4. Study formation
5. Resume to see outcome
```

## 🚀 Performance Tips

### Faster Loading
- Use shorter date ranges (< 30 days)
- Smaller intervals for recent data
- Intraday mode for current day

### Smooth Replay
- Close unused indicators
- Use moderate speed (300-500ms)
- Avoid switching instruments during replay

### Mobile Optimization
- Use WiFi for initial load
- Cache data locally
- Restart app if memory issues

## 🔐 Security Best Practices

### API Token
```dart
// ❌ DON'T: Hardcode in public repo
final api = ApiService("your-real-token");

// ✅ DO: Use environment variables
final token = String.fromEnvironment('UPSTOX_TOKEN');
final api = ApiService(token);
```

### Build with env var:
```bash
flutter run --dart-define=UPSTOX_TOKEN=your_token_here
```

## 📱 Mobile-Specific Features

### Gestures
- **Pinch**: Zoom chart
- **Drag**: Pan chart
- **Double-tap**: Reset zoom

### Dialogs
- **Indicators**: Tap chart icon
- **Settings**: Tap gear icon
- **Help**: Long-press any button

## 🎨 Customization Examples

### Change Default Speed
```dart
// lib/services/api_controller.dart
RxInt replaySpeed = 500.obs; // Changed from 300
```

### Add More Speed Options
```dart
List<int> get speedOptions => [50, 100, 200, 300, 500, 1000, 2000];
```

### Change Default Timeframe
```dart
void setDefault1Day() {
  unit.value = "hours";    // Changed from "minutes"
  interval.value = 1;      // Changed from 5
  // ...
}
```

## 🆘 Troubleshooting

### Chart Not Loading
1. Check console for errors
2. Verify API token is valid
3. Check network tab for API calls
4. Clear browser cache (web)

### Replay Not Working
1. Ensure data is loaded first
2. Check if valid date is set
3. Verify speed is not too fast
4. Stop and restart

### Indicators Not Showing
1. Ensure data is loaded
2. Try removing and re-adding
3. Check if indicator is already added
4. Refresh page

### Mobile UI Issues
1. Check screen orientation
2. Update Flutter to latest
3. Clear app cache
4. Reinstall app

## 📞 Support & Resources

- **Documentation**: See README.md
- **API Docs**: https://upstox.com/developer/api-documentation/v3/
- **TradingView Charts**: https://tradingview.github.io/lightweight-charts/
- **Issues**: Check GitHub issues

---

**Pro Tip**: Start with shorter date ranges and slower speeds when learning. Gradually increase as you become familiar with the interface!
