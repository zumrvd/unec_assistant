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
                  color: data.finalScheduled ? const Color(0xFF1F1F1F) : const Color(0x80838A97),
                ),
              ),
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
        ],
      ),
    );
  }
}
