import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:unec_assistant/providers/theme_provider.dart';
import 'package:unec_assistant/providers/locale_provider.dart';
import 'package:unec_assistant/presentation/theme/app_colors.dart';
import '../../../models/note.dart';
import '../../../providers/notes_provider.dart';

class RecentNoteCard extends ConsumerWidget {
  const RecentNoteCard({super.key});

  Color _getSkinBgColor(PaperSkin skin, AppColors appColors, bool isDark) {
    if (skin == PaperSkin.plain) {
      return appColors.cardBackground;
    }
    if (isDark) {
      switch (skin) {
        case PaperSkin.plain:
          return appColors.cardBackground;
        case PaperSkin.ruled:
          return const Color(0xFF162036);
        case PaperSkin.grid:
          return const Color(0xFF142918);
        case PaperSkin.dotted:
          return const Color(0xFF2C2216);
        case PaperSkin.cream:
          return const Color(0xFF2B1822);
        case PaperSkin.blue:
          return const Color(0xFF1E1A34);
      }
    }
    switch (skin) {
      case PaperSkin.plain:
        return const Color(0xFFFFFFFF);
      case PaperSkin.ruled:
        return const Color(0xFFF0F6FF);
      case PaperSkin.grid:
        return const Color(0xFFF0FFF1);
      case PaperSkin.dotted:
        return const Color(0xFFFFF7F0);
      case PaperSkin.cream:
        return const Color(0xFFFFF0F5);
      case PaperSkin.blue:
        return const Color(0xFFF5F0FF);
    }
  }

  Color _getSkinAccentColor(PaperSkin skin, AppColors appColors) {
    switch (skin) {
      case PaperSkin.plain:
        return appColors.textSecondary;
      case PaperSkin.ruled:
        return appColors.primary;
      case PaperSkin.grid:
        return appColors.success;
      case PaperSkin.dotted:
        return appColors.warning;
      case PaperSkin.cream:
        return appColors.error;
      case PaperSkin.blue:
        return appColors.notificationPurple;
    }
  }

  String _getPlainText(String jsonContent) {
    if (jsonContent.isEmpty) return '';
    try {
      final List<dynamic> decoded = jsonDecode(jsonContent);
      return quill.Document.fromJson(decoded).toPlainText();
    } catch (e) {
      return jsonContent;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notes = ref.watch(notesProvider);
    final appColors = ref.watch(appColorsProvider);
    final tr = ref.watch(strProvider);
    final isDark = ref.watch(isDarkModeProvider);

    if (notes.isEmpty) {
      return const SizedBox.shrink();
    }

    // Sort to find the most recent
    final sortedNotes = [...notes];
    sortedNotes.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

    final note = sortedNotes.first;
    final accentColor = _getSkinAccentColor(note.paperSkin, appColors);
    final bgColor = _getSkinBgColor(note.paperSkin, appColors, isDark);
    final plainText = _getPlainText(note.content);

    final String semanticLabel =
        "Recent Note: ${note.title.isEmpty ? tr.noteUntitled : note.title}, Last edited ${DateFormat('MMM d').format(note.updatedAt)}";

    return Column(
      children: [
        const SizedBox(height: 10),
        Semantics(
          container: true,
          button: true,
          label: semanticLabel,
          child: GestureDetector(
            onTap: () => context.go('/notes/editor/${note.noteId}'),
            behavior: HitTestBehavior.opaque,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: appColors.borderColor, width: 1),
              ),
              padding: const EdgeInsets.all(16),
              child: ExcludeSemantics(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.edit_note_rounded,
                              size: 18,
                              color: accentColor,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              tr.noteRecentLabel,
                              style: GoogleFonts.redditSans(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                                color: accentColor,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: accentColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            DateFormat('MMM d').format(note.updatedAt),
                            style: GoogleFonts.redditSans(
                              fontWeight: FontWeight.w700,
                              fontSize: 10,
                              color: accentColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    // Title
                    Text(
                      note.title.isEmpty ? tr.noteUntitled : note.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.redditSans(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        color: appColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Info Box (Preview)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: note.paperSkin == PaperSkin.plain
                            ? appColors.surface
                            : (isDark
                                  ? Colors.black.withValues(alpha: 0.3)
                                  : Colors.white.withValues(alpha: 0.5)),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: appColors.borderColor.withValues(alpha: 0.5),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        plainText.isEmpty ? tr.noteNoContent : plainText,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.redditSans(
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                          color: appColors.textSecondary,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
