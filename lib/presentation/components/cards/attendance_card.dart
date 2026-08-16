import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../providers/subject_detail_provider.dart';

class AttendanceCard extends ConsumerWidget {
  const AttendanceCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final attentionSubjects = ref.watch(attentionSubjectsProvider);

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
        ? const Color(0xFFD54829)
        : isCaution
            ? const Color(0xFFE3993C)
            : const Color(0xFF0569FF);

    final Color borderColor = isDanger
        ? const Color(0x80D54829)
        : isCaution
            ? const Color(0x80E3993C)
            : const Color(0xFFE0E4F0);

    final Color pillBg = isDanger
        ? const Color(0x26D54829)
        : isCaution
            ? const Color(0x26E3993C)
            : const Color(0x260F6E11);

    final Color pillTextColor = isDanger
        ? const Color(0xFFD54829)
        : isCaution
            ? const Color(0xFF985909)
            : const Color(0xFF0F6E11);

    final Color barColor = isDanger
        ? const Color(0xFFD54829)
        : isCaution
            ? const Color(0xFFE3993C)
            : const Color(0xFF0F6E11);

    final String pillLabel = '$absencesLeft Left';

    final String absencesLeftLabel = isDanger
        ? 'no absence left'
        : '$absencesLeft absences left';

    return Column(
      children: [
        const SizedBox(height: 10),
        GestureDetector(
          onTap: () => context.go('/functions/attendance_function'),
          behavior: HitTestBehavior.opaque,
          child: Container(
            width: 330,
            decoration: BoxDecoration(
              color: Colors.white,
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
                                color: const Color(0xFF1F1F1F),
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
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F9FC),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: const Color(0xFFE0E4F0), width: 1),
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
                              color: const Color(0xFF1F1F1F),
                              height: 1.1,
                            ),
                          ),
                          Text(
                            'used',
                            style: GoogleFonts.redditSans(
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                              color: const Color(0xFF838A97),
                              height: 1.1,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 15),
                      Container(width: 1, height: 40, color: const Color(0xFFE0E4F0)),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Limit : ${subject.absenceLimit}',
                              style: GoogleFonts.redditSans(
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                                color: const Color(0xFF838A97),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              absencesLeftLabel,
                              style: GoogleFonts.redditSans(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                                color: const Color(0xFF1F1F1F),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 5),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: LinearProgressIndicator(
                                  value: usedRatio.clamp(0.0, 1.0),
                                  minHeight: 6,
                                  backgroundColor: const Color(0xFFE0E4F0),
                                  valueColor: AlwaysStoppedAnimation<Color>(barColor),
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
