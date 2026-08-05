import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../../models/subject_detail.dart';
import '../../../../presentation/components/cards/subject_grade_header_card.dart';
import '../../../../presentation/components/cards/midterm_grade_card.dart';
import '../../../../presentation/components/cards/seminar_grades_card.dart';
import '../../../../presentation/components/cards/final_grade_card.dart';

import '../../../../presentation/components/lists/labels.dart';

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
      appBar: CustomAppBar(title: data.subjectName),
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
