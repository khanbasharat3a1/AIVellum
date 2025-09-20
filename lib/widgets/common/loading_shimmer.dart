import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../config/app_config.dart';

class LoadingShimmer extends StatelessWidget {
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;

  const LoadingShimmer({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Shimmer.fromColors(
      baseColor: theme.brightness == Brightness.light
          ? Colors.grey[300]!
          : Colors.grey[700]!,
      highlightColor: theme.brightness == Brightness.light
          ? Colors.grey[100]!
          : Colors.grey[500]!,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: borderRadius ?? BorderRadius.circular(4),
        ),
      ),
    );
  }
}

// Category cards shimmer
class CategoryShimmer extends StatelessWidget {
  final int itemCount;

  const CategoryShimmer({
    super.key,
    this.itemCount = 6,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.4,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) => const CategoryCardShimmer(),
    );
  }
}

class CategoryCardShimmer extends StatelessWidget {
  const CategoryCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon shimmer
            LoadingShimmer(
              width: 40,
              height: 40,
              borderRadius: BorderRadius.circular(12),
            ),
            
            const Spacer(),
            
            // Title shimmer
            const LoadingShimmer(
              width: double.infinity,
              height: 16,
            ),
            
            const SizedBox(height: 4),
            
            // Description shimmer
            LoadingShimmer(
              width: MediaQuery.of(context).size.width * 0.6,
              height: 12,
            ),
            
            const SizedBox(height: 12),
            
            // Stats shimmer
            Row(
              children: [
                LoadingShimmer(
                  width: 40,
                  height: 20,
                  borderRadius: BorderRadius.circular(10),
                ),
                const SizedBox(width: 6),
                LoadingShimmer(
                  width: 30,
                  height: 20,
                  borderRadius: BorderRadius.circular(10),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Prompt cards shimmer
class PromptShimmer extends StatelessWidget {
  final int itemCount;

  const PromptShimmer({
    super.key,
    this.itemCount = 5,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        itemCount,
        (index) => const Padding(
          padding: EdgeInsets.only(bottom: 12),
          child: PromptCardShimmer(),
        ),
      ),
    );
  }
}

class PromptCardShimmer extends StatelessWidget {
  const PromptCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row
            Row(
              children: [
                LoadingShimmer(
                  width: 60,
                  height: 20,
                  borderRadius: BorderRadius.circular(10),
                ),
                const Spacer(),
                LoadingShimmer(
                  width: 20,
                  height: 20,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Title
            const LoadingShimmer(
              width: double.infinity,
              height: 20,
            ),
            
            const SizedBox(height: 8),
            
            // Description lines
            const LoadingShimmer(
              width: double.infinity,
              height: 16,
            ),
            
            const SizedBox(height: 4),
            
            LoadingShimmer(
              width: MediaQuery.of(context).size.width * 0.7,
              height: 16,
            ),
            
            const SizedBox(height: 12),
            
            // Footer
            Row(
              children: [
                LoadingShimmer(
                  width: 80,
                  height: 14,
                  borderRadius: BorderRadius.circular(4),
                ),
                const SizedBox(width: 16),
                LoadingShimmer(
                  width: 40,
                  height: 14,
                  borderRadius: BorderRadius.circular(4),
                ),
                const Spacer(),
                LoadingShimmer(
                  width: 16,
                  height: 16,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// List shimmer for general use
class ListShimmer extends StatelessWidget {
  final int itemCount;
  final double itemHeight;
  final EdgeInsets? padding;

  const ListShimmer({
    super.key,
    this.itemCount = 5,
    this.itemHeight = 80,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Column(
        children: List.generate(
          itemCount,
          (index) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: ListTileShimmer(height: itemHeight),
          ),
        ),
      ),
    );
  }
}

class ListTileShimmer extends StatelessWidget {
  final double height;

  const ListTileShimmer({
    super.key,
    this.height = 80,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Container(
        height: height,
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Leading shimmer
            LoadingShimmer(
              width: 48,
              height: 48,
              borderRadius: BorderRadius.circular(8),
            ),
            
            const SizedBox(width: 16),
            
            // Content shimmer
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const LoadingShimmer(
                    width: double.infinity,
                    height: 16,
                  ),
                  const SizedBox(height: 8),
                  LoadingShimmer(
                    width: MediaQuery.of(context).size.width * 0.6,
                    height: 14,
                  ),
                ],
              ),
            ),
            
            const SizedBox(width: 16),
            
            // Trailing shimmer
            LoadingShimmer(
              width: 16,
              height: 16,
              borderRadius: BorderRadius.circular(4),
            ),
          ],
        ),
      ),
    );
  }
}

// Stats shimmer
class StatsShimmer extends StatelessWidget {
  final int itemCount;

  const StatsShimmer({
    super.key,
    this.itemCount = 3,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        itemCount,
        (index) => Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right: index < itemCount - 1 ? 12 : 0,
            ),
            child: const StatsCardShimmer(),
          ),
        ),
      ),
    );
  }
}

