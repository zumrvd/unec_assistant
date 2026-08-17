import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unec_assistant/models/calendar_event.dart';
import 'package:unec_assistant/utils/subject_event_link.dart';

class CalendarEventsNotifier extends Notifier<List<CalendarEvent>> {
  @override
  List<CalendarEvent> build() {
    return generateSemesterSchedule(
      startDate: DateTime(2026, 9, 15),
      numberOfWeeks: 15,
    );
  }

  /// Projects the 2-week (Week A / Week B) template across [numberOfWeeks].
  /// Template day offsets 0–6 = ust hefte (A), 7–13 = alt hefte (Week B).
  List<CalendarEvent> generateSemesterSchedule({
    required DateTime startDate,
    required int numberOfWeeks,
    List<CalendarEvent>? template,
  }) {
    final base = normalizeDay(startDate);
    final mondayOfBase = base.subtract(Duration(days: base.weekday - 1));

    final tpl = template ?? kTwoWeekTemplate;
    final generated = <CalendarEvent>[];
    final cycles = (numberOfWeeks / 2).ceil();

    final templateAnchor = DateTime(2026, 1, 5);

    for (var cycle = 0; cycle < cycles; cycle++) {
      final cycleStart = mondayOfBase.add(Duration(days: cycle * 14));
      for (final event in tpl) {
        final templateDay = normalizeDay(
          event.startTime,
        ).difference(templateAnchor).inDays;
        final duration = event.endTime.difference(event.startTime);
        final start = DateTime(
          cycleStart.year,
          cycleStart.month,
          cycleStart.day + templateDay,
          event.startTime.hour,
          event.startTime.minute,
        );

        if (start.isBefore(base)) continue;

        final end = start.add(duration);
        generated.add(
          event.copyWith(
            id: '${event.id}-c$cycle-${start.millisecondsSinceEpoch}',
            startTime: start,
            endTime: end,
            timeRange: event.displayTimeRange,
            isRecurring: true,
          ),
        );
      }
    }

    generated.addAll(_demoOneOffs());
    return generated;
  }

  List<CalendarEvent> _demoOneOffs() {
    return [
      CalendarEvent(
        id: 'personal-nov-16',
        title: 'Kitabxana sessiyası',
        subtype: 'Personal',
        location: 'Kitabxana',
        startTime: DateTime(2026, 11, 25, 15, 0),
        endTime: DateTime(2026, 11, 25, 16, 30),
        type: EventType.personalEvent,
        isRecurring: false,
      ),
    ];
  }

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

  List<CalendarEvent> getEventsForDay(DateTime day) {
    final d = normalizeDay(day);
    final matches = state.where((e) {
      final start = e.startDay;
      final end = e.endDay;
      return !d.isBefore(start) && !d.isAfter(end);
    }).toList()..sort((a, b) => a.startTime.compareTo(b.startTime));
    return matches;
  }

  void replaceAll(List<CalendarEvent> events) {
    state = List<CalendarEvent>.from(events);
  }

  void regenerateSemester({
    required DateTime startDate,
    required int numberOfWeeks,
  }) {
    state = generateSemesterSchedule(
      startDate: startDate,
      numberOfWeeks: numberOfWeeks,
    );
  }
}

final calendarEventsProvider =
    NotifierProvider<CalendarEventsNotifier, List<CalendarEvent>>(
      CalendarEventsNotifier.new,
    );

/// Convenience: events for a specific day from the notifier.
List<CalendarEvent> eventsForDay(WidgetRef ref, DateTime day) {
  return ref.read(calendarEventsProvider.notifier).getEventsForDay(day);
}
