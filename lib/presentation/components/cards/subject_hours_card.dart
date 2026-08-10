import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../models/subject_detail.dart';

class SubjectHoursCard extends StatelessWidget {
  final SubjectDetail data;

  const SubjectHoursCard({
    required this.data,
    super.key,
  });

  Widget _hoursRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.redditSans(
            fontWeight: FontWeight.w700,
            fontSize: 13,
            color: const Color(0xFF838A97),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.redditSans(
            fontWeight: FontWeight.w700,
            fontSize: 16,
            color: const Color(0xFF1F1F1F),
          ),
        ),
      ],
    );
  }

  Widget _breakdownRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Icon(
              Icons.subdirectory_arrow_right_rounded,
              size: 20,
              color: Color(0xFFE0E4F0),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.redditSans(
                fontWeight: FontWeight.w700,
                fontSize: 13,
                color: const Color(0xFF838A97),
              ),
            ),
          ],
        ),
        Text(
          value,
          style: GoogleFonts.redditSans(
            fontWeight: FontWeight.w700,
            fontSize: 16,
            color: const Color(0xFF1F1F1F),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    const iconColor = Color(0xFF534AB7);
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
        crossAxisAlignment: CrossAxisAlignment.start,
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
                  child: const Icon(
                    Icons.access_time_filled_rounded,
                    size: 18,
                    color: iconColor,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  "HOURS",
                  style: GoogleFonts.redditSans(
                    fontWeight: FontWeight.w700,
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: _hoursRow("Total Hours", "${data.subjectTotalHours}hrs"),
          ),
          const Divider(color: Color(0xFFE0E4F0), thickness: 1, height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: _hoursRow("Auditorium Hours", "${data.subjectAuditoriumHours}hrs"),
          ),
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFFF8F9FC),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(18),
                bottomRight: Radius.circular(18),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(color: Color(0xFFE0E4F0), thickness: 1, height: 1),
                Padding(
                  padding: const EdgeInsets.only(left: 30, top: 16, right: 30),
                  child: Text(
                    "BREAKDOWN",
                    style: GoogleFonts.redditSans(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      color: const Color(0x80838A97),
                    )
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 6),
                  child: _breakdownRow("Lectures", "${data.subjectLectureHours}hrs"),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 6),
                  child: _breakdownRow("Seminars", "${data.subjectSeminarHours}hrs"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
