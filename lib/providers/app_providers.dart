import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
import '../services/data_service.dart';
import '../services/ad_service.dart';
import '../services/purchase_service.dart';

// Data Service Provider
final dataServiceProvider = Provider<DataService>((ref) {
  return DataService.instance;
});

// Vault Provider
final vaultProvider = Provider<Vault?>((ref) {
  final dataService = ref.watch(dataServiceProvider);
  return dataService.getVault();
});

// Categories Provider
final categoriesProvider = Provider<List<Category>>((ref) {
  final dataService = ref.watch(dataServiceProvider);
  return dataService.getAllCategories();
});

// All Prompts Provider
final allPromptsProvider = Provider<List<Prompt>>((ref) {
  final dataService = ref.watch(dataServiceProvider);
  return dataService.getAllPrompts();
});

// Category by ID Provider
final categoryByIdProvider = Provider.family<Category?, String>((ref, categoryId) {
  final dataService = ref.watch(dataServiceProvider);
  return dataService.getCategoryById(categoryId);
});

// Category Prompts Provider
final categoryPromptsProvider = Provider.family<List<Prompt>, String>((ref, categoryId) {
  final dataService = ref.watch(dataServiceProvider);
  return dataService.getPromptsByCategory(categoryId);
});

// Prompt by ID Provider
final promptProvider = Provider.family<Prompt?, String>((ref, promptId) {
  final dataService = ref.watch(dataServiceProvider);
  return dataService.getPromptById(promptId);
});

// App Settings Provider
final appSettingsProvider = StateNotifierProvider<AppSettingsNotifier, AppSettings>((ref) {
  final dataService = ref.watch(dataServiceProvider);
  return AppSettingsNotifier(dataService);
});

class AppSettingsNotifier extends StateNotifier<AppSettings> {
  final DataService _dataService;

  AppSettingsNotifier(this._dataService) : super(_dataService.getAppSettings());

  Future<void> toggleDarkMode() async {
    state = AppSettings(
      isDarkMode: !state.isDarkMode,
      hasLifetimeAccess: state.hasLifetimeAccess,
      lastAdShown: state.lastAdShown,
      promptsViewedCount: state.promptsViewedCount,
      preferredLanguage: state.preferredLanguage,
      hasSeenOnboarding: state.hasSeenOnboarding,
    );
    await _dataService.updateAppSettings(state);
  }

  Future<void> setLifetimeAccess(bool hasAccess) async {
    state = AppSettings(
      isDarkMode: state.isDarkMode,
      hasLifetimeAccess: hasAccess,
      lastAdShown: state.lastAdShown,
      promptsViewedCount: state.promptsViewedCount,
      preferredLanguage: state.preferredLanguage,
      hasSeenOnboarding: state.hasSeenOnboarding,
    );
    await _dataService.updateAppSettings(state);
  }

  Future<void> incrementPromptsViewed() async {
    state = AppSettings(
      isDarkMode: state.isDarkMode,
      hasLifetimeAccess: state.hasLifetimeAccess,
      lastAdShown: state.lastAdShown,
      promptsViewedCount: state.promptsViewedCount + 1,
      preferredLanguage: state.preferredLanguage,
      hasSeenOnboarding: state.hasSeenOnboarding,
    );
    await _dataService.updateAppSettings(state);
  }

  Future<void> updateLastAdShown() async {
    state = AppSettings(
      isDarkMode: state.isDarkMode,
      hasLifetimeAccess: state.hasLifetimeAccess,
      lastAdShown: DateTime.now(),
      promptsViewedCount: state.promptsViewedCount,
      preferredLanguage: state.preferredLanguage,
      hasSeenOnboarding: state.hasSeenOnboarding,
    );
    await _dataService.updateAppSettings(state);
  }

  Future<void> setLanguage(String language) async {
    state = AppSettings(
      isDarkMode: state.isDarkMode,
      hasLifetimeAccess: state.hasLifetimeAccess,
      lastAdShown: state.lastAdShown,
      promptsViewedCount: state.promptsViewedCount,
      preferredLanguage: language,
      hasSeenOnboarding: state.hasSeenOnboarding,
    );
    await _dataService.updateAppSettings(state);
  }

  Future<void> setHasSeenOnboarding() async {
    state = AppSettings(
      isDarkMode: state.isDarkMode,
      hasLifetimeAccess: state.hasLifetimeAccess,
      lastAdShown: state.lastAdShown,
      promptsViewedCount: state.promptsViewedCount,
      preferredLanguage: state.preferredLanguage,
      hasSeenOnboarding: true,
    );
    await _dataService.updateAppSettings(state);
  }
}

// Search Provider
final searchQueryProvider = StateProvider<String>((ref) => '');

final searchResultsProvider = Provider<List<Prompt>>((ref) {
  final query = ref.watch(searchQueryProvider);
  final dataService = ref.watch(dataServiceProvider);
  return dataService.searchPrompts(query);
});

// Purchase Status Providers
final promptAccessProvider = Provider.family<bool, String>((ref, promptId) {
  final dataService = ref.watch(dataServiceProvider);
  return dataService.canAccessPrompt(promptId);
});

final promptUnlockedProvider = Provider.family<bool, String>((ref, promptId) {
  final dataService = ref.watch(dataServiceProvider);
  return dataService.isPromptUnlocked(promptId);
});

final promptFreeProvider = Provider.family<bool, String>((ref, promptId) {
  final dataService = ref.watch(dataServiceProvider);
  return dataService.isPromptFree(promptId);
});

