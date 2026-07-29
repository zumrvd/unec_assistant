import 'package:flutter/material.dart';
import 'package:unec_assistant/presentation/components/buttons/subjects/subject_button.dart';

class Subject1Button extends StatelessWidget {
  final VoidCallback onTap;

  const Subject1Button({
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SubjectButton(
      subjectName: 'Programlaşdırmanın əsasları',
      subjectTag: 'Lecture · Seminar',
      iconColor: const Color(0xFF0569FF),
      iconBg: const Color(0x260569FF),
      onTap: onTap,
    );
  }
}
