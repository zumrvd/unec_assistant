import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:unec_assistant/providers/theme_provider.dart';
import 'package:unec_assistant/providers/locale_provider.dart';
import 'package:unec_assistant/providers/time_provider.dart';
import '../../../models/subject_detail.dart';
import '../../../providers/subject_detail_provider.dart';

enum GradeType { seminar, midterm, finalGrade }

class GradeEvent {
  final String title;
  final String dateStr;
  final DateTime date;
  final int score;
  final int max;
  final GradeType type;
  final SubjectDetail subject;

  GradeEvent({
    required this.title,
    required this.dateStr,
    required this.date,
    required this.score,
    required this.max,
    required this.type,
    required this.subject,
  });
}

class RecentGradeCard extends ConsumerWidget {
  const RecentGradeCard({super.key});

  DateTime? _parseDate(String dateStr, DateTime now) {
    if (dateStr.isEmpty) return null;
    try {
      if (dateStr.contains(',')) {
        return DateFormat('MMM d, yyyy').parse(dateStr);
      } else {
        return DateFormat('MMMM d').parse(dateStr).copyWith(year: now.year);
      }
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = ref.watch(nowProvider);
    final subjects = ref.watch(allSubjectsProvider);
    final appColors = ref.watch(appColorsProvider);
    final tr = ref.watch(strProvider);

    final List<GradeEvent> allEvents = [];

    for (final s in subjects) {
      // 1. Seminars
      for (final e in s.seminarEntries) {
        final parsed = _parseDate(e.date, now);
        if (parsed != null) {
          allEvents.add(
            GradeEvent(
              title: e.title,
              dateStr: e.date,
              date: parsed,
              score: e.score,
              max: e.maxScore,
              type: GradeType.seminar,
              subject: s,
            ),
          );
        }
      }

      // 2. Midterm
      if (s.midtermScore > 0) {
        final parsed = _parseDate(s.midtermDate, now);
        if (parsed != null) {
          allEvents.add(
            GradeEvent(
              title: tr.gradeMidtermExam,
              dateStr: s.midtermDate,
              date: parsed,
              score: s.midtermScore,
              max: 30,
              type: GradeType.midterm,
              subject: s,
            ),
          );
        }
      }

      // 3. Final
      if (s.finalScore > 0) {
        final parsed = _parseDate(s.finalExamDate, now);
        if (parsed != null) {
          allEvents.add(
            GradeEvent(
              title: tr.gradeFinalExam,
              dateStr: s.finalExamDate,
              date: parsed,
              score: s.finalScore,
              max: 50,
              type: GradeType.finalGrade,
              subject: s,
            ),
          );
        }
      }
    }

    if (allEvents.isEmpty) {
      return const SizedBox.shrink();
    }

    // Sort descending by date
    allEvents.sort((a, b) => b.date.compareTo(a.date));

    final latest = allEvents.first;
    final subject = latest.subject;

    String typeLabel;
    switch (latest.type) {
      case GradeType.seminar:
        typeLabel = tr.gradeSeminarLabel;
        break;
      case GradeType.midterm:
        typeLabel = tr.gradeMidtermLabel;
        break;
      case GradeType.finalGrade:
        typeLabel = tr.gradeFinalLabel;
        break;
    }

    final String semanticLabel =
        'Recent Grade: $typeLabel for ${subject.subjectName}, ${latest.title}, score ${latest.score} out of ${latest.max} on ${latest.dateStr}';

    return Column(
      children: [
        const SizedBox(height: 10),
        Semantics(
          container: true,
          button: true,
          label: semanticLabel,
          child: GestureDetector(
            onTap: () =>
                context.go('/functions/grades/subject/${subject.subjectId}'),
            behavior: HitTestBehavior.opaque,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: appColors.cardBackground,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: appColors.borderColor, width: 1),
              ),
              child: ExcludeSemantics(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Headline (Grade Category)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: subject.iconColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        typeLabel,
                        style: GoogleFonts.redditSans(
                          fontWeight: FontWeight.w700,
                          fontSize: 9,
                          color: subject.iconColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Full Subject Name
                    Row(
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: subject.iconColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            subject.subjectName,
                            style: GoogleFonts.redditSans(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              color: subject.iconColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Specific Task Title
                    Text(
                      latest.title,
                      style: GoogleFonts.redditSans(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: appColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Info Box
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 15,
                      ),
                      decoration: BoxDecoration(
                        color: appColors.surface,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: appColors.borderColor,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${latest.score}',
                                style: GoogleFonts.redditSans(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 32,
                                  color: appColors.textPrimary,
                                  height: 1.1,
                                ),
                              ),
                              Text(
                                '/ ${latest.max}',
                                style: GoogleFonts.redditSans(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12,
                                  color: appColors.textSecondary,
                                  height: 1.1,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 15),
                          Container(
                            width: 1,
                            height: 40,
                            color: appColors.divider,
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  tr.gradeDateReceived,
                                  style: GoogleFonts.redditSans(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 11,
                                    color: appColors.textSecondary,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  tr.localizeDateString(latest.dateStr),
                                  style: GoogleFonts.redditSans(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                    color: appColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.stars_rounded,
                            color: subject.iconColor,
                            size: 24,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