// Statistics Providers
final totalPromptsCountProvider = Provider<int>((ref) {
  final dataService = ref.watch(dataServiceProvider);
  return dataService.getTotalPromptsCount();
});

final unlockedPromptsCountProvider = Provider<int>((ref) {
  final dataService = ref.watch(dataServiceProvider);
  return dataService.getUnlockedPromptsCount();
});

final categoryStatsProvider = Provider<Map<String, int>>((ref) {
  final dataService = ref.watch(dataServiceProvider);
  return dataService.getCategoryStats();
});

// Ad Service Provider
final adServiceProvider = Provider<AdService>((ref) {
  return AdService();
});

// Purchase Service Provider
final purchaseServiceProvider = Provider<PurchaseService>((ref) {
  return PurchaseService();
});

// Navigation State Provider
final currentPageIndexProvider = StateProvider<int>((ref) => 0);

// Selected Category Provider
final selectedCategoryProvider = StateProvider<String?>((ref) => null);

// Loading States
final isLoadingProvider = StateProvider<bool>((ref) => false);

// Error State Provider  
final errorMessageProvider = StateProvider<String?>((ref) => null);

// Purchase Flow State
final purchaseFlowStateProvider = StateNotifierProvider<PurchaseFlowNotifier, PurchaseFlowState>((ref) {
  final purchaseService = ref.watch(purchaseServiceProvider);
  final dataService = ref.watch(dataServiceProvider);
  return PurchaseFlowNotifier(purchaseService, dataService);
});

enum PurchaseFlowStatus { idle, loading, success, error, cancelled }

class PurchaseFlowState {
  final PurchaseFlowStatus status;
  final String? errorMessage;
  final String? purchasedPromptId;

  PurchaseFlowState({
    required this.status,
    this.errorMessage,
    this.purchasedPromptId,
  });

  PurchaseFlowState copyWith({
    PurchaseFlowStatus? status,
    String? errorMessage,
    String? purchasedPromptId,
  }) {
    return PurchaseFlowState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      purchasedPromptId: purchasedPromptId ?? this.purchasedPromptId,
    );
  }
}

class PurchaseFlowNotifier extends StateNotifier<PurchaseFlowState> {
  final PurchaseService _purchaseService;
  final DataService _dataService;

  PurchaseFlowNotifier(this._purchaseService, this._dataService) 
    : super(PurchaseFlowState(status: PurchaseFlowStatus.idle));

  Future<void> purchasePrompt(String promptId) async {
    state = state.copyWith(status: PurchaseFlowStatus.loading);
    
    try {
      final success = await _purchaseService.purchasePrompt(promptId);
      
      if (success) {
        // Add purchase record
        final purchase = UserPurchase(
          promptId: promptId,
          purchaseDate: DateTime.now(),
          amount: 1.0, // This should come from the actual purchase
          currency: 'INR',
          transactionId: DateTime.now().millisecondsSinceEpoch.toString(),
        );
        
        await _dataService.addPurchase(purchase);
        
        state = state.copyWith(
          status: PurchaseFlowStatus.success,
          purchasedPromptId: promptId,
        );
      } else {
        state = state.copyWith(
          status: PurchaseFlowStatus.cancelled,
        );
      }
    } catch (e) {
      state = state.copyWith(
        status: PurchaseFlowStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> purchaseLifetimeAccess() async {
    state = state.copyWith(status: PurchaseFlowStatus.loading);
    
    try {
      final success = await _purchaseService.purchaseLifetimeAccess();
      
      if (success) {
        await _dataService.setLifetimeAccess(true);
        
        state = state.copyWith(
          status: PurchaseFlowStatus.success,
          purchasedPromptId: 'lifetime',
        );
      } else {
        state = state.copyWith(
          status: PurchaseFlowStatus.cancelled,
        );
      }
    } catch (e) {
      state = state.copyWith(
        status: PurchaseFlowStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  void resetState() {
    state = PurchaseFlowState(status: PurchaseFlowStatus.idle);
  }
}

// Theme Provider
final themeProvider = Provider<bool>((ref) {
  final settings = ref.watch(appSettingsProvider);
  return settings.isDarkMode;
});

// Favorite Prompts Provider (for future feature)
final favoritePromptsProvider = StateNotifierProvider<FavoritePromptsNotifier, List<String>>((ref) {
  return FavoritePromptsNotifier();
});

class FavoritePromptsNotifier extends StateNotifier<List<String>> {
  FavoritePromptsNotifier() : super([]);

  void toggleFavorite(String promptId) {
    if (state.contains(promptId)) {
      state = state.where((id) => id != promptId).toList();
    } else {
      state = [...state, promptId];
    }
  }

  bool isFavorite(String promptId) {
    return state.contains(promptId);
  }
}

// Recently Viewed Prompts Provider
final recentlyViewedProvider = StateNotifierProvider<RecentlyViewedNotifier, List<String>>((ref) {
  return RecentlyViewedNotifier();
});

class RecentlyViewedNotifier extends StateNotifier<List<String>> {
  RecentlyViewedNotifier() : super([]);
  
  static const int maxRecentItems = 10;

  void addRecentPrompt(String promptId) {
    final newList = [promptId];
    
    // Add existing items (excluding the current one to avoid duplicates)
    newList.addAll(state.where((id) => id != promptId));
    
    // Limit to maxRecentItems
    if (newList.length > maxRecentItems) {
      state = newList.take(maxRecentItems).toList();
    } else {
      state = newList;
    }
  }

  void clearRecent() {
    state = [];
  }
}