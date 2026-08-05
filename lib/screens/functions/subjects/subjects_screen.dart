import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unec_assistant/presentation/components/buttons/subjects/subject_button.dart';

import '../../../presentation/components/buttons/download_curriculum_button.dart';
import '../../../presentation/components/cards/semester_info_card.dart';
import '../../../providers/subject_detail_provider.dart';

import 'package:unec_assistant/presentation/components/lists/labels.dart';

class SubjectsScreen extends StatelessWidget {
  const SubjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const data = kProgDetail;
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),
      appBar: const CustomAppBar(title: 'Subjects'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SemesterInfoCard(data: data),
            const SizedBox(height: 12),
            DownloadCurriculumButton(onTap: () {}),
            const SizedBox(height: 12),
            Subject1Button(onTap: () => context.push('/functions/subjects/1')),
            const SizedBox(height: 12),
            Subject2Button(onTap: () => context.push('/functions/subjects/2')),
            const SizedBox(height: 12),
            Subject3Button(onTap: () => context.push('/functions/subjects/3')),
            const SizedBox(height: 12),
            Subject4Button(onTap: () => context.push('/functions/subjects/4')),
            const SizedBox(height: 12),
            Subject5Button(onTap: () => context.push('/functions/subjects/5')),
            const SizedBox(height: 12),
            Subject6Button(onTap: () => context.push('/functions/subjects/6')),
          ],
        ),
      ),
    );
  }
}
