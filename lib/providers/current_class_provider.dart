import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/calendar_event.dart';
import '../models/lecture_material.dart';
import '../models/subject_detail.dart';
import '../providers/calendar_provider.dart';
import '../providers/materials_provider.dart';
import '../providers/subject_detail_provider.dart';
import '../utils/subject_event_link.dart';
import 'time_provider.dart';

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

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

/// Returns the most recent lecture with a non-empty bundle for [subjectId],
/// or the last lecture if none have a bundle, or null if the list is empty.
///
/// [allMaterials] is injected by [currentClassProvider] to avoid a
/// direct dependency on the compile-time constant map.
LectureMaterial? resolveRelevantLecture(
  String subjectId,
  Map<String, List<LectureMaterial>> allMaterials,
) {
  final lectures = allMaterials[subjectId] ?? const <LectureMaterial>[];
  if (lectures.isEmpty) return null;
  for (var i = lectures.length - 1; i >= 0; i--) {
    if (lectures[i].bundleFileName.isNotEmpty) return lectures[i];
  }
  return lectures.last;
}

TrackedClass? _trackedFromEvent(
  CalendarEvent event,
  List<SubjectDetail> subjects,
  Map<String, List<LectureMaterial>> allMaterials,
) {
  // Only real class sessions — never personal plans.
  if (event.type != EventType.classEvent) return null;

  final subject = resolveSubjectForEvent(event, subjects);
  if (subject == null) return null;

  return TrackedClass(
    subject: subject,
    event: event.subjectId == subject.subjectId
        ? event
        : event.copyWith(subjectId: subject.subjectId),
    lecture: resolveRelevantLecture(subject.subjectId, allMaterials),
  );
}

bool _isActiveNow(CalendarEvent event, DateTime now) {
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

// ---------------------------------------------------------------------------
// Provider
// ---------------------------------------------------------------------------

/// Resolves the live active class, or the next upcoming registered class
/// (today or a future day). Watches the same [calendarEventsProvider] as
/// Schedule, and [allMaterialsProvider] to resolve the relevant lecture.
final currentClassProvider = Provider<CurrentClassState>((ref) {
  final nowAsync = ref.watch(nowTickerProvider);
  final now = nowAsync.maybeWhen(
    data: (d) => d,
    orElse: () => ref.read(nowProvider),
  );

  final subjects = ref.watch(allSubjectsProvider);
  final allEvents = ref.watch(calendarEventsProvider);
  final allMaterials = ref.watch(allMaterialsProvider);

  final tracked = <TrackedClass>[];
  for (final e in allEvents) {
    final t = _trackedFromEvent(e, subjects, allMaterials);
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
      next = t;
      break;
    }
  }

  return CurrentClassState(
    activeClass: active,
    nextClass: next,
    nextWhen:
        next != null ? _whenFor(next.event.startTime, now) : NextClassWhen.today,
  );
});
