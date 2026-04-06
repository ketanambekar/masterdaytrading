/// Ad Integration Example for Master Day Trading
/// This file shows how to integrate Google AdMob into your trading app

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// STEP 1: Add to pubspec.yaml
/// ```yaml
/// dependencies:
///   google_mobile_ads: ^4.0.0
/// ```

/// STEP 2: Initialize in main.dart
/// ```dart
/// void main() async {
///   WidgetsFlutterBinding.ensureInitialized();
///   await GetStorage.init();
///   await MobileAds.instance.initialize();
///   Get.put(OfferTimerController());
///   runApp(MyApp(localeService: LocaleService()));
/// }
/// ```

/// STEP 3: Add Ad Unit IDs to constants
class AdConstants {
  // Get these from AdMob console: https://apps.admob.com/
  
  // Android Ad Unit IDs
  static const String androidBannerId = 'ca-app-pub-3940256099942544/6300978111'; // Test ID
  static const String androidInterstitialId = 'ca-app-pub-3940256099942544/1033173712'; // Test ID
  static const String androidNativeId = 'ca-app-pub-3940256099942544/2247696110'; // Test ID
  
  // iOS Ad Unit IDs
  static const String iosBannerId = 'ca-app-pub-3940256099942544/2934735716'; // Test ID
  static const String iosInterstitialId = 'ca-app-pub-3940256099942544/4411468910'; // Test ID
  static const String iosNativeId = 'ca-app-pub-3940256099942544/3986624511'; // Test ID
  
  // Web Ad Unit IDs (if using web)
  static const String webBannerId = 'YOUR_WEB_BANNER_ID';
  
  // Helper to get platform-specific ID
  static String get bannerAdUnitId {
    if (GetPlatform.isAndroid) return androidBannerId;
    if (GetPlatform.isIOS) return iosBannerId;
    return webBannerId;
  }
  
  static String get interstitialAdUnitId {
    if (GetPlatform.isAndroid) return androidInterstitialId;
    if (GetPlatform.isIOS) return iosInterstitialId;
    return '';
  }
  
  static String get nativeAdUnitId {
    if (GetPlatform.isAndroid) return androidNativeId;
    if (GetPlatform.isIOS) return iosNativeId;
    return '';
  }
}

/// Banner Ad Widget (for bottom of screen)
class AdBannerWidget extends StatefulWidget {
  final AdSize adSize;
  
  const AdBannerWidget({
    Key? key,
    this.adSize = AdSize.banner,
  }) : super(key: key);
  
  @override
  State<AdBannerWidget> createState() => _AdBannerWidgetState();
}

class _AdBannerWidgetState extends State<AdBannerWidget> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;
  
  @override
  void initState() {
    super.initState();
    _loadAd();
  }
  
  void _loadAd() {
    _bannerAd = BannerAd(
      adUnitId: AdConstants.bannerAdUnitId,
      size: widget.adSize,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          if (mounted) {
            setState(() => _isLoaded = true);
          }
        },
        onAdFailedToLoad: (ad, error) {
          print('Banner ad failed to load: $error');
          ad.dispose();
          // Retry after 30 seconds
          Future.delayed(const Duration(seconds: 30), () {
            if (mounted) _loadAd();
          });
        },
      ),
    )..load();
  }
  
  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    if (_bannerAd != null && _isLoaded) {
      return Container(
        height: widget.adSize.height.toDouble(),
        alignment: Alignment.center,
        child: AdWidget(ad: _bannerAd!),
      );
    }
    
    // Placeholder while loading
    return SizedBox(
      height: widget.adSize.height.toDouble(),
      child: const Center(
        child: Text(
          'Advertisement',
          style: TextStyle(color: Colors.grey, fontSize: 10),
        ),
      ),
    );
  }
}

/// Interstitial Ad Controller (GetX)
class InterstitialAdController extends GetxController {
  InterstitialAd? _interstitialAd;
  RxBool isLoaded = false.obs;
  DateTime? _lastShown;
  
  // Minimum time between interstitial ads (5 minutes)
  static const Duration minimumInterval = Duration(minutes: 5);
  
  @override
  void onInit() {
    super.onInit();
    _loadAd();
  }
  
  void _loadAd() {
    InterstitialAd.load(
      adUnitId: AdConstants.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          isLoaded.value = true;
          
          // Set fullscreen content callback
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _loadAd(); // Load next ad
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              print('Interstitial ad failed to show: $error');
              ad.dispose();
              _loadAd();
            },
          );
        },
        onAdFailedToLoad: (error) {
          print('Interstitial ad failed to load: $error');
          isLoaded.value = false;
          
          // Retry after 60 seconds
          Future.delayed(const Duration(seconds: 60), _loadAd);
        },
      ),
    );
  }
  
  /// Show interstitial ad with frequency capping
  Future<void> show() async {
    // Check if enough time has passed since last ad
    if (_lastShown != null) {
      final timeSinceLastAd = DateTime.now().difference(_lastShown!);
      if (timeSinceLastAd < minimumInterval) {
        print('Too soon to show another ad. Wait ${minimumInterval.inMinutes} minutes.');
        return;
      }
    }
    
    if (_interstitialAd != null && isLoaded.value) {
      await _interstitialAd!.show();
      _lastShown = DateTime.now();
      isLoaded.value = false;
    } else {
      print('Interstitial ad not ready yet');
    }
  }
  
  @override
  void onClose() {
    _interstitialAd?.dispose();
    super.onClose();
  }
}

/// Native Ad Widget (for in-feed ads)
class NativeAdWidget extends StatefulWidget {
  const NativeAdWidget({Key? key}) : super(key: key);
  
