import 'package:flutter/material.dart';
import 'package:unec_assistant/presentation/components/buttons/subjects/subject_button.dart';

class Subject6Button extends StatelessWidget {
  final VoidCallback onTap;

  const Subject6Button({
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SubjectButton(
      subjectName: 'Xarici dildə işguzar və akademik kommunikasiya',
      subjectTag: 'Seminar',
      iconColor: const Color(0xFF534AB7),
      iconBg: const Color(0x26534AB7),
      onTap: onTap,
    );
  }
}
