import 'package:flutter/material.dart';

class AppConfig {
  // App Info
  static const String appName = 'Aivellum';
  static const String packageName = 'com.khanbasharat.aivellum';
  static const String version = '1.0.0';
  
  // Database
  static const String databasePath = 'assets/data/prompts_database.json';
  
  // Hive Boxes
  static const String vaultBox = 'vault_box';
  static const String categoriesBox = 'categories_box';
  static const String promptsBox = 'prompts_box';
  static const String purchasesBox = 'purchases_box';
  static const String settingsBox = 'settings_box';
  
  // AdMob IDs (Test IDs - Replace with real ones in production)
  static const String androidBannerAdId = 'ca-app-pub-3940256099942544/6300978111';
  static const String iosBannerAdId = 'ca-app-pub-3940256099942544/2934735716';
  static const String androidInterstitialAdId = 'ca-app-pub-3940256099942544/1033173712';
  static const String iosInterstitialAdId = 'ca-app-pub-3940256099942544/4411468910';
  static const String androidRewardedAdId = 'ca-app-pub-3940256099942544/5224354917';
  static const String iosRewardedAdId = 'ca-app-pub-3940256099942544/1712485313';
  
  // Google Play Billing Product IDs
  static const String lifetimeUnlockProductId = 'lifetime_unlock_all_prompts';
  static const String individualPromptProductId = 'unlock_single_prompt_';
  
  // UI Constants
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double defaultBorderRadius = 12.0;
  static const double cardElevation = 2.0;
  
  // Animation Durations
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 300);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);
  
  // Free Content Limits
  static const int freePromptsPerCategory = 3;
  
  // Ad Frequency
  static const int interstitialAdFrequency = 3; // Show ad every 3 prompts
  static const int minTimeBetweenAds = 30; // Seconds between ads
}

class AppTheme {
  // Light Theme Colors
  static const Color primaryColor = Color(0xFF6366F1);
  static const Color secondaryColor = Color(0xFF8B5CF6);
  static const Color accentColor = Color(0xFF06B6D4);
  static const Color backgroundColor = Color(0xFFF8FAFC);
  static const Color surfaceColor = Color(0xFFFFFFFF);
  static const Color cardColor = Color(0xFFFFFFFF);
  static const Color textPrimaryColor = Color(0xFF0F172A);
  static const Color textSecondaryColor = Color(0xFF64748B);
  static const Color borderColor = Color(0xFFE2E8F0);
  static const Color errorColor = Color(0xFFEF4444);
  static const Color successColor = Color(0xFF10B981);
  static const Color warningColor = Color(0xFFF59E0B);
  
  // Dark Theme Colors
  static const Color darkPrimaryColor = Color(0xFF818CF8);
  static const Color darkSecondaryColor = Color(0xFFA78BFA);
  static const Color darkAccentColor = Color(0xFF22D3EE);
  static const Color darkBackgroundColor = Color(0xFF0F172A);
  static const Color darkSurfaceColor = Color(0xFF1E293B);
  static const Color darkCardColor = Color(0xFF334155);
  static const Color darkTextPrimaryColor = Color(0xFFF8FAFC);
  static const Color darkTextSecondaryColor = Color(0xFFCBD5E1);
  static const Color darkBorderColor = Color(0xFF475569);
  
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: backgroundColor,
    cardColor: cardColor,
    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
      tertiary: accentColor,
      surface: surfaceColor,
      error: errorColor,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onTertiary: Colors.white,
      onSurface: textPrimaryColor,
      onError: Colors.white,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: surfaceColor,
      foregroundColor: textPrimaryColor,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: textPrimaryColor,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    ),
    cardTheme: CardThemeData(
      color: cardColor,
      elevation: AppConfig.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConfig.defaultBorderRadius),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 2,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConfig.defaultBorderRadius),
        ),
      ),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        color: textPrimaryColor,
        fontSize: 32,
        fontWeight: FontWeight.bold,
      ),
      displayMedium: TextStyle(
        color: textPrimaryColor,
        fontSize: 28,
        fontWeight: FontWeight.bold,
      ),
      displaySmall: TextStyle(
        color: textPrimaryColor,
        fontSize: 24,
        fontWeight: FontWeight.w600,
      ),
      headlineLarge: TextStyle(
        color: textPrimaryColor,
        fontSize: 22,
        fontWeight: FontWeight.w600,
      ),
      headlineMedium: TextStyle(
        color: textPrimaryColor,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      headlineSmall: TextStyle(
        color: textPrimaryColor,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
      titleLarge: TextStyle(
        color: textPrimaryColor,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      titleMedium: TextStyle(
        color: textPrimaryColor,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      titleSmall: TextStyle(
        color: textSecondaryColor,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      bodyLarge: TextStyle(
        color: textPrimaryColor,
        fontSize: 16,
        fontWeight: FontWeight.normal,
      ),
      bodyMedium: TextStyle(
        color: textPrimaryColor,
        fontSize: 14,
        fontWeight: FontWeight.normal,
      ),
      bodySmall: TextStyle(
        color: textSecondaryColor,
        fontSize: 12,
        fontWeight: FontWeight.normal,
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: darkPrimaryColor,
    scaffoldBackgroundColor: darkBackgroundColor,
    cardColor: darkCardColor,
    colorScheme: const ColorScheme.dark(
      primary: darkPrimaryColor,
      secondary: darkSecondaryColor,
      tertiary: darkAccentColor,
      surface: darkSurfaceColor,
      error: errorColor,
      onPrimary: darkBackgroundColor,
      onSecondary: darkBackgroundColor,
      onTertiary: darkBackgroundColor,
      onSurface: darkTextPrimaryColor,
      onError: Colors.white,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: darkSurfaceColor,
      foregroundColor: darkTextPrimaryColor,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: darkTextPrimaryColor,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    ),
    cardTheme: CardThemeData(
      color: darkCardColor,
      elevation: AppConfig.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConfig.defaultBorderRadius),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: darkPrimaryColor,
        foregroundColor: darkBackgroundColor,
        elevation: 2,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConfig.defaultBorderRadius),
        ),
      ),
    ),
  );
}

// Category Icons mapping
class CategoryIcons {
  static const Map<String, IconData> icons = {
    'edit': Icons.edit_rounded,
    'business': Icons.business_center_rounded,
    'code': Icons.code_rounded,
    'trending_up': Icons.trending_up_rounded,
    'school': Icons.school_rounded,
    'schedule': Icons.schedule_rounded,
    'psychology': Icons.psychology_rounded,
    'campaign': Icons.campaign_rounded,
    'analytics': Icons.analytics_rounded,
    'design_services': Icons.design_services_rounded,
  };
  
  static IconData getIcon(String iconName) {
    return icons[iconName] ?? Icons.category_rounded;
  }
}

// Difficulty Colors
class DifficultyConfig {
  static const Map<String, Color> colors = {
    'beginner': AppTheme.successColor,
    'intermediate': AppTheme.warningColor,
    'advanced': AppTheme.errorColor,
  };
  
  static Color getColor(String difficulty) {
    return colors[difficulty] ?? AppTheme.textSecondaryColor;
  }
  
  static String getDisplayText(String difficulty) {
    switch (difficulty) {
      case 'beginner':
        return 'Beginner';
      case 'intermediate':
        return 'Intermediate';
      case 'advanced':
        return 'Advanced';
      default:
        return difficulty.toUpperCase();
    }
  }
}