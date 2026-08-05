import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../../providers/subject_detail_provider.dart';
import '../../../../presentation/components/buttons/grade_calculator_button.dart';
import '../../../../presentation/components/cards/grade_calculator_card.dart';

import '../../../../presentation/components/lists/labels.dart';

class GradeCalculatorScreen extends StatelessWidget {
  const GradeCalculatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),
      appBar: const CustomAppBar(title: 'Grade Goal Calculator'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 16),
        child: Column(
          children: [
            GradeCalculatorButton(
              onTap: () {},
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
              ),
            ),
            const GradeCalculatorCard(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(18),
                bottomRight: Radius.circular(18),
              ),
              subjects: [kProgDetail, kFizikaDetail, kAzDetail, kXettiDetail, kInfoDetail, kXariciDetail],
            ),
          ],
        ),
      ),
    );
  }
}
