import 'package:unec_assistant/models/calendar_event.dart';
import 'package:unec_assistant/models/subject_detail.dart';
import 'package:unec_assistant/providers/subject_detail_provider.dart';

/// Canonical subjects used for calendar ↔ subject linking (base consts, no fileCount).
const List<SubjectDetail> kLinkableSubjects = [
  kProgDetail,
  kFizikaDetail,
  kAzDetail,
  kXettiDetail,
  kInfoDetail,
  kXariciDetail,
];

/// Short titles used in the schedule template that differ from full [SubjectDetail.subjectName].
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
  final list = subjects ?? kLinkableSubjects;
  for (final s in list) {
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
/// Personal events and unrecognized titles return null — never treat those as classes.
SubjectDetail? resolveSubjectForEvent(
  CalendarEvent event, [
  List<SubjectDetail>? subjects,
]) {
  final list = subjects ?? kLinkableSubjects;

  final explicit = event.subjectId;
  if (explicit != null) {
    final byId = subjectById(explicit, list);
    if (byId != null) return byId;
  }

  // Do not link personal events by title even if the title happens to match a subject.
  if (event.type == EventType.personalEvent) return null;

  final normalized = normalizeSubjectTitle(event.title);
  if (normalized.isEmpty) return null;

  final aliasId = kSubjectTitleAliases[normalized];
  if (aliasId != null) {
    final byAlias = subjectById(aliasId, list);
    if (byAlias != null) return byAlias;
  }

  for (final s in list) {
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
  if (event.subjectId != null &&
      subjectById(event.subjectId!, subjects) != null) {
    return event;
  }
  final id = resolveSubjectIdForEvent(event, subjects);
  if (id == null || id == event.subjectId) return event;
  return event.copyWith(subjectId: id);
}
