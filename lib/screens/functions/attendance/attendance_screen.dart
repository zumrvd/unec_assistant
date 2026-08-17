import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unec_assistant/presentation/components/cards/subject_attendance_card.dart';
import 'package:unec_assistant/presentation/providers/theme_provider.dart';
import 'package:unec_assistant/providers/subject_detail_provider.dart';
import '../../../presentation/components/lists/labels.dart';

class AttendanceScreen extends ConsumerWidget {
  const AttendanceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allSubjects = ref.watch(allSubjectsProvider);
    final attentionSubjects = ref.watch(attentionSubjectsProvider);
    final appColors = ref.watch(appColorsProvider);

    return Scaffold(
      backgroundColor: appColors.background,
      appBar: const CustomAppBar(title: 'Attendance'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10,
          children: [
            if (attentionSubjects.isNotEmpty) ...[
              const SectionLabel('Needs attention'),
              ...attentionSubjects.map((s) => Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: SubjectAttendanceCard(subject: s),
              )),
            ],
            const SectionLabel('All subjects'),
            ...allSubjects.map((s) => Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: SubjectAttendanceCard(subject: s),
            )),
          ],
        ),
      ),
    );
  }
}

