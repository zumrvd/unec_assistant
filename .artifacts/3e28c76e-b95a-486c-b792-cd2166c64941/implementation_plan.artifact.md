# Implementation Plan - Note Feature Refinement

Refine the note-taking feature by improving the editor experience, adding deletion capabilities, and simplifying folder management.

## User Review Required

> [!IMPORTANT]
> - **Rich Text Editor**: I will add the `flutter_quill` package. This is necessary to provide a "flawless" experience where text decorators actually format the text instead of inserting markdown markers. Your notes will now be stored in a JSON-based format (Delta) to preserve all formatting.
> - **Deletion Logic**: I will implement a confirmation dialog when clicking the "three dots" to ensure notes aren't deleted accidentally.
> - **Folder Management**: As requested, the "Add Folder" button will be removed from the main Notes screen, making the folder list purely derived from your subject list.

## Proposed Changes

### 1. Dependencies
- Add `flutter_quill: ^9.4.1` to `pubspec.yaml`.

### 2. UI Components
#### [MODIFY] [note_file_tile.dart](file:///C:/src/unec_assistant/lib/presentation/components/cards/note_file_tile.dart)
- Add `onDelete` callback.
- Wrap the `...` icon in a `GestureDetector` that triggers the delete flow.
- Improve content preview logic to extract plain text from the new rich-text format.

#### [MODIFY] [note_files_grid.dart](file:///C:/src/unec_assistant/lib/presentation/components/lists/note_files_grid.dart)
- Pass the `onDelete` callback through to each tile.

### 3. Screens
#### [MODIFY] [notes_screen.dart](file:///C:/src/unec_assistant/lib/screens/functions/notes/notes_screen.dart)
- **Remove** `NotesAddButton` and the `_showNewFolderDialog` logic.
- The UI will now strictly show the "Personal" and "Subject" folders.

#### [MODIFY] [note_files_screen.dart](file:///C:/src/unec_assistant/lib/screens/functions/notes/note_files_screen.dart)
- Implement a `_confirmDelete(Note note)` method that shows a custom styled dialog.
- Wire the delete action to `ref.read(notesProvider.notifier).deleteNote(noteId)`.

#### [MODIFY] [note_editor_screen.dart](file:///C:/src/unec_assistant/lib/screens/functions/notes/note_editor_screen.dart)
- Replace the basic `TextField` with `QuillEditor`.
- Replace the manual toolbar row with `QuillToolbar`.
- Update the save logic to handle Quill Delta JSON.

### 4. Data Layer
#### [MODIFY] [notes_provider.dart](file:///C:/src/unec_assistant/lib/providers/notes_provider.dart)
- Ensure the JSON persistence handles the rich-text Delta format correctly.

## Verification Plan
- [ ] Create a note and apply **Bold**, *Italic*, and Bullet points. Verify the formatting persists after saving and reloading.
- [ ] Verify the note preview in the grid is clean (no JSON/Delta tags visible).
- [ ] Verify that the "Add Folder" button is gone from the folders screen.
- [ ] Delete a note via the "three dots" menu and confirm it is removed from both the UI and disk.
