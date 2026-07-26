enum EventType { classEvent, personalEvent, exam }

class CalendarEvent {
  const CalendarEvent({
    required this.id,
    required this.title,
    required this.subtype,
    required this.location,
    required this.startTime,
    required this.endTime,
    required this.type,
    this.description = '',
    this.timeRange = '',
    this.isRecurring = false,
  });

  final String id;
  final String title;
  final String subtype;
  final String location;
  final String description;
  final DateTime startTime;
  final DateTime endTime;
  final EventType type;
  final String timeRange;
  final bool isRecurring;

  String get displayTimeRange {
    if (timeRange.isNotEmpty) return timeRange;
    return '${_pad(startTime.hour)}:${_pad(startTime.minute)}-'
        '${_pad(endTime.hour)}:${_pad(endTime.minute)}';
  }

  DateTime get startDay =>
      DateTime(startTime.year, startTime.month, startTime.day);

  DateTime get endDay => DateTime(endTime.year, endTime.month, endTime.day);

  bool get crossesMidnight => !isSameCalendarDay(startTime, endTime);

  CalendarEvent copyWith({
    String? id,
    String? title,
    String? subtype,
    String? location,
    String? description,
    DateTime? startTime,
    DateTime? endTime,
    EventType? type,
    String? timeRange,
    bool? isRecurring,
  }) {
    return CalendarEvent(
      id: id ?? this.id,
      title: title ?? this.title,
      subtype: subtype ?? this.subtype,
      location: location ?? this.location,
      description: description ?? this.description,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      type: type ?? this.type,
      timeRange: timeRange ?? this.timeRange,
      isRecurring: isRecurring ?? this.isRecurring,
    );
  }

  static String _pad(int n) => n.toString().padLeft(2, '0');
}

bool isSameCalendarDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

DateTime normalizeDay(DateTime d) => DateTime(d.year, d.month, d.day);