class StatsCardShimmer extends StatelessWidget {
  const StatsCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Icon shimmer
            LoadingShimmer(
              width: 40,
              height: 40,
              borderRadius: BorderRadius.circular(12),
            ),
            
            const SizedBox(height: 16),
            
            // Value shimmer
            LoadingShimmer(
              width: 40,
              height: 24,
              borderRadius: BorderRadius.circular(4),
            ),
            
            const SizedBox(height: 8),
            
            // Title shimmer
            LoadingShimmer(
              width: 60,
              height: 16,
              borderRadius: BorderRadius.circular(4),
            ),
          ],
        ),
      ),
    );
  }
}

// Text shimmer for different sizes
class TextShimmer extends StatelessWidget {
  final double width;
  final double height;
  final int lines;

  const TextShimmer({
    super.key,
    this.width = double.infinity,
    this.height = 16,
    this.lines = 1,
  });

  @override
  Widget build(BuildContext context) {
    if (lines == 1) {
      return LoadingShimmer(
        width: width == double.infinity ? null : width,
        height: height,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(
        lines,
        (index) => Padding(
          padding: EdgeInsets.only(bottom: index < lines - 1 ? 4 : 0),
          child: LoadingShimmer(
            width: index == lines - 1 
                ? (width == double.infinity ? MediaQuery.of(context).size.width * 0.7 : width * 0.7)
                : (width == double.infinity ? null : width),
            height: height,
          ),
        ),
      ),
    );
  }
}

// Profile shimmer
class ProfileShimmer extends StatelessWidget {
  const ProfileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Avatar shimmer
          LoadingShimmer(
            width: 80,
            height: 80,
            borderRadius: BorderRadius.circular(40),
          ),
          
          const SizedBox(height: 16),
          
          // Name shimmer
          LoadingShimmer(
            width: 120,
            height: 18,
            borderRadius: BorderRadius.circular(4),
          ),
          
          const SizedBox(height: 8),
          
          // Email shimmer
          LoadingShimmer(
            width: 160,
            height: 14,
            borderRadius: BorderRadius.circular(4),
          ),
          
          const SizedBox(height: 24),
          
          // Settings items shimmer
          ...List.generate(
            5,
            (index) => const Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: ListTileShimmer(height: 60),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom shimmer widget for specific use cases
class CustomShimmer extends StatelessWidget {
  final Widget child;
  final bool enabled;
  final Duration period;

  const CustomShimmer({
    super.key,
    required this.child,
    this.enabled = true,
    this.period = const Duration(milliseconds: 1500),
  });

  @override
  Widget build(BuildContext context) {
    if (!enabled) return child;

    final theme = Theme.of(context);
    
    return Shimmer.fromColors(
      baseColor: theme.brightness == Brightness.light
          ? Colors.grey[300]!
          : Colors.grey[700]!,
      highlightColor: theme.brightness == Brightness.light
          ? Colors.grey[100]!
          : Colors.grey[500]!,
      period: period,
      child: child,
    );
  }
}