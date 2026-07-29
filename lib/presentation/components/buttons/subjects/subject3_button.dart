import 'package:flutter/material.dart';
import 'package:unec_assistant/presentation/components/buttons/subjects/subject_button.dart';

class Subject3Button extends StatelessWidget {
  final VoidCallback onTap;

  const Subject3Button({
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SubjectButton(
      subjectName: 'Azərbaycan dilində işguzar və akademik kommunikasiya',
      subjectTag: 'Seminar (Online)',
      iconColor: const Color(0xFF985909),
      iconBg: const Color(0x26E3993C),
      onTap: onTap,
    );
  }
}
