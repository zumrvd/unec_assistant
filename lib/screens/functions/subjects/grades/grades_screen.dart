import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unec_assistant/presentation/providers/theme_provider.dart';
import '../../../../providers/subject_detail_provider.dart';
import '../../../../presentation/components/buttons/grade_calculator_button.dart';
import '../../../../presentation/components/cards/subject_grade_list_item.dart';

import '../../../../presentation/components/lists/labels.dart';

class GradesScreen extends ConsumerWidget {
  const GradesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allSubjects = ref.watch(allSubjectsProvider);
    final appColors = ref.watch(appColorsProvider);

    return Scaffold(
      backgroundColor: appColors.background,
      appBar: const CustomAppBar(title: 'Grades'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10,
          children: [
            GradeCalculatorButton(
              onTap: () => context.push('/functions/grades/calculator'),
              subtitle: 'Select a target grade and see exactly what you need to achieve it.',
            ),
            const SizedBox(height: 16),
            Text(
              'All subjects  ${allSubjects.length}',
              style: GoogleFonts.redditSans(
                fontWeight: FontWeight.w700,
                fontSize: 13,
                color: appColors.textSecondary,
              ),
            ),
            ...allSubjects.map((s) => Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: SubjectGradeListItem(
                data: s,
                onTap: () => context.push('/functions/grades/subject/${s.subjectId}'),
              ),
            )),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

