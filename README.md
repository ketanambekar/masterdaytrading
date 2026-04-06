# Master Day Trading - Professional Trading Platform

A comprehensive Flutter-based day trading application for Nifty & Bank Nifty intraday trading with advanced charting, real-time data, and replay capabilities.

## 🚀 Features

### Chart Features
- ✅ **Real-time Candlestick Charts** powered by TradingView Lightweight Charts
- ✅ **Historical & Intraday Data** from Upstox API
- ✅ **Autoplay/Replay Mode** with adjustable speed (100ms - 2000ms)
- ✅ **Multiple Indicators**: SMA, EMA, RSI, VWAP, Bollinger Bands
- ✅ **Multiple Timeframes**: Minutes (1, 3, 5, 15, 30, 60), Hours (1, 2, 4), Days, Weeks, Months
- ✅ **Date Range Selection** for historical backtesting
- ✅ **Responsive Design** for mobile, tablet, and desktop

### User Experience
- ✅ Multi-language support (English, Hindi, Gujarati)
- ✅ Loading states and error handling
- ✅ Auto-fetch on parameter change
- ✅ Razorpay payment integration
- ✅ Video background landing page
- ✅ Instagram integration

## 📱 Responsive Design

The application is fully responsive with:
- **Desktop (>1024px)**: Full toolbar with all controls visible
- **Tablet (600-1024px)**: Optimized layout with essential controls
- **Mobile (<600px)**: Compact UI with dropdown menus and dialogs

## 🔧 Technical Stack

- **Framework**: Flutter 3.4.3+
- **State Management**: GetX 4.7.2
- **HTTP Client**: Dio 5.9.0
- **Charts**: TradingView Lightweight Charts (Web)
- **WebView**: webview_flutter 4.13.0
- **Storage**: get_storage 2.1.1
- **Payments**: razorpay_flutter 1.4.0

## 🔌 API Integration

### Upstox API v3

The app supports both:

1. **Historical Candle Data API**
   ```
   GET /historical-candle/{instrumentKey}/{unit}/{interval}/{toDate}/{fromDate}
   ```
   - Used for: days, weeks, months
   - Requires: date range

2. **Intraday Candle Data API**
   ```
   GET /historical-candle/intraday/{instrumentKey}/{unit}/{interval}
   ```
   - Used for: minutes, hours (current day only)
   - No date range required

### Smart API Selection
The app automatically chooses the appropriate API based on:
- Selected timeframe unit
- Presence of date range
- Optimizes for performance and data availability

## 📊 Chart Controls

### Playback Controls
- **Play**: Start replay from selected date
- **Pause**: Pause current replay
- **Stop**: Stop and reset replay
- **Speed**: Adjust replay speed (100ms - 2000ms)
- **Auto-play**: Automatically start replay after loading data

### Indicators
- **SMA** (Simple Moving Average) - 20 period
- **EMA** (Exponential Moving Average) - 20 period
- **RSI** (Relative Strength Index) - 14 period
- **VWAP** (Volume Weighted Average Price)
- **BB** (Bollinger Bands) - 20 period, 2 std dev

## 📺 **IMPORTANT: Ads & Licensing Information**

### Can You Display Ads?

**YES, you can display ads without any licensing issues!** Here's why:

### ✅ TradingView Lightweight Charts License

**License Type**: Apache License 2.0

**What This Means**:
- ✅ **Free for commercial use** (including ads)
- ✅ No restrictions on monetization
- ✅ No attribution required (though recommended)
- ✅ Can modify and distribute
- ✅ Can use in proprietary software

**Official Statement**: TradingView's Lightweight Charts library is completely free and open-source with no commercial restrictions.

### 📱 Ad Integration Options

You can integrate ads using these Flutter packages:

#### 1. **Google AdMob** (Recommended)
```yaml
dependencies:
  google_mobile_ads: ^4.0.0
```
**Best For**: Banner ads, Interstitial ads, Rewarded ads
**Revenue**: High fill rate, reliable payments

#### 2. **Facebook Audience Network**
```yaml
dependencies:
  facebook_audience_network: ^1.0.0
```
**Best For**: Native ads, Banner ads
**Revenue**: Good rates in specific regions

#### 3. **Unity Ads**
```yaml
dependencies:
  unity_ads_plugin: ^0.3.0
```
**Best For**: Video ads, Gaming apps
**Revenue**: High CPM for video ads

#### 4. **AppLovin MAX** (Premium)
```yaml
dependencies:
  applovin_max: ^3.0.0
```
**Best For**: Mediation, Multiple ad networks
**Revenue**: Highest potential (combines multiple networks)

### 📍 Recommended Ad Placements

