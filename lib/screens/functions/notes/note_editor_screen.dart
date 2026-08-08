import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../models/note.dart';
import '../../../providers/notes_provider.dart';

class NoteEditorScreen extends ConsumerStatefulWidget {
  final String noteId;

  const NoteEditorScreen({
    required this.noteId,
    super.key,
  });

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
    final note =
        ref.read(notesProvider).firstWhere((n) => n.noteId == widget.noteId);
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
    final contentJson =
        jsonEncode(_quillController.document.toDelta().toJson());
    final oldNote =
        ref.read(notesProvider).firstWhere((n) => n.noteId == widget.noteId);
    final updatedNote = oldNote.copyWith(
      title: _titleController.text,
      content: contentJson,
      paperSkin: _selectedSkin,
      updatedAt: DateTime.now(),
    );
    ref.read(notesProvider.notifier).updateNote(updatedNote);
  }

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

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: _getSkinBgColor(_selectedSkin),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: Container(
          padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  _saveNote();
                  Navigator.pop(context);
                },
                child: const Icon(Icons.arrow_back_ios_new_rounded,
                    size: 20, color: Color(0xFF838A97)),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: TextField(
                  controller: _titleController,
                  onChanged: (_) => _onChanged(),
                  style: GoogleFonts.redditSans(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                      color: const Color(0xFF1F1F1F)),
                  decoration: const InputDecoration(
                      border: InputBorder.none, hintText: 'Note Title'),
                ),
              ),
              GestureDetector(
                onTap: () {
                  _saveNote();
                  Navigator.pop(context);
                },
                child: Text(
                  'Done',
                  style: GoogleFonts.redditSans(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: const Color(0xFF0569FF)),
                ),
              ),
            ],
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
                      color: const Color(0xFF838A97)),
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
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: _getSkinAccentColor(skin),
                            shape: BoxShape.circle,
                            border: isSelected
                                ? Border.all(
                                    color: const Color(0xFF0569FF), width: 2)
                                : null,
                          ),
                          child: isSelected
                              ? const Icon(Icons.check_rounded,
                                  size: 12, color: Colors.white)
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
