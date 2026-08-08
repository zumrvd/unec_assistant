import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../models/note_folder.dart';
import '../../../presentation/components/lists/labels.dart';
import '../../../presentation/components/inputs/notes_search_bar.dart';
import '../../../presentation/components/cards/note_folder_tile.dart';
import '../../../providers/notes_provider.dart';

class NotesScreen extends ConsumerStatefulWidget {
  const NotesScreen({super.key});

  @override
  ConsumerState<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends ConsumerState<NotesScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final folders = ref.watch(searchedFoldersProvider(_searchQuery));
    final personalFolders = folders.where((f) => f.type == FolderType.personal).toList();
    final subjectFolders = folders.where((f) => f.type == FolderType.subject).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),
      appBar: const CustomAppBar(title: 'Notes'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            NotesSearchBar(
              controller: _searchController,
              hintText: 'Search notes...',
              onChanged: (q) => setState(() => _searchQuery = q),
            ),
            const SizedBox(height: 25),
            
            if (personalFolders.isNotEmpty) ...[
              const SectionLabel('PERSONAL'),
              const SizedBox(height: 12),
              ...personalFolders.map((f) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: NoteFolderTile(
                  data: f,
                  noteCount: ref.watch(noteCountProvider(f.folderId)),
                  onTap: () => context.push('/notes/folder/${f.folderId}'),
                ),
              )),
              const SizedBox(height: 15),
            ],

            if (subjectFolders.isNotEmpty) ...[
              const SectionLabel('CLASS FOLDERS'),
              const SizedBox(height: 12),
              ...subjectFolders.map((f) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: NoteFolderTile(
                  data: f,
                  noteCount: ref.watch(noteCountProvider(f.folderId)),
                  onTap: () => context.push('/notes/folder/${f.folderId}'),
                ),
              )),
            ],
          ],
        ),
      ),
    );
  }
}
