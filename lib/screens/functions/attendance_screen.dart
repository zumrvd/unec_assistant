import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unec_assistant/presentation/components/cards/subject_attendance_card.dart';

class AttendanceScreen extends StatelessWidget {
  const AttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(85),
        child: Container(
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: Color(0xFFE0E4F0), width: 1),
                bottom: BorderSide(color: Color(0xFFE0E4F0), width: 1),
              ),
            ),
            child: Container(
              height: 70,
              width: double.infinity,
              color: const Color(0xFFF8F9FC),
              padding: const EdgeInsets.symmetric(horizontal: 35.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () => context.pop(),
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: const Color(0x80E0E4F0),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.arrow_back,
                              size: 20,
                              color: Color(0x80838A97),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            'Attendance',
                            style: GoogleFonts.redditSans(
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                              color: const Color(0xFF838A97),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
              ),
            )
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 10.0),
              child: Text(
                'Needs attention',
                style: TextStyle(
                  color: Color(0xFF838A97),
                  fontSize: 15,
                ),
              ),
            ),

            SubjectAttendanceCard(
              subjectName: 'Fizika',
              absencesUsed: 7,
              absenceLimit: 7,
            ),

            const SizedBox(height: 12),

            SubjectAttendanceCard(
              subjectName: 'Xətti cəbr və analitik həndəsə',
              absencesUsed: 4,
              absenceLimit: 7,
            ),

            const SizedBox(height: 12),

            SubjectAttendanceCard(
              subjectName: 'Informasiya texnologiyalarının əsasları',
              absencesUsed: 4,
              absenceLimit: 7,
            ),

            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: Text(
                'All subjects',
                style: TextStyle(
                  color: Color(0xFF838A97),
                  fontSize: 15,
                ),
              ),
            ),

            SubjectAttendanceCard(
              subjectName: 'Programlaşdırmanın əsasları',
              absencesUsed: 2,
              absenceLimit: 7,
            ),

            const SizedBox(height: 12),

            SubjectAttendanceCard(
              subjectName: 'XDIAK - 1',
              absencesUsed: 2,
              absenceLimit: 7,
            ),

            const SizedBox(height: 12),

            SubjectAttendanceCard(
              subjectName: 'ADIAK',
              absencesUsed: 0,
              absenceLimit: 7,
            ),
          ],
        ),
      ),
    );
  }
}
