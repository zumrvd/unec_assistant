import 'package:flutter/material.dart';

class SubjectMaterial {
  final String subjectId;
  final String subjectName;
  final int fileCount;
  final IconData icon;
  final Color iconColor;
  final Color iconBg;

  const SubjectMaterial({
    required this.subjectId,
    required this.subjectName,
    required this.fileCount,
    required this.icon,
    required this.iconColor,
    required this.iconBg,
  });
}
