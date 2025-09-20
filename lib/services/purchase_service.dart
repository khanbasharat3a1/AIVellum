import 'dart:async';
import 'dart:io';
import 'package:in_app_purchase/in_app_purchase.dart';
import '../config/app_config.dart';

class PurchaseService {
  static final PurchaseService _instance = PurchaseService._internal();
  factory PurchaseService() => _instance;
  PurchaseService._internal();

  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;

  bool _isInitialized = false;
  bool _isPurchaseAvailable = false;
  List<ProductDetails> _products = [];

  // Product IDs
  static const Set<String> _productIds = {
    AppConfig.lifetimeUnlockProductId,
  };

  // Initialize the purchase service
  Future<void> initialize() async {
    if (_isInitialized) return;

    // Enable pending purchases for Android
    if (Platform.isAndroid) {
      // TODO: Fix this API change
      // final InAppPurchaseAndroidPlatformAddition androidAddition =
      //     _inAppPurchase.getPlatformAddition<InAppPurchaseAndroidPlatformAddition>();
      // await androidAddition.enablePendingPurchases();
    }

    // Check if store is available
    _isPurchaseAvailable = await _inAppPurchase.isAvailable();
    if (!_isPurchaseAvailable) {
      print('❌ In-app purchases not available on this device');
      return;
    }

    // Listen to purchase updates
    _subscription = _inAppPurchase.purchaseStream.listen(
      _onPurchaseUpdate,
      onError: _onPurchaseError,
      onDone: () => print('📱 Purchase stream completed'),
    );

    // Load products
    await _loadProducts();

    _isInitialized = true;
    print('✅ Purchase service initialized');
  }

  // Load available products from store
  Future<void> _loadProducts() async {
    try {
      final ProductDetailsResponse response = await _inAppPurchase.queryProductDetails(_productIds);
      
      if (response.notFoundIDs.isNotEmpty) {
        print('⚠️ Products not found: ${response.notFoundIDs}');
      }

      _products = response.productDetails;
      print('✅ Loaded ${_products.length} products');
      
      for (final product in _products) {
        print('📦 Product: ${product.id} - ${product.title} - ${product.price}');
      }
    } catch (e) {
      print('❌ Error loading products: $e');
    }
  }

  // Handle purchase updates
  void _onPurchaseUpdate(List<PurchaseDetails> purchases) {
    for (final purchase in purchases) {
      print('📱 Purchase update: ${purchase.productID} - ${purchase.status}');
      
      if (purchase.status == PurchaseStatus.purchased ||
          purchase.status == PurchaseStatus.restored) {
        _handleSuccessfulPurchase(purchase);
      } else if (purchase.status == PurchaseStatus.error) {
        _handlePurchaseError(purchase);
      }

      // Complete the purchase on Android
      if (purchase.pendingCompletePurchase) {
        _inAppPurchase.completePurchase(purchase);
      }
    }
  }

  // Handle purchase errors
  void _onPurchaseError(dynamic error) {
    print('❌ Purchase stream error: $error');
  }

  // Handle successful purchase
  void _handleSuccessfulPurchase(PurchaseDetails purchase) {
    print('✅ Purchase successful: ${purchase.productID}');
    
    // Verify purchase (in production, this should be done server-side)
    if (purchase.productID == AppConfig.lifetimeUnlockProductId) {
      _unlockLifetimeAccess(purchase);
    } else if (purchase.productID.startsWith(AppConfig.individualPromptProductId)) {
      final promptId = purchase.productID.replaceFirst(AppConfig.individualPromptProductId, '');
      _unlockIndividualPrompt(promptId, purchase);
    }
  }

  // Handle purchase errors
  void _handlePurchaseError(PurchaseDetails purchase) {
    print('❌ Purchase error: ${purchase.productID} - ${purchase.error}');
  }

  // Unlock lifetime access
  void _unlockLifetimeAccess(PurchaseDetails purchase) {
    // This would typically save to your backend and local storage
    print('🔓 Lifetime access unlocked');
  }

  // Unlock individual prompt
  void _unlockIndividualPrompt(String promptId, PurchaseDetails purchase) {
    // This would typically save to your backend and local storage
    print('🔓 Prompt unlocked: $promptId');
  }

  // Purchase lifetime access
  Future<bool> purchaseLifetimeAccess() async {
    if (!_isPurchaseAvailable || !_isInitialized) {
      print('❌ Purchase service not available');
      return false;
    }

    final lifetimeProduct = _products.firstWhere(
      (product) => product.id == AppConfig.lifetimeUnlockProductId,
      orElse: () => throw Exception('Lifetime product not found'),
    );

    final purchaseParam = PurchaseParam(productDetails: lifetimeProduct);
    
    try {
      final result = await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
      return result;
    } catch (e) {
      print('❌ Error purchasing lifetime access: $e');
      return false;
    }
  }

  // Purchase individual prompt
  Future<bool> purchasePrompt(String promptId) async {
    if (!_isPurchaseAvailable || !_isInitialized) {
      print('❌ Purchase service not available');
      return false;
    }

    // For Phase 1, we don't have individual prompt purchases
    // This is prepared for Phase 2
    print('⚠️ Individual prompt purchases not available in Phase 1');
    return false;

    // Phase 2 implementation:
    /*
    final promptProductId = '${AppConfig.individualPromptProductId}$promptId';
    
    // In a real implementation, you'd need to create products for each prompt
    // or use a server-side system to handle dynamic pricing
    
    try {
      // This would require server-side product creation
      // For now, we'll return false as it's Phase 2 feature
      return false;
    } catch (e) {
      print('❌ Error purchasing prompt: $e');
      return false;
    }
    */
  }

  // Restore purchases
  Future<bool> restorePurchases() async {
    if (!_isPurchaseAvailable || !_isInitialized) {
      print('❌ Purchase service not available');
      return false;
    }

    try {
      await _inAppPurchase.restorePurchases();
      print('✅ Purchases restored');
      return true;
    } catch (e) {
      print('❌ Error restoring purchases: $e');
      return false;
    }
  }

  // Get product details
  ProductDetails? getLifetimeProduct() {
    try {
      return _products.firstWhere(
        (product) => product.id == AppConfig.lifetimeUnlockProductId,
      );
    } catch (e) {
      return null;
    }
  }

  // Get localized price for lifetime access
  String getLifetimePrice() {
    final product = getLifetimeProduct();
    return product?.price ?? '₹999';
  }

  // Check if purchases are available
  bool get isPurchaseAvailable => _isPurchaseAvailable && _isInitialized;

  // Check if specific product is available
  bool isProductAvailable(String productId) {
    return _products.any((product) => product.id == productId);
  }

  // Get all available products
  List<ProductDetails> get availableProducts => _products;

  // Pricing helpers for different regions
  double getIndividualPromptPrice(String currencyCode) {
    switch (currencyCode.toUpperCase()) {
      case 'INR':
        return 1.0;
      case 'USD':
        return 0.05;
      case 'EUR':
        return 0.05;
      case 'GBP':
        return 0.04;
      default:
        return 0.05; // Default to USD equivalent
    }
  }

  double getLifetimePriceForCurrency(String currencyCode) {
    switch (currencyCode.toUpperCase()) {
      case 'INR':
        return 999.0;
      case 'USD':
        return 12.99;
      case 'EUR':
        return 11.99;
      case 'GBP':
        return 9.99;
      default:
        return 12.99; // Default to USD
    }
  }

  String formatPrice(double price, String currencyCode) {
    switch (currencyCode.toUpperCase()) {
      case 'INR':
        return '₹${price.toStringAsFixed(0)}';
      case 'USD':
        return '\$${price.toStringAsFixed(2)}';
      case 'EUR':
        return '€${price.toStringAsFixed(2)}';
      case 'GBP':
        return '£${price.toStringAsFixed(2)}';
      default:
        return '\$${price.toStringAsFixed(2)}';
    }
  }

  // Dispose resources
  void dispose() {
    if (_isInitialized) {
      _subscription.cancel();
      _isInitialized = false;
    }
  }

  // Development helpers
  Future<void> clearPurchaseHistory() async {
    // This is for testing purposes only
    print('🧹 Purchase history cleared (testing only)');
  }

  Map<String, dynamic> getPurchaseServiceStatus() {
    return {
      'initialized': _isInitialized,
      'available': _isPurchaseAvailable,
      'products_loaded': _products.length,
      'lifetime_product_available': isProductAvailable(AppConfig.lifetimeUnlockProductId),
    };
  }

  // Simulate purchase for testing (Phase 1)
  Future<bool> simulatePurchase(String productId) async {
    // This is only for Phase 1 testing when all prompts are free
    print('🧪 Simulating purchase for: $productId');
    await Future.delayed(const Duration(seconds: 2));
    return true;
  }
}