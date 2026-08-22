import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unec_assistant/providers/theme_provider.dart';
import 'package:unec_assistant/providers/locale_provider.dart';
import 'package:uuid/uuid.dart';
import '../../../presentation/components/lists/labels.dart';
import '../../../presentation/components/inputs/app_search_bar.dart';
import '../../../presentation/components/lists/note_files_grid.dart';
import '../../../providers/notes_provider.dart';
import '../../../models/note.dart';

class NoteFilesScreen extends ConsumerStatefulWidget {
  final String folderId;

  const NoteFilesScreen({required this.folderId, super.key});

  @override
  ConsumerState<NoteFilesScreen> createState() => _NoteFilesScreenState();
}

class _NoteFilesScreenState extends ConsumerState<NoteFilesScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _createNewNote() {
    final newId = const Uuid().v4();
    final newNote = Note(
      noteId: newId,
      folderId: widget.folderId,
      title: '',
      content: '',
      paperSkin: PaperSkin.plain,
      updatedAt: DateTime.now(),
    );

    ref.read(notesProvider.notifier).createNote(newNote);
    context.push('/notes/editor/$newId');
  }

  void _confirmDelete(Note note) {
    final appColors = ref.read(appColorsProvider);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: appColors.cardBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: SectionLabel(ref.read(strProvider).notesDeleteTitle),
          content: Text(
            ref.read(strProvider).notesDeleteDesc(note.title.isEmpty ? ref.read(strProvider).noteUntitled : note.title),
            style: GoogleFonts.redditSans(
              fontSize: 14,
              color: appColors.textSecondary,
            ),
          ),
          actions: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  ref.read(strProvider).notesDeleteCancel,
                  style: GoogleFonts.redditSans(color: appColors.textSecondary),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                ref.read(notesProvider.notifier).deleteNote(note.noteId);
                Navigator.pop(context);
              },
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  ref.read(strProvider).notesDeleteConfirm,
                  style: GoogleFonts.redditSans(
                    color: appColors.error,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final appColors = ref.watch(appColorsProvider);
    final folders = ref.watch(foldersProvider);
    final folder = folders.firstWhere((f) => f.folderId == widget.folderId);
    final notes = ref.watch(
      searchedNotesProvider((folderId: widget.folderId, query: _searchQuery)),
    );

    return Scaffold(
      backgroundColor: appColors.background,
      appBar: CustomAppBar(title: folder.folderName),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppSearchBar(
              controller: _searchController,
              hintText: ref.watch(strProvider).notesSearchFolderHint,
              onChanged: (q) => setState(() => _searchQuery = q),
            ),
            const SizedBox(height: 25),
            if (notes.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: Text(
                    _searchQuery.isEmpty
                        ? ref.watch(strProvider).notesEmptyFolder
                        : ref.watch(strProvider).notesEmptySearch,
                    style: GoogleFonts.redditSans(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: appColors.textSecondary,
                    ),
                  ),
                ),
              )
            else
              NoteFilesGrid(
                notes: notes,
                onNoteTap: (note) =>
                    context.push('/notes/editor/${note.noteId}'),
                onDeleteNote: _confirmDelete,
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createNewNote,
        backgroundColor: appColors.primary,
        shape: const CircleBorder(),
        elevation: 4,
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 28),
      ),
    );
  }
}
