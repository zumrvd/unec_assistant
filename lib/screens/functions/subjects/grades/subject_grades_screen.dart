import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unec_assistant/providers/theme_provider.dart';
import '../../../../providers/subject_detail_provider.dart';
import '../../../../presentation/components/cards/subject_grade_header_card.dart';
import '../../../../presentation/components/cards/midterm_grade_card.dart';
import '../../../../presentation/components/cards/seminar_grades_card.dart';
import '../../../../presentation/components/cards/final_grade_card.dart';

import '../../../../presentation/components/lists/labels.dart';

class SubjectGradesScreen extends ConsumerWidget {
  /// The subject whose grades to display, resolved from [allSubjectsProvider].
  final String subjectId;

  const SubjectGradesScreen({required this.subjectId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appColors = ref.watch(appColorsProvider);

    // Look up the live subject from the repository-backed provider.
    final subjects = ref.watch(allSubjectsProvider);
    final data = subjects.firstWhere(
      (s) => s.subjectId == subjectId,
      orElse: () => subjects.first,
    );

    return Scaffold(
      backgroundColor: appColors.background,
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
