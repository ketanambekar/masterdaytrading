# Master Day Trading - Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────────┐
│                          USER INTERFACE                              │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  ┌──────────────────┐              ┌──────────────────┐            │
│  │   Home Page      │              │   Chart Page     │            │
│  │  (Landing)       │─────────────▶│  (Responsive)    │            │
│  │                  │              │                  │            │
│  │ • Video BG       │              │ • Desktop View   │            │
│  │ • Pricing        │              │ • Tablet View    │            │
│  │ • Benefits       │              │ • Mobile View    │            │
│  │ • Instagram      │              │ • Controls       │            │
│  │ • Payment        │              │ • Loading        │            │
│  └──────────────────┘              └──────────────────┘            │
│                                             │                       │
└─────────────────────────────────────────────┼───────────────────────┘
                                              │
                    ┌─────────────────────────┼─────────────────────────┐
                    │           STATE MANAGEMENT (GetX)                 │
                    ├───────────────────────────────────────────────────┤
                    │                                                   │
                    │  ┌──────────────────┐    ┌──────────────────┐   │
                    │  │  ChartController │    │  ApiController   │   │
                    │  │                  │    │                  │   │
                    │  │ • sendData()     │◀──▶│ • fetchData()    │   │
                    │  │ • startReplay()  │    │ • isLoading      │   │
                    │  │ • pauseReplay()  │    │ • autoplay       │   │
                    │  │ • addIndicator() │    │ • replaySpeed    │   │
                    │  │ • setSpeed()     │    │ • unit/interval  │   │
                    │  └──────────────────┘    └──────────────────┘   │
                    │           │                        │             │
                    └───────────┼────────────────────────┼─────────────┘
                                │                        │
                    ┌───────────▼────────────────────────▼─────────────┐
                    │              SERVICE LAYER                        │
                    ├───────────────────────────────────────────────────┤
                    │                                                   │
                    │  ┌──────────────────────────────────────────┐   │
                    │  │           ApiService                      │   │
                    │  │                                           │   │
                    │  │  • getHistoricalCandles()                │   │
                    │  │    └─▶ /historical-candle/{key}/{unit}/  │   │
                    │  │        {interval}/{toDate}/{fromDate}    │   │
                    │  │                                           │   │
                    │  │  • getIntradayCandles()                  │   │
                    │  │    └─▶ /historical-candle/intraday/      │   │
                    │  │        {key}/{unit}/{interval}           │   │
                    │  │                                           │   │
                    │  │  • getCandles() [Smart Router]           │   │
                    │  │                                           │   │
                    │  └──────────────────────────────────────────┘   │
                    │                     │                            │
                    └─────────────────────┼────────────────────────────┘
                                          │
                              ┌───────────▼───────────┐
                              │     Dio HTTP Client    │
                              │   (with interceptors)  │
                              └───────────┬───────────┘
                                          │
                              ┌───────────▼───────────┐
                              │    UPSTOX API v3      │
                              │  api.upstox.com/v3    │
                              └───────────────────────┘


┌─────────────────────────────────────────────────────────────────────┐
│                        CHART RENDERING LAYER                         │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  ┌──────────────────────────────────────────────────────────────┐  │
│  │         realtime_chart.html (Lightweight Charts)             │  │
│  │                                                               │  │
│  │  ┌────────────────────────────────────────────────────────┐ │  │
│  │  │  Chart Instance                                         │ │  │
│  │  │  • Candlestick Series (price action)                   │ │  │
│  │  │  • Volume Histogram (volume bars)                      │ │  │
│  │  │  • Indicator Series (SMA/EMA/RSI/VWAP/BB)             │ │  │
│  │  └────────────────────────────────────────────────────────┘ │  │
│  │                                                               │  │
│  │  ┌────────────────────────────────────────────────────────┐ │  │
│  │  │  Replay Engine                                          │ │  │
│  │  │  • fullData[] (all candles)                            │ │  │
│  │  │  • replayRows[] (filtered by date)                     │ │  │
│  │  │  • replayPos (current position)                        │ │  │
│  │  │  • replayTimer (interval)                              │ │  │
│  │  └────────────────────────────────────────────────────────┘ │  │
│  │                                                               │  │
│  │  ┌────────────────────────────────────────────────────────┐ │  │
│  │  │  Indicator Calculator                                   │ │  │
│  │  │  • calculateSMA(data, period)                          │ │  │
│  │  │  • calculateEMA(data, period)                          │ │  │
│  │  │  • calculateRSI(data, period)                          │ │  │
│  │  │  • calculateVWAP(data)                                 │ │  │
│  │  │  • calculateBB(data, period, mult)                     │ │  │
│  │  └────────────────────────────────────────────────────────┘ │  │
│  │                                                               │  │
│  └──────────────────────────────────────────────────────────────┘  │
│                           ▲                                         │
│                           │ postMessage (Web) / runJavaScript       │
│                           │ (Mobile)                                │
└───────────────────────────┼─────────────────────────────────────────┘
                            │
                  ┌─────────┴─────────┐
                  │                   │
          ┌───────▼──────┐   ┌───────▼──────┐
          │   IFrame     │   │  WebView     │
          │   (Web)      │   │  (Mobile)    │
          └──────────────┘   └──────────────┘


