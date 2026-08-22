import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unec_assistant/providers/theme_provider.dart';
import 'package:unec_assistant/providers/locale_provider.dart';
import '../../../providers/subject_detail_provider.dart';

class AttendanceCard extends ConsumerWidget {
  const AttendanceCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final attentionSubjects = ref.watch(attentionSubjectsProvider);
    final appColors = ref.watch(appColorsProvider);
    final tr = ref.watch(strProvider);

    if (attentionSubjects.isEmpty) {
      return const SizedBox.shrink();
    }

    // Sort by most urgent (highest ratio of used/limit)
    final sortedSubjects = [...attentionSubjects];
    sortedSubjects.sort((a, b) {
      final ratioA = a.absencesUsed / a.absenceLimit;
      final ratioB = b.absencesUsed / b.absenceLimit;
      return ratioB.compareTo(ratioA);
    });

    final subject = sortedSubjects.first;

    final int absencesLeft = subject.absenceLimit - subject.absencesUsed;
    final double usedRatio = subject.absencesUsed / subject.absenceLimit;
    final bool isSafe = usedRatio < 0.5;
    final bool isDanger = subject.absencesUsed >= subject.absenceLimit;
    final bool isCaution = !isSafe && !isDanger;

    final Color dotColor = isDanger
        ? appColors.error
        : isCaution
        ? appColors.warning
        : appColors.primary;

    final Color borderColor = isDanger
        ? appColors.error.withValues(alpha: 0.5)
        : isCaution
        ? appColors.warning.withValues(alpha: 0.5)
        : appColors.borderColor;

    final Color pillBg = isDanger
        ? appColors.error.withValues(alpha: 0.15)
        : isCaution
        ? appColors.warning.withValues(alpha: 0.15)
        : appColors.success.withValues(alpha: 0.15);

    final Color pillTextColor = isDanger
        ? appColors.error
        : isCaution
        ? appColors.warning
        : appColors.success;

    final Color barColor = isDanger
        ? appColors.error
        : isCaution
        ? appColors.warning
        : appColors.success;

    final String pillLabel = tr.attendanceLeftPill(absencesLeft);

    final String absencesLeftLabel = isDanger
        ? tr.attendanceNoLeft
        : tr.attendanceAbsencesLeft(absencesLeft);

    return Column(
      children: [
        const SizedBox(height: 10),
        GestureDetector(
          onTap: () => context.go('/functions/attendance_function'),
          behavior: HitTestBehavior.opaque,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: appColors.cardBackground,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: borderColor, width: 1),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header (Subject Name + Pill)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: dotColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              subject.subjectName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.redditSans(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                                color: appColors.textPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: pillBg,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        pillLabel,
                        style: GoogleFonts.redditSans(
                          fontWeight: FontWeight.w700,
                          fontSize: 10,
                          color: pillTextColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Info Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                  decoration: BoxDecoration(
                    color: appColors.surface,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: appColors.borderColor, width: 1),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${subject.absencesUsed}',
                            style: GoogleFonts.redditSans(
                              fontWeight: FontWeight.w700,
                              fontSize: 36,
                              color: appColors.textPrimary,
                              height: 1.1,
                            ),
                          ),
                          Text(
                            tr.attendanceUsed,
                            style: GoogleFonts.redditSans(
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                              color: appColors.textSecondary,
                              height: 1.1,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 15),
                      Container(width: 1, height: 40, color: appColors.divider),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              tr.attendanceLimit(subject.absenceLimit),
                              style: GoogleFonts.redditSans(
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                                color: appColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              absencesLeftLabel,
                              style: GoogleFonts.redditSans(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                                color: appColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 5,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: LinearProgressIndicator(
                                  value: usedRatio.clamp(0.0, 1.0),
                                  minHeight: 6,
                                  backgroundColor: appColors.borderColor,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    barColor,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
