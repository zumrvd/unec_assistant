import 'package:unec_assistant/models/calendar_event.dart';
import 'package:unec_assistant/models/subject_detail.dart';

/// Short titles used in the schedule template that differ from full
/// [SubjectDetail.subjectName]. Keyed by normalized title → subjectId.
const Map<String, String> kSubjectTitleAliases = {
  'adiak': '3',
  'xdiak': '6',
  'programlasdirmanin esaslari': '1',
  'fizika': '2',
  'xetti cebr ve analitik hendese': '4',
  'informasiya texnologiyalarinin esaslari': '5',
  'azerbaycan dilinde isguzar ve akademik kommunikasiya': '3',
  'xarici dilde isguzar ve akademik kommunikasiya': '6',
};

String normalizeSubjectTitle(String raw) {
  var s = raw.trim().toLowerCase();
  const map = {
    'ə': 'e',
    'ı': 'i',
    'İ': 'i',
    'i̇': 'i',
    'ö': 'o',
    'ü': 'u',
    'ç': 'c',
    'ş': 's',
    'ğ': 'g',
    'á': 'a',
  };
  map.forEach((from, to) {
    s = s.replaceAll(from, to);
  });
  // Collapse whitespace / punctuation noise for fuzzy equality.
  s = s.replaceAll(RegExp(r'[^a-z0-9]+'), ' ').trim();
  return s;
}

SubjectDetail? subjectById(
  String id, [
  List<SubjectDetail>? subjects,
]) {
  if (subjects == null) return null;
  for (final s in subjects) {
    if (s.subjectId == id) return s;
  }
  return null;
}

/// Resolves a registered subject for a calendar event.
///
/// Order:
/// 1. Explicit [CalendarEvent.subjectId] if it matches a registered subject
/// 2. Exact / alias / contains match on normalized title
///
/// A non-null [subjects] list is always required. Personal events and
/// unrecognized titles return null.
SubjectDetail? resolveSubjectForEvent(
  CalendarEvent event, [
  List<SubjectDetail>? subjects,
]) {
  if (subjects == null || subjects.isEmpty) return null;

  final explicit = event.subjectId;
  if (explicit != null) {
    final byId = subjectById(explicit, subjects);
    if (byId != null) return byId;
  }

  // Do not link personal events by title even if the title happens to match.
  if (event.type == EventType.personalEvent) return null;

  final normalized = normalizeSubjectTitle(event.title);
  if (normalized.isEmpty) return null;

  final aliasId = kSubjectTitleAliases[normalized];
  if (aliasId != null) {
    final byAlias = subjectById(aliasId, subjects);
    if (byAlias != null) return byAlias;
  }

  for (final s in subjects) {
    final name = normalizeSubjectTitle(s.subjectName);
    if (name == normalized) return s;
    // Truncated calendar labels ("Progra...", "Xətti cə...") or partial edits.
    if (name.startsWith(normalized) || normalized.startsWith(name)) return s;
    if (normalized.length >= 6 &&
        (name.contains(normalized) || normalized.contains(name))) {
      return s;
    }
  }

  return null;
}

String? resolveSubjectIdForEvent(
  CalendarEvent event, [
  List<SubjectDetail>? subjects,
]) {
  return resolveSubjectForEvent(event, subjects)?.subjectId;
}

/// Returns a copy of [event] with [subjectId] filled in when resolvable.
CalendarEvent withResolvedSubjectId(
  CalendarEvent event, [
  List<SubjectDetail>? subjects,
]) {
  if (subjects != null &&
      event.subjectId != null &&
      subjectById(event.subjectId!, subjects) != null) {
    return event;
  }
  // When subjectId is already set and no list is provided, trust the ID.
  if (subjects == null && event.subjectId != null) return event;

  final id = resolveSubjectIdForEvent(event, subjects);
  if (id == null || id == event.subjectId) return event;
  return event.copyWith(subjectId: id);
}
