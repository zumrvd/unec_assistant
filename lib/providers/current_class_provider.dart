import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unec_assistant/models/calendar_event.dart';
import 'package:unec_assistant/models/lecture_material.dart';
import 'package:unec_assistant/models/subject_detail.dart';
import 'package:unec_assistant/providers/calendar_provider.dart';
import 'package:unec_assistant/providers/materials_provider.dart';
import 'package:unec_assistant/providers/subject_detail_provider.dart';
import 'package:unec_assistant/utils/subject_event_link.dart';

/// Ticks once per minute so active/upcoming resolution stays current.
final nowTickerProvider = StreamProvider<DateTime>((ref) async* {
  yield DateTime.now();
  await for (final _ in Stream.periodic(const Duration(minutes: 1))) {
    yield DateTime.now();
  }
});

/// Relative day of an upcoming class vs "now".
enum NextClassWhen { today, tomorrow, later }

/// A resolved trackable class: registered subject + its calendar event + materials.
class TrackedClass {
  const TrackedClass({
    required this.subject,
    required this.event,
    this.lecture,
  });

  final SubjectDetail subject;
  final CalendarEvent event;
  final LectureMaterial? lecture;
}

class CurrentClassState {
  const CurrentClassState({
    this.activeClass,
    this.nextClass,
    this.nextWhen = NextClassWhen.today,
  });

  final TrackedClass? activeClass;
  final TrackedClass? nextClass;

  /// Only meaningful when [nextClass] is non-null and there is no [activeClass].
  final NextClassWhen nextWhen;

  bool get hasActive => activeClass != null;
  bool get hasNext => nextClass != null;
  bool get isEmpty => activeClass == null && nextClass == null;
}

/// Prefer the most recently listed lecture with a non-empty bundle; else last lecture.
LectureMaterial? resolveRelevantLecture(String subjectId) {
  final lectures = kSubjectLecturesMap[subjectId] ?? const <LectureMaterial>[];
  if (lectures.isEmpty) return null;
  for (var i = lectures.length - 1; i >= 0; i--) {
    if (lectures[i].bundleFileName.isNotEmpty) return lectures[i];
  }
  return lectures.last;
}

TrackedClass? _trackedFromEvent(
  CalendarEvent event,
  List<SubjectDetail> subjects,
) {
  // Only real class sessions — never personal plans, even if titled like a subject.
  if (event.type != EventType.classEvent) return null;

  final subject = resolveSubjectForEvent(event, subjects);
  if (subject == null) return null;

  return TrackedClass(
    subject: subject,
    event: event.subjectId == subject.subjectId
        ? event
        : event.copyWith(subjectId: subject.subjectId),
    lecture: resolveRelevantLecture(subject.subjectId),
  );
}

bool _isActiveNow(CalendarEvent event, DateTime now) {
  // Inclusive range — matches TodaysEventsCard's minute-of-day intent for same-day
  // events, and correctly handles overnight / multi-hour spans.
  return !now.isBefore(event.startTime) && !now.isAfter(event.endTime);
}

NextClassWhen _whenFor(DateTime eventStart, DateTime now) {
  final eventDay = normalizeDay(eventStart);
  final today = normalizeDay(now);
  final diff = eventDay.difference(today).inDays;
  if (diff <= 0) return NextClassWhen.today;
  if (diff == 1) return NextClassWhen.tomorrow;
  return NextClassWhen.later;
}

/// Resolves the live active class, or the next upcoming registered class
/// (today or a future day). Watches the same [calendarEventsProvider] as Schedule.
final currentClassProvider = Provider<CurrentClassState>((ref) {
  final nowAsync = ref.watch(nowTickerProvider);
  final now = nowAsync.when(
    data: (d) => d,
    loading: () => DateTime.now(),
    error: (_, _) => DateTime.now(),
  );
  final subjects = ref.watch(allSubjectsProvider);
  final allEvents = ref.watch(calendarEventsProvider);

  final tracked = <TrackedClass>[];
  for (final e in allEvents) {
    final t = _trackedFromEvent(e, subjects);
    if (t != null) tracked.add(t);
  }
  tracked.sort((a, b) => a.event.startTime.compareTo(b.event.startTime));

  TrackedClass? active;
  for (final t in tracked) {
    if (_isActiveNow(t.event, now)) {
      active = t;
      break;
    }
  }

  TrackedClass? next;
  for (final t in tracked) {
    if (t.event.startTime.isAfter(now)) {
      // If something is active, "next" is the first start after now
      // (may still be useful; screen uses it only when inactive).
      next = t;
      break;
    }
  }

  return CurrentClassState(
    activeClass: active,
    nextClass: next,
    nextWhen: next != null ? _whenFor(next.event.startTime, now) : NextClassWhen.today,
  );
});
