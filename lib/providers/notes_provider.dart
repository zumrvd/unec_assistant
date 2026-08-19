import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/note.dart';
import '../models/note_folder.dart';
import 'subject_detail_provider.dart';

class NotesNotifier extends Notifier<List<Note>> {
  static const _storageKey = 'unec_notes_v1';

  @override
  List<Note> build() {
    // Initial state is empty; async load will update it.
    loadNotes();
    return [];
  }

  /// Reads persisted notes from storage into memory.
  Future<void> loadNotes() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_storageKey);
      if (jsonString != null) {
        final List<dynamic> decoded = jsonDecode(jsonString);
        state = decoded.map((item) => Note.fromJson(item)).toList();
      }
    } catch (e) {
      debugPrint('Error loading notes: $e');
      // If error occurs, keep current state (empty list).
    }
  }

  Future<void> _saveToDisk() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = jsonEncode(state.map((e) => e.toJson()).toList());
      await prefs.setString(_storageKey, jsonString);
    } catch (e) {
      debugPrint('Error saving notes: $e');
    }
  }

  /// Creates a new note and persists it immediately.
  Future<void> createNote(Note note) async {
    state = [...state, note];
    await _saveToDisk();
  }

  /// Updates an existing note and persists changes.
  Future<void> updateNote(Note note) async {
    state = [
      for (final n in state)
        if (n.noteId == note.noteId) note else n
    ];
    await _saveToDisk();
  }

  /// Deletes a note and persists the updated list.
  Future<void> deleteNote(String noteId) async {
    state = state.where((n) => n.noteId != noteId).toList();
    await _saveToDisk();
  }

  /// Returns all notes belonging to a specific folder.
  List<Note> notesForFolder(String folderId) {
    return state.where((n) => n.folderId == folderId).toList();
  }

  /// Returns the number of notes in a specific folder.
  int noteCountForFolder(String folderId) {
    return state.where((n) => n.folderId == folderId).length;
  }

  /// Performs a case-insensitive search within a folder.
  List<Note> searchNotesInFolder(String folderId, String query) {
    final folderNotes = notesForFolder(folderId);
    if (query.isEmpty) return folderNotes;

    final lowercaseQuery = query.toLowerCase();
    return folderNotes.where((n) =>
      n.title.toLowerCase().contains(lowercaseQuery) ||
      n.content.toLowerCase().contains(lowercaseQuery)
    ).toList();
  }
}

/// Provider for the list of notes with state management logic.
final notesProvider = NotifierProvider<NotesNotifier, List<Note>>(NotesNotifier.new);

/// Dynamically generates the list of folders based on registered subjects.
final foldersProvider = Provider<List<NoteFolder>>((ref) {
  final subjects = ref.watch(allSubjectsProvider);
  
  final List<NoteFolder> folders = [];
  
  // 1. Fixed Personal Folder
  folders.add(const NoteFolder(
    folderId: 'personal',
    folderName: 'Personal',
    type: FolderType.personal,
    icon: Icons.snippet_folder_outlined,
    iconColor: Color(0xFFDA4979),
    iconBg: Color(0x26DA4979),
  ));
  
  // 2. Deterministic palette from design system
  final palette = [
    {'color': const Color(0xFF0569FF), 'bg': const Color(0x260569FF)},
    {'color': const Color(0xFF0F6E11), 'bg': const Color(0x260F6E11)},
    {'color': const Color(0xFF854F0B), 'bg': const Color(0x26E3993C)},
    {'color': const Color(0xFF993C1D), 'bg': const Color(0x26993C1D)},
    {'color': const Color(0xFFDA4979), 'bg': const Color(0x26DA4979)},
    {'color': const Color(0xFF534AB7), 'bg': const Color(0x26534AB7)},
  ];

  // 3. Subject-derived folders
  for (int i = 0; i < subjects.length; i++) {
    final subject = subjects[i];
    final theme = palette[i % palette.length];
    
    folders.add(NoteFolder(
      folderId: subject.subjectId,
      folderName: subject.subjectName,
      type: FolderType.subject,
      subjectId: subject.subjectId,
      icon: Icons.folder_outlined,
      iconColor: theme['color']!,
      iconBg: theme['bg']!,
    ));
  }
  
  return folders;
});

/// Case-insensitive folder search.
final searchedFoldersProvider = Provider.family<List<NoteFolder>, String>((ref, query) {
  final folders = ref.watch(foldersProvider);
  if (query.isEmpty) return folders;
  
  final lowercaseQuery = query.toLowerCase();
  return folders.where((f) => 
    f.folderName.toLowerCase().contains(lowercaseQuery)
  ).toList();
});

/// Search logic for notes within a specific folder.
final searchedNotesProvider = Provider.family<List<Note>, ({String folderId, String query})>((ref, arg) {
  final allNotes = ref.watch(notesProvider);
  final folderNotes = allNotes.where((n) => n.folderId == arg.folderId).toList();
  
  if (arg.query.isEmpty) return folderNotes;
  
  final lowercaseQuery = arg.query.toLowerCase();
  return folderNotes.where((n) => 
    n.title.toLowerCase().contains(lowercaseQuery) || 
    n.content.toLowerCase().contains(lowercaseQuery)
  ).toList();
});

/// Count logic for folder subtitles.
final noteCountProvider = Provider.family<int, String>((ref, folderId) {
  final allNotes = ref.watch(notesProvider);
  return allNotes.where((n) => n.folderId == folderId).length;
});