#### For Your Trading App:

1. **Bottom Banner** (Non-intrusive)
   ```dart
   // Already implemented in bottom_offer_bar.dart
   // Replace offer timer with AdMob banner
   ```

2. **Between Sections** (Home page)
   - After "About" card
   - After "Benefits" section
   - Before footer

3. **Interstitial Ads** (Full-screen)
   - After successful chart data load
   - Before navigating to chart page
   - Frequency: Max once every 3-5 minutes

4. **Native Ads** (Blended)
   - In Instagram feed section
   - In testimonials section

### 🎯 Implementation Example

```dart
// Add to pubspec.yaml
dependencies:
  google_mobile_ads: ^4.0.0

// Initialize in main.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await MobileAds.instance.initialize();
  
  runApp(MyApp());
}

// Create banner ad widget
class AdBanner extends StatefulWidget {
  @override
  _AdBannerState createState() => _AdBannerState();
}

class _AdBannerState extends State<AdBanner> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    _bannerAd = BannerAd(
      adUnitId: 'YOUR_AD_UNIT_ID', // Get from AdMob console
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) => setState(() => _isLoaded = true),
      ),
    )..load();
  }

  @override
  Widget build(BuildContext context) {
    if (_bannerAd != null && _isLoaded) {
      return Container(
        height: 50,
        child: AdWidget(ad: _bannerAd!),
      );
    }
    return const SizedBox.shrink();
  }
}
```

### 💰 Revenue Optimization Tips

1. **Use Mediation**: AppLovin MAX or Google AdMob mediation
2. **Ad Placement**: Bottom banners + occasional interstitials
3. **User Experience**: Don't interrupt chart viewing
4. **Frequency Capping**: Max 1 interstitial per 5 minutes
5. **Test Markets**: India has good CPM for finance apps

### ⚠️ What to Avoid

- ❌ Don't place ads over charts
- ❌ Don't interrupt active trading/replay
- ❌ Don't show interstitials during data loading
- ❌ Don't use more than 2 banner ads per screen

### 📋 Compliance Checklist

- ✅ TradingView Lightweight Charts: Apache 2.0 (Commercial use OK)
- ✅ Flutter: BSD 3-Clause (Commercial use OK)
- ✅ GetX: MIT License (Commercial use OK)
- ✅ All dependencies: Check `pubspec.yaml` (all are commercial-friendly)

**Bottom Line**: You're 100% clear to monetize with ads! No licensing issues.

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.4.3 or higher
- Upstox API access token
- Android/iOS/Web platform setup

### Installation

1. Clone the repository
```bash
git clone <your-repo-url>
cd masterdaytrading
```

2. Install dependencies
```bash
flutter pub get
```

3. Update API token in `lib/services/api_controller.dart`:
```dart
final api = ApiService("YOUR_UPSTOX_API_TOKEN");
```

4. Run the app
```bash
flutter run -d chrome  # For web
flutter run            # For mobile
```

## 🎨 Customization

### Change Default Instrument
Edit in `lib/services/api_controller.dart`:
```dart
RxString selectedInstrument = "NSE_EQ|INE848E01016".obs; // Reliance
```

### Adjust Replay Speeds
Edit in `lib/services/api_controller.dart`:
```dart
List<int> get speedOptions => [50, 100, 300, 500, 1000];
```

### Customize Chart Colors
Edit `assets/html/realtime_chart.html`:
```javascript
const chart = LightweightCharts.createChart(document.getElementById('chart'), {
  layout: { background: { color: '#000' }, textColor: '#fff' },
  // ... customize here
});
```

## 📦 Build for Production

### Web
```bash
flutter build web --release
```

### Android
```bash
flutter build apk --release
```

### iOS
```bash
flutter build ios --release
```

## 🔐 Security Notes

**IMPORTANT**: Never commit API tokens to version control!

Use environment variables or secure storage:
```dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = FlutterSecureStorage();
final token = await storage.read(key: 'upstox_token');
```

## 🐛 Known Issues & Solutions

1. **CORS errors on web**: Configure Upstox API CORS settings
2. **iOS WebView**: Enable in `Info.plist`
3. **Android WebView**: Enable in `AndroidManifest.xml`

## 📄 License

This project is licensed under the MIT License - see LICENSE file for details.

## 🤝 Contributing

Contributions are welcome! Please follow these steps:
1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push and create a Pull Request

## 📧 Support

For support, email: support@masterdaytrading.com

## 🙏 Acknowledgments

- [TradingView Lightweight Charts](https://github.com/tradingview/lightweight-charts)
- [Upstox API](https://upstox.com/developer/)
- Flutter & GetX communities
