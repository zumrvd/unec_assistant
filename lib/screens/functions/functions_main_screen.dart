import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:unec_assistant/presentation/components/buttons/current_class_button.dart';
import 'package:unec_assistant/presentation/components/buttons/schedule_button.dart';
import 'package:unec_assistant/presentation/components/buttons/subjects/subjects_button.dart';
import 'package:unec_assistant/presentation/components/buttons/attendance/attendance_button.dart';
import 'package:unec_assistant/presentation/components/buttons/notes_button.dart';
import 'package:unec_assistant/providers/theme_provider.dart';

import '../../presentation/components/lists/labels.dart';

class FunctionsMainScreen extends ConsumerWidget {
  const FunctionsMainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appColors = ref.watch(appColorsProvider);

    return Scaffold(
      backgroundColor: appColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 35.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionLabel('Class & Attendance'),
            const SizedBox(height: 10),

            CurrentClassButton(
              onTap: () => context.push('/functions/current_class_function'),
            ),
            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(
                  child: ScheduleButton(
                    onTap: () => context.push('/functions/schedule_function'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: AttendanceButton(
                    onTap: () => context.push('/functions/attendance_function'),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),
            const SectionLabel('Academic'),
            const SizedBox(height: 10),

            SubjectsButton(
              onTapSubjects: () => context.push('/functions/subjects'),
              onTapTeachingMaterials: () =>
                  context.push('/functions/teaching-materials'),
              onTapGrades: () => context.push('/functions/grades'),
              onTapOpen: () {},
            ),

            const SizedBox(height: 10),
            const SectionLabel('Personal'),
            const SizedBox(height: 10),

            NotesButton(onTap: () => context.push('/notes')),
          ],
        ),
      ),
    );
  }
}
