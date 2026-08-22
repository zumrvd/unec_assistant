import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unec_assistant/providers/theme_provider.dart';
import 'package:unec_assistant/providers/locale_provider.dart';
import '../../../../providers/subject_detail_provider.dart';
import '../../../../presentation/components/buttons/grade_calculator_button.dart';
import '../../../../presentation/components/cards/grade_calculator_card.dart';

import '../../../../presentation/components/lists/labels.dart';

class GradeCalculatorScreen extends ConsumerWidget {
  const GradeCalculatorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appColors = ref.watch(appColorsProvider);
    final tr = ref.watch(strProvider);

    return Scaffold(
      backgroundColor: appColors.background,
      appBar: CustomAppBar(title: tr.gradeCalcScreenTitle),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 16),
        child: Column(
          children: [
            GradeCalculatorButton(
              onTap: () {},
              subtitle: tr.gradeCalcSubtitle,
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
              subjects: [
                kProgDetail,
                kFizikaDetail,
                kAzDetail,
                kXettiDetail,
                kInfoDetail,
                kXariciDetail,
              ],
            ),
          ],
        ),
      ),
    );
  }
}
