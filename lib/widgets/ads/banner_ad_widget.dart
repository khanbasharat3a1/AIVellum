import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../providers/app_providers.dart';

class BannerAdWidget extends ConsumerStatefulWidget {
  const BannerAdWidget({super.key});

  @override
  ConsumerState<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends ConsumerState<BannerAdWidget> {
  BannerAd? _bannerAd;
  bool _isAdLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadBannerAd();
  }

  void _loadBannerAd() {
    // Check if user has lifetime access (no ads for premium users)
    final settings = ref.read(appSettingsProvider);
    if (settings.hasLifetimeAccess) {
      return;
    }

    final adService = ref.read(adServiceProvider);
    _bannerAd = adService.getBannerAd();
    
    if (_bannerAd != null) {
      setState(() {
        _isAdLoaded = true;
      });
    }
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(appSettingsProvider);
    
    // Don't show ads for premium users
    if (settings.hasLifetimeAccess) {
      return const SizedBox.shrink();
    }

    // Don't show if ad is not loaded
    if (!_isAdLoaded || _bannerAd == null) {
      return const SizedBox.shrink();
    }

    return Container(
      alignment: Alignment.center,
      width: _bannerAd!.size.width.toDouble(),
      height: _bannerAd!.size.height.toDouble(),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: AdWidget(ad: _bannerAd!),
    );
  }
}

// Alternative banner ad widget with manual loading
class CustomBannerAdWidget extends ConsumerStatefulWidget {
  final AdSize adSize;
  final EdgeInsets? margin;
  
  const CustomBannerAdWidget({
    super.key,
    this.adSize = AdSize.banner,
    this.margin,
  });

  @override
  ConsumerState<CustomBannerAdWidget> createState() => _CustomBannerAdWidgetState();
}

class _CustomBannerAdWidgetState extends ConsumerState<CustomBannerAdWidget> {
  BannerAd? _bannerAd;
  bool _isAdLoaded = false;
  bool _isAdFailed = false;

  @override
  void initState() {
    super.initState();
    _initializeBannerAd();
  }

  void _initializeBannerAd() {
    // Check if user has lifetime access
    final settings = ref.read(appSettingsProvider);
    if (settings.hasLifetimeAccess) {
      return;
    }

    final adService = ref.read(adServiceProvider);
    
    // Create a new banner ad instance
    _bannerAd = BannerAd(
      adUnitId: adService.bannerAdUnitId,
      size: widget.adSize,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          if (mounted) {
            setState(() {
              _isAdLoaded = true;
              _isAdFailed = false;
            });
          }
        },
        onAdFailedToLoad: (ad, error) {
          if (mounted) {
            setState(() {
              _isAdFailed = true;
              _isAdLoaded = false;
            });
          }
          ad.dispose();
          print('Banner ad failed to load: $error');
        },
        onAdOpened: (ad) {
          print('Banner ad opened');
        },
        onAdClosed: (ad) {
          print('Banner ad closed');
        },
      ),
    );

    _bannerAd!.load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(appSettingsProvider);
    final theme = Theme.of(context);
    
    // Don't show ads for premium users
    if (settings.hasLifetimeAccess) {
      return const SizedBox.shrink();
    }

    // Show loading placeholder while ad loads
    if (!_isAdLoaded && !_isAdFailed && _bannerAd != null) {
      return Container(
        margin: widget.margin,
        width: widget.adSize.width.toDouble(),
        height: widget.adSize.height.toDouble(),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: theme.dividerColor,
            width: 1,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    theme.primaryColor,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Loading ad...',
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        ),
      );
    }

    // Show error placeholder if ad failed to load
    if (_isAdFailed) {
      return Container(
        margin: widget.margin,
        width: widget.adSize.width.toDouble(),
        height: widget.adSize.height.toDouble(),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: theme.dividerColor,
            width: 1,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.ads_click_rounded,
                color: theme.disabledColor,
                size: 24,
              ),
              const SizedBox(height: 8),
              Text(
                'Ad space',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.disabledColor,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Show the actual ad
    if (_isAdLoaded && _bannerAd != null) {
      return Container(
        margin: widget.margin,
        width: _bannerAd!.size.width.toDouble(),
        height: _bannerAd!.size.height.toDouble(),
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: AdWidget(ad: _bannerAd!),
        ),
      );
    }

    // Default empty state
    return const SizedBox.shrink();
  }
}

// Inline banner ad for use within lists or content
class InlineBannerAdWidget extends ConsumerWidget {
  final EdgeInsets padding;
  
  const InlineBannerAdWidget({
    super.key,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(appSettingsProvider);
    
    // Don't show for premium users
    if (settings.hasLifetimeAccess) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: padding,
      child: const CustomBannerAdWidget(
        adSize: AdSize.mediumRectangle,
      ),
    );
  }
}

// Native ad widget placeholder for future implementation
class NativeAdWidget extends ConsumerWidget {
  final EdgeInsets? margin;
  
  const NativeAdWidget({super.key, this.margin});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(appSettingsProvider);
    final theme = Theme.of(context);
    
    // Don't show for premium users
    if (settings.hasLifetimeAccess) {
      return const SizedBox.shrink();
    }

    // Placeholder for native ad (to be implemented in future)
    return Container(
      margin: margin ?? const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.dividerColor,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: theme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.star_rounded,
                  color: theme.primaryColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Upgrade to Premium',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Remove ads and unlock all prompts',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Navigate to purchase screen
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 8),
              ),
              child: const Text('Upgrade Now'),
            ),
          ),
        ],
      ),
    );
  }
}