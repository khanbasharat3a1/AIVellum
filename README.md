# Aivellum - AI Prompts Collection App

<div align="center">


**A modern Flutter app showcasing curated AI prompts with monetization features**

[![Flutter Version](https://img.shields.io/badge/Flutter-3.10+-blue.svg)](https://flutter.dev/)
[![Dart Version](https://img.shields.io/badge/Dart-3.0+-blue.svg)](https://dart.dev/)

</div>

## 🚀 Overview

Aivellum is a production-ready Flutter application that showcases AI prompts across multiple categories. Built with modern architecture patterns, state management, and monetization strategies in mind.

### Key Features

- **📱 Modern UI/UX**: Clean, minimal design with smooth animations
- **🎯 Categorized Prompts**: Well-organized prompt collections
- **💰 Monetization Ready**: Phase 1 (AdMob) + Phase 2 (In-App Purchases)
- **🔐 Freemium Model**: 3 free prompts per category, premium unlocks
- **📊 Analytics Ready**: Built-in tracking and user behavior analytics
- **🌐 Scalable Architecture**: Clean code with provider pattern
- **📱 Responsive Design**: Optimized for all screen sizes
- **🎨 Theming**: Light/Dark mode support

## 📋 Table of Contents

- [Architecture](#-architecture)
- [Getting Started](#-getting-started)
- [Project Structure](#-project-structure)
- [Database Management](#-database-management)
- [Monetization Strategy](#-monetization-strategy)
- [Features](#-features)
- [API Documentation](#-api-documentation)
- [Development Guidelines](#-development-guidelines)
- [Deployment](#-deployment)
- [Contributing](#-contributing)

## 🏗 Architecture

### Tech Stack

- **Framework**: Flutter 3.10+
- **State Management**: Riverpod 2.4+
- **Navigation**: GoRouter 12.1+
- **Local Database**: Hive 2.2+
- **Monetization**: Google Mobile Ads + In-App Purchase
- **UI Components**: Material 3 + Custom Widgets
- **Animations**: Flutter Staggered Animations
- **Data Format**: JSON-based prompt database

### Design Patterns

- **Provider Pattern**: Riverpod for state management
- **Repository Pattern**: Data service abstraction
- **MVVM**: Model-View-ViewModel architecture
- **Dependency Injection**: Service locator pattern
- **Observer Pattern**: State change notifications

## 🚀 Getting Started

### Prerequisites

- Flutter SDK 3.10 or higher
- Dart SDK 3.0 or higher
- Android Studio / VS Code
- Python 3.7+ (for database management)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/aivellum.git
   cd aivellum
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate code (if needed)**
   ```bash
   flutter packages pub run build_runner build
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

### Configuration

1. **AdMob Setup** (Replace test IDs in `app_config.dart`)
   ```dart
   // Production AdMob IDs
   static const String androidBannerAdId = 'ca-app-pub-YOUR_ID/BANNER_ID';
   static const String iosBannerAdId = 'ca-app-pub-YOUR_ID/BANNER_ID';
   ```

2. **Google Play Billing** (Configure in Phase 2)
   ```dart
   static const String lifetimeUnlockProductId = 'lifetime_unlock_all_prompts';
   ```

3. **App Metadata** (Update in `app_config.dart`)
   ```dart
   static const String appName = 'Aivellum';
   static const String packageName = 'com.khanbasharat.aivellum';
   ```

## 📁 Project Structure

```
lib/
├── config/                 # App configuration
│   └── app_config.dart
├── models/                 # Data models
│   └── models.dart
├── services/               # Business logic services
│   ├── data_service.dart
│   ├── ad_service.dart
│   └── purchase_service.dart
├── providers/              # Riverpod providers
│   └── app_providers.dart
├── screens/                # UI screens
│   ├── splash_screen.dart
│   ├── onboarding/
│   ├── home/
│   ├── category/
│   ├── prompt/
│   ├── search/
│   ├── settings/
│   └── purchase/
├── widgets/                # Reusable UI components
│   ├── cards/
│   ├── common/
│   ├── layout/
│   └── ads/
├── navigation/             # Routing configuration
│   └── app_router.dart
└── main.dart              # App entry point

assets/
├── data/
│   └── prompts_database.json
├── images/
├── animations/
└── fonts/

database_manager.py         # Python CRUD script
```

## 💾 Database Management

The app uses a JSON-based database for prompt storage, managed through a comprehensive Python script.

### Database Structure

```json
{
  "vault": {
    "id": "vault_001",
    "name": "50 Tier 1 Real Prompts Vault",
    "total_prompts": 55,
    "free_prompts_limit": 3
  },
  "categories": [...],
  "prompts": [...],
  "pricing": {...},
  "ads": {...}
}
```

### Python Database Manager

**Installation**
```bash
pip install -r requirements.txt  # (if you create one)
# or just ensure you have Python 3.7+
```

**Usage Examples**

```bash
# List all categories
python database_manager.py list-categories

# Add new category
python database_manager.py add-category \
  --name "AI Art" \
  --description "Creative AI art prompts" \
  --icon "palette" \
  --color "#FF6B6B"

# Add new prompt
python database_manager.py add-prompt \
  --category cat_writing \
  --title "Blog Post Creator" \
  --description "Generate engaging blog posts" \
  --content "Your detailed prompt here..." \
  --tags blog content writing \
  --difficulty intermediate \
  --premium

# Update existing prompt
python database_manager.py update-prompt \
  --id prompt_001 \
  --title "Updated Title" \
  --description "New description"

# Search prompts
python database_manager.py list-prompts \
  --category cat_business \
  --search "marketing"

# Database operations
python database_manager.py validate      # Validate integrity
python database_manager.py stats        # Show statistics
python database_manager.py backup       # Create backup
python database_manager.py restore --file backup.json
```

## 💰 Monetization Strategy

### Phase 1: AdMob Integration (Current)
- **Banner Ads**: Every screen
- **Interstitial Ads**: Every 3 prompt views
- **Rewarded Ads**: Optional unlock mechanism
- **All Prompts Free**: Building user base

### Phase 2: Premium Monetization (Future)
- **Individual Unlock**: ₹1 per prompt (localized pricing)
- **Lifetime Access**: ₹999 (all prompts forever)
- **Ad Removal**: Premium users see no ads
- **Advanced Features**: Favorites, history, export

### Pricing Strategy

| Region | Individual Prompt | Lifetime Access |
|--------|------------------|-----------------|
| India  | ₹1               | ₹999            |
| US     | $0.05            | $12.99          |
| Europe | €0.05            | €11.99          |
| UK     | £0.04            | £9.99           |

## 🎯 Features

### Core Features
- ✅ Categorized prompt browsing
- ✅ Search and filtering
- ✅ Smooth animations and transitions
- ✅ Dark/Light theme support
- ✅ Offline-first architecture
- ✅ AdMob integration
- ✅ User progress tracking

### Premium Features (Phase 2)
- 🔄 Individual prompt purchases
- 🔄 Lifetime access option
- 🔄 Ad-free experience
- 🔄 Advanced search filters
- 🔄 Prompt favorites
- 🔄 Usage analytics
- 🔄 Export functionality

### Technical Features
- ✅ State management with Riverpod
- ✅ Type-safe navigation with GoRouter
- ✅ Efficient data persistence with Hive
- ✅ Comprehensive error handling
- ✅ Loading states and shimmer effects
- ✅ Responsive design
- ✅ Performance optimizations

## 📚 API Documentation

### Key Services

#### DataService
```dart
// Initialize service
await DataService().initialize();

// Get prompts
List<Prompt> prompts = dataService.getPromptsByCategory('cat_writing');
bool canAccess = dataService.canAccessPrompt('prompt_001');

// Purchase management
await dataService.addPurchase(purchase);
bool isUnlocked = dataService.isPromptUnlocked('prompt_001');
```

#### AdService
```dart
// Initialize ads
await AdService().initialize();

// Show ads
bool shown = await adService.showInterstitialAd();
bool canShow = adService.canShowInterstitialAd();
```

#### PurchaseService
```dart
// Initialize purchases
await PurchaseService().initialize();

// Make purchases
bool success = await purchaseService.purchaseLifetimeAccess();
String price = purchaseService.getLifetimePrice();
```

### State Management

#### Providers
```dart
// App-wide providers
final categoriesProvider = Provider<List<Category>>((ref) => ...);
final promptProvider = Provider.family<Prompt?, String>((ref, id) => ...);
final appSettingsProvider = StateNotifierProvider<AppSettingsNotifier, AppSettings>((ref) => ...);

// Usage in widgets
final categories = ref.watch(categoriesProvider);
final prompt = ref.watch(promptProvider('prompt_001'));
```

## 🛠 Development Guidelines

### Code Style
- Follow Dart/Flutter style guide
- Use meaningful variable names
- Add comprehensive documentation
- Write unit tests for business logic

### Git Workflow
```bash
git checkout -b feature/new-feature
git add .
git commit -m "feat: add new feature"
git push origin feature/new-feature
```

### Testing
```bash
# Unit tests
flutter test

# Integration tests
flutter test integration_test/

# Widget tests
flutter test test/widgets/
```

### Build Commands
```bash
# Development build
flutter run --debug

# Release build
flutter build apk --release
flutter build ios --release

# Web build
flutter build web --release
```

## 🚀 Deployment

### Android Deployment

1. **Configure Signing**
   ```bash
   keytool -genkey -v -keystore ~/aivellum-release.jks -keyalg RSA -keysize 2048 -validity 10000 -alias aivellum
   ```

2. **Build APK/AAB**
   ```bash
   flutter build apk --release
   flutter build appbundle --release
   ```

3. **Upload to Play Store**
   - Follow Play Console guidelines
   - Configure in-app products for Phase 2
   - Set up AdMob integration

### iOS Deployment

1. **Configure Xcode**
   - Set up provisioning profiles
   - Configure App Store Connect

2. **Build IPA**
   ```bash
   flutter build ios --release
   ```

### Environment Configuration

Create environment-specific configs:

```dart
// lib/config/environment.dart
class Environment {
  static const bool isProduction = bool.fromEnvironment('PRODUCTION');
  static const String adMobAppId = String.fromEnvironment('ADMOB_APP_ID');
}
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

### Development Setup

```bash
git clone https://github.com/yourusername/aivellum.git
cd aivellum
flutter pub get
flutter test
```

### Issue Reporting

Use GitHub issues with the following labels:
- `bug`: Something isn't working
- `enhancement`: New feature or request
- `documentation`: Documentation needs improvement
- `performance`: Performance related issues


## 📞 Support

- **Email**: khanbasharat3a1@gmail.com

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Riverpod for excellent state management
- Material Design team for design guidelines
- All contributors who help improve Aivellum

---

<div align="center">
Made with ❤️ by the Khan Basharat
</div>
