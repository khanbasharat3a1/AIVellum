import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/app_config.dart';
import '../../models/models.dart';
import '../../providers/app_providers.dart';

class PromptCard extends ConsumerWidget {
  final dynamic prompt; // Can be Prompt model
  final VoidCallback onTap;
  final bool showLockIcon;
  final bool showCategory;

  const PromptCard({
    super.key,
    required this.prompt,
    required this.onTap,
    this.showLockIcon = false,
    this.showCategory = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final settings = ref.watch(appSettingsProvider);
    final isUnlocked = ref.watch(promptUnlockedProvider(prompt.id));
    final isFree = ref.watch(promptFreeProvider(prompt.id));
    
    final canAccess = isFree || isUnlocked || settings.hasLifetimeAccess;
    final isLocked = showLockIcon && !canAccess;

    return Card(
      elevation: 2,
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConfig.defaultBorderRadius),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                children: [
                  // Difficulty Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: DifficultyConfig.getColor(prompt.difficulty).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: DifficultyConfig.getColor(prompt.difficulty).withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      DifficultyConfig.getDisplayText(prompt.difficulty),
                      style: TextStyle(
                        color: DifficultyConfig.getColor(prompt.difficulty),
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  
                  const Spacer(),
                  
                  // Lock Icon
                  if (isLocked)
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppTheme.warningColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.lock_rounded,
                        size: 16,
                        color: AppTheme.warningColor,
                      ),
                    )
                  else if (isFree)
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppTheme.successColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.star_rounded,
                        size: 16,
                        color: AppTheme.successColor,
                      ),
                    ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Title
              Text(
                prompt.title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isLocked 
                      ? theme.textTheme.titleMedium?.color?.withOpacity(0.6)
                      : null,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              
              const SizedBox(height: 8),
              
              // Description
              Text(
                prompt.description,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isLocked 
                      ? theme.textTheme.bodyMedium?.color?.withOpacity(0.5)
                      : theme.textTheme.bodySmall?.color,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              
              const SizedBox(height: 12),
              
              // Footer
              Row(
                children: [
                  // Time Estimate
                  Icon(
                    Icons.access_time_rounded,
                    size: 14,
                    color: theme.textTheme.bodySmall?.color,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    prompt.estimatedTime,
                    style: theme.textTheme.bodySmall,
                  ),
                  
                  const SizedBox(width: 16),
                  
                  // Tags (show first 2)
                  if (prompt.tags.isNotEmpty) ...[
                    Expanded(
                      child: Wrap(
                        spacing: 4,
                        children: prompt.tags.take(2).map<Widget>((tag) => 
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: theme.primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '#$tag',
                              style: TextStyle(
                                fontSize: 10,
                                color: theme.primaryColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ).toList(),
                      ),
                    ),
                  ],
                  
                  // Action Icon
                  Icon(
                    isLocked 
                        ? Icons.lock_rounded 
                        : Icons.arrow_forward_ios_rounded,
                    size: 16,
                    color: isLocked 
                        ? AppTheme.warningColor 
                        : theme.textTheme.bodySmall?.color,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Compact version for lists
class PromptCardCompact extends ConsumerWidget {
  final dynamic prompt;
  final VoidCallback onTap;
  final bool showCategory;

  const PromptCardCompact({
    super.key,
    required this.prompt,
    required this.onTap,
    this.showCategory = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final settings = ref.watch(appSettingsProvider);
    final isUnlocked = ref.watch(promptUnlockedProvider(prompt.id));
    final isFree = ref.watch(promptFreeProvider(prompt.id));
    
    final canAccess = isFree || isUnlocked || settings.hasLifetimeAccess;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: DifficultyConfig.getColor(prompt.difficulty).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            canAccess ? Icons.psychology_rounded : Icons.lock_rounded,
            color: canAccess 
                ? DifficultyConfig.getColor(prompt.difficulty)
                : AppTheme.warningColor,
            size: 20,
          ),
        ),
        title: Text(
          prompt.title,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              prompt.description,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: DifficultyConfig.getColor(prompt.difficulty).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    DifficultyConfig.getDisplayText(prompt.difficulty),
                    style: TextStyle(
                      fontSize: 10,
                      color: DifficultyConfig.getColor(prompt.difficulty),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.access_time_rounded,
                  size: 12,
                  color: theme.textTheme.bodySmall?.color,
                ),
                const SizedBox(width: 2),
                Text(
                  prompt.estimatedTime,
                  style: theme.textTheme.bodySmall?.copyWith(fontSize: 11),
                ),
                if (!canAccess) ...[
                  const SizedBox(width: 8),
                  Icon(
                    Icons.lock_rounded,
                    size: 12,
                    color: AppTheme.warningColor,
                  ),
                ],
              ],
            ),
          ],
        ),
        trailing: Icon(
          Icons.arrow_forward_ios_rounded,
          size: 16,
          color: theme.textTheme.bodySmall?.color,
        ),
      ),
    );
  }
}

// Featured prompt card for home screen
class FeaturedPromptCard extends ConsumerWidget {
  final dynamic prompt;
  final VoidCallback onTap;

  const FeaturedPromptCard({
    super.key,
    required this.prompt,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final categories = ref.watch(categoriesProvider);
    final category = categories.firstWhere(
      (cat) => cat.id == prompt.categoryId,
      orElse: () {
        return Category(id: '', name: '', description: '', icon: '', color: '', order: 0);
      },
    );

    return Card(
      elevation: 4,
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConfig.defaultBorderRadius),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppConfig.defaultBorderRadius),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                theme.primaryColor.withOpacity(0.8),
                theme.primaryColor,
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Category Badge
              if (category != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    category.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              
              const SizedBox(height: 12),
              
              // Title
              Text(
                prompt.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              
              const SizedBox(height: 8),
              
              // Description
              Text(
                prompt.description,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 14,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              
              const SizedBox(height: 16),
              
              // Footer
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.access_time_rounded,
                          size: 12,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          prompt.estimatedTime,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const Spacer(),
                  
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.arrow_forward_rounded,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Shimmer loading card
class PromptCardSkeleton extends StatelessWidget {
  const PromptCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      margin: EdgeInsets.zero,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row
            Row(
              children: [
                Container(
                  width: 60,
                  height: 20,
                  decoration: BoxDecoration(
                    color: theme.disabledColor.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const Spacer(),
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: theme.disabledColor.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Title
            Container(
              width: double.infinity,
              height: 20,
              decoration: BoxDecoration(
                color: theme.disabledColor.withOpacity(0.3),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            
            const SizedBox(height: 8),
            
            // Description lines
            Container(
              width: double.infinity,
              height: 16,
              decoration: BoxDecoration(
                color: theme.disabledColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            
            const SizedBox(height: 4),
            
            Container(
              width: MediaQuery.of(context).size.width * 0.7,
              height: 16,
              decoration: BoxDecoration(
                color: theme.disabledColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            
            const SizedBox(height: 12),
            
            // Footer
            Row(
              children: [
                Container(
                  width: 80,
                  height: 14,
                  decoration: BoxDecoration(
                    color: theme.disabledColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 16),
                Container(
                  width: 40,
                  height: 14,
                  decoration: BoxDecoration(
                    color: theme.disabledColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const Spacer(),
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: theme.disabledColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}