import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unec_assistant/presentation/providers/theme_provider.dart';
import 'package:unec_assistant/presentation/theme/app_colors.dart';
import '../../../models/post.dart';

class FeedFilterTabs extends ConsumerWidget {
  final Set<PostFeedType> selectedFilters;
  final ValueChanged<PostFeedType?> onSelect;

  const FeedFilterTabs({
    required this.selectedFilters,
    required this.onSelect,
    super.key,
  });

  Widget _buildPill({
    required String label,
    required PostFeedType? type,
    required AppColors appColors,
    bool showCheckbox = true,
  }) {
    final isSelected = type == null ? selectedFilters.isEmpty : selectedFilters.contains(type);

    return GestureDetector(
      onTap: () => onSelect(type),
      behavior: HitTestBehavior.opaque,
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? appColors.primary : appColors.cardBackground,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? appColors.primary : appColors.borderColor,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: GoogleFonts.redditSans(
                fontWeight: FontWeight.w700,
                fontSize: 12,
                color: isSelected ? Colors.white : appColors.textSecondary,
              ),
            ),
            if (showCheckbox) ...[
              const SizedBox(width: 6),
              Icon(
                isSelected ? Icons.check_box_rounded : Icons.check_box_outline_blank_rounded,
                size: 16,
                color: isSelected ? Colors.white : appColors.textSecondary,
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appColors = ref.watch(appColorsProvider);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildPill(label: 'Discover', type: null, appColors: appColors, showCheckbox: false),
          _buildPill(label: 'Subscribed', type: PostFeedType.subscribed, appColors: appColors),
          _buildPill(label: 'Official', type: PostFeedType.official, appColors: appColors),
          _buildPill(label: 'Clubs', type: PostFeedType.clubs, appColors: appColors),
          _buildPill(label: 'Dev Team', type: PostFeedType.devTeam, appColors: appColors),
        ],
      ),
    );
  }
}

