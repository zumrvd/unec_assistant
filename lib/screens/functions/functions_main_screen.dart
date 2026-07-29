import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:unec_assistant/presentation/components/buttons/current_class_button.dart';
import 'package:unec_assistant/presentation/components/buttons/schedule_button.dart';
import 'package:unec_assistant/presentation/components/buttons/subjects_button.dart';
import 'package:unec_assistant/presentation/components/buttons/attendance_button.dart';
import 'package:unec_assistant/presentation/components/buttons/notes_button.dart';



class FunctionsMainScreen extends StatelessWidget {
  const FunctionsMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 10.0),
              child: Text(
                'Class & Attendance',
                style: TextStyle(
                  color: Color(0xFF838A97),
                  fontSize: 15,
                ),
              ),
            ),

            CurrentClassButton(
              onTap: () => context.push('/functions/current_class_function'),
            ),

            const SizedBox(height: 15),

            Row(
              children: [
                Expanded(
                  child: ScheduleButton(
                    onTap: () => context.push('/functions/schedule_function'),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: AttendanceButton(
                    onTap: () => context.push('/functions/attendance_function'),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            const Padding(
              padding: EdgeInsets.only(bottom: 10.0),
              child: Text(
                'Academic',
                style: TextStyle(
                  color: Color(0xFF838A97),
                  fontSize: 15,
                ),
              ),
            ),

            SubjectsButton(
              onTapSubjects: () => context.push('/functions/subjects'),
              onTapTeachingMaterials: () =>
                  context.push('/functions/teaching-materials'),
              onTapGrades: () => context.push('/functions/grades'),
              onTapOpen: () {},
            ),

            const SizedBox(height: 16),

            const Padding(
              padding: EdgeInsets.only(bottom: 10.0),
              child: Text(
                'Personal',
                style: TextStyle(
                  color: Color(0xFF838A97),
                  fontSize: 15,
                ),
              ),
            ),

            NotesButton(
              onTap: () => context.push('/functions/notes_function'),
            ),
          ],
        ),
      ),
    );
  }
}