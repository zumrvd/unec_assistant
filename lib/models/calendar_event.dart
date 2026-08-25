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
    this.subjectId,
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

  /// Links this event to a registered [SubjectDetail.subjectId].
  /// Null for personal events and user-created class-like events without a real subject.
  final String? subjectId;

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
    String? subjectId,
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
      subjectId: subjectId ?? this.subjectId,
    );
  }

  static String _pad(int n) => n.toString().padLeft(2, '0');
}

bool isSameCalendarDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

DateTime normalizeDay(DateTime d) => DateTime(d.year, d.month, d.day);

// kTwoWeekTemplate has moved to lib/data/mock_schedule_repository.dart.
// It is mock/data-layer concern and does not belong in the domain model.

final DateTime kHbdDate = DateTime(2026, 9, 16);
