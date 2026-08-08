import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../models/subject_detail.dart';
import '../../../presentation/components/cards/subject_name_card.dart';
import '../../../presentation/components/buttons/subjects/open_action_button.dart';
import '../../../presentation/components/cards/teacher_card.dart';
import '../../../presentation/components/cards/subject_hours_card.dart';
import '../../../presentation/components/cards/class_load_card.dart';
import '../../../presentation/components/cards/subject_credit_card.dart';
import '../../../presentation/components/lists/labels.dart';

class SubjectDetailScreen extends StatelessWidget {
  final SubjectDetail data;

  const SubjectDetailScreen({
    required this.data,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),
      appBar: CustomAppBar(title: data.subjectName),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10,
          children: [
            SubjectNameCard(data: data),
            Row(
              spacing: 10,
              children: [
                Expanded(
                  child: OpenActionButton(
                    label: 'Open Grades',
                    sublabel: 'For this subject',
                    icon: Icons.star_rounded,
                    onTap: () => context.push('/functions/grades/subject/${data.subjectId}'),
                  ),
                ),
                Expanded(
                  child: OpenActionButton(
                    label: 'Open Materials',
                    sublabel: 'For this subject',
                    icon: Icons.article_rounded,
                    onTap: () => context.push('/functions/teaching-materials/subject/${data.subjectId}'),
                  ),
                ),
              ],
            ),
            TeacherCard(data: data),
            SubjectHoursCard(data: data),
            ClassLoadCard(data: data),
            SubjectCreditCard(data: data),
          ],
        ),
      ),
    );
  }
}
