import 'package:flutter/material.dart';

enum FolderType { personal, subject }

class NoteFolder {
  final String folderId;
  final String folderName;
  final FolderType type;
  final String? subjectId; // non-null only when type == FolderType.subject
  final IconData icon;
  final Color iconColor;
  final Color iconBg;

  const NoteFolder({
    required this.folderId,
    required this.folderName,
    required this.type,
    this.subjectId,
    required this.icon,
    required this.iconColor,
    required this.iconBg,
  });
}