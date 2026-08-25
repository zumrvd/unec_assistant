import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repository_providers.dart';
import '../models/lecture_material.dart';

// =============================================================================
// UI-only mappings — these are pure presentation constants.
// The API will never serve icon or colour values; this mapping always stays
// here in the UI layer.
// =============================================================================

const Map<String, IconData> kFileTypeIcons = {
  'Lecture': Icons.menu_book_rounded,
  'Presentation': Icons.slideshow_rounded,
  'Quiz': Icons.quiz_rounded,
  'Seminar': Icons.groups_rounded,
  'Other': Icons.insert_drive_file_rounded,
};

const Map<String, Color> kFileTypeColors = {
  'Lecture': Color(0xFF0569FF),
  'Presentation': Color(0xFFE3993C),
  'Quiz': Color(0xFF0F6E11),
  'Seminar': Color(0xFFDA4979),
  'Other': Color(0xFF838A97),
};

// =============================================================================
// State + Notifier
// =============================================================================

/// Holds the materials state for all enrolled subjects in the current semester.
class MaterialsState {
  const MaterialsState({
    this.bySubjectId = const {},
    this.isLoading = false,
    this.error,
  });

  /// All lecture materials keyed by `subjectId`.
  final Map<String, List<LectureMaterial>> bySubjectId;
  final bool isLoading;
  final String? error;

  MaterialsState copyWith({
    Map<String, List<LectureMaterial>>? bySubjectId,
    bool? isLoading,
    String? error,
  }) {
    return MaterialsState(
      bySubjectId: bySubjectId ?? this.bySubjectId,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Loads all teaching materials from [MaterialsRepository] and exposes them
/// as a keyed map. Consumers use the derived providers below rather than
/// watching this notifier directly.
class MaterialsNotifier extends Notifier<MaterialsState> {
  @override
  MaterialsState build() {
    Future.microtask(_load);
    return const MaterialsState(isLoading: true);
  }

  Future<void> _load() async {
    state = state.copyWith(isLoading: true);
    try {
      final repo = ref.read(materialsRepositoryProvider);
      final materials = await repo.fetchAllMaterials(kCurrentSemesterId);
      state = MaterialsState(bySubjectId: materials, isLoading: false);
    } catch (e, st) {
      debugPrint('MaterialsNotifier._load error: $e\n$st');
      state = MaterialsState(error: e.toString(), isLoading: false);
    }
  }

  /// Force-refresh materials (e.g. called after a new upload notification).
  Future<void> refresh() => _load();
}

/// Root notifier provider. Prefer the derived providers below in UI code.
final materialsNotifierProvider =
    NotifierProvider<MaterialsNotifier, MaterialsState>(
  MaterialsNotifier.new,
);

// =============================================================================
// Derived providers — same public API as before, now repository-backed
// =============================================================================

/// All materials for every enrolled subject, keyed by `subjectId`.
///
/// Previously this was `kSubjectLecturesMap` — a compile-time constant.
/// Now it is loaded from [MaterialsRepository] and reactive to refreshes.
final allMaterialsProvider = Provider<Map<String, List<LectureMaterial>>>((ref) {
  return ref.watch(materialsNotifierProvider).bySubjectId;
});

/// Materials for a single subject, identified by `subjectId`.
///
/// Usage: `ref.watch(subjectMaterialsProvider('1'))` → `List<LectureMaterial>`
final subjectMaterialsProvider =
    Provider.family<List<LectureMaterial>, String>((ref, subjectId) {
  return ref.watch(allMaterialsProvider)[subjectId] ?? const [];
});
