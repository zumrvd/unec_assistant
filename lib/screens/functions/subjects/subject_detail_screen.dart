import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../models/subject_detail.dart';
import '../../../presentation/components/cards/subject_name_card.dart';
import '../../../presentation/components/buttons/open_action_button.dart';
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
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SubjectNameCard(data: data),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OpenActionButton(
                    label: 'Open Grades',
                    sublabel: 'For this subject',
                    icon: Icons.star_rounded,
                    onTap: () {},
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OpenActionButton(
                    label: 'Open Materials',
                    sublabel: 'For this subject',
                    icon: Icons.article_rounded,
                    onTap: () {},
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TeacherCard(data: data),
            const SizedBox(height: 12),
            SubjectHoursCard(data: data),
            const SizedBox(height: 12),
            ClassLoadCard(data: data),
            const SizedBox(height: 12),
            SubjectCreditCard(data: data),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
