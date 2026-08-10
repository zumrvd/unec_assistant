import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';
import '../../../presentation/components/lists/labels.dart';
import '../../../presentation/components/inputs/app_search_bar.dart';
import '../../../presentation/components/lists/note_files_grid.dart';
import '../../../presentation/components/buttons/notes_add_button.dart';
import '../../../providers/notes_provider.dart';
import '../../../models/note.dart';

class NoteFilesScreen extends ConsumerStatefulWidget {
  final String folderId;

  const NoteFilesScreen({
    required this.folderId,
    super.key,
  });

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
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFFF8F9FC),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          title: const SectionLabel('Delete Note?'),
          content: Text(
            'Are you sure you want to delete "${note.title.isEmpty ? 'Untitled' : note.title}"? This action cannot be undone.',
            style: GoogleFonts.redditSans(
                fontSize: 14, color: const Color(0xFF838A97)),
          ),
          actions: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child:
                    Text('Cancel', style: TextStyle(color: Color(0xFF838A97))),
              ),
            ),
            GestureDetector(
              onTap: () {
                ref.read(notesProvider.notifier).deleteNote(note.noteId);
                Navigator.pop(context);
              },
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Delete',
                    style: TextStyle(
                        color: Color(0xFFD54829), fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final folders = ref.watch(foldersProvider);
    final folder = folders.firstWhere((f) => f.folderId == widget.folderId);
    final notes = ref.watch(searchedNotesProvider(
        (folderId: widget.folderId, query: _searchQuery)));

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),
      appBar: CustomAppBar(title: folder.folderName),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppSearchBar(
                  controller: _searchController,
                  hintText: 'Search in folder...',
                  onChanged: (q) => setState(() => _searchQuery = q),
                ),
                const SizedBox(height: 25),
                if (notes.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 40),
                      child: Text(
                        _searchQuery.isEmpty
                            ? "No notes in this folder"
                            : "No notes matching your search",
                        style: GoogleFonts.redditSans(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: const Color(0xFF838A97),
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
          Positioned(
            bottom: 30,
            right: 30,
            child: NotesAddButton(onTap: _createNewNote),
          ),
        ],
      ),
    );
  }
}
