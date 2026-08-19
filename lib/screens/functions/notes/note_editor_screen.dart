import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unec_assistant/providers/theme_provider.dart';
import 'package:unec_assistant/presentation/theme/app_colors.dart';
import '../../../models/note.dart';
import '../../../providers/notes_provider.dart';

class NoteEditorScreen extends ConsumerStatefulWidget {
  final String noteId;

  const NoteEditorScreen({required this.noteId, super.key});

  @override
  ConsumerState<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends ConsumerState<NoteEditorScreen> {
  final TextEditingController _titleController = TextEditingController();
  late QuillController _quillController;
  PaperSkin _selectedSkin = PaperSkin.plain;
  Timer? _debounceTimer;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _quillController = QuillController.basic();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadNote();
    });
  }

  void _loadNote() {
    final note = ref
        .read(notesProvider)
        .firstWhere((n) => n.noteId == widget.noteId);
    _titleController.text = note.title;
    _selectedSkin = note.paperSkin;

    if (note.content.isNotEmpty) {
      try {
        final List<dynamic> decoded = jsonDecode(note.content);
        _quillController = QuillController(
          document: Document.fromJson(decoded),
          selection: const TextSelection.collapsed(offset: 0),
        );
      } catch (e) {
        // Fallback for plain text
        _quillController.document = Document()..insert(0, note.content);
      }
    }

    _quillController.addListener(_onChanged);
    setState(() => _isInitialized = true);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _titleController.dispose();
    _quillController.dispose();
    super.dispose();
  }

  void _onChanged() {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 800), _saveNote);
  }

  void _saveNote() {
    if (!mounted) return;
    final contentJson = jsonEncode(
      _quillController.document.toDelta().toJson(),
    );
    final oldNote = ref
        .read(notesProvider)
        .firstWhere((n) => n.noteId == widget.noteId);
    final updatedNote = oldNote.copyWith(
      title: _titleController.text,
      content: contentJson,
      paperSkin: _selectedSkin,
      updatedAt: DateTime.now(),
    );
    ref.read(notesProvider.notifier).updateNote(updatedNote);
  }

  Color _getSkinBgColor(PaperSkin skin, AppColors appColors, bool isDark) {
    if (isDark) {
      switch (skin) {
        case PaperSkin.plain:
          return appColors.cardBackground;
        case PaperSkin.ruled:
          return const Color(0xFF141F30);
        case PaperSkin.grid:
          return const Color(0xFF13281A);
        case PaperSkin.dotted:
          return const Color(0xFF281F14);
        case PaperSkin.cream:
          return const Color(0xFF2A1620);
        case PaperSkin.blue:
          return const Color(0xFF1C1833);
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
        return appColors.attendanceOrange;
      case PaperSkin.cream:
        return appColors.pink;
      case PaperSkin.blue:
        return appColors.notificationPurple;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final appColors = ref.watch(appColorsProvider);
    final isDark = ref.watch(isDarkModeProvider);
    final skinBg = _getSkinBgColor(_selectedSkin, appColors, isDark);

    return Scaffold(
      backgroundColor: skinBg,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(85),
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: appColors.borderColor, width: 1),
              bottom: BorderSide(color: appColors.borderColor, width: 1),
            ),
          ),
          child: Container(
            height: 70,
            width: double.infinity,
            color: skinBg,
            padding: const EdgeInsets.symmetric(horizontal: 35.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          _saveNote();
                          Navigator.pop(context);
                        },
                        behavior: HitTestBehavior.opaque,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: appColors.iconBoxArrowBg,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.arrow_back,
                            size: 20,
                            color: appColors.textSecondary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextField(
                          controller: _titleController,
                          onChanged: (_) => _onChanged(),
                          style: GoogleFonts.redditSans(
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                            color: appColors.textPrimary,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Note Title',
                            hintStyle: TextStyle(color: appColors.textMuted),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: () {
                    _saveNote();
                    Navigator.pop(context);
                  },
                  behavior: HitTestBehavior.opaque,
                  child: Text(
                    'Done',
                    style: GoogleFonts.redditSans(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: appColors.primary,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Toolbar
          QuillSimpleToolbar(
            controller: _quillController,
            config: const QuillSimpleToolbarConfig(
              multiRowsDisplay: false,
              showFontFamily: false,
              showFontSize: false,
              showBoldButton: true,
              showItalicButton: true,
              showUnderLineButton: true,
              showStrikeThrough: false,
              showColorButton: false,
              showBackgroundColorButton: false,
              showClearFormat: false,
              showAlignmentButtons: true,
              showLeftAlignment: true,
              showCenterAlignment: true,
              showRightAlignment: true,
              showJustifyAlignment: true,
              showListNumbers: true,
              showListBullets: true,
              showListCheck: true,
              showCodeBlock: false,
              showQuote: false,
              showIndent: false,
              showLink: false,
              showSearchButton: false,
              showSubscript: false,
              showSuperscript: false,
            ),
          ),

          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(35),
              child: QuillEditor.basic(
                controller: _quillController,
                config: const QuillEditorConfig(
                  placeholder: 'Start typing...',
                  expands: true,
                ),
              ),
            ),
          ),

          // Paper Skin Selector
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 20),
            child: Row(
              children: [
                Text(
                  'Paper',
                  style: GoogleFonts.redditSans(
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                    color: appColors.textSecondary,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: PaperSkin.values.map((skin) {
                      final isSelected = _selectedSkin == skin;
                      return GestureDetector(
                        onTap: () {
                          setState(() => _selectedSkin = skin);
                          _onChanged();
                        },
                        behavior: HitTestBehavior.opaque,
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: _getSkinAccentColor(skin, appColors),
                            shape: BoxShape.circle,
                            border: isSelected
                                ? Border.all(color: appColors.primary, width: 2)
                                : null,
                          ),
                          child: isSelected
                              ? const Icon(
                                  Icons.check_rounded,
                                  size: 12,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
