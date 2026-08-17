import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unec_assistant/presentation/providers/theme_provider.dart';
import 'package:unec_assistant/presentation/theme/app_colors.dart';
import 'package:unec_assistant/providers/current_class_provider.dart';

class CurrentClassCard extends ConsumerWidget {
  const CurrentClassCard({required this.onTap, super.key});

  final VoidCallback onTap;

  static String _roomNumber(String location) {
    final match = RegExp(
      r'Room\s+(\S+)',
      caseSensitive: false,
    ).firstMatch(location);
    if (match != null) return match.group(1)!;
    return location;
  }

  String _nextWhenMessage(NextClassWhen when) {
    switch (when) {
      case NextClassWhen.today:
        return 'Later today';
      case NextClassWhen.tomorrow:
        return 'Tomorrow';
      case NextClassWhen.later:
        return 'Upcoming';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(currentClassProvider);
    final appColors = ref.watch(appColorsProvider);

    if (state.isEmpty) {
      return const SizedBox.shrink();
    }

    final isUpcoming = !state.hasActive && state.hasNext;
    final tracked = isUpcoming ? state.nextClass! : state.activeClass!;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 330,
        decoration: BoxDecoration(
          color: appColors.cardBackground,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: appColors.borderColor, width: 1),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isUpcoming ? 'UP NEXT' : 'CURRENT CLASS',
                      style: GoogleFonts.redditSans(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: appColors.primary,
                      ),
                    ),
                    if (isUpcoming) ...[
                      const SizedBox(height: 4),
                      Text(
                        'No class is currently active',
                        style: GoogleFonts.redditSans(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          color: appColors.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
                if (!isUpcoming)
                  ExcludeSemantics(
                    child: Image.asset(
                      'assets/images/red_dot.gif',
                      width: 28,
                      height: 28,
                      gaplessPlayback: true,
                    ),
                  )
                else
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: appColors.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _nextWhenMessage(state.nextWhen),
                      style: GoogleFonts.redditSans(
                        fontWeight: FontWeight.w700,
                        fontSize: 10,
                        color: appColors.primary,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  'Room',
                  style: GoogleFonts.redditSans(
                    fontWeight: FontWeight.w700,
                    fontSize: 10,
                    color: appColors.textSecondary,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  _roomNumber(tracked.event.location),
                  style: GoogleFonts.redditSans(
                    fontWeight: FontWeight.w700,
                    fontSize: 40,
                    color: appColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _infoRow(
              Icons.book_outlined,
              'Subject',
              tracked.subject.subjectName,
              appColors,
            ),
            const SizedBox(height: 12),
            _infoRow(
              Icons.compare_outlined,
              'Type',
              tracked.event.subtype,
              appColors,
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value, AppColors appColors) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: appColors.primaryContainer,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(icon, size: 16, color: appColors.primary),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: GoogleFonts.redditSans(
            fontWeight: FontWeight.w700,
            fontSize: 10,
            color: appColors.textSecondary,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            softWrap: true,
            style: GoogleFonts.redditSans(
              fontWeight: FontWeight.w700,
              fontSize: 13,
              color: appColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}

