import '../models/lecture_material.dart';

/// Contract for teaching materials (lectures, presentations, quizzes, etc.)
/// associated with a student's enrolled subjects.
///
/// ## API integration
/// Implement this interface in a concrete `ApiMaterialsRepository`, then
/// swap the provider binding in `lib/data/repository_providers.dart`.
/// No provider, notifier, or screen file needs to change.
///
/// ## Questions to resolve with the UNEC API team before implementing
/// - Do materials have a direct download URL, or a short-lived redirect token
///   that must be exchanged before the file can be downloaded?
/// - Are materials grouped by lecture number on the API, or returned as a
///   flat list that the client must group?
/// - Is there a webhook / server-sent event for new material uploads, or
///   does the client need to poll?
abstract class MaterialsRepository {
  /// Returns all lecture materials for a single subject identified by
  /// [subjectId], grouped by lecture number.
  ///
  /// Result is ordered by lecture number ascending.
  Future<List<LectureMaterial>> fetchMaterialsForSubject(String subjectId);

  /// Returns materials for all subjects enrolled in [semesterId], keyed by
  /// `subjectId`.
  ///
  /// Prefer this over multiple [fetchMaterialsForSubject] calls to avoid
  /// N+1 API requests. The mock returns in-memory data with no latency.
  Future<Map<String, List<LectureMaterial>>> fetchAllMaterials(String semesterId);
}
