import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import '../../config/app_config.dart';
import '../../navigation/app_router.dart';
import '../../providers/app_providers.dart';
import '../../widgets/cards/prompt_card.dart';
import '../../widgets/common/loading_shimmer.dart';
import '../../models/models.dart';
import '../../widgets/ads/banner_ad_widget.dart';
import '../../services/ad_service.dart';

class CategoryScreen extends ConsumerStatefulWidget {
  final String categoryId;

  const CategoryScreen({
    super.key,
    required this.categoryId,
  });

  @override
  ConsumerState<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends ConsumerState<CategoryScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _showFab = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    
    // Track screen view
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final category = ref.read(categoryByIdProvider(widget.categoryId));
      if (category != null) {
        NavigationAnalytics.trackScreenView('category_${category.name.toLowerCase()}');
      }
    });
  }

  void _scrollListener() {
    if (_scrollController.offset > 200 && !_showFab) {
      setState(() => _showFab = true);
    } else if (_scrollController.offset <= 200 && _showFab) {
      setState(() => _showFab = false);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final category = ref.watch(categoryByIdProvider(widget.categoryId));
    final prompts = ref.watch(categoryPromptsProvider(widget.categoryId));
    final settings = ref.watch(appSettingsProvider);
    final theme = Theme.of(context);

    if (category == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('Category not found.')),
      );
    }

    final freePrompts = prompts.take(AppConfig.freePromptsPerCategory).toList();
    final premiumPrompts = prompts.skip(AppConfig.freePromptsPerCategory).toList();

    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // App Bar with Hero Animation
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: Color(int.parse(category.color.replaceFirst('#', '0xFF'))),
            foregroundColor: Colors.white,
            leading: IconButton(
              onPressed: () => context.pop(),
              icon: const Icon(Icons.arrow_back_rounded),
            ),
            actions: [
              IconButton(
                onPressed: () => _shareCategory(category),
                icon: const Icon(Icons.share_rounded),
              ),
              IconButton(
                onPressed: () => _showCategoryInfo(category),
                icon: const Icon(Icons.info_outline_rounded),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                category.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      offset: Offset(0, 1),
                      blurRadius: 3.0,
                      color: Colors.black26,
                    ),
                  ],
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(int.parse(category.color.replaceFirst('#', '0xFF'))),
                      Color(int.parse(category.color.replaceFirst('#', '0xFF'))).withOpacity(0.8),
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: 80,
                      right: -20,
                      child: Icon(
                        CategoryIcons.getIcon(category.icon),
                        size: 120,
                        color: Colors.white.withOpacity(0.1),
                      ),
                    ),
                    Positioned(
                      bottom: 60,
                      left: 16,
                      right: 16,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  '${prompts.length} prompts',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  '${freePrompts.length} free',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            category.description,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 14,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Content
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Stats Section
                _buildStatsSection(context, prompts, settings),
                const SizedBox(height: 24),

                // Free Prompts Section
                if (freePrompts.isNotEmpty) ...[
                  _buildSectionHeader(
                    'Free Prompts',
                    '${freePrompts.length} available',
                    Icons.star_rounded,
                    AppTheme.successColor,
                  ),
                  const SizedBox(height: 16),
                  _buildPromptsGrid(freePrompts, isFree: true),
                  const SizedBox(height: 32),
                ],

                // Premium Prompts Section
                if (premiumPrompts.isNotEmpty) ...[
                  _buildSectionHeader(
                    'Premium Prompts',
                    settings.hasLifetimeAccess
                        ? '${premiumPrompts.length} unlocked'
                        : '${premiumPrompts.length} locked',
                    settings.hasLifetimeAccess
                        ? Icons.lock_open_rounded
                        : Icons.lock_rounded,
                    settings.hasLifetimeAccess
                        ? AppTheme.successColor
                        : AppTheme.warningColor,
                  ),
                  const SizedBox(height: 16),
                  _buildPromptsGrid(premiumPrompts, isFree: false),
                  const SizedBox(height: 32),
                ],

                // Unlock All Section
                if (!settings.hasLifetimeAccess && premiumPrompts.isNotEmpty) ...[
                  _buildUnlockAllSection(context, premiumPrompts.length),
                  const SizedBox(height: 32),
                ],

                // Inline Ad
                const InlineBannerAdWidget(),
                const SizedBox(height: 100), // Bottom padding for navigation
              ]),
            ),
          ),
        ],
      ),

      // Floating Action Button
      floatingActionButton: AnimatedScale(
        scale: _showFab ? 1.0 : 0.0,
        duration: AppConfig.shortAnimationDuration,
        child: FloatingActionButton(
          onPressed: _scrollToTop,
          child: const Icon(Icons.keyboard_arrow_up_rounded),
        ),
      ),
    );
  }

  Widget _buildStatsSection(BuildContext context, List<Prompt> prompts, AppSettings settings) {
    final theme = Theme.of(context);
    final unlockedCount = settings.hasLifetimeAccess
        ? prompts.length
        : AppConfig.freePromptsPerCategory;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildStatItem(
              'Total',
              prompts.length.toString(),
              Icons.psychology_rounded,
              theme.primaryColor,
            ),
          ),
          Container(
            width: 1,
            height: 40,
            color: theme.dividerColor,
          ),
          Expanded(
            child: _buildStatItem(
              'Unlocked',
              unlockedCount.toString(),
              Icons.lock_open_rounded,
              AppTheme.successColor,
            ),
          ),
          Container(
            width: 1,
            height: 40,
            color: theme.dividerColor,
          ),
          Expanded(
            child: _buildStatItem(
              'Premium',
              (prompts.length - AppConfig.freePromptsPerCategory).toString(),
              Icons.star_rounded,
              AppTheme.warningColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, String subtitle, IconData icon, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPromptsGrid(List<Prompt> prompts, {required bool isFree}) {
    return AnimationLimiter(
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          childAspectRatio: 3.5,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: prompts.length,
        itemBuilder: (context, index) {
          final prompt = prompts[index];
          return AnimationConfiguration.staggeredGrid(
            position: index,
            duration: AppConfig.mediumAnimationDuration,
            columnCount: 1,
            child: SlideAnimation(
              verticalOffset: 30,
              child: FadeInAnimation(
                child: PromptCard(
                  prompt: prompt,
                  onTap: () => _handlePromptTap(prompt, isFree),
                  showLockIcon: !isFree,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildUnlockAllSection(BuildContext context, int premiumCount) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.primaryColor,
            theme.primaryColor.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.star_rounded,
                color: Colors.white,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Unlock Everything',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Get instant access to all $premiumCount premium prompts',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => context.goToPurchase('lifetime'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: theme.primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                    'Unlock All - ₹999',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              OutlinedButton(
                onPressed: () => _showPricingInfo(),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text('Info'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _handlePromptTap(Prompt prompt, bool isFree) async {
    final settings = ref.read(appSettingsProvider);

    // Check if user can access the prompt
    final canAccess = isFree ||
        settings.hasLifetimeAccess ||
        ref.read(dataServiceProvider).isPromptUnlocked(prompt.id);

    if (canAccess) {
      // Add to recently viewed
      ref.read(recentlyViewedProvider.notifier).addRecentPrompt(prompt.id);

      // Show interstitial ad if needed
      final shouldShowAd = ref.read(adServiceProvider).shouldShowInterstitialAd(
            settings.promptsViewedCount,
          );

      if (shouldShowAd && !settings.hasLifetimeAccess) {
        await ref.read(adServiceProvider).showInterstitialAd();
        ref.read(appSettingsProvider.notifier).updateLastAdShown();
      }

      // Navigate to prompt
      context.goToPrompt(prompt.id, categoryId: widget.categoryId);

      // Increment viewed count
      ref.read(appSettingsProvider.notifier).incrementPromptsViewed();
    } else {
      // Show purchase dialog
      _showPurchaseDialog(prompt);
    }
  }

  void _showPurchaseDialog(Prompt prompt) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Premium Prompt'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('This prompt is part of our premium collection.'),
            const SizedBox(height: 16),
            Text(
              prompt.title,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              prompt.description,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.goToPurchase('lifetime');
            },
            child: const Text('Unlock All'),
          ),
        ],
      ),
    );
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: AppConfig.mediumAnimationDuration,
      curve: Curves.easeInOut,
    );
  }

  void _shareCategory(Category category) {
    final textToShare =
        'Check out the "${category.name}" category in the Aivellum app! It has great prompts for ${category.description}.';
    Share.share(textToShare, subject: 'Aivellum Prompt Category');
    NavigationAnalytics.trackButtonTap('share_category', 'category_screen');
  }

  void _showCategoryInfo(Category category) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(category.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(category.description),
            const SizedBox(height: 16),
            const Text(
              'This category contains professional AI prompts designed to enhance your productivity and creativity.',
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showPricingInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pricing Information'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Unlock all premium prompts with our lifetime access plan:'),
            SizedBox(height: 16),
            Text('• ₹999 - India'),
            Text('• \$12.99 - USA'),
            Text('• €11.99 - Europe'),
            Text('• £9.99 - UK'),
            SizedBox(height: 16),
            Text('One-time payment, lifetime access to all current and future prompts.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.goToPurchase('lifetime');
            },
            child: const Text('Get Access'),
          ),
        ],
      ),
    );
  }
}