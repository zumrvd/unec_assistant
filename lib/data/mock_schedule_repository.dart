import '../models/calendar_event.dart';
import 'schedule_repository.dart';

/// In-memory implementation of [ScheduleRepository].
///
/// Contains the 2-week repeating schedule template and the semester-expansion
/// algorithm previously living as an instance method on
/// `CalendarEventsNotifier` in `calendar_provider.dart`.
///
/// ## Swapping to the real API
/// Replace this class with `ApiScheduleRepository` in
/// `lib/data/repository_providers.dart`. No provider, notifier, or screen
/// file needs to change.
class MockScheduleRepository implements ScheduleRepository {
  // -------------------------------------------------------------------------
  // 2-week template (previously kTwoWeekTemplate in calendar_event.dart)
  // -------------------------------------------------------------------------

  /// Builds the repeating two-week class template anchored to 5 Jan 2026.
  ///
  /// Days 0–6 = Week A, days 7–13 = Week B. Times of day are preserved when
  /// the template is projected across the real semester dates.
  List<CalendarEvent> _buildTemplate() {
    DateTime t(int dayOffset, int h, int m) =>
        DateTime(2026, 1, 5 + dayOffset, h, m);

    return [
      // ── Week A ─────────────────────────────────────────────────────────
      // Monday (0)
      CalendarEvent(id: 'tpl-a-mon-1', title: 'Programlaşdırmanın əsasları',          subtype: 'Mühazirə',   location: 'Room 117', startTime: t(0, 9,  0),  endTime: t(0, 10, 20), type: EventType.classEvent, isRecurring: true, subjectId: '1'),
      CalendarEvent(id: 'tpl-a-mon-2', title: 'Xətti cəbr və analitik həndəsə',       subtype: 'Seminar',    location: 'Room 316', startTime: t(0, 10, 30), endTime: t(0, 11, 50), type: EventType.classEvent, isRecurring: true, subjectId: '4'),
      CalendarEvent(id: 'tpl-a-mon-3', title: 'Fizika',                               subtype: 'Mühazirə',   location: 'Room 336', startTime: t(0, 12, 0),  endTime: t(0, 13, 20), type: EventType.classEvent, isRecurring: true, subjectId: '2'),
      // Wednesday (2)
      CalendarEvent(id: 'tpl-a-wed-1', title: 'ADIAK',                                subtype: 'Seminar',    location: 'Online',   startTime: t(2, 10, 30), endTime: t(2, 11, 50), type: EventType.classEvent, isRecurring: true, subjectId: '3'),
      CalendarEvent(id: 'tpl-a-wed-2', title: 'ADIAK',                                subtype: 'Seminar',    location: 'Online',   startTime: t(2, 12, 0),  endTime: t(2, 13, 20), type: EventType.classEvent, isRecurring: true, subjectId: '3'),
      // Thursday (3)
      CalendarEvent(id: 'tpl-a-thu-1', title: 'Informasiya texnologiyalarının əsasları', subtype: 'Mühazirə', location: 'Room 336', startTime: t(3, 9,  0),  endTime: t(3, 10, 20), type: EventType.classEvent, isRecurring: true, subjectId: '5'),
      CalendarEvent(id: 'tpl-a-thu-2', title: 'XDIAK',                                subtype: 'Seminar',    location: 'Room 415', startTime: t(3, 10, 30), endTime: t(3, 11, 50), type: EventType.classEvent, isRecurring: true, subjectId: '6'),
      CalendarEvent(id: 'tpl-a-thu-3', title: 'Informasiya texnologiyalarının əsasları', subtype: 'Seminar',  location: 'Room 316', startTime: t(3, 12, 0),  endTime: t(3, 13, 20), type: EventType.classEvent, isRecurring: true, subjectId: '5'),
      // Friday (4)
      CalendarEvent(id: 'tpl-a-fri-1', title: 'Xətti cəbr və analitik həndəsə',       subtype: 'Mühazirə',   location: 'Room 236', startTime: t(4, 9,  0),  endTime: t(4, 10, 20), type: EventType.classEvent, isRecurring: true, subjectId: '4'),
      CalendarEvent(id: 'tpl-a-fri-2', title: 'XDIAK',                                subtype: 'Seminar',    location: 'Room 222', startTime: t(4, 10, 30), endTime: t(4, 11, 50), type: EventType.classEvent, isRecurring: true, subjectId: '6'),
      CalendarEvent(id: 'tpl-a-fri-3', title: 'Programlaşdırmanın əsasları',          subtype: 'Seminar',    location: 'Room 32',  startTime: t(4, 12, 0),  endTime: t(4, 13, 20), type: EventType.classEvent, isRecurring: true, subjectId: '1'),

      // ── Week B ─────────────────────────────────────────────────────────
      // Monday (7)
      CalendarEvent(id: 'tpl-b-mon-1', title: 'Programlaşdırmanın əsasları',          subtype: 'Mühazirə',   location: 'Room 117', startTime: t(7,  9,  0),  endTime: t(7,  10, 20), type: EventType.classEvent, isRecurring: true, subjectId: '1'),
      CalendarEvent(id: 'tpl-b-mon-2', title: 'Fizika',                               subtype: 'Laboratoriya', location: 'Room 335', startTime: t(7,  10, 30), endTime: t(7,  11, 50), type: EventType.classEvent, isRecurring: true, subjectId: '2'),
      CalendarEvent(id: 'tpl-b-mon-3', title: 'Fizika',                               subtype: 'Mühazirə',   location: 'Room 336', startTime: t(7,  12, 0),  endTime: t(7,  13, 20), type: EventType.classEvent, isRecurring: true, subjectId: '2'),
      // Wednesday (9)
      CalendarEvent(id: 'tpl-b-wed-1', title: 'ADIAK',                                subtype: 'Seminar',    location: 'Online',   startTime: t(9,  10, 30), endTime: t(9,  11, 50), type: EventType.classEvent, isRecurring: true, subjectId: '3'),
      CalendarEvent(id: 'tpl-b-wed-2', title: 'ADIAK',                                subtype: 'Seminar',    location: 'Online',   startTime: t(9,  12, 0),  endTime: t(9,  13, 20), type: EventType.classEvent, isRecurring: true, subjectId: '3'),
      // Thursday (10)
      CalendarEvent(id: 'tpl-b-thu-1', title: 'Informasiya texnologiyalarının əsasları', subtype: 'Mühazirə', location: 'Room 336', startTime: t(10, 9,  0),  endTime: t(10, 10, 20), type: EventType.classEvent, isRecurring: true, subjectId: '5'),
      CalendarEvent(id: 'tpl-b-thu-2', title: 'XDIAK',                                subtype: 'Seminar',    location: 'Room 415', startTime: t(10, 10, 30), endTime: t(10, 11, 50), type: EventType.classEvent, isRecurring: true, subjectId: '6'),
      CalendarEvent(id: 'tpl-b-thu-3', title: 'Informasiya texnologiyalarının əsasları', subtype: 'Seminar',  location: 'Room 316', startTime: t(10, 12, 0),  endTime: t(10, 13, 20), type: EventType.classEvent, isRecurring: true, subjectId: '5'),
      // Friday (11)
      CalendarEvent(id: 'tpl-b-fri-1', title: 'Xətti cəbr və analitik həndəsə',       subtype: 'Mühazirə',   location: 'Room 236', startTime: t(11, 9,  0),  endTime: t(11, 10, 20), type: EventType.classEvent, isRecurring: true, subjectId: '4'),
      CalendarEvent(id: 'tpl-b-fri-3', title: 'Programlaşdırmanın əsasları',          subtype: 'Seminar',    location: 'Room 32',  startTime: t(11, 12, 0),  endTime: t(11, 13, 20), type: EventType.classEvent, isRecurring: true, subjectId: '1'),
    ];
  }

