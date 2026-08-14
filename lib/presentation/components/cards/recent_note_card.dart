import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../models/note.dart';
import '../../../providers/notes_provider.dart';

class RecentNoteCard extends ConsumerWidget {
  const RecentNoteCard({super.key});

  static const _borderColor = Color(0xFFE0E4F0);
  static const _labelGrey = Color(0xFF838A97);
  static const _valueBlack = Color(0xFF1F1F1F);

  Color _getSkinBgColor(PaperSkin skin) {
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

  Color _getSkinAccentColor(PaperSkin skin) {
    switch (skin) {
      case PaperSkin.plain:
        return const Color(0xFF838A97);
      case PaperSkin.ruled:
        return const Color(0xFF0569FF);
      case PaperSkin.grid:
        return const Color(0xFF0F6E11);
      case PaperSkin.dotted:
        return const Color(0xFFE3993C);
      case PaperSkin.cream:
        return const Color(0xFFDA4979);
      case PaperSkin.blue:
        return const Color(0xFF534AB7);
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

    if (notes.isEmpty) {
      return const SizedBox.shrink();
    }

    // Sort to find the most recent
    final sortedNotes = [...notes];
    sortedNotes.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

    final note = sortedNotes.first;
    final accentColor = _getSkinAccentColor(note.paperSkin);
    final bgColor = _getSkinBgColor(note.paperSkin);
    final plainText = _getPlainText(note.content);

    final String semanticLabel = "Recent Note: ${note.title.isEmpty ? 'Untitled' : note.title}, Last edited ${DateFormat('MMM d').format(note.updatedAt)}";

    return Column(
      children: [
        const SizedBox(height: 10),
        Semantics(
          container: true,
          button: true,
          label: semanticLabel,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => context.go('/notes/editor/${note.noteId}'),
              borderRadius: BorderRadius.circular(18),
              child: Container(
                width: 330,
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: _borderColor, width: 1),
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
                              Icon(Icons.edit_note_rounded, size: 18, color: accentColor),
                              const SizedBox(width: 8),
                              Text(
                                'RECENT NOTE',
                                style: GoogleFonts.redditSans(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                  color: accentColor,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: accentColor.withOpacity(0.1),
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
                        note.title.isEmpty ? 'Untitled' : note.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.redditSans(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                          color: _valueBlack,
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Info Box (Preview)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: (note.paperSkin == PaperSkin.plain ? const Color(0xFFF8F9FC) : Colors.white.withOpacity(0.5)),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: _borderColor.withOpacity(0.5), width: 1),
                        ),
                        child: Text(
                          plainText.isEmpty ? 'No additional content' : plainText,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.redditSans(
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                            color: _labelGrey,
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
        ),
      ],
    );
  }
}