┌─────────────────────────────────────────────────────────────────────┐
│                         DATA FLOW                                    │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  USER ACTION                                                         │
│       │                                                              │
│       ▼                                                              │
│  [Select Date & Interval]                                            │
│       │                                                              │
│       ▼                                                              │
│  ApiController.fetchData()                                           │
│       │                                                              │
│       ├─▶ Check if intraday or historical                           │
│       │                                                              │
│       ├─▶ ApiService.getCandles()                                   │
│       │         │                                                    │
│       │         ▼                                                    │
│       │    Upstox API Call                                           │
│       │         │                                                    │
│       │         ▼                                                    │
│       │    Parse Response                                            │
│       │         │                                                    │
│       │         ▼                                                    │
│       │    Convert to Chart Format                                   │
│       │    [time, open, high, low, close, volume]                   │
│       │         │                                                    │
│       ▼         ▼                                                    │
│  ChartController.sendData(candles)                                   │
│       │                                                              │
│       ▼                                                              │
│  postMessage / runJavaScript                                         │
│       │                                                              │
│       ▼                                                              │
│  HTML: window.addData(data)                                          │
│       │                                                              │
│       ▼                                                              │
│  candleSeries.setData(fullData)                                      │
│       │                                                              │
│       ▼                                                              │
│  Chart Renders                                                       │
│       │                                                              │
│       ▼                                                              │
│  [If autoplay enabled]                                               │
│       │                                                              │
│       ▼                                                              │
│  startReplayInternal()                                               │
│       │                                                              │
│       ▼                                                              │
│  setInterval(replaySpeedMs)                                          │
│       │                                                              │
│       ▼                                                              │
│  candleSeries.update(row) [one by one]                               │
│       │                                                              │
│       ▼                                                              │
│  Visual Animation                                                    │
│                                                                      │
└──────────────────────────────────────────────────────────────────────┘


┌─────────────────────────────────────────────────────────────────────┐
│                    RESPONSIVE BREAKPOINTS                            │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  Mobile (≤600px)           Tablet (600-1024px)      Desktop (>1024) │
│  ┌────────────┐            ┌────────────────┐      ┌──────────────┐│
│  │ Compact UI │            │  Optimized UI  │      │   Full UI    ││
│  │            │            │                │      │              ││
│  │ • Stacked  │            │ • Two columns  │      │ • Two rows   ││
│  │ • Dropdowns│            │ • Inline chips │      │ • All visible││
│  │ • Dialogs  │            │ • Visible ctrls│      │ • Horizontal ││
│  │ • Icons    │            │ • Compact space│      │ • Spacious   ││
│  └────────────┘            └────────────────┘      └──────────────┘│
│                                                                      │
└──────────────────────────────────────────────────────────────────────┘


┌─────────────────────────────────────────────────────────────────────┐
│                      ERROR HANDLING FLOW                             │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  API Call                                                            │
│      │                                                               │
│      ├─▶ [Try]                                                       │
│      │     │                                                         │
│      │     ├─▶ Success                                               │
│      │     │     │                                                   │
│      │     │     ├─▶ candles.isEmpty?                               │
│      │     │     │     ├─▶ Yes: Show "No Data" snackbar             │
│      │     │     │     └─▶ No: Process & display                    │
│      │     │     │                                                   │
│      │     │     └─▶ Show success message                           │
│      │     │                                                         │
│      │     └─▶ [Catch DioException]                                 │
│      │           │                                                   │
│      │           ├─▶ Timeout: "Check connection"                    │
│      │           ├─▶ Bad Response: "Server error: {code}"           │
│      │           ├─▶ Cancel: "Request cancelled"                    │
│      │           └─▶ Other: "Network error"                         │
│      │                                                               │
│      └─▶ [Finally]                                                   │
│            │                                                         │
│            └─▶ isLoading.value = false                               │
│                                                                      │
└──────────────────────────────────────────────────────────────────────┘


┌─────────────────────────────────────────────────────────────────────┐
│                   MONETIZATION ARCHITECTURE                          │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  ┌──────────────────────────────────────────────────────────────┐  │
│  │                    User Viewing App                           │  │
│  └────────────────────────────┬─────────────────────────────────┘  │
│                                │                                    │
│         ┌──────────────────────┼──────────────────────┐            │
│         │                      │                      │            │
│         ▼                      ▼                      ▼            │
│  ┌────────────┐        ┌────────────┐        ┌────────────┐      │
│  │   Banner   │        │Interstitial│        │   Native   │      │
│  │    Ad      │        │    Ad      │        │    Ad      │      │
│  │            │        │            │        │            │      │
│  │ • Bottom   │        │ • After    │        │ • Between  │      │
│  │ • Always   │        │   data     │        │   sections │      │
│  │ • Visible  │        │ • 5min cap │        │ • Blended  │      │
│  └────────────┘        └────────────┘        └────────────┘      │
│         │                      │                      │            │
│         └──────────────────────┼──────────────────────┘            │
│                                │                                    │
│                                ▼                                    │
│                      ┌─────────────────┐                           │
│                      │   AdMob SDK     │                           │
│                      │  (Mediation)    │                           │
│                      └────────┬────────┘                           │
│                               │                                     │
│                ┌──────────────┼──────────────┐                     │
│                │              │              │                     │
│                ▼              ▼              ▼                     │
│         ┌──────────┐   ┌──────────┐   ┌──────────┐               │
│         │  Google  │   │ Facebook │   │ Unity Ads│               │
│         │  Ads     │   │Audience  │   │          │               │
│         └──────────┘   └──────────┘   └──────────┘               │
│                │              │              │                     │
│                └──────────────┼──────────────┘                     │
│                               │                                     │
│                               ▼                                     │
│                         [Ad Served]                                │
│                               │                                     │
│                               ▼                                     │
│                        [User Views]                                │
│                               │                                     │
│                               ▼                                     │
│                       [Revenue ₹₹₹]                                │
│                                                                      │
└──────────────────────────────────────────────────────────────────────┘


┌─────────────────────────────────────────────────────────────────────┐
│                      DEPLOYMENT WORKFLOW                             │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  Development                                                         │
│       │                                                              │
│       ├─▶ Code in VS Code                                           │
│       ├─▶ Test locally (flutter run -d chrome)                      │
│       ├─▶ Verify features work                                      │
│       │                                                              │
│       ▼                                                              │
│  Testing                                                             │
│       │                                                              │
│       ├─▶ Use test Ad IDs                                           │
│       ├─▶ Test on multiple devices                                  │
│       ├─▶ Check responsive layouts                                  │
│       ├─▶ Verify API calls                                          │
│       │                                                              │
│       ▼                                                              │
│  Production Setup                                                    │
│       │                                                              │
│       ├─▶ Create AdMob account                                      │
│       ├─▶ Get production Ad Unit IDs                                │
│       ├─▶ Update API token (secure storage)                         │
│       ├─▶ Add Privacy Policy                                        │
│       ├─▶ Configure app signing                                     │
│       │                                                              │
│       ▼                                                              │
│  Build                                                               │
│       │                                                              │
│       ├─▶ flutter build web --release                               │
│       ├─▶ flutter build apk --release                               │
│       ├─▶ flutter build ios --release                               │
│       │                                                              │
│       ▼                                                              │
│  Deploy                                                              │
│       │                                                              │
│       ├─▶ Web: Firebase Hosting / Netlify / Vercel                  │
│       ├─▶ Android: Google Play Store                                │
│       ├─▶ iOS: Apple App Store                                      │
│       │                                                              │
│       ▼                                                              │
│  Monitor                                                             │
│       │                                                              │
│       ├─▶ AdMob analytics                                           │
│       ├─▶ Firebase analytics                                        │
│       ├─▶ User feedback                                             │
│       └─▶ Error tracking (Sentry/Firebase Crashlytics)              │
│                                                                      │
└──────────────────────────────────────────────────────────────────────┘
```

## 🎯 Key Takeaways

1. **Clean Architecture**: Separation of concerns (UI, State, Service, Data)
2. **Smart API Routing**: Automatic selection of optimal endpoint
3. **Responsive Design**: Single codebase, multiple layouts
4. **Error Resilience**: Comprehensive error handling at every layer
5. **Monetization Ready**: Ad integration points identified
6. **Performance Optimized**: Efficient data processing and rendering
7. **User Experience First**: Loading states, feedback, smooth animations
8. **Scalable**: Easy to add features (new indicators, instruments, etc.)

## 📊 Component Interactions

- **Tight Coupling**: ChartController ↔ HTML Chart (by design)
- **Loose Coupling**: UI ↔ Controllers (via GetX)
- **Independent**: Service Layer (can be used anywhere)
- **Isolated**: Ad System (doesn't affect core functionality)
