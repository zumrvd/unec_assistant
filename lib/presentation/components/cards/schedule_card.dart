import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unec_assistant/models/calendar_event.dart';
import 'package:unec_assistant/presentation/components/cards/calendar_card.dart';
import 'package:unec_assistant/presentation/providers/theme_provider.dart';
import 'package:unec_assistant/providers/calendar_provider.dart';

class ScheduleCard extends ConsumerWidget {
  const ScheduleCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = DateTime.now();
    final events = ref.watch(calendarEventsProvider);
    final appColors = ref.watch(appColorsProvider);

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
    final accentColor = isExam ? appColors.success : appColors.warning;
    final isActive = firstEvent != null &&
        now.isAfter(firstEvent.startTime) &&
        now.isBefore(firstEvent.endTime);

    final String semanticLabel = firstEvent != null
        ? 'Upcoming ${isExam ? 'Exam' : 'Personal Plan'}: ${firstEvent.title}, ${_formatDate(firstEvent.startTime)} at ${firstEvent.displayTimeRange}'
        : '';

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
            child: GestureDetector(
              onTap: () {
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
              behavior: HitTestBehavior.opaque,
              child: Container(
                width: 330,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: appColors.cardBackground,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: appColors.borderColor, width: 1),
                ),
                child: ExcludeSemantics(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header (Type label + date pill)
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
                                    color: appColors.error.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    'ACTIVE',
                                    style: GoogleFonts.redditSans(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 9,
                                      color: appColors.error,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                              ],
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: accentColor.withValues(alpha: 0.15),
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
                        firstEvent?.title ?? '',
                        style: GoogleFonts.redditSans(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                          color: appColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Info Card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        decoration: BoxDecoration(
                          color: appColors.surface,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: appColors.borderColor, width: 1),
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
                                  'Time',
                                  style: GoogleFonts.redditSans(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 11,
                                    color: appColors.textSecondary,
                                    height: 1.1,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 15),
                            Container(width: 1, height: 40, color: appColors.divider),
                            const SizedBox(width: 15),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    firstEvent?.displayTimeRange ?? '',
                                    style: GoogleFonts.redditSans(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                      color: appColors.textPrimary,
                                    ),
                                  ),
                                  if (firstEvent?.location.isNotEmpty ?? false) ...[
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Icon(Icons.location_on_outlined, size: 12, color: appColors.textSecondary),
                                        const SizedBox(width: 4),
                                        Expanded(
                                          child: Text(
                                            firstEvent?.location ?? '',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.redditSans(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12,
                                              color: appColors.textSecondary,
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

