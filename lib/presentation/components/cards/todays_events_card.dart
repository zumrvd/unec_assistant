import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unec_assistant/models/calendar_event.dart';
import 'package:unec_assistant/providers/theme_provider.dart';
import 'package:unec_assistant/presentation/theme/app_colors.dart';
import 'package:unec_assistant/providers/locale_provider.dart';

class TodaysEventsCard extends ConsumerStatefulWidget {
  final List<CalendarEvent> events;

  const TodaysEventsCard({required this.events, super.key});

  @override
  ConsumerState<TodaysEventsCard> createState() => _TodaysEventsCardState();
}

class _TodaysEventsCardState extends ConsumerState<TodaysEventsCard> {
  late Timer _timer;
  DateTime _now = DateTime.now();

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(minutes: 1), (_) {
      if (mounted) {
        setState(() => _now = DateTime.now());
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _pad(int n) => n.toString().padLeft(2, '0');

  Widget _buildEventTile(CalendarEvent e, AppColors appColors) {
    final bool isPersonal = e.type == EventType.personalEvent;
    final bool isExam = e.type == EventType.exam;

    final Color accentColor = isPersonal
        ? appColors.warning
        : isExam
        ? appColors.success
        : appColors.primary;

    final Color bgColor = isPersonal
        ? appColors.warning.withValues(alpha: 0.15)
        : isExam
        ? appColors.success.withValues(alpha: 0.15)
        : appColors.primaryContainer;

    final Color borderColor = isPersonal
        ? appColors.warning.withValues(alpha: 0.25)
        : isExam
        ? appColors.success.withValues(alpha: 0.25)
        : appColors.primary.withValues(alpha: 0.25);

    final Color subtitleColor = isPersonal
        ? appColors.warningOnContainer
        : isExam
        ? appColors.success
        : appColors.primary;

    final Color locationColor = isPersonal
        ? appColors.warningOnContainer
        : isExam
        ? appColors.success
        : appColors.primary;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(width: 15),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Container(
                width: 3,
                decoration: BoxDecoration(
                  color: accentColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      e.title,
                      style: GoogleFonts.redditSans(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: appColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "${_pad(e.startTime.hour)}:${_pad(e.startTime.minute)} - ${_pad(e.endTime.hour)}:${_pad(e.endTime.minute)}",
                      style: GoogleFonts.redditSans(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        color: subtitleColor,
                      ),
                    ),
                    if (e.location.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        e.location,
                        style: GoogleFonts.redditSans(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          color: locationColor,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(width: 15),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appColors = ref.watch(appColorsProvider);
    final tr = ref.watch(strProvider);
    final int classCount = widget.events
        .where((e) => e.type == EventType.classEvent)
        .length;
    final int personalCount = widget.events
        .where((e) => e.type == EventType.personalEvent)
        .length;

    final nowMin = _now.hour * 60 + _now.minute;

    final Iterable<CalendarEvent?> nullableEvents = widget.events
        .cast<CalendarEvent?>();

    final CalendarEvent? activeEvent = nullableEvents.firstWhere((e) {
      final start = e!.startTime.hour * 60 + e.startTime.minute;
      final end = e.endTime.hour * 60 + e.endTime.minute;
      return nowMin >= start && nowMin <= end;
    }, orElse: () => null);

    final CalendarEvent? upNextEvent = nullableEvents.firstWhere((e) {
      final start = e!.startTime.hour * 60 + e.startTime.minute;
      return start > nowMin;
    }, orElse: () => null);

    int minutesUntilNext = upNextEvent != null
        ? (upNextEvent.startTime.hour * 60 + upNextEvent.startTime.minute) -
              nowMin
        : 0;

    final String todayLabel =
        "${tr.weekdays[_now.weekday - 1]}, ${tr.monthsFull[_now.month - 1]} ${_now.day}";

    return Container(
      width: 300,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: appColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: appColors.borderColor, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            todayLabel,
            style: GoogleFonts.redditSans(
              fontWeight: FontWeight.w700,
              fontSize: 14,
              color: appColors.textPrimary,
            ),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: appColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: appColors.borderColor, width: 1),
                ),
                child: Row(
                  children: [
                    Text(
                      "$classCount",
                      style: GoogleFonts.redditSans(
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                        color: appColors.primary,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      tr.scheduleClasses,
                      style: GoogleFonts.redditSans(
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                        color: appColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 5,
                height: 5,
                decoration: BoxDecoration(
                  color: appColors.borderColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: appColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: appColors.borderColor, width: 1),
                ),
                child: Row(
                  children: [
                    Text(
                      "$personalCount",
                      style: GoogleFonts.redditSans(
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                        color: appColors.warning,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      tr.schedulePersonalPlans,
                      style: GoogleFonts.redditSans(
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                        color: appColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (activeEvent != null) ...[
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: appColors.primaryContainer,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                tr.currentClassActive,
                style: GoogleFonts.redditSans(
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                  color: appColors.primary,
                ),
              ),
            ),
            const SizedBox(height: 15),
            _buildEventTile(activeEvent, appColors),
          ],
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                tr.currentClassUpNext,
                style: GoogleFonts.redditSans(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: appColors.textSecondary,
                ),
              ),
              if (upNextEvent != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: appColors.primaryContainer,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    tr.scheduleMinutesLater(minutesUntilNext),
                    style: GoogleFonts.redditSans(
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                      color: appColors.primary,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 15),
          if (upNextEvent != null)
            _buildEventTile(upNextEvent, appColors)
          else
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                tr.scheduleNoUpcomingEventsToday,
                style: GoogleFonts.redditSans(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  color: appColors.textMuted,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
