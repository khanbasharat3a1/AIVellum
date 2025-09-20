import 'package:json_annotation/json_annotation.dart';
import 'package:hive/hive.dart';

part 'models.g.dart';

@JsonSerializable()
@HiveType(typeId: 0)
class Vault extends HiveObject {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String name;
  
  @HiveField(2)
  final String description;
  
  @HiveField(3)
  final String version;
  
  @HiveField(4)
  @JsonKey(name: 'created_at')
  final String createdAt;
  
  @HiveField(5)
  @JsonKey(name: 'updated_at')
  final String updatedAt;
  
  @HiveField(6)
  @JsonKey(name: 'total_prompts')
  final int totalPrompts;
  
  @HiveField(7)
  @JsonKey(name: 'free_prompts_limit')
  final int freePromptsLimit;

  Vault({
    required this.id,
    required this.name,
    required this.description,
    required this.version,
    required this.createdAt,
    required this.updatedAt,
    required this.totalPrompts,
    required this.freePromptsLimit,
  });

  factory Vault.fromJson(Map<String, dynamic> json) => _$VaultFromJson(json);
  Map<String, dynamic> toJson() => _$VaultToJson(this);
}

@JsonSerializable()
@HiveType(typeId: 1)
class Category extends HiveObject {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String name;
  
  @HiveField(2)
  final String description;
  
  @HiveField(3)
  final String icon;
  
  @HiveField(4)
  final String color;
  
  @HiveField(5)
  final int order;

  Category({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    required this.order,
  });

  factory Category.fromJson(Map<String, dynamic> json) => _$CategoryFromJson(json);
  Map<String, dynamic> toJson() => _$CategoryToJson(this);
}

@JsonSerializable()
@HiveType(typeId: 2)
class Prompt extends HiveObject {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  @JsonKey(name: 'category_id')
  final String categoryId;
  
  @HiveField(2)
  final String title;
  
  @HiveField(3)
  final String description;
  
  @HiveField(4)
  final String content;
  
  @HiveField(5)
  final List<String> tags;
  
  @HiveField(6)
  final String difficulty;
  
  @HiveField(7)
  @JsonKey(name: 'estimated_time')
  final String estimatedTime;
  
  @HiveField(8)
  @JsonKey(name: 'is_premium')
  final bool isPremium;
  
  @HiveField(9)
  @JsonKey(name: 'created_at')
  final String createdAt;
  
  @HiveField(10)
  final int order;

  Prompt({
    required this.id,
    required this.categoryId,
    required this.title,
    required this.description,
    required this.content,
    required this.tags,
    required this.difficulty,
    required this.estimatedTime,
    required this.isPremium,
    required this.createdAt,
    required this.order,
  });

  factory Prompt.fromJson(Map<String, dynamic> json) => _$PromptFromJson(json);
  Map<String, dynamic> toJson() => _$PromptToJson(this);
}

@JsonSerializable()
class PricingTier {
  @JsonKey(name: 'individual_unlock')
  final Map<String, double> individualUnlock;
  
  @JsonKey(name: 'lifetime_unlock')
  final Map<String, double> lifetimeUnlock;

  PricingTier({
    required this.individualUnlock,
    required this.lifetimeUnlock,
  });

  factory PricingTier.fromJson(Map<String, dynamic> json) => _$PricingTierFromJson(json);
  Map<String, dynamic> toJson() => _$PricingTierToJson(this);
}

@JsonSerializable()
class AdSettings {
  @JsonKey(name: 'banner_frequency')
  final String bannerFrequency;
  
  @JsonKey(name: 'interstitial_frequency')
  final String interstitialFrequency;
  
  @JsonKey(name: 'rewarded_frequency')
  final String rewardedFrequency;

  AdSettings({
    required this.bannerFrequency,
    required this.interstitialFrequency,
    required this.rewardedFrequency,
  });

  factory AdSettings.fromJson(Map<String, dynamic> json) => _$AdSettingsFromJson(json);
  Map<String, dynamic> toJson() => _$AdSettingsToJson(this);
}

@JsonSerializable()
class PromptsDatabase {
  final Vault vault;
  final List<Category> categories;
  final List<Prompt> prompts;
  final PricingTier pricing;
  final AdSettings ads;

  PromptsDatabase({
    required this.vault,
    required this.categories,
    required this.prompts,
    required this.pricing,
    required this.ads,
  });

  factory PromptsDatabase.fromJson(Map<String, dynamic> json) => _$PromptsDatabaseFromJson(json);
  Map<String, dynamic> toJson() => _$PromptsDatabaseToJson(this);
}

// User Purchase Model for tracking unlocked prompts
@HiveType(typeId: 3)
class UserPurchase extends HiveObject {
  @HiveField(0)
  final String promptId;
  
  @HiveField(1)
  final DateTime purchaseDate;
  
  @HiveField(2)
  final double amount;
  
  @HiveField(3)
  final String currency;
  
  @HiveField(4)
  final String transactionId;

  UserPurchase({
    required this.promptId,
    required this.purchaseDate,
    required this.amount,
    required this.currency,
    required this.transactionId,
  });
}

// App Settings Model
@HiveType(typeId: 4)
class AppSettings extends HiveObject {
  @HiveField(0)
  bool isDarkMode;
  
  @HiveField(1)
  bool hasLifetimeAccess;
  
  @HiveField(2)
  DateTime? lastAdShown;
  
  @HiveField(3)
  int promptsViewedCount;
  
  @HiveField(4)
  String preferredLanguage;

  AppSettings({
    this.isDarkMode = false,
    this.hasLifetimeAccess = false,
    this.lastAdShown,
    this.promptsViewedCount = 0,
    this.preferredLanguage = 'en',
  });
}