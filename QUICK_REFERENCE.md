# 🚀 Quick Reference Card - Master Day Trading

## 📌 Instant Access

### Get Chart Page
```dart
Get.toNamed(Routes.chartPage);
```

### Load Today's Data (Intraday)
```dart
final api = Get.find<ApiController>();
api.setIntradayMode();  // Auto-loads current day
```

### Load Historical Data
```dart
api.fromDate.value = "2024-12-01";
api.toDate.value = "2024-12-12";
api.unit.value = "minutes";
api.interval.value = 5;
api.fetchData();
```

### Enable Autoplay
```dart
api.autoplayEnabled.value = true;
api.replaySpeed.value = 300; // milliseconds
```

## 🎯 API Endpoints

### Intraday (Today Only)
```
GET /historical-candle/intraday/{instrument}/{unit}/{interval}
Example: /historical-candle/intraday/NSE_EQ|INE848E01016/minutes/5
```

### Historical (Date Range)
```
GET /historical-candle/{instrument}/{unit}/{interval}/{toDate}/{fromDate}
Example: /historical-candle/NSE_EQ|INE848E01016/days/1/2024-12-12/2024-12-01
```

## 📊 Instrument Keys

```dart
// Popular stocks
"NSE_EQ|INE848E01016"  // Reliance Industries
"NSE_EQ|INE467B01029"  // Tata Consultancy Services (TCS)
"NSE_EQ|INE040A01034"  // HDFC Bank
"NSE_EQ|INE002A01018"  // Reliance Industries
"NSE_EQ|INE009A01021"  // Infosys

// Indices
"NSE_INDEX|Nifty 50"
"NSE_INDEX|Nifty Bank"
"NSE_INDEX|Nifty IT"
```

## 🎨 Indicator IDs

```dart
chart.addIndicator("sma20");   // Simple Moving Average
chart.addIndicator("ema20");   // Exponential Moving Average
chart.addIndicator("rsi14");   // Relative Strength Index
chart.addIndicator("vwap");    // Volume Weighted Avg Price
chart.addIndicator("bb20");    // Bollinger Bands

// Custom periods
chart.addIndicator("sma50");   // 50-period SMA
chart.addIndicator("ema9");    // 9-period EMA
chart.addIndicator("rsi7");    // 7-period RSI
```

## ⌨️ Keyboard Shortcuts (To Implement)

```dart
// Add to chart_view_responsive.dart
KeyboardListener(
  onKeyEvent: (event) {
    if (event is KeyDownEvent) {
      switch (event.logicalKey) {
        case LogicalKeyboardKey.space:
          chart.startReplay();
          break;
        case LogicalKeyboardKey.keyP:
          chart.pauseReplay();
          break;
        case LogicalKeyboardKey.keyS:
          chart.stopReplay();
          break;
      }
    }
  },
  child: yourWidget,
)
```

## 💾 State Management

### Observable Variables
```dart
// API Controller
api.isLoading          // bool - Loading state
api.autoplayEnabled    // bool - Autoplay toggle
api.replaySpeed        // int - Speed in ms
api.unit               // String - Timeframe unit
api.interval           // int - Interval value
api.fromDate           // String - Start date
api.toDate             // String - End date
```

### Listen to Changes
```dart
ever(api.isLoading, (loading) {
  if (loading) print("Loading data...");
  else print("Data loaded!");
});
```

## 🎬 Playback Methods

```dart
final chart = Get.find<ChartController>();

chart.startReplay();        // Start from beginning
chart.pauseReplay();        // Pause at current
chart.stopReplay();         // Stop and clear
chart.setSpeed(500);        // Set speed (ms)
chart.sendData(candles);    // Load new data
chart.setStartDate("2024-12-01");  // Set replay start
```

## 🎯 Common Patterns

### Pattern 1: Quick Backtest
```dart
// Load last month, 5-min candles, autoplay
api.fromDate.value = DateTime.now()
    .subtract(Duration(days: 30))
    .toString().substring(0, 10);
api.toDate.value = DateTime.now().toString().substring(0, 10);
api.unit.value = "minutes";
api.interval.value = 5;
api.autoplayEnabled.value = true;
api.fetchData();
```

### Pattern 2: Live Analysis
```dart
// Today's data, no autoplay
api.setIntradayMode();
```

### Pattern 3: Pattern Study
```dart
// Slow replay with indicators
api.autoplayEnabled.value = true;
api.replaySpeed.value = 1000;
chart.addIndicator("sma20");
chart.addIndicator("rsi14");
api.fetchData();
```

## 🔧 Troubleshooting

### No data loading?
```dart
// Check token
print(api.api.token);  // Should not be empty

// Check dates
print("From: ${api.fromDate.value}");
print("To: ${api.toDate.value}");

// Check response
try {
  await api.fetchData();
} catch (e) {
  print("Error: $e");
}
```

### Chart not displaying?
```dart
// Check platform
print(GetPlatform.isWeb);  // true for web
print(GetPlatform.isAndroid);  // true for android

// Verify chart controller
final chart = Get.find<ChartController>();
print(chart.viewId);  // Should be "chart-iframe-view"
```

### Replay not working?
```dart
// Ensure data is loaded
if (api.isLoading.value) {
  print("Wait for data to load");
} else {
  chart.startReplay();
}

// Check start date is set
chart.setStartDate(api.fromDate.value);
```

## 📱 Responsive Breakpoints

```dart
final size = MediaQuery.of(context).size;
final isDesktop = size.width > 1024;   // Full toolbar
final isTablet = size.width > 600;      // Compact toolbar
final isMobile = size.width <= 600;     // Dialogs + dropdowns
```

## 🎨 Color Scheme

```dart
// Dark theme colors
const background = Color(0xff0d0d0f);
const toolbar = Color(0xff111113);
const button = Color(0xff262628);
const active = Colors.blueAccent;
const success = Colors.green;
const error = Colors.red;
const warning = Colors.orange;
```

## 💡 Pro Tips

1. **Always validate dates** before API call
2. **Use autoplay for demos** - great UX
3. **Limit replay speed** on mobile (slower = smoother)
4. **Add indicators before replay** for better visualization
5. **Cache successful responses** to reduce API calls
6. **Use intraday API** when possible (faster)
7. **Show loading states** - users appreciate feedback
8. **Implement retry logic** for failed API calls
9. **Test with different instruments** - not all have same data
10. **Monitor API quota** - Upstox may have limits

## 📊 Performance Benchmarks

```
Data Load (1000 candles):
- Intraday API: ~1-2 seconds
- Historical API: ~2-3 seconds

Replay (1000 candles):
- 100ms speed: ~100 seconds
- 300ms speed: ~300 seconds (5 min)
- 1000ms speed: ~1000 seconds (16 min)

Chart Rendering:
- Initial: <500ms
- Indicator add: <100ms
- Replay step: <50ms
```

## 🔗 Useful Links

- [Upstox API Docs](https://upstox.com/developer/api-documentation/v3/)
- [TradingView Charts](https://tradingview.github.io/lightweight-charts/)
- [GetX Docs](https://pub.dev/packages/get)
- [AdMob Setup](https://admob.google.com/)

## 📞 Quick Commands

```bash
# Run on web
flutter run -d chrome

# Build for production
flutter build web --release

# Check for errors
flutter analyze

# Update dependencies
flutter pub upgrade

# Clean build
flutter clean && flutter pub get

# Generate icons
flutter pub run flutter_launcher_icons
```

---

**Remember**: Start with test mode → Verify everything works → Replace with production keys → Deploy! 🚀