  @override
  State<NativeAdWidget> createState() => _NativeAdWidgetState();
}

class _NativeAdWidgetState extends State<NativeAdWidget> {
  NativeAd? _nativeAd;
  bool _isLoaded = false;
  
  @override
  void initState() {
    super.initState();
    _loadAd();
  }
  
  void _loadAd() {
    _nativeAd = NativeAd(
      adUnitId: AdConstants.nativeAdUnitId,
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          if (mounted) {
            setState(() => _isLoaded = true);
          }
        },
        onAdFailedToLoad: (ad, error) {
          print('Native ad failed to load: $error');
          ad.dispose();
        },
      ),
      request: const AdRequest(),
      nativeTemplateStyle: NativeTemplateStyle(
        templateType: TemplateType.medium,
        mainBackgroundColor: Colors.white,
        cornerRadius: 10.0,
      ),
    )..load();
  }
  
  @override
  void dispose() {
    _nativeAd?.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    if (_nativeAd != null && _isLoaded) {
      return Container(
        height: 300,
        margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: AdWidget(ad: _nativeAd!),
      );
    }
    return const SizedBox.shrink();
  }
}

/// USAGE EXAMPLES:

/// 1. Replace bottom_offer_bar.dart with AdBannerWidget
/// ```dart
/// // In home_view.dart or chart_view.dart
/// bottomNavigationBar: const AdBannerWidget(),
/// ```

/// 2. Add banner between sections in HomeView
/// ```dart
/// const SizedBox(height: 24),
/// const Padding(
///   padding: EdgeInsets.symmetric(horizontal: 16),
///   child: AboutCard(...),
/// ),
/// const AdBannerWidget(), // <-- Add here
/// const SizedBox(height: 24),
/// ```

/// 3. Show interstitial after loading chart data
/// ```dart
/// // In api_controller.dart
/// class ApiController extends GetxController {
///   final interstitialAd = Get.put(InterstitialAdController());
///   
///   Future<void> fetchData() async {
///     // ... load data ...
///     
///     // Show ad after successful load
///     if (candles.isNotEmpty) {
///       await interstitialAd.show();
///     }
///   }
/// }
/// ```

/// 4. Add native ad in home page sections
/// ```dart
/// const SizedBox(height: 24),
/// const Padding(
///   padding: EdgeInsets.symmetric(horizontal: 16),
///   child: MasterclassTopicsCard(),
/// ),
/// const NativeAdWidget(), // <-- Add here
/// const SizedBox(height: 16),
/// ```

/// STEP 4: Configure AndroidManifest.xml
/// ```xml
/// <manifest>
///   <application>
///     <meta-data
///       android:name="com.google.android.gms.ads.APPLICATION_ID"
///       android:value="ca-app-pub-XXXXXXXXXXXXXXXX~YYYYYYYYYY"/>
///   </application>
/// </manifest>
/// ```

/// STEP 5: Configure Info.plist (iOS)
/// ```xml
/// <key>GADApplicationIdentifier</key>
/// <string>ca-app-pub-XXXXXXXXXXXXXXXX~YYYYYYYYYY</string>
/// <key>SKAdNetworkItems</key>
/// <array>
///   <dict>
///     <key>SKAdNetworkIdentifier</key>
///     <string>cstr6suwn9.skadnetwork</string>
///   </dict>
/// </array>
/// ```

/// MONETIZATION STRATEGY FOR TRADING APP:

/// 1. Bottom Banner (Always visible)
///    - Location: Bottom of home page and chart page
///    - Type: Standard banner (320x50)
///    - Frequency: Constant
///    - Revenue: Low but steady

/// 2. Interstitial (Occasional)
///    - Trigger: After loading chart data
///    - Frequency: Max once every 5 minutes
///    - Revenue: Medium-High
///    - User experience: Acceptable if not too frequent

/// 3. Native Ads (In-feed)
///    - Location: Between benefit cards on home page
///    - Frequency: 1 ad every 3-4 sections
///    - Revenue: Medium
///    - User experience: Best (blends with content)

/// 4. Rewarded Ads (Optional)
///    - Offer: "Watch ad to unlock premium indicator"
///    - Frequency: User-initiated only
///    - Revenue: Highest per view
///    - User experience: Great (user chooses)

/// EXPECTED REVENUE (India Market):
/// - Banner CPM: ₹10-30
/// - Interstitial CPM: ₹50-150
/// - Native CPM: ₹30-80
/// - Rewarded CPM: ₹100-300

/// With 1000 daily active users:
/// - Banners: 1000 users × 10 views/day × ₹20/1000 = ₹200/day
/// - Interstitials: 1000 users × 2 views/day × ₹100/1000 = ₹200/day
/// - Native: 1000 users × 5 views/day × ₹50/1000 = ₹250/day
/// Total: ₹650/day = ₹19,500/month

/// IMPORTANT TIPS:
/// 1. Always test with test IDs first
/// 2. Replace with real IDs before production
/// 3. Don't click your own ads (ban risk)
/// 4. Use AdMob mediation for higher fill rates
/// 5. Monitor metrics in AdMob console
/// 6. A/B test ad placements
/// 7. Respect user experience

/// LEGAL COMPLIANCE:
/// 1. Add Privacy Policy (required by AdMob)
/// 2. Implement GDPR consent (EU users)
/// 3. Comply with Google's ad policies
/// 4. Disclose data collection
/// 5. Provide opt-out option (if required)

/// PRIVACY POLICY TEMPLATE:
/// "This app uses Google AdMob to display advertisements. 
/// AdMob may collect device information, location data, and 
/// usage data to serve personalized ads. For more information, 
/// visit Google's Privacy Policy at https://policies.google.com/privacy"
