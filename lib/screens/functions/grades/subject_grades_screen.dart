import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../models/subject_detail.dart';
import '../../../presentation/components/cards/subject_grade_header_card.dart';
import '../../../presentation/components/cards/midterm_grade_card.dart';
import '../../../presentation/components/cards/seminar_grades_card.dart';
import '../../../presentation/components/cards/final_grade_card.dart';

class SubjectGradesScreen extends StatelessWidget {
  final SubjectDetail data;

  const SubjectGradesScreen({
    required this.data,
    super.key,
  });

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
                          data.subjectName,
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
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 16),
        child: Column(
          children: [
            SubjectGradeHeaderCard(data: data),
            const SizedBox(height: 12),
            MidtermGradeCard(data: data),
            const SizedBox(height: 12),
            SeminarGradesCard(data: data),
            const SizedBox(height: 12),
            FinalGradeCard(data: data),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
