import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'config/app_config.dart';
import 'providers/app_providers.dart';
import 'navigation/app_router.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarColor: Colors.white,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));

  runApp(const ProviderScope(child: AivellumApp()));
}

class AivellumApp extends ConsumerWidget {
  const AivellumApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataServiceAsync = ref.watch(dataServiceInitializerProvider);

    return dataServiceAsync.when(
      data: (dataService) {
        // Data service is initialized, now we can build the main app and router.
        return const AppRouterInitializer();
      },
      loading: () {
        // Show a simple splash screen while initializing
        return const MaterialApp(
          home: SplashScreen(),
          debugShowCheckedModeBanner: false,
        );
      },
      error: (error, stackTrace) {
        // Show an error widget if initialization fails
        return AppErrorWidget(
          error: 'Failed to initialize application: $error',
          onRetry: () => ref.invalidate(dataServiceInitializerProvider),
        );
      },
    );
  }
}

/// A widget that initializes the router and performs the initial navigation.
class AppRouterInitializer extends ConsumerStatefulWidget {
  const AppRouterInitializer({super.key});

  @override
  ConsumerState<AppRouterInitializer> createState() =>
      _AppRouterInitializerState();
}

class _AppRouterInitializerState extends ConsumerState<AppRouterInitializer> {
  @override
  void initState() {
    super.initState();
    // Perform navigation after the first frame to ensure the router is ready.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _performInitialNavigation();
    });
  }

  void _performInitialNavigation() {
    final settings = ref.read(appSettingsProvider);
    final router = ref.read(routerProvider);

    // Based on whether the user has seen the onboarding, navigate to the
    // correct initial screen.
    if (settings.hasSeenOnboarding) {
      router.go(AppRoutes.home);
    } else {
      router.go(AppRoutes.onboarding);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeProvider);
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: AppConfig.appName,
      debugShowCheckedModeBanner: false,
      
      // Theme configuration
      theme: AppTheme.lightTheme.copyWith(
        textTheme: GoogleFonts.interTextTheme(AppTheme.lightTheme.textTheme),
      ),
      darkTheme: AppTheme.darkTheme.copyWith(
        textTheme: GoogleFonts.interTextTheme(AppTheme.darkTheme.textTheme),
      ),
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,

      // Routing
      routerConfig: router,

      // Localization (for future multi-language support)
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('hi', 'IN'),
      ],
      
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(MediaQuery.of(context).textScaleFactor.clamp(0.8, 1.2)),
          ),
          child: child!,
        );
      },
    );
  }
}

// Error Widget for better error handling
class AppErrorWidget extends StatelessWidget {
  final String error;
  final VoidCallback? onRetry;

  const AppErrorWidget({
    super.key,
    required this.error,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline_rounded,
                  size: 64,
                  color: AppTheme.errorColor,
                ),
                const SizedBox(height: 16),
                Text(
                  'Oops! Something went wrong',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: AppTheme.textPrimaryColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  error,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondaryColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                if (onRetry != null)
                  ElevatedButton.icon(
                    onPressed: onRetry,
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('Try Again'),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}