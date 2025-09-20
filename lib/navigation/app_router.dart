import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../screens/splash_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/category/category_screen.dart';
import '../screens/prompt/prompt_screen.dart';
import '../screens/search/search_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../screens/purchase/purchase_screen.dart';
import '../screens/onboarding/onboarding_screen.dart';
import '../widgets/layout/main_layout.dart';

// Route names
class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String home = '/home';
  static const String category = '/category';
  static const String prompt = '/prompt';
  static const String search = '/search';
  static const String settings = '/settings';
  static const String purchase = '/purchase';
}

// Router provider
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    routes: [
      // Splash Screen
      GoRoute(
        path: AppRoutes.splash,
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),

      // Onboarding Screen
      GoRoute(
        path: AppRoutes.onboarding,
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),

      // Main Shell Route with Bottom Navigation
      ShellRoute(
        builder: (context, state, child) {
          return MainLayout(child: child);
        },
        routes: [
          // Home Screen
          GoRoute(
            path: AppRoutes.home,
            name: 'home',
            builder: (context, state) => const HomeScreen(),
          ),

          // Search Screen
          GoRoute(
            path: AppRoutes.search,
            name: 'search',
            builder: (context, state) => const SearchScreen(),
          ),

          // Settings Screen
          GoRoute(
            path: AppRoutes.settings,
            name: 'settings',
            builder: (context, state) => const SettingsScreen(),
          ),
        ],
      ),

      // Category Screen (Full screen)
      GoRoute(
        path: '${AppRoutes.category}/:categoryId',
        name: 'category',
        builder: (context, state) {
          final categoryId = state.pathParameters['categoryId']!;
          return CategoryScreen(categoryId: categoryId);
        },
      ),

      // Prompt Screen (Full screen)
      GoRoute(
        path: '${AppRoutes.prompt}/:promptId',
        name: 'prompt',
        builder: (context, state) {
          final promptId = state.pathParameters['promptId']!;
          final categoryId = state.uri.queryParameters['categoryId'];
          return PromptScreen(
            promptId: promptId,
            categoryId: categoryId,
          );
        },
      ),

      // Purchase Screen (Full screen)
      GoRoute(
        path: '${AppRoutes.purchase}/:type',
        name: 'purchase',
        builder: (context, state) {
          final type = state.pathParameters['type']!;
          final promptId = state.uri.queryParameters['promptId'];
          return PurchaseScreen(
            purchaseType: type,
            promptId: promptId,
          );
        },
      ),
    ],
    
    // Error page
    errorBuilder: (context, state) => ErrorScreen(error: state.error.toString()),
    
    // Redirect logic
    redirect: (context, state) {
      // Add any authentication or initialization checks here
      return null;
    },
  );
});

// Error Screen
class ErrorScreen extends StatelessWidget {
  final String error;

  const ErrorScreen({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Error'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline_rounded,
                size: 64,
                color: Colors.red,
              ),
              const SizedBox(height: 16),
              Text(
                'Page Not Found',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                error,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => context.go(AppRoutes.home),
                icon: const Icon(Icons.home_rounded),
                label: const Text('Go Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Navigation helper extensions
extension AppNavigation on BuildContext {
  void goToCategory(String categoryId) {
    go('${AppRoutes.category}/$categoryId');
  }

  void goToPrompt(String promptId, {String? categoryId}) {
    final uri = Uri(
      path: '${AppRoutes.prompt}/$promptId',
      queryParameters: categoryId != null ? {'categoryId': categoryId} : null,
    );
    go(uri.toString());
  }

  void goToPurchase(String type, {String? promptId}) {
    final uri = Uri(
      path: '${AppRoutes.purchase}/$type',
      queryParameters: promptId != null ? {'promptId': promptId} : null,
    );
    go(uri.toString());
  }

  void goHome() {
    go(AppRoutes.home);
  }

  void goToSearch() {
    go(AppRoutes.search);
  }

  void goToSettings() {
    go(AppRoutes.settings);
  }

  void goToOnboarding() {
    go(AppRoutes.onboarding);
  }
}

// Route information provider
final currentRouteProvider = Provider<String>((ref) {
  // This would be updated by the router delegate
  // For now, return default
  return AppRoutes.home;
});

// Navigation analytics helper
class NavigationAnalytics {
  static void trackScreenView(String screenName, {Map<String, String>? parameters}) {
    // Add your analytics tracking here (Firebase Analytics, etc.)
    debugPrint('📊 Screen View: $screenName ${parameters ?? ""}');
  }

  static void trackButtonTap(String buttonName, String screenName) {
    debugPrint('👆 Button Tap: $buttonName on $screenName');
  }

  static void trackPurchaseFlow(String step, {String? promptId}) {
    debugPrint('💰 Purchase Flow: $step ${promptId != null ? "for $promptId" : ""}');
  }
}