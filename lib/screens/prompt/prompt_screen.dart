import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:aivellum/models/models.dart';
import 'package:aivellum/config/app_config.dart';
import 'package:aivellum/providers/app_providers.dart';

class PromptScreen extends ConsumerWidget {
  final String promptId;
  final String? categoryId; // Keep it for consistency with router, though not directly used here

  const PromptScreen({super.key, required this.promptId, this.categoryId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final prompt = ref.watch(promptProvider(promptId));

    if (prompt == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('Prompt not found.')),
      );
    }

    final settings = ref.watch(appSettingsProvider);
    final isUnlocked = ref.watch(promptUnlockedProvider(prompt.id));
    final isFree = ref.watch(promptFreeProvider(prompt.id));

    final canAccess = isFree || isUnlocked || settings.hasLifetimeAccess;

    return Scaffold(
      appBar: AppBar(
        title: Text(prompt.title),
        actions: [
          if (!canAccess)
            IconButton(
              icon: const Icon(Icons.lock_rounded),
              onPressed: () => _showPurchaseDialog(context, ref, prompt),
            ),
          IconButton(
            icon: const Icon(Icons.copy_rounded),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: prompt.content));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Prompt copied to clipboard!')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.share_rounded),
            onPressed: () => _sharePrompt(prompt),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConfig.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              prompt.title,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              prompt.description,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.textTheme.bodyLarge?.color?.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Chip(
                  label: Text(prompt.difficulty),
                  backgroundColor: DifficultyConfig.getColor(prompt.difficulty).withOpacity(0.1),
                  labelStyle: TextStyle(color: DifficultyConfig.getColor(prompt.difficulty)),
                ),
                const SizedBox(width: 8),
                Icon(Icons.access_time_rounded, size: 16, color: theme.textTheme.bodySmall?.color),
                const SizedBox(width: 4),
                Text(
                  prompt.estimatedTime,
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (prompt.tags.isNotEmpty) ...[
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: prompt.tags
                    .map((tag) => Chip(
                          label: Text('#$tag'),
                          backgroundColor: theme.primaryColor.withOpacity(0.1),
                          labelStyle: TextStyle(color: theme.primaryColor),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 16),
            ],
            Text(
              'Prompt Content',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(AppConfig.defaultPadding),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(AppConfig.defaultBorderRadius),
                border: Border.all(color: theme.dividerColor.withOpacity(0.5)),
              ),
              child: SelectableText(
                canAccess ? prompt.content : 'Unlock this prompt to view its content.',
                style: theme.textTheme.bodyMedium,
              ),
            ),
            const SizedBox(height: 16),
            if (!canAccess)
              Center(
                child: ElevatedButton.icon(
                  onPressed: () => _showPurchaseDialog(context, ref, prompt),
                  icon: const Icon(Icons.lock_open_rounded),
                  label: const Text('Unlock Prompt'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _sharePrompt(Prompt prompt) {
    final textToShare =
        'Check out this prompt from the Aivellum app:\n\nTitle: ${prompt.title}\n\n${prompt.content}';
    Share.share(textToShare, subject: prompt.title);
  }

  void _showPurchaseDialog(BuildContext context, WidgetRef ref, Prompt prompt) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Premium Prompt'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('This prompt is part of our premium collection.'),
            const SizedBox(height: 16),
            Text(
              prompt.title,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              prompt.description,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.go('/purchase/lifetime');
            },
            child: const Text('Unlock All'),
          ),
        ],
      ),
    );
  }
}