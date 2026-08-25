import '../models/semester_summary.dart';
import '../models/subject_detail.dart';

/// Contract for all student academic data: enrolled subjects, grades,
/// and attendance records.
///
/// A single [SubjectDetail] is the canonical unit — it carries subject
/// metadata, grade breakdowns (seminar, midterm, final), and attendance
/// figures (`absencesUsed` / `absenceLimit`) in one coherent model.
///
/// ## API integration
/// Implement this interface in a concrete `ApiAcademicRepository`, then
/// swap the provider binding in `lib/data/repository_providers.dart`.
/// No provider, notifier, or screen file needs to change.
///
/// ## Questions to resolve with the UNEC API team before implementing
/// - Are grades returned as part of the course listing, or via a separate
///   `/grades` endpoint?
/// - Is attendance per session/slot, or as a subject-level total only?
/// - Does the API use a semester ID, or is "current semester" implicit per
///   authenticated session?
abstract class AcademicRepository {
  /// Returns all semesters available for the authenticated student,
  /// ordered with the most recent first.
  ///
  /// Use [SemesterSummary.semesterId] as the key in all other calls.
  /// The semester marked [SemesterSummary.isCurrent] is the default view.
  Future<List<SemesterSummary>> fetchSemesters();

  /// Returns all enrolled subjects for [semesterId], each including full
  /// grade breakdowns and attendance totals.
  Future<List<SubjectDetail>> fetchSubjects(String semesterId);

  /// Returns a single subject with full detail for [subjectId] in [semesterId].
  ///
  /// Useful for refreshing one subject's data (e.g. after a grade update
  /// notification) without re-fetching the entire list.
  Future<SubjectDetail> fetchSubjectById(String subjectId, String semesterId);
}
