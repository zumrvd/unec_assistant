import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:unec_assistant/presentation/components/buttons/subjects/subject_button.dart';
import 'package:unec_assistant/presentation/providers/theme_provider.dart';

import '../../../presentation/components/buttons/subjects/download_curriculum_button.dart';
import '../../../presentation/components/cards/semester_info_card.dart';
import '../../../providers/subject_detail_provider.dart';

import 'package:unec_assistant/presentation/components/lists/labels.dart';

class SubjectsScreen extends ConsumerWidget {
  const SubjectsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allSubjects = ref.watch(allSubjectsProvider);
    final progDetail = allSubjects.firstWhere((s) => s.subjectId == '1');
    final appColors = ref.watch(appColorsProvider);

    return Scaffold(
      backgroundColor: appColors.background,
      appBar: const CustomAppBar(title: 'Subjects'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10,
          children: [
            SemesterInfoCard(data: progDetail),
            DownloadCurriculumButton(onTap: () {}),
            SectionLabel('All subjects  ${allSubjects.length}'),
            ...allSubjects.map((subject) => SubjectButton(
              subject: subject,
              onTap: () => context.push('/functions/subjects/${subject.subjectId}'),
            )),
          ],
        ),
      ),
    );
  }
}

