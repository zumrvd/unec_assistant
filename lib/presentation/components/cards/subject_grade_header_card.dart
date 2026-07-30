import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../models/subject_detail.dart';

class SubjectGradeHeaderCard extends StatelessWidget {
  final SubjectDetail data;

  const SubjectGradeHeaderCard({
    required this.data,
    super.key,
  });

  static const _cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF0569FF),
      Color(0xCC0569FF),
      Color(0xFF035CE1),
    ],
    stops: [0.0, 0.5, 1.0],
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: _cardGradient,
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.subjectCode,
                  style: GoogleFonts.redditSans(
                    fontWeight: FontWeight.w700,
                    fontSize: 8,
                    color: const Color(0x80F8F9FC),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  data.subjectName,
                  softWrap: true,
                  style: GoogleFonts.redditSans(
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                    color: const Color(0xFFF8F9FC),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "${data.currentScore}",
                style: GoogleFonts.redditSans(
                  fontWeight: FontWeight.w700,
                  fontSize: 32,
                  color: const Color(0xFFF8F9FC),
                ),
              ),
              Text(
                "/${data.maxScore}",
                style: GoogleFonts.redditSans(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: const Color(0x80F8F9FC),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