  // -------------------------------------------------------------------------
  // Schedule generation (previously CalendarEventsNotifier.generateSemesterSchedule)
  // -------------------------------------------------------------------------

  /// Projects the 2-week template across [numberOfWeeks] starting from
  /// [startDate], returning fully-expanded individual [CalendarEvent] objects.
  List<CalendarEvent> _generate({
    required DateTime startDate,
    required int numberOfWeeks,
  }) {
    final base = normalizeDay(startDate);
    final mondayOfBase = base.subtract(Duration(days: base.weekday - 1));
    final template = _buildTemplate();
    final generated = <CalendarEvent>[];
    final cycles = (numberOfWeeks / 2).ceil();
    final templateAnchor = DateTime(2026, 1, 5);

    for (var cycle = 0; cycle < cycles; cycle++) {
      final cycleStart = mondayOfBase.add(Duration(days: cycle * 14));
      for (final event in template) {
        final templateDay =
            normalizeDay(event.startTime).difference(templateAnchor).inDays;
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
        generated.add(event.copyWith(
          id: '${event.id}-c$cycle-${start.millisecondsSinceEpoch}',
          startTime: start,
          endTime: end,
          timeRange: event.displayTimeRange,
          isRecurring: true,
        ));
      }
    }

    generated.addAll(_oneOffEvents());
    return generated;
  }

  /// One-off personal/demo events appended to the semester schedule.
  List<CalendarEvent> _oneOffEvents() {
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

  // -------------------------------------------------------------------------
  // ScheduleRepository implementation
  // -------------------------------------------------------------------------

  @override
  Future<List<CalendarEvent>> fetchSemesterSchedule(String semesterId) async {
    // Mock: semester ID is ignored; returns Fall 2025 schedule.
    // Future.value is used intentionally — no I/O, so no artificial delay.
    return _generate(startDate: DateTime(2026, 9, 15), numberOfWeeks: 15);
  }

  @override
  Future<List<CalendarEvent>> fetchEventsForDateRange(
    String semesterId, {
    required DateTime from,
    required DateTime to,
  }) async {
    final all = await fetchSemesterSchedule(semesterId);
    return all.where((e) {
      return !e.startTime.isBefore(from) && !e.startTime.isAfter(to);
    }).toList();
  }

  @override
  Future<List<CalendarEvent>> fetchExamEvents(String semesterId) async {
    final all = await fetchSemesterSchedule(semesterId);
    return all.where((e) => e.type == EventType.exam).toList();
  }
}
