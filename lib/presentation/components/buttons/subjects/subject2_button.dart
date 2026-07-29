import 'package:flutter/material.dart';
import 'package:unec_assistant/presentation/components/buttons/subjects/subject_button.dart';

class Subject2Button extends StatelessWidget {
  final VoidCallback onTap;

  const Subject2Button({
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SubjectButton(
      subjectName: 'Fizika',
      subjectTag: 'Lecture · Laboratory',
      iconColor: const Color(0xFF0F6E11),
      iconBg: const Color(0x260F6E11),
      onTap: onTap,
    );
  }
}
