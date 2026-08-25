import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repository_providers.dart';
import '../models/subject_detail.dart';

// =============================================================================
// State + Notifier
// =============================================================================

/// Holds the academic data state for all enrolled subjects.
class AcademicState {
  const AcademicState({
    this.subjects = const [],
    this.isLoading = false,
    this.error,
  });

  final List<SubjectDetail> subjects;
  final bool isLoading;
  final String? error;

  AcademicState copyWith({
    List<SubjectDetail>? subjects,
    bool? isLoading,
    String? error,
  }) {
    return AcademicState(
      subjects: subjects ?? this.subjects,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Loads enrolled subjects (with grades and attendance) from
/// [AcademicRepository] and exposes them through the derived providers below.
///
/// Consumers use [allSubjectsProvider] or [attentionSubjectsProvider] rather
/// than watching this notifier directly, preserving the same public API
/// that all screens already consume.
class AcademicNotifier extends Notifier<AcademicState> {
  @override
  AcademicState build() {
    Future.microtask(_load);
    return const AcademicState(isLoading: true);
  }

  Future<void> _load() async {
    state = state.copyWith(isLoading: true);
    try {
      final repo = ref.read(academicRepositoryProvider);
      final subjects = await repo.fetchSubjects(kCurrentSemesterId);
      state = AcademicState(subjects: subjects, isLoading: false);
    } catch (e, st) {
      debugPrint('AcademicNotifier._load error: $e\n$st');
      state = AcademicState(error: e.toString(), isLoading: false);
    }
  }

  /// Force-refresh all subject data (grades, attendance, etc.).
  Future<void> refresh() => _load();
}

/// Root notifier provider. Prefer the derived providers below in UI code.
final academicNotifierProvider =
    NotifierProvider<AcademicNotifier, AcademicState>(AcademicNotifier.new);

// =============================================================================
// Derived providers — identical public API to what screens already consume
// =============================================================================

/// All enrolled subjects for the current semester, including grades and
/// attendance data.
///
/// Previously a `Provider<List<SubjectDetail>>` backed by compile-time
/// constants. Now reactive to [AcademicRepository] — screens are unchanged.
final allSubjectsProvider = Provider<List<SubjectDetail>>((ref) {
  return ref.watch(academicNotifierProvider).subjects;
});

/// Subjects that have crossed the attention threshold
/// (≥ 50 % of allowed absences used).
///
/// Previously derived from the const list. Now derived from [allSubjectsProvider]
/// which is itself repository-backed — screens are unchanged.
final attentionSubjectsProvider = Provider<List<SubjectDetail>>((ref) {
  return ref.watch(allSubjectsProvider).where((s) => s.needsAttention).toList();
});
