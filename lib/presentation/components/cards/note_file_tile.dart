import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:unec_assistant/presentation/providers/theme_provider.dart';
import 'package:unec_assistant/presentation/theme/app_colors.dart';
import '../../../models/note.dart';

class NoteFileTile extends ConsumerWidget {
  final Note data;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const NoteFileTile({
    required this.data,
    this.onTap,
    this.onDelete,
    super.key,
  });

  String _getPlainText(String jsonContent) {
    if (jsonContent.isEmpty) return '';
    try {
      final List<dynamic> decoded = jsonDecode(jsonContent);
      return quill.Document.fromJson(decoded).toPlainText();
    } catch (e) {
      // Fallback for plain text or malformed JSON
      return jsonContent;
    }
  }

  Color _getSkinColor(PaperSkin skin, AppColors appColors) {
    switch (skin) {
      case PaperSkin.plain:
        return appColors.textSecondary;
      case PaperSkin.ruled:
        return appColors.primary;
      case PaperSkin.grid:
        return appColors.success;
      case PaperSkin.dotted:
        return appColors.attendanceOrange;
      case PaperSkin.cream:
        return const Color(0xFFDA4979);
      case PaperSkin.blue:
        return appColors.notificationPurple;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appColors = ref.watch(appColorsProvider);
    final skinColor = _getSkinColor(data.paperSkin, appColors);

    return GestureDetector(
      onTap: onTap ?? () {},
      behavior: HitTestBehavior.opaque,
      child: Container(
        decoration: BoxDecoration(
          color: appColors.cardBackground,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: appColors.borderColor, width: 1),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            // Left-edge accent bar
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: Container(
                width: 4,
                color: skinColor,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.title.isEmpty ? 'Untitled' : data.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.redditSans(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      color: appColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Expanded(
                    child: Text(
                      _getPlainText(data.content),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.redditSans(
                        fontWeight: FontWeight.w500,
                        fontSize: 11,
                        color: appColors.textSecondary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        DateFormat('MMM d').format(data.updatedAt),
                        style: GoogleFonts.redditSans(
                          fontWeight: FontWeight.w600,
                          fontSize: 9,
                          color: appColors.textMuted,
                        ),
                      ),
                      GestureDetector(
                        onTap: onDelete,
                        behavior: HitTestBehavior.opaque,
                        child: Icon(
                          Icons.more_horiz_rounded,
                          size: 16,
                          color: appColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

