import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../models/subject_detail.dart';

class FinalGradeCard extends StatelessWidget {
  final SubjectDetail data;

  const FinalGradeCard({
    required this.data,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE0E4F0), width: 1),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.star_rounded, size: 20, color: Color(0xFFE3993C)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  "Final exam",
                  style: GoogleFonts.redditSans(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: const Color(0xFF1F1F1F),
                  ),
                ),
              ),
              Text(
                data.finalScheduled ? "score" : "Not Yet",
                style: GoogleFonts.redditSans(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: data.finalScheduled
                      ? const Color(0xFF1F1F1F)
                      : const Color(0x80838A97),
                ),
              ),
              if (data.finalScheduled) ...[
                const SizedBox(width: 4),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "${data.finalScore}",
                        style: GoogleFonts.redditSans(
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                          color: const Color(0xFF1F1F1F),
                        ),
                      ),
                      TextSpan(
                        text: "/${data.finalMax}",
                        style: GoogleFonts.redditSans(
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                          color: const Color(0x80838A97),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
          if (!data.finalScheduled) ...[
            const SizedBox(height: 8),
            Text(
              data.finalNote,
              style: GoogleFonts.redditSans(
                fontWeight: FontWeight.w700,
                fontSize: 10,
                color: const Color(0x80838A97),
              ),
            ),
          ],
          if (data.finalScheduled) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF0569FF),
                    Color(0xCC0569FF),
                    Color(0xFF035CE1),
                  ],
                  stops: [0.0, 0.5, 1.0],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.grid_view_rounded,
                          size: 18, color: Color(0xFFF8F9FC)),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Open in Unec Cabinet",
                            style: GoogleFonts.redditSans(
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                              color: const Color(0xFFF8F9FC),
                            ),
                          ),
                          Text(
                            "See your results in Unec Cabinet",
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
                  const Icon(Icons.arrow_outward_rounded,
                      size: 18, color: Color(0xFFF8F9FC)),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
