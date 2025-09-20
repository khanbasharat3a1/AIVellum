// lib/screens/favorites/favorites_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aivellum/providers/app_providers.dart';
import 'package:aivellum/widgets/cards/prompt_card.dart';
import 'package:aivellum/navigation/app_router.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Corrected provider usage
    final favoritePrompts = ref.watch(favoritePromptsProvider.select((value) => value.values.toList()));
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Prompts'),
      ),
      body: favoritePrompts.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.favorite_border, size: 80, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    'No favorites yet!',
                    style: theme.textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add prompts to your favorites to see them here.',
                    style: theme.textTheme.titleMedium,
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: favoritePrompts.length,
              itemBuilder: (context, index) {
                final prompt = favoritePrompts[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: PromptCard(
                    prompt: prompt,
                    onTap: () => context.goToPrompt(prompt.id),
                  ),
                );
              },
            ),
    );
  }
}