import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../models/subject_detail.dart';

class ClassLoadCard extends StatelessWidget {
  final SubjectDetail data;

  const ClassLoadCard({
    required this.data,
    super.key,
  });

  Widget _loadBox(String bigText, String smallText) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0x4DE0E4F0),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFFE0E4F0),
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
                color: const Color(0xFF1F1F1F),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              smallText,
              textAlign: TextAlign.center,
              style: GoogleFonts.redditSans(
                fontWeight: FontWeight.w700,
                fontSize: 12,
                color: const Color(0xFF838A97),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const iconColor = Color(0xFFDA4979);
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFE0E4F0),
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
                    color: iconColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
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
          const Divider(color: Color(0xFFE0E4F0), thickness: 1, height: 1),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _loadBox("${data.sessionsPerWeek}", "sessions/\nweek"),
                const SizedBox(width: 10),
                _loadBox("${data.hrsPerWeek}", "hrs/\nweek"),
                const SizedBox(width: 10),
                _loadBox(data.classDays, "class\ndays"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
