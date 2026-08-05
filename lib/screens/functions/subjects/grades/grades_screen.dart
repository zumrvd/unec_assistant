import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../providers/subject_detail_provider.dart';
import '../../../../presentation/components/buttons/grade_calculator_button.dart';
import '../../../../presentation/components/cards/subject_grade_list_item.dart';

import '../../../../presentation/components/lists/labels.dart';

class GradesScreen extends StatelessWidget {
  const GradesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),
      appBar: const CustomAppBar(title: 'Grades'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GradeCalculatorButton(
              onTap: () => context.push('/functions/grades/calculator'),
              subtitle: 'Select a target grade and see exactly what you need to achieve it.',
            ),
            const SizedBox(height: 16),
            Text(
              'All subjects  6',
              style: GoogleFonts.redditSans(
                fontWeight: FontWeight.w700,
                fontSize: 13,
                color: const Color(0xFF838A97),
              ),
            ),
            const SizedBox(height: 12),
            SubjectGradeListItem(
              data: kProgDetail,
              iconColor: const Color(0xFF0569FF),
              iconBg: const Color(0x260569FF),
              onTap: () => context.push('/functions/grades/subject/prog'),
            ),
            const SizedBox(height: 10),
            SubjectGradeListItem(
              data: kFizikaDetail,
              iconColor: const Color(0xFF0F6E11),
              iconBg: const Color(0x260F6E11),
              onTap: () => context.push('/functions/grades/subject/fizika'),
            ),
            const SizedBox(height: 10),
            SubjectGradeListItem(
              data: kAzDetail,
              iconColor: const Color(0xFF985909),
              iconBg: const Color(0x26E3993C),
              onTap: () => context.push('/functions/grades/subject/az'),
            ),
            const SizedBox(height: 10),
            SubjectGradeListItem(
              data: kXettiDetail,
              iconColor: const Color(0xFFD54829),
              iconBg: const Color(0x26D54829),
              onTap: () => context.push('/functions/grades/subject/xetti'),
            ),
            const SizedBox(height: 10),
            SubjectGradeListItem(
              data: kInfoDetail,
              iconColor: const Color(0xFFE16890),
              iconBg: const Color(0x26E16890),
              onTap: () => context.push('/functions/grades/subject/info'),
            ),
            const SizedBox(height: 10),
            SubjectGradeListItem(
              data: kXariciDetail,
              iconColor: const Color(0xFF534AB7),
              iconBg: const Color(0x26534AB7),
              onTap: () => context.push('/functions/grades/subject/xarici'),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
