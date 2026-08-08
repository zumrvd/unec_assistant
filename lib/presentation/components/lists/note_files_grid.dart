import 'package:flutter/material.dart';
import '../../../models/note.dart';
import '../cards/note_file_tile.dart';

class NoteFilesGrid extends StatelessWidget {
  final List<Note> notes;
  final void Function(Note) onNoteTap;
  final void Function(Note) onDeleteNote;

  const NoteFilesGrid({
    required this.notes,
    required this.onNoteTap,
    required this.onDeleteNote,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.0, // Roughly square-ish
      ),
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes[index];
        return NoteFileTile(
          data: note,
          onTap: () => onNoteTap(note),
          onDelete: () => onDeleteNote(note),
        );
      },
    );
  }
}
