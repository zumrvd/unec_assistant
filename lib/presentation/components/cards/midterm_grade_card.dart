import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unec_assistant/providers/theme_provider.dart';
import 'package:unec_assistant/providers/locale_provider.dart';
import '../../../models/subject_detail.dart';

class MidtermGradeCard extends ConsumerWidget {
  final SubjectDetail data;

  const MidtermGradeCard({required this.data, super.key});

  static const _buttonGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0569FF), Color(0xCC0569FF), Color(0xFF035CE1)],
    stops: [0.0, 0.5, 1.0],
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appColors = ref.watch(appColorsProvider);
    final tr = ref.watch(strProvider);

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
          Row(
            children: [
              Icon(
                Icons.star_rounded,
                size: 20,
                color: appColors.attendanceOrange,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  tr.subjectMidtermTitle,
                  style: GoogleFonts.redditSans(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: appColors.textPrimary,
                  ),
                ),
              ),
              Text(
                data.midtermScheduled ? "" : tr.subjectMidtermNotYet,
                style: GoogleFonts.redditSans(
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                  color: data.midtermScheduled
                      ? appColors.textPrimary
                      : appColors.textMuted,
                ),
              ),
              if (data.midtermScheduled) ...[
                const SizedBox(width: 4),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "${data.midtermScore}",
                        style: GoogleFonts.redditSans(
                          fontWeight: FontWeight.w700,
                          fontSize: 25,
                          color: appColors.textPrimary,
                        ),
                      ),
                      TextSpan(
                        text: "/${data.midtermMax}",
                        style: GoogleFonts.redditSans(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          color: appColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
          if (!data.midtermScheduled) ...[
            const SizedBox(height: 8),
            Text(
              tr.gradeMidtermNotScheduled,
              style: GoogleFonts.redditSans(
                fontWeight: FontWeight.w700,
                fontSize: 10,
                color: appColors.textMuted,
              ),
            ),
          ],
          if (data.midtermScheduled && data.midtermExamCode.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              data.midtermExamCode,
              softWrap: true,
              style: GoogleFonts.redditSans(
                fontWeight: FontWeight.w700,
                fontSize: 10,
                color: appColors.textMuted,
              ),
            ),
            const SizedBox(height: 4),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                data.midtermDate,
                style: GoogleFonts.redditSans(
                  fontWeight: FontWeight.w700,
                  fontSize: 10,
                  color: appColors.textSecondary,
                ),
              ),
            ),
          ],
          if (data.midtermScheduled) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: _buttonGradient,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.grid_view_rounded,
                        size: 18,
                        color: Color(0xFFF8F9FC),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tr.subjectMidtermOpen,
                            style: GoogleFonts.redditSans(
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                              color: const Color(0xFFF8F9FC),
                            ),
                          ),
                          Text(
                            tr.subjectMidtermOpenDesc,
                            style: GoogleFonts.redditSans(
                              fontWeight: FontWeight.w700,
                              fontSize: 9,
                              color: const Color(0x80F8F9FC),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Icon(
                    Icons.arrow_outward_rounded,
                    size: 18,
                    color: Color(0xFFF8F9FC),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
