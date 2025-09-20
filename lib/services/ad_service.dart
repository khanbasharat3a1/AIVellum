import 'dart:io';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../config/app_config.dart';

class AdService {
  static final AdService _instance = AdService._internal();
  factory AdService() => _instance;
  AdService._internal();

  BannerAd? _bannerAd;
  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;

  bool _isInitialized = false;
  bool _bannerAdLoaded = false;
  bool _interstitialAdLoaded = false;
  bool _rewardedAdLoaded = false;

  DateTime? _lastInterstitialShown;

  // Initialize Google Mobile Ads
  Future<void> initialize() async {
    if (_isInitialized) return;

    await MobileAds.instance.initialize();
    _isInitialized = true;
    
    // Load initial ads
    _loadBannerAd();
    _loadInterstitialAd();
    _loadRewardedAd();
  }

  // Ad Unit IDs based on platform
  String get bannerAdUnitId {
    return Platform.isAndroid 
        ? AppConfig.androidBannerAdId 
        : AppConfig.iosBannerAdId;
  }

  String get _interstitialAdUnitId {
    return Platform.isAndroid 
        ? AppConfig.androidInterstitialAdId 
        : AppConfig.iosInterstitialAdId;
  }

  String get _rewardedAdUnitId {
    return Platform.isAndroid 
        ? AppConfig.androidRewardedAdId 
        : AppConfig.iosRewardedAdId;
  }

  // Banner Ad Methods
  void _loadBannerAd() {
    _bannerAd = BannerAd(
            adUnitId: bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          _bannerAdLoaded = true;
          print('✅ Banner ad loaded');
        },
        onAdFailedToLoad: (ad, error) {
          _bannerAdLoaded = false;
          ad.dispose();
          print('❌ Banner ad failed to load: $error');
          
          // Retry loading after 30 seconds
          Future.delayed(const Duration(seconds: 30), () {
            _loadBannerAd();
          });
        },
        onAdOpened: (ad) {
          print('📱 Banner ad opened');
        },
        onAdClosed: (ad) {
          print('❌ Banner ad closed');
        },
      ),
    );
    
    _bannerAd!.load();
  }

  BannerAd? getBannerAd() {
    return _bannerAdLoaded ? _bannerAd : null;
  }

  // Interstitial Ad Methods
  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: _interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _interstitialAdLoaded = true;
          print('✅ Interstitial ad loaded');
          
          _interstitialAd!.setImmersiveMode(true);
        },
        onAdFailedToLoad: (error) {
          _interstitialAdLoaded = false;
          print('❌ Interstitial ad failed to load: $error');
          
          // Retry loading after 60 seconds
          Future.delayed(const Duration(seconds: 60), () {
            _loadInterstitialAd();
          });
        },
      ),
    );
  }

  Future<bool> showInterstitialAd() async {
    if (!_interstitialAdLoaded || _interstitialAd == null) {
      print('⚠️ Interstitial ad not ready');
      return false;
    }

    // Check if enough time has passed since last ad
    if (_lastInterstitialShown != null) {
      final timeDiff = DateTime.now().difference(_lastInterstitialShown!);
      if (timeDiff.inSeconds < AppConfig.minTimeBetweenAds) {
        print('⚠️ Not enough time passed since last interstitial ad');
        return false;
      }
    }

    bool adShown = false;
    
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        adShown = true;
        _lastInterstitialShown = DateTime.now();
        print('📱 Interstitial ad showed');
      },
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _interstitialAdLoaded = false;
        print('❌ Interstitial ad dismissed');
        
        // Load next ad
        _loadInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _interstitialAdLoaded = false;
        print('❌ Interstitial ad failed to show: $error');
        
        // Load next ad
        _loadInterstitialAd();
      },
    );

    await _interstitialAd!.show();
    return adShown;
  }

  bool canShowInterstitialAd() {
    if (!_interstitialAdLoaded) return false;
    
    if (_lastInterstitialShown != null) {
      final timeDiff = DateTime.now().difference(_lastInterstitialShown!);
      return timeDiff.inSeconds >= AppConfig.minTimeBetweenAds;
    }
    
    return true;
  }

  // Rewarded Ad Methods
  void _loadRewardedAd() {
    RewardedAd.load(
      adUnitId: _rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          _rewardedAdLoaded = true;
          print('✅ Rewarded ad loaded');
        },
        onAdFailedToLoad: (error) {
          _rewardedAdLoaded = false;
          print('❌ Rewarded ad failed to load: $error');
          
          // Retry loading after 60 seconds
          Future.delayed(const Duration(seconds: 60), () {
            _loadRewardedAd();
          });
        },
      ),
    );
  }

  Future<bool> showRewardedAd({required Function() onRewarded}) async {
    if (!_rewardedAdLoaded || _rewardedAd == null) {
      print('⚠️ Rewarded ad not ready');
      return false;
    }

    bool rewardGranted = false;
    
    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        print('📱 Rewarded ad showed');
      },
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _rewardedAdLoaded = false;
        print('❌ Rewarded ad dismissed');
        
        // Load next ad
        _loadRewardedAd();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _rewardedAdLoaded = false;
        print('❌ Rewarded ad failed to show: $error');
        
        // Load next ad
        _loadRewardedAd();
      },
    );

    await _rewardedAd!.show(onUserEarnedReward: (ad, reward) {
      rewardGranted = true;
      onRewarded();
      print('🎉 User earned reward: ${reward.amount} ${reward.type}');
    });
    
    return rewardGranted;
  }

  bool get isRewardedAdReady => _rewardedAdLoaded;

  // Ad frequency management
  bool shouldShowInterstitialAd(int promptsViewed) {
    return promptsViewed > 0 && 
           promptsViewed % AppConfig.interstitialAdFrequency == 0 &&
           canShowInterstitialAd();
  }

  // Cleanup
  void dispose() {
    _bannerAd?.dispose();
    _interstitialAd?.dispose();
    _rewardedAd?.dispose();
    
    _bannerAdLoaded = false;
    _interstitialAdLoaded = false;
    _rewardedAdLoaded = false;
  }

  // Test methods (for development)
  void forceLoadAllAds() {
    _loadBannerAd();
    _loadInterstitialAd();
    _loadRewardedAd();
  }

  Map<String, bool> getAdStatus() {
    return {
      'initialized': _isInitialized,
      'banner_loaded': _bannerAdLoaded,
      'interstitial_loaded': _interstitialAdLoaded,
      'rewarded_loaded': _rewardedAdLoaded,
    };
  }
}