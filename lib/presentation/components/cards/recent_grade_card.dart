import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
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

  static const _borderColor = Color(0xFFE0E4F0);
  static const _labelGrey = Color(0xFF838A97);
  static const _valueBlack = Color(0xFF1F1F1F);

  DateTime? _parseDate(String dateStr) {
    if (dateStr.isEmpty) return null;
    try {
      if (dateStr.contains(',')) {
        return DateFormat('MMM d, yyyy').parse(dateStr);
      } else {
        final now = DateTime.now();
        return DateFormat('MMMM d').parse(dateStr).copyWith(year: now.year);
      }
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subjects = ref.watch(allSubjectsProvider);

    final List<GradeEvent> allEvents = [];

    for (final s in subjects) {
      // 1. Seminars
      for (final e in s.seminarEntries) {
        final date = _parseDate(e.date);
        if (date != null) {
          allEvents.add(
            GradeEvent(
              title: e.title,
              dateStr: e.date,
              date: date,
              score: e.score,
              max: 10,
              type: GradeType.seminar,
              subject: s,
            ),
          );
        }
      }

      // 2. Midterm
      if (s.midtermScore > 0) {
        final date = _parseDate(s.midtermDate);
        if (date != null) {
          allEvents.add(
            GradeEvent(
              title: 'Midterm Exam',
              dateStr: s.midtermDate,
              date: date,
              score: s.midtermScore,
              max: s.midtermMax,
              type: GradeType.midterm,
              subject: s,
            ),
          );
        }
      }

      // 3. Final
      if (s.finalScore > 0) {
        final date = _parseDate(s.endDate);
        if (date != null) {
          allEvents.add(
            GradeEvent(
              title: 'Final Exam',
              dateStr: s.endDate,
              date: date,
              score: s.finalScore,
              max: s.finalMax,
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

    // Sort by date descending
    allEvents.sort((a, b) => b.date.compareTo(a.date));

    final latest = allEvents.first;
    final subject = latest.subject;

    String typeLabel = 'RECENT GRADE';
    if (latest.type == GradeType.midterm) typeLabel = 'MIDTERM RESULT';
    if (latest.type == GradeType.finalGrade) typeLabel = 'FINAL RESULT';

    final String semanticLabel =
        'Recent Grade in ${subject.subjectName}: ${latest.title}, Score ${latest.score} out of ${latest.max}';

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
              width: 330,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: _borderColor, width: 1),
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
                        color: _valueBlack,
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
                        color: const Color(0xFFF8F9FC),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: _borderColor, width: 1),
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
                                  color: const Color(0xFF1F1F1F),
                                  height: 1.1,
                                ),
                              ),
                              Text(
                                '/ ${latest.max}',
                                style: GoogleFonts.redditSans(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12,
                                  color: _labelGrey,
                                  height: 1.1,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 15),
                          Container(width: 1, height: 40, color: _borderColor),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Date received',
                                  style: GoogleFonts.redditSans(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 11,
                                    color: _labelGrey,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  latest.dateStr,
                                  style: GoogleFonts.redditSans(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                    color: _valueBlack,
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
