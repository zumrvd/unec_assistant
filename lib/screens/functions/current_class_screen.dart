import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:unec_assistant/presentation/components/cards/current_class_detailed_card.dart';
import 'package:unec_assistant/presentation/components/cards/teaching_materials_card.dart';
import 'package:unec_assistant/presentation/components/buttons/attendance_detailed_button.dart';

class CurrentClassScreen extends StatelessWidget {
  const CurrentClassScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 35.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CurrentClassDetailedCard(),

            const SizedBox(height: 20),

            AttendanceButton(
              onTap: () => context.push('/functions/attendance_function'),
            ),

            const SizedBox(height: 20),

            TeachingMaterialsCard(),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
