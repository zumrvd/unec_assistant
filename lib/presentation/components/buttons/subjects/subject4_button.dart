import 'package:flutter/material.dart';
import 'package:unec_assistant/presentation/components/buttons/subjects/subject_button.dart';

class Subject4Button extends StatelessWidget {
  final VoidCallback onTap;

  const Subject4Button({
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SubjectButton(
      subjectName: 'Xətti cəbr və analitik həndəsə',
      subjectTag: 'Lecture · Seminar',
      iconColor: const Color(0xFFD54829),
      iconBg: const Color(0x26D54829),
      onTap: onTap,
    );
  }
}
