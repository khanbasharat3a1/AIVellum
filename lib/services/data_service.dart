import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/models.dart';
import '../config/app_config.dart';

class DataService {
  static final DataService instance = DataService._internal();
  factory DataService() => instance;
  DataService._internal();

  late Box<Vault> _vaultBox;
  late Box<Category> _categoriesBox;
  late Box<Prompt> _promptsBox;
  late Box<UserPurchase> _purchasesBox;
  late Box<AppSettings> _settingsBox;

  // Initialize Hive and load data
  Future<void> initialize() async {
    print('DataService: Initializing...');
    await Hive.initFlutter();
    
    // Register adapters
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(VaultAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(CategoryAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(PromptAdapter());
    }
    if (!Hive.isAdapterRegistered(3)) {
      Hive.registerAdapter(UserPurchaseAdapter());
    }
    if (!Hive.isAdapterRegistered(4)) {
      Hive.registerAdapter(AppSettingsAdapter());
    }

    // Open boxes
    _vaultBox = await Hive.openBox<Vault>(AppConfig.vaultBox);
    _categoriesBox = await Hive.openBox<Category>(AppConfig.categoriesBox);
    _promptsBox = await Hive.openBox<Prompt>(AppConfig.promptsBox);
    _purchasesBox = await Hive.openBox<UserPurchase>(AppConfig.purchasesBox);
    _settingsBox = await Hive.openBox<AppSettings>(AppConfig.settingsBox);

    // Load initial data if boxes are empty
    await _loadInitialDataIfNeeded();
    print('DataService: Initialization complete.');
  }

  // Load data from JSON asset if boxes are empty
  Future<void> _loadInitialDataIfNeeded() async {
    print('DataService: Checking if initial data load is needed...');
    print('DataService: _categoriesBox.isEmpty: ${_categoriesBox.isEmpty}');
    print('DataService: _promptsBox.isEmpty: ${_promptsBox.isEmpty}');
    if (_categoriesBox.isEmpty || _promptsBox.isEmpty) {
      print('DataService: Boxes are empty, loading data from assets.');
      await loadDataFromAssets();
    } else {
      print('DataService: Boxes are not empty, skipping initial data load.');
    }

    // Initialize app settings if not exists
    if (_settingsBox.isEmpty) {
      await _settingsBox.put('main', AppSettings());
      print('DataService: App settings initialized.');
    }
  }

  // Load data from assets/data/prompts_database.json
  Future<void> loadDataFromAssets() async {
    print('DataService: Loading data from assets...');
    try {
      final String jsonString = await rootBundle.loadString(AppConfig.databasePath);
      print('DataService: JSON string loaded. Length: ${jsonString.length}');
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      print('DataService: JSON data decoded.');
      final PromptsDatabase database = PromptsDatabase.fromJson(jsonData);

      // Clear existing data
      await _vaultBox.clear();
      await _categoriesBox.clear();
      await _promptsBox.clear();
      print('DataService: Cleared existing Hive data.');

      // Store vault data
      await _vaultBox.put('main', database.vault);

      // Store categories
      for (final category in database.categories) {
        await _categoriesBox.put(category.id, category);
      }
      print('DataService: Stored ${database.categories.length} categories.');

      // Store prompts
      for (final prompt in database.prompts) {
        await _promptsBox.put(prompt.id, prompt);
      }
      print('DataService: Stored ${database.prompts.length} prompts.');

      print('✅ Data loaded successfully from assets');
    } catch (e) {
      print('❌ Error loading data from assets: $e');
      throw Exception('Failed to load initial data: $e');
    }
  }

  // Vault operations
  Vault? getVault() {
    return _vaultBox.get('main');
  }

  // Category operations
  List<Category> getAllCategories() {
    final categories = _categoriesBox.values.toList();
    categories.sort((a, b) => a.order.compareTo(b.order));
    return categories;
  }

  Category? getCategoryById(String id) {
    return _categoriesBox.get(id);
  }

  // Prompt operations
  List<Prompt> getAllPrompts() {
    return _promptsBox.values.toList();
  }

  List<Prompt> getPromptsByCategory(String categoryId) {
    final prompts = _promptsBox.values
        .where((prompt) => prompt.categoryId == categoryId)
        .toList();
    prompts.sort((a, b) => a.order.compareTo(b.order));
    return prompts;
  }

  Prompt? getPromptById(String id) {
    return _promptsBox.get(id);
  }

  List<Prompt> getFreePrompts(String categoryId) {
    final categoryPrompts = getPromptsByCategory(categoryId);
    return categoryPrompts.take(AppConfig.freePromptsPerCategory).toList();
  }

  List<Prompt> getPremiumPrompts(String categoryId) {
    final categoryPrompts = getPromptsByCategory(categoryId);
    return categoryPrompts.skip(AppConfig.freePromptsPerCategory).toList();
  }

  // Search prompts
  List<Prompt> searchPrompts(String query) {
    if (query.isEmpty) return getAllPrompts();
    
    final lowercaseQuery = query.toLowerCase();
    return _promptsBox.values.where((prompt) {
      return prompt.title.toLowerCase().contains(lowercaseQuery) ||
             prompt.description.toLowerCase().contains(lowercaseQuery) ||
             prompt.tags.any((tag) => tag.toLowerCase().contains(lowercaseQuery));
    }).toList();
  }

  // Purchase operations
  Future<void> addPurchase(UserPurchase purchase) async {
    await _purchasesBox.put(purchase.promptId, purchase);
  }

  List<UserPurchase> getAllPurchases() {
    return _purchasesBox.values.toList();
  }

  bool isPromptUnlocked(String promptId) {
    // Check if user has lifetime access
    final settings = getAppSettings();
    if (settings.hasLifetimeAccess) return true;

    // Check if prompt is individually purchased
    return _purchasesBox.containsKey(promptId);
  }

  bool isPromptFree(String promptId) {
    final prompt = getPromptById(promptId);
    if (prompt == null) return false;

    final categoryPrompts = getPromptsByCategory(prompt.categoryId);
    final promptIndex = categoryPrompts.indexWhere((p) => p.id == promptId);
    
    return promptIndex < AppConfig.freePromptsPerCategory;
  }

  bool canAccessPrompt(String promptId) {
    return isPromptFree(promptId) || isPromptUnlocked(promptId);
  }

  // App Settings operations
  AppSettings getAppSettings() {
    return _settingsBox.get('main') ?? AppSettings();
  }

  Future<void> updateAppSettings(AppSettings settings) async {
    await _settingsBox.put('main', settings);
  }

  Future<void> setLifetimeAccess(bool hasAccess) async {
    final settings = getAppSettings();
    settings.hasLifetimeAccess = hasAccess;
    await updateAppSettings(settings);
  }

  Future<void> setDarkMode(bool isDark) async {
    final settings = getAppSettings();
    settings.isDarkMode = isDark;
    await updateAppSettings(settings);
  }

  Future<void> incrementPromptsViewed() async {
    final settings = getAppSettings();
    settings.promptsViewedCount++;
    await updateAppSettings(settings);
  }

  Future<void> updateLastAdShown() async {
    final settings = getAppSettings();
    settings.lastAdShown = DateTime.now();
    await updateAppSettings(settings);
  }

  // Statistics
  int getTotalPromptsCount() {
    return _promptsBox.length;
  }

  int getCategoryPromptsCount(String categoryId) {
    return getPromptsByCategory(categoryId).length;
  }

  int getUnlockedPromptsCount() {
    final settings = getAppSettings();
    if (settings.hasLifetimeAccess) {
      return getTotalPromptsCount();
    }
    
    int freeCount = 0;
    for (final category in getAllCategories()) {
      final categoryPrompts = getPromptsByCategory(category.id);
      freeCount += categoryPrompts.take(AppConfig.freePromptsPerCategory).length;
    }
    
    return freeCount + _purchasesBox.length;
  }

  Map<String, int> getCategoryStats() {
    final stats = <String, int>{};
    for (final category in getAllCategories()) {
      stats[category.id] = getCategoryPromptsCount(category.id);
    }
    return stats;
  }

  // Backup and restore
  Future<String> exportData() async {
    final data = {
      'vault': getVault()?.toJson(),
      'categories': getAllCategories().map((c) => c.toJson()).toList(),
      'prompts': getAllPrompts().map((p) => p.toJson()).toList(),
      'purchases': getAllPurchases().map((p) => {
        'promptId': p.promptId,
        'purchaseDate': p.purchaseDate.toIso8601String(),
        'amount': p.amount,
        'currency': p.currency,
        'transactionId': p.transactionId,
      }).toList(),
      'settings': {
        'isDarkMode': getAppSettings().isDarkMode,
        'hasLifetimeAccess': getAppSettings().hasLifetimeAccess,
        'promptsViewedCount': getAppSettings().promptsViewedCount,
        'preferredLanguage': getAppSettings().preferredLanguage,
      },
      'exportDate': DateTime.now().toIso8601String(),
    };
    
    return json.encode(data);
  }

  Future<void> importData(String jsonData) async {
    try {
      final data = json.decode(jsonData);
      
      // Import purchases
      if (data['purchases'] != null) {
        for (final purchaseData in data['purchases']) {
          final purchase = UserPurchase(
            promptId: purchaseData['promptId'],
            purchaseDate: DateTime.parse(purchaseData['purchaseDate']),
            amount: purchaseData['amount'],
            currency: purchaseData['currency'],
            transactionId: purchaseData['transactionId'],
          );
          await addPurchase(purchase);
        }
      }
      
      // Import settings
      if (data['settings'] != null) {
        final settingsData = data['settings'];
        final settings = AppSettings(
          isDarkMode: settingsData['isDarkMode'] ?? false,
          hasLifetimeAccess: settingsData['hasLifetimeAccess'] ?? false,
          promptsViewedCount: settingsData['promptsViewedCount'] ?? 0,
          preferredLanguage: settingsData['preferredLanguage'] ?? 'en',
        );
        await updateAppSettings(settings);
      }
      
      print('✅ Data imported successfully');
    } catch (e) {
      print('❌ Error importing data: $e');
      throw Exception('Failed to import data: $e');
    }
  }

  // Cleanup
  Future<void> dispose() async {
    await _vaultBox.close();
    await _categoriesBox.close();
    await _promptsBox.close();
    await _purchasesBox.close();
    await _settingsBox.close();
  }

  // Development helper methods
  Future<void> resetAllData() async {
    await _vaultBox.clear();
    await _categoriesBox.clear();
    await _promptsBox.clear();
    await _purchasesBox.clear();
    await _settingsBox.clear();
    
    await loadDataFromAssets();
    await _settingsBox.put('main', AppSettings());
  }

  Future<void> unlockAllPromptsForTesting() async {
    final settings = getAppSettings();
    settings.hasLifetimeAccess = true;
    await updateAppSettings(settings);
  }
}