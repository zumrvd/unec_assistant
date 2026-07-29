import 'package:flutter/material.dart';
import 'package:unec_assistant/presentation/components/buttons/subjects/subject_button.dart';

class Subject5Button extends StatelessWidget {
  final VoidCallback onTap;

  const Subject5Button({
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SubjectButton(
      subjectName: 'İnformasiya texnologiyalarının əsasları',
      subjectTag: 'Lecture · Seminar',
      iconColor: const Color(0xFFE16890),
      iconBg: const Color(0x26E16890),
      onTap: onTap,
    );
  }
}
