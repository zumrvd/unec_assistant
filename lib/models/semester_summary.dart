/// Represents a single academic semester.
///
/// Used as a namespace key for all student data — subjects, grades, attendance,
/// schedule, and materials — so the app correctly handles multi-semester
/// history once the UNEC API provides it.
///
/// All repository methods that are semester-scoped accept a [semesterId] string
/// derived from a [SemesterSummary] returned by [AcademicRepository.fetchSemesters].
class SemesterSummary {
  const SemesterSummary({
    required this.semesterId,
    required this.label,
    required this.startDate,
    required this.endDate,
    required this.isCurrent,
  });

  /// Stable identifier used as the primary key in all repository calls.
  ///
  /// Convention: lowercase kebab-case matching the API's own naming.
  /// Examples: `"fall-2025"`, `"spring-2026"`.
  final String semesterId;

  /// Human-readable label shown in semester selectors.
  ///
  /// Example: `"FALL 2025"`, `"SPRING 2026"`.
  final String label;

  final DateTime startDate;
  final DateTime endDate;

  /// Whether this semester is the currently active one for the student.
  final bool isCurrent;
}
