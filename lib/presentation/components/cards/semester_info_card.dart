import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../models/subject_detail.dart';

class SemesterInfoCard extends StatelessWidget {
  final SubjectDetail data;

  const SemesterInfoCard({
    required this.data,
    super.key,
  });

  Widget _infoRow(IconData icon, Color iconColor, Color iconBg, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                size: 20,
                color: iconColor,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.redditSans(
                fontWeight: FontWeight.w700,
                fontSize: 15,
                color: const Color(0xFF838A97),
              ),
            ),
          ],
        ),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.redditSans(
              fontWeight: FontWeight.w700,
              fontSize: 17,
              color: const Color(0xFF1F1F1F),
            ),
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
            fontSize: 15,
            color: const Color(0xFF1F1F1F),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
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
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.semesterLabel,
                  style: GoogleFonts.redditSans(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: const Color(0x80838A97),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  data.semesterType,
                  style: GoogleFonts.redditSans(
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                    color: const Color(0xFF0569FF),
                  ),
                ),
                const SizedBox(height: 16),
                _infoRow(Icons.play_circle_rounded, const Color(0xFF0F6E11), const Color(0x260F6E11), "Starting in", data.startDate),
                const SizedBox(height: 15),
                _infoRow(Icons.stop_circle_rounded, const Color(0xFFDA4979), const Color(0x26DA4979), "Ending in", data.endDate),
                const SizedBox(height: 15),
                _infoRow(Icons.diamond_rounded, const Color(0xFFE3993C), const Color(0x26E3993C), "Total Credits", "${data.totalCredits}"),
                const SizedBox(height: 15),
                _infoRow(Icons.book_rounded, const Color(0xFF0569FF), const Color(0x260569FF), "Total Subjects", "${data.totalSubjects}"),
                const SizedBox(height: 15),
                _infoRow(Icons.timelapse_rounded, const Color(0xFF534AB7), const Color(0x26534AB7), "Total Hours", "${data.totalHours}"),
                const SizedBox(height: 15),
                _infoRow(Icons.access_time_filled_rounded, const Color(0xFF993C1D), const Color(0x26993C1D), "Auditorium Hours", "${data.auditoriumHours}"),
              ],
            ),
          ),
          const Divider(
            color: Color(0xFFE0E4F0),
            thickness: 1,
            height: 1,
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
            padding: const EdgeInsets.only(left: 50, top: 16, bottom: 16, right: 20),
            child: Column(
              children: [
                _breakdownRow("Lectures", "${data.lectureHours}"),
                const SizedBox(height: 8),
                _breakdownRow("Seminars", "${data.seminarHours}"),
                const SizedBox(height: 8),
                _breakdownRow("Laboratories", "${data.labHours}"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
