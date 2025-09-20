// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VaultAdapter extends TypeAdapter<Vault> {
  @override
  final int typeId = 0;

  @override
  Vault read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Vault(
      id: fields[0] as String,
      name: fields[1] as String,
      description: fields[2] as String,
      version: fields[3] as String,
      createdAt: fields[4] as String,
      updatedAt: fields[5] as String,
      totalPrompts: fields[6] as int,
      freePromptsLimit: fields[7] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Vault obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.version)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.updatedAt)
      ..writeByte(6)
      ..write(obj.totalPrompts)
      ..writeByte(7)
      ..write(obj.freePromptsLimit);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VaultAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CategoryAdapter extends TypeAdapter<Category> {
  @override
  final int typeId = 1;

  @override
  Category read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Category(
      id: fields[0] as String,
      name: fields[1] as String,
      description: fields[2] as String,
      icon: fields[3] as String,
      color: fields[4] as String,
      order: fields[5] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Category obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.icon)
      ..writeByte(4)
      ..write(obj.color)
      ..writeByte(5)
      ..write(obj.order);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CategoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PromptAdapter extends TypeAdapter<Prompt> {
  @override
  final int typeId = 2;

  @override
  Prompt read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Prompt(
      id: fields[0] as String,
      categoryId: fields[1] as String,
      title: fields[2] as String,
      description: fields[3] as String,
      content: fields[4] as String,
      tags: (fields[5] as List).cast<String>(),
      difficulty: fields[6] as String,
      estimatedTime: fields[7] as String,
      isPremium: fields[8] as bool,
      createdAt: fields[9] as String,
      order: fields[10] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Prompt obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.categoryId)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.content)
      ..writeByte(5)
      ..write(obj.tags)
      ..writeByte(6)
      ..write(obj.difficulty)
      ..writeByte(7)
      ..write(obj.estimatedTime)
      ..writeByte(8)
      ..write(obj.isPremium)
      ..writeByte(9)
      ..write(obj.createdAt)
      ..writeByte(10)
      ..write(obj.order);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PromptAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class UserPurchaseAdapter extends TypeAdapter<UserPurchase> {
  @override
  final int typeId = 3;

  @override
  UserPurchase read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserPurchase(
      promptId: fields[0] as String,
      purchaseDate: fields[1] as DateTime,
      amount: fields[2] as double,
      currency: fields[3] as String,
      transactionId: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, UserPurchase obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.promptId)
      ..writeByte(1)
      ..write(obj.purchaseDate)
      ..writeByte(2)
      ..write(obj.amount)
      ..writeByte(3)
      ..write(obj.currency)
      ..writeByte(4)
      ..write(obj.transactionId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserPurchaseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AppSettingsAdapter extends TypeAdapter<AppSettings> {
  @override
  final int typeId = 4;

  @override
  AppSettings read(BinaryReader reader) {
    // NOTE: This file was manually edited because the build_runner could not be
    // executed in the agent's environment. The changes reflect the addition
    // of defaultValues to the @HiveField annotations in the AppSettings class.
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AppSettings(
      isDarkMode: fields[0] ?? false,
      hasLifetimeAccess: fields[1] ?? false,
      lastAdShown: fields[2] as DateTime?,
      promptsViewedCount: fields[3] ?? 0,
      preferredLanguage: fields[4] ?? 'en',
      hasSeenOnboarding: fields[5] ?? false,
    );
  }

  @override
  void write(BinaryWriter writer, AppSettings obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.isDarkMode)
      ..writeByte(1)
      ..write(obj.hasLifetimeAccess)
      ..writeByte(2)
      ..write(obj.lastAdShown)
      ..writeByte(3)
      ..write(obj.promptsViewedCount)
      ..writeByte(4)
      ..write(obj.preferredLanguage)
      ..writeByte(5)
      ..write(obj.hasSeenOnboarding);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppSettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Vault _$VaultFromJson(Map<String, dynamic> json) => Vault(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      version: json['version'] as String,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      totalPrompts: (json['total_prompts'] as num).toInt(),
      freePromptsLimit: (json['free_prompts_limit'] as num).toInt(),
    );

Map<String, dynamic> _$VaultToJson(Vault instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'version': instance.version,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'total_prompts': instance.totalPrompts,
      'free_prompts_limit': instance.freePromptsLimit,
    };

Category _$CategoryFromJson(Map<String, dynamic> json) => Category(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      icon: json['icon'] as String,
      color: json['color'] as String,
      order: (json['order'] as num).toInt(),
    );

Map<String, dynamic> _$CategoryToJson(Category instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'icon': instance.icon,
      'color': instance.color,
      'order': instance.order,
    };

Prompt _$PromptFromJson(Map<String, dynamic> json) => Prompt(
      id: json['id'] as String,
      categoryId: json['category_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      content: json['content'] as String,
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      difficulty: json['difficulty'] as String,
      estimatedTime: json['estimated_time'] as String,
      isPremium: json['is_premium'] as bool,
      createdAt: json['created_at'] as String,
      order: (json['order'] as num).toInt(),
    );

Map<String, dynamic> _$PromptToJson(Prompt instance) => <String, dynamic>{
      'id': instance.id,
      'category_id': instance.categoryId,
      'title': instance.title,
      'description': instance.description,
      'content': instance.content,
      'tags': instance.tags,
      'difficulty': instance.difficulty,
      'estimated_time': instance.estimatedTime,
      'is_premium': instance.isPremium,
      'created_at': instance.createdAt,
      'order': instance.order,
    };

PricingTier _$PricingTierFromJson(Map<String, dynamic> json) => PricingTier(
      individualUnlock: (json['individual_unlock'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
      lifetimeUnlock: (json['lifetime_unlock'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
    );

Map<String, dynamic> _$PricingTierToJson(PricingTier instance) =>
    <String, dynamic>{
      'individual_unlock': instance.individualUnlock,
      'lifetime_unlock': instance.lifetimeUnlock,
    };

AdSettings _$AdSettingsFromJson(Map<String, dynamic> json) => AdSettings(
      bannerFrequency: json['banner_frequency'] as String,
      interstitialFrequency: json['interstitial_frequency'] as String,
      rewardedFrequency: json['rewarded_frequency'] as String,
    );

Map<String, dynamic> _$AdSettingsToJson(AdSettings instance) =>
    <String, dynamic>{
      'banner_frequency': instance.bannerFrequency,
      'interstitial_frequency': instance.interstitialFrequency,
      'rewarded_frequency': instance.rewardedFrequency,
    };

PromptsDatabase _$PromptsDatabaseFromJson(Map<String, dynamic> json) =>
    PromptsDatabase(
      vault: Vault.fromJson(json['vault'] as Map<String, dynamic>),
      categories: (json['categories'] as List<dynamic>)
          .map((e) => Category.fromJson(e as Map<String, dynamic>))
          .toList(),
      prompts: (json['prompts'] as List<dynamic>)
          .map((e) => Prompt.fromJson(e as Map<String, dynamic>))
          .toList(),
      pricing: PricingTier.fromJson(json['pricing'] as Map<String, dynamic>),
      ads: AdSettings.fromJson(json['ads'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PromptsDatabaseToJson(PromptsDatabase instance) =>
    <String, dynamic>{
      'vault': instance.vault,
      'categories': instance.categories,
      'prompts': instance.prompts,
      'pricing': instance.pricing,
      'ads': instance.ads,
    };
