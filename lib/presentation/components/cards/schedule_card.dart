import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unec_assistant/models/calendar_event.dart';
import 'package:unec_assistant/presentation/components/cards/calendar_card.dart';
import 'package:unec_assistant/providers/calendar_provider.dart';

class ScheduleCard extends ConsumerWidget {
  const ScheduleCard({super.key});

  static const _borderColor = Color(0xFFE0E4F0);
  static const _labelGrey = Color(0xFF838A97);
  static const _valueBlack = Color(0xFF1F1F1F);
  
  static const _personalYellow = Color(0xFFE3993C);
  static const _examGreen = Color(0xFF0F6E56);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = DateTime.now();
    final events = ref.watch(calendarEventsProvider);
    
    // Filter for upcoming personal events and exams
    final upcomingEvents = events.where((e) {
      return (e.type == EventType.personalEvent || e.type == EventType.exam) &&
             e.endTime.isAfter(now);
    }).toList();

    // Sort by start time
    upcomingEvents.sort((a, b) => a.startTime.compareTo(b.startTime));

    final bool hasEvent = upcomingEvents.isNotEmpty;
    final firstEvent = hasEvent ? upcomingEvents.first : null;
    final isExam = firstEvent?.type == EventType.exam;
    final accentColor = isExam ? _examGreen : _personalYellow;
    final isActive = firstEvent != null && now.isAfter(firstEvent.startTime) && now.isBefore(firstEvent.endTime);

    // Stability Label for AXTree
    final String semanticLabel = firstEvent != null 
        ? "Upcoming ${isExam ? 'Exam' : 'Personal Plan'}: ${firstEvent.title}, ${_formatDate(firstEvent.startTime)} at ${firstEvent.displayTimeRange}"
        : "";

    return Visibility(
      visible: hasEvent,
      maintainState: true,
      child: Column(
        children: [
          const SizedBox(height: 10),
          Semantics(
            container: true,
            button: true,
            label: semanticLabel,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  // Micro-delay to allow UI tree to settle
                  Future.delayed(Duration.zero, () {
                    if (context.mounted && firstEvent != null) {
                      context.go(
                        '/functions/schedule_function',
                        extra: {
                          'initialDate': firstEvent.startTime,
                          'initialView': CalendarView.day,
                          'scrollToTime': TimeOfDay.fromDateTime(firstEvent.startTime),
                        },
                      );
                    }
                  });
                },
                borderRadius: BorderRadius.circular(18),
                child: Container(
                  width: 330,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: _borderColor,
                      width: 1,
                    ),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: ExcludeSemantics(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header (Subject Name + Pill)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 10,
                                    height: 10,
                                    decoration: BoxDecoration(
                                      color: accentColor,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      isExam ? 'Upcoming Exam' : 'Personal Plan',
                                      style: GoogleFonts.redditSans(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14,
                                        color: accentColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Row(
                              children: [
                                if (isActive) ...[
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFFE5E5),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      'ACTIVE',
                                      style: GoogleFonts.redditSans(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 9,
                                        color: const Color(0xFFF65959),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                ],
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: accentColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    _formatDate(firstEvent?.startTime ?? now),
                                    style: GoogleFonts.redditSans(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 10,
                                      color: accentColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Title
                        Text(
                          firstEvent?.title ?? "",
                          style: GoogleFonts.redditSans(
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                            color: _valueBlack,
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Info Card (Mirrored from Attendance)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8F9FC),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: const Color(0xFFE0E4F0), width: 1),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.access_time_rounded, size: 28, color: accentColor),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Time",
                                    style: GoogleFonts.redditSans(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 11,
                                      color: const Color(0xFF838A97),
                                      height: 1.1,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 15),
                              Container(width: 1, height: 40, color: const Color(0xFFE0E4F0)),
                              const SizedBox(width: 15),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      firstEvent?.displayTimeRange ?? "",
                                      style: GoogleFonts.redditSans(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16,
                                        color: const Color(0xFF1F1F1F),
                                      ),
                                    ),
                                    if (firstEvent?.location.isNotEmpty ?? false) ...[
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Icon(Icons.location_on_outlined, size: 12, color: _labelGrey),
                                          const SizedBox(width: 4),
                                          Expanded(
                                            child: Text(
                                              firstEvent?.location ?? "",
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.redditSans(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 12,
                                                color: _labelGrey,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    if (date.year == now.year && date.month == now.month && date.day == now.day) {
      return 'Today';
    }
    final tomorrow = now.add(const Duration(days: 1));
    if (date.year == tomorrow.year && date.month == tomorrow.month && date.day == tomorrow.day) {
      return 'Tomorrow';
    }
    return '${date.day} ${_getMonthName(date.month)}';
  }

  String _getMonthName(int month) {
    const names = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return names[month - 1];
  }
}
