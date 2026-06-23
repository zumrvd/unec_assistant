import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FeedFilterButtons extends StatefulWidget {
  const FeedFilterButtons({super.key});

  @override
  State<FeedFilterButtons> createState() => _FeedFilterButtonsState();
}

class _FeedFilterButtonsState extends State<FeedFilterButtons> {
  bool isDiscoverSelected = true;
  final Map<String, bool> otherFilters = {
    'Subscribed': false,
    'Official': false,
    'Clubs': false,
    'Dev Team': false,
  };

  void _onDiscoverTap() {
    setState(() {
      isDiscoverSelected = true;
      otherFilters.updateAll((key, value) => false);
    });
  }

  void _onOtherFilterTap(String label) {
    setState(() {
      otherFilters[label] = !otherFilters[label]!;
      
      if (otherFilters.values.any((selected) => selected)) {
        isDiscoverSelected = false;
      } else {
        isDiscoverSelected = true;
      }
    });
  }

  Widget _buildFilterButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    bool hasCheckbox = true,
  }) {
    final bool isDiscoverMode = label == 'Discover';
    final Color bgColor = (isDiscoverMode && isSelected) ? const Color(0xFF0569FF) : Colors.white;
    final Color textColor = (isDiscoverMode && isSelected) ? Colors.white : const Color(0xFF838A97);
    final Color borderColor = const Color(0xFFE0E4F0);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(7),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: GoogleFonts.redditSans(
                fontWeight: FontWeight.bold,
                fontSize: 11,
                color: textColor,
              ),
            ),
            if (hasCheckbox) ...[
              const SizedBox(width: 6),
              Icon(
                isSelected ? Icons.check_box : Icons.check_box_outline_blank,
                size: 14,
                color: textColor,
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
          _buildFilterButton(
            label: 'Discover',
            isSelected: isDiscoverSelected,
            onTap: _onDiscoverTap,
            hasCheckbox: false,
          ),
          const SizedBox(width: 8),
          ...otherFilters.entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: _buildFilterButton(
                label: entry.key,
                isSelected: entry.value,
                onTap: () => _onOtherFilterTap(entry.key),
              ),
            );
          }),
        ],
      ),
    );
  }
}
