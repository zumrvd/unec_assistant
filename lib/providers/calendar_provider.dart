import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repository_providers.dart';
import '../models/calendar_event.dart';
import '../utils/subject_event_link.dart';

/// Manages the full semester event list.
///
/// On initialisation the notifier fetches the schedule from
/// [ScheduleRepository] via [scheduleRepositoryProvider]. User-created
/// personal events (add / edit / delete) are applied as pure state mutations
/// on top of the server-sourced baseline — they are not written back to the
/// repository (personal event persistence is a separate concern).
class CalendarEventsNotifier extends Notifier<List<CalendarEvent>> {
  @override
  List<CalendarEvent> build() {
    Future.microtask(_loadSchedule);
    return const [];
  }

  // ---------------------------------------------------------------------------
  // Internal load / reload
  // ---------------------------------------------------------------------------

  Future<void> _loadSchedule() async {
    try {
      final repo = ref.read(scheduleRepositoryProvider);
      final events = await repo.fetchSemesterSchedule(kCurrentSemesterId);
      state = List<CalendarEvent>.from(events);
    } catch (e, st) {
      debugPrint('CalendarEventsNotifier._loadSchedule error: $e\n$st');
      // Keep current state (may be empty on first load; screen shows empty calendar).
    }
  }

  // ---------------------------------------------------------------------------
  // User-facing mutations (personal events only — not persisted to repo)
  // ---------------------------------------------------------------------------

  void addEvent(CalendarEvent event) {
    state = [...state, withResolvedSubjectId(event)];
  }

  void updateEvent(CalendarEvent event) {
    final linked = withResolvedSubjectId(event);
    state = [
      for (final e in state)
        if (e.id == linked.id) linked else e,
    ];
  }

  void healSubjectLinks() {
    var changed = false;
    final healed = <CalendarEvent>[];
    for (final e in state) {
      final next = withResolvedSubjectId(e);
      if (next.subjectId != e.subjectId) changed = true;
      healed.add(next);
    }
    if (changed) state = healed;
  }

  void deleteEvent(String id) {
    state = state.where((e) => e.id != id).toList();
  }

  // ---------------------------------------------------------------------------
  // Query helpers
  // ---------------------------------------------------------------------------

  List<CalendarEvent> getEventsForDay(DateTime day) {
    final d = normalizeDay(day);
    return (state.where((e) {
      final start = e.startDay;
      final end = e.endDay;
      return !d.isBefore(start) && !d.isAfter(end);
    }).toList()
      ..sort((a, b) => a.startTime.compareTo(b.startTime)));
  }

  // ---------------------------------------------------------------------------
  // Bulk replacement / reload
  // ---------------------------------------------------------------------------

  /// Replaces the entire event list.
  ///
  /// Useful for injecting a fully resolved list from an external source
  /// (e.g. a one-time migration or import flow).
  void replaceAll(List<CalendarEvent> events) {
    state = List<CalendarEvent>.from(events);
  }

  /// Re-fetches the semester schedule from the repository.
  ///
  /// Previously `regenerateSemester({startDate, numberOfWeeks})` — the
  /// generation parameters are now encapsulated inside the repository
  /// implementation and are not a concern of the notifier.
  Future<void> regenerateSemester() => _loadSchedule();
}

final calendarEventsProvider =
    NotifierProvider<CalendarEventsNotifier, List<CalendarEvent>>(
  CalendarEventsNotifier.new,
);

/// Convenience: events for a specific day from the notifier.
List<CalendarEvent> eventsForDay(WidgetRef ref, DateTime day) {
  return ref.read(calendarEventsProvider.notifier).getEventsForDay(day);
}
