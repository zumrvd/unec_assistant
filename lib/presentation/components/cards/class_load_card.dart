import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unec_assistant/presentation/providers/theme_provider.dart';
import 'package:unec_assistant/presentation/theme/app_colors.dart';
import '../../../models/subject_detail.dart';

class ClassLoadCard extends ConsumerWidget {
  final SubjectDetail data;

  const ClassLoadCard({
    required this.data,
    super.key,
  });

  Widget _loadBox(String bigText, String smallText, AppColors appColors) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: appColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: appColors.borderColor,
            width: 1,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              bigText,
              style: GoogleFonts.redditSans(
                fontWeight: FontWeight.w700,
                fontSize: 17,
                color: appColors.textPrimary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              smallText,
              textAlign: TextAlign.center,
              style: GoogleFonts.redditSans(
                fontWeight: FontWeight.w700,
                fontSize: 12,
                color: appColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appColors = ref.watch(appColorsProvider);
    final iconColor = const Color(0xFFDA4979);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: appColors.cardBackground,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: appColors.borderColor,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 16, right: 16),
            child: Row(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.pie_chart,
                    size: 18,
                    color: iconColor,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  "CLASS LOAD",
                  style: GoogleFonts.redditSans(
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                    color: iconColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Divider(color: appColors.divider, thickness: 1, height: 1),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _loadBox("${data.sessionsPerWeek}", "sessions/\nweek", appColors),
                const SizedBox(width: 10),
                _loadBox("${data.hrsPerWeek}", "hrs/\nweek", appColors),
                const SizedBox(width: 10),
                _loadBox(data.classDays, "class\ndays", appColors),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

