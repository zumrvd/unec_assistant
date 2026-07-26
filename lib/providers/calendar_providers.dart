import 'package:flutter_riverpod/flutter_riverpod.dart';

enum EventType { classEvent, personalEvent }

class CalendarEvent {
  final String title;
  final String subtype;
  final String location;
  final String timeRange;
  final int startHour;
  final int startMinute;
  final int endHour;
  final int endMinute;
  final EventType type;
  final DateTime date;

  const CalendarEvent({
    required this.title,
    required this.subtype,
    required this.location,
    required this.timeRange,
    required this.startHour,
    required this.startMinute,
    required this.endHour,
    required this.endMinute,
    required this.type,
    required this.date,
  });
}

final DateTime kHbdDate = DateTime(2026, 11, 16);

final List<CalendarEvent> kScheduleEvents = [
  CalendarEvent(
    title: 'Programlaşdırmanın əsasları',
    subtype: 'Mühazirə',
    location: 'Room 316',
    timeRange: '09:00-10:20',
    startHour: 9,
    startMinute: 0,
    endHour: 10,
    endMinute: 20,
    type: EventType.classEvent,
    date: DateTime(2026, 11, 16),
  ),
  CalendarEvent(
    title: 'Xətti cəbr və analitik həndəsə',
    subtype: 'Seminar',
    location: 'Room 316',
    timeRange: '11:00-12:20',
    startHour: 10,
    startMinute: 30,
    endHour: 11,
    endMinute: 50,
    type: EventType.classEvent,
    date: DateTime(2026, 11, 17),
  ),
  CalendarEvent(
    title: 'Fizika',
    subtype: 'Mühazirə',
    location: 'Room 336',
    timeRange: '09:00-10:20',
    startHour: 12,
    startMinute: 0,
    endHour: 13,
    endMinute: 20,
    type: EventType.classEvent,
    date: DateTime(2026, 11, 16),
  ),
  CalendarEvent(
    title: 'Layihə görüşü',
    subtype: 'Personal',
    location: 'Kitabxana',
    timeRange: '09:00-10:20',
    startHour: 9,
    startMinute: 0,
    endHour: 10,
    endMinute: 0,
    type: EventType.personalEvent,
    date: DateTime(2026, 11, 14),
  ),
  CalendarEvent(
    title: 'Proqramlaşdırmanın əsasları',
    subtype: 'Mühazirə',
    location: 'Room 316',
    timeRange: '09:00-10:20',
    startHour: 9,
    startMinute: 0,
    endHour: 10,
    endMinute: 20,
    type: EventType.classEvent,
    date: DateTime(2026, 11, 22),
  ),
  CalendarEvent(
    title: 'Xətti cəbr və analitik həndəsə',
    subtype: 'Seminar',
    location: 'Room 316',
    timeRange: '11:00-12:20',
    startHour: 10,
    startMinute: 30,
    endHour: 11,
    endMinute: 50,
    type: EventType.classEvent,
    date: DateTime(2026, 11, 22),
  ),
  CalendarEvent(
    title: 'Informasiya texnologiyalarının əsasları',
    subtype: 'Mühazirə',
    location: 'Room 336',
    timeRange: '09:00-10:20',
    startHour: 9,
    startMinute: 0,
    endHour: 10,
    endMinute: 20,
    type: EventType.classEvent,
    date: DateTime(2026, 11, 17),
  ),
  CalendarEvent(
    title: 'ADIAK',
    subtype: 'Mühazirə',
    location: 'Online',
    timeRange: '09:00-10:20',
    startHour: 9,
    startMinute: 0,
    endHour: 10,
    endMinute: 20,
    type: EventType.classEvent,
    date: DateTime(2026, 11, 17),
  ),
  CalendarEvent(
    title: 'Informasiya texnologiyalarının əsasları',
    subtype: 'Seminar',
    location: 'Room 336',
    timeRange: '13:00-14:20',
    startHour: 13,
    startMinute: 0,
    endHour: 14,
    endMinute: 20,
    type: EventType.classEvent,
    date: DateTime(2026, 11, 17),
  ),
  CalendarEvent(
    title: 'ADIAK',
    subtype: 'Mühazirə',
    location: 'Online',
    timeRange: '09:00-10:20',
    startHour: 9,
    startMinute: 0,
    endHour: 10,
    endMinute: 20,
    type: EventType.classEvent,
    date: DateTime(2026, 11, 18),
  ),
  CalendarEvent(
    title: 'XDIAK',
    subtype: 'Seminar',
    location: 'Room 415',
    timeRange: '11:00-12:20',
    startHour: 11,
    startMinute: 0,
    endHour: 12,
    endMinute: 20,
    type: EventType.classEvent,
    date: DateTime(2026, 11, 18),
  ),
  CalendarEvent(
    title: 'Azərbaycan dili',
    subtype: 'Seminar',
    location: 'Room 316',
    timeRange: '09:00-10:20',
    startHour: 9,
    startMinute: 0,
    endHour: 10,
    endMinute: 20,
    type: EventType.classEvent,
    date: DateTime(2026, 11, 19),
  ),
];

final calendarEventsProvider = Provider<List<CalendarEvent>>((ref) {
  return kScheduleEvents;
});
