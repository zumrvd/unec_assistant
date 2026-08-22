import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unec_assistant/providers/theme_provider.dart';
import 'skeleton_box.dart';

class PostSkeleton extends ConsumerWidget {
  const PostSkeleton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appColors = ref.watch(appColorsProvider);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: appColors.cardBackground,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: appColors.borderColor, width: 1),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              const SkeletonBox(
                width: 40,
                height: 40,
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SkeletonBox(width: 120, height: 14),
                    const SizedBox(height: 6),
                    const SkeletonBox(width: 80, height: 10),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Image Placeholder
          const SkeletonBox(
            width: double.infinity,
            height: 160,
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          const SizedBox(height: 12),

          // Body Text
          const SkeletonBox(width: double.infinity, height: 12),
          const SizedBox(height: 8),
          const SkeletonBox(width: 200, height: 12),
          const SizedBox(height: 15),

          // Action Row
          Row(
            children: [
              const SkeletonBox(width: 40, height: 16),
              const SizedBox(width: 15),
              const SkeletonBox(width: 40, height: 16),
              const Spacer(),
              const SkeletonBox(width: 20, height: 20),
            ],
          ),
        ],
      ),
    );
  }
}
