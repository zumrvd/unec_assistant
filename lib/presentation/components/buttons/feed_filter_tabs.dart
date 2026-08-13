import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../models/post.dart';

class FeedFilterTabs extends StatelessWidget {
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
          color: isSelected ? const Color(0xFF0569FF) : const Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? const Color(0xFF0569FF) : const Color(0xFFE0E4F0),
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
                color: isSelected ? const Color(0xFFFFFFFF) : const Color(0xFF838A97),
              ),
            ),
            if (showCheckbox) ...[
              const SizedBox(width: 6),
              Icon(
                isSelected ? Icons.check_box_rounded : Icons.check_box_outline_blank_rounded,
                size: 16,
                color: isSelected ? const Color(0xFFFFFFFF) : const Color(0xFF838A97),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildPill(label: 'Discover', type: null, showCheckbox: false),
          _buildPill(label: 'Subscribed', type: PostFeedType.subscribed),
          _buildPill(label: 'Official', type: PostFeedType.official),
          _buildPill(label: 'Clubs', type: PostFeedType.clubs),
          _buildPill(label: 'Dev Team', type: PostFeedType.devTeam),
        ],
      ),
    );
  }
}
