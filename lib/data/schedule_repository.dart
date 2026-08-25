import '../models/calendar_event.dart';

/// Contract for the student's class schedule and exam timetable.
///
/// ## API integration
/// Implement this interface in a concrete `ApiScheduleRepository`, then
/// swap the provider binding in `lib/data/repository_providers.dart`.
/// No provider, notifier, or screen file needs to change.
///
/// ## Questions to resolve with the UNEC API team before implementing
/// - Does the schedule come as a recurring rule / 2-week template, or as
///   pre-expanded individual events for the full semester?
/// - Are exams on a separate endpoint (e.g. `/v1/exams`) or returned as
///   events of type `exam` within the schedule response?
/// - Are room/location changes pushed in real-time, or fetched on refresh?
abstract class ScheduleRepository {
  /// Returns all class events for [semesterId], fully expanded across the
  /// semester calendar (i.e. each individual class occurrence as a separate
  /// [CalendarEvent], not as a recurring rule).
  ///
  /// The mock implementation applies the 2-week template internally.
  /// A real API would return pre-expanded events directly.
  Future<List<CalendarEvent>> fetchSemesterSchedule(String semesterId);

  /// Returns only the events whose [CalendarEvent.startTime] falls within
  /// the inclusive range `[from, to]`.
  ///
  /// Intended for future paginated calendar views (e.g. month-by-month).
  /// The mock implementation filters the full semester list in memory.
  Future<List<CalendarEvent>> fetchEventsForDateRange(
    String semesterId, {
    required DateTime from,
    required DateTime to,
  });

  /// Returns only events of type [EventType.exam] for [semesterId].
  ///
  /// Exam events typically live on a dedicated endpoint in university APIs.
  Future<List<CalendarEvent>> fetchExamEvents(String semesterId);
}