/// Template events for Week A (days 0–6) and Week B (days 7–13)
/// relative to a semester [startDate]. Times of day are preserved.
List<CalendarEvent> get kTwoWeekTemplate {
  DateTime t(int dayOffset, int h, int m) =>
      DateTime(2026, 1, 5 + dayOffset, h, m);

  return [
    // Week A — Mon (0)
    CalendarEvent(
      id: 'tpl-a-mon-1',
      title: 'Programlaşdırmanın əsasları',
      subtype: 'Mühazirə',
      location: 'Room 117',
      startTime: t(0, 9, 0),
      endTime: t(0, 10, 20),
      type: EventType.classEvent,
      isRecurring: true,
    ),
    CalendarEvent(
      id: 'tpl-a-mon-2',
      title: 'Xətti cəbr və analitik həndəsə',
      subtype: 'Seminar',
      location: 'Room 316',
      startTime: t(0, 10, 30),
      endTime: t(0, 11, 50),
      type: EventType.classEvent,
      isRecurring: true,
    ),
    CalendarEvent(
      id: 'tpl-a-mon-3',
      title: 'Fizika',
      subtype: 'Mühazirə',
      location: 'Room 336',
      startTime: t(0, 12, 0),
      endTime: t(0, 13, 20),
      type: EventType.classEvent,
      isRecurring: true,
    ),

    // Week A — Tue (1)

    // Week A — Wed (2)
    CalendarEvent(
      id: 'tpl-a-wed-1',
      title: 'ADIAK',
      subtype: 'Seminar',
      location: 'Online',
      startTime: t(2, 10, 30),
      endTime: t(2, 11, 50),
      type: EventType.classEvent,
      isRecurring: true,
    ),
    CalendarEvent(
      id: 'tpl-a-wed-2',
      title: 'ADIAK',
      subtype: 'Seminar',
      location: 'Online',
      startTime: t(2, 12, 0),
      endTime: t(2, 13, 20),
      type: EventType.classEvent,
      isRecurring: true,
    ),

    // Week A — Thu (3)
    CalendarEvent(
      id: 'tpl-a-thu-1',
      title: 'Informasiya texnologiyalarının əsasları',
      subtype: 'Mühazirə',
      location: 'Room 336',
      startTime: t(3, 9, 0),
      endTime: t(3, 10, 20),
      type: EventType.classEvent,
      isRecurring: true,
    ),
    CalendarEvent(
      id: 'tpl-a-thu-2',
      title: 'XDIAK',
      subtype: 'Seminar',
      location: 'Room 415',
      startTime: t(3, 10, 30),
      endTime: t(3, 11, 50),
      type: EventType.classEvent,
      isRecurring: true,
    ),
    CalendarEvent(
      id: 'tpl-a-thu-3',
      title: 'Informasiya texnologiyalarının əsasları',
      subtype: 'Seminar',
      location: 'Room 316',
      startTime: t(3, 12, 0),
      endTime: t(3, 13, 20),
      type: EventType.classEvent,
      isRecurring: true,
    ),

    // Week A — Fri (4)
    CalendarEvent(
      id: 'tpl-a-fri-1',
      title: 'Xətti cəbr və analitik həndəsə',
      subtype: 'Mühazirə',
      location: 'Room 236',
      startTime: t(4, 9, 0),
      endTime: t(4, 10, 20),
      type: EventType.classEvent,
      isRecurring: true,
    ),
    CalendarEvent(
      id: 'tpl-a-fri-2',
      title: 'XDIAK',
      subtype: 'Seminar',
      location: 'Room 222',
      startTime: t(4, 10, 30),
      endTime: t(4, 11, 50),
      type: EventType.classEvent,
      isRecurring: true,
    ),
    CalendarEvent(
      id: 'tpl-a-fri-3',
      title: 'Programlaşdırmanın əsasları',
      subtype: 'Seminar',
      location: 'Room 32',
      startTime: t(4, 12, 0),
      endTime: t(4, 13, 20),
      type: EventType.classEvent,
      isRecurring: true,
    ),


    // Week B — Mon (7)
    CalendarEvent(
      id: 'tpl-b-mon-1',
      title: 'Programlaşdırmanın əsasları',
      subtype: 'Mühazirə',
      location: 'Room 117',
      startTime: t(7, 9, 0),
      endTime: t(7, 10, 20),
      type: EventType.classEvent,
      isRecurring: true,
    ),
    CalendarEvent(
      id: 'tpl-b-mon-2',
      title: 'Fizika',
      subtype: 'Laboratoriya',
      location: 'Room 335',
      startTime: t(7, 10, 30),
      endTime: t(7, 11, 50),
      type: EventType.classEvent,
      isRecurring: true,
    ),
    CalendarEvent(
      id: 'tpl-b-mon-3',
      title: 'Fizika',
      subtype: 'Mühazirə',
      location: 'Room 336',
      startTime: t(7, 12, 0),
      endTime: t(7, 13, 20),
      type: EventType.classEvent,
      isRecurring: true,
    ),

    // Week B — Tue (8)

    // Week B — Wed (9)
    CalendarEvent(
      id: 'tpl-b-wed-1',
      title: 'ADIAK',
      subtype: 'Seminar',
      location: 'Online',
      startTime: t(9, 10, 30),
      endTime: t(9, 11, 50),
      type: EventType.classEvent,
      isRecurring: true,
    ),
    CalendarEvent(
      id: 'tpl-b-wed-2',
      title: 'ADIAK',
      subtype: 'Seminar',
      location: 'Online',
      startTime: t(9, 12, 0),
      endTime: t(9, 13, 20),
      type: EventType.classEvent,
      isRecurring: true,
    ),

    // Week B — Thu (10)
    CalendarEvent(
      id: 'tpl-b-thu-1',
      title: 'Informasiya texnologiyalarının əsasları',
      subtype: 'Mühazirə',
      location: 'Room 336',
      startTime: t(10, 9, 0),
      endTime: t(10, 10, 20),
      type: EventType.classEvent,
      isRecurring: true,
    ),
    CalendarEvent(
      id: 'tpl-b-thu-2',
      title: 'XDIAK',
      subtype: 'Seminar',
      location: 'Room 415',
      startTime: t(10, 10, 30),
      endTime: t(10, 11, 50),
      type: EventType.classEvent,
      isRecurring: true,
    ),
    CalendarEvent(
      id: 'tpl-a-thu-3',
      title: 'Informasiya texnologiyalarının əsasları',
      subtype: 'Seminar',
      location: 'Room 316',
      startTime: t(10, 12, 0),
      endTime: t(10, 13, 20),
      type: EventType.classEvent,
      isRecurring: true,
    ),

    // Week B — Fri (11)
    CalendarEvent(
      id: 'tpl-b-fri-1',
      title: 'Xətti cəbr və analitik həndəsə',
      subtype: 'Mühazirə',
      location: 'Room 236',
      startTime: t(11, 9, 0),
      endTime: t(11, 10, 20),
      type: EventType.classEvent,
      isRecurring: true,
    ),
    CalendarEvent(
      id: 'tpl-b-fri-3',
      title: 'Programlaşdırmanın əsasları',
      subtype: 'Seminar',
      location: 'Room 32',
      startTime: t(11, 12, 0),
      endTime: t(11, 13, 20),
      type: EventType.classEvent,
      isRecurring: true,
    ),
  ];
}

final DateTime kHbdDate = DateTime(2026, 9, 16);
