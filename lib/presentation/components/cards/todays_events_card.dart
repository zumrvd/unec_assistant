import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unec_assistant/models/calendar_event.dart';

class TodaysEventsCard extends StatefulWidget {
  final List<CalendarEvent> events;

  const TodaysEventsCard({
    required this.events,
    super.key,
  });

  @override
  State<TodaysEventsCard> createState() => _TodaysEventsCardState();
}

class _TodaysEventsCardState extends State<TodaysEventsCard> {
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

  Widget _buildEventTile(CalendarEvent e) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFE8F0FE),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0x260569FF), width: 1),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 4,
              decoration: const BoxDecoration(
                color: Color(0xFF0569FF),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(14),
                  bottomLeft: Radius.circular(14),
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
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: const Color(0xFF1F1F1F),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${_pad(e.startTime.hour)}:${_pad(e.startTime.minute)} - ${_pad(e.endTime.hour)}:${_pad(e.endTime.minute)}",
                      style: GoogleFonts.redditSans(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        color: const Color(0x800569FF),
                      ),
                    ),
                    if (e.location.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        e.location,
                        style: GoogleFonts.redditSans(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          color: const Color(0xBF0569FF),
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
    final int classCount =
        widget.events.where((e) => e.type == EventType.classEvent).length;
    final int personalCount =
        widget.events.where((e) => e.type == EventType.personalEvent).length;

    final nowMin = _now.hour * 60 + _now.minute;

    final Iterable<CalendarEvent?> nullableEvents =
        widget.events.cast<CalendarEvent?>();

    final CalendarEvent? activeEvent = nullableEvents.firstWhere(
      (e) {
        final start = e!.startTime.hour * 60 + e.startTime.minute;
        final end = e.endTime.hour * 60 + e.endTime.minute;
        return nowMin >= start && nowMin <= end;
      },
      orElse: () => null,
    );

    final CalendarEvent? upNextEvent = nullableEvents.firstWhere(
      (e) {
        final start = e!.startTime.hour * 60 + e.startTime.minute;
        return start > nowMin;
      },
      orElse: () => null,
    );

    int minutesUntilNext = upNextEvent != null
        ? (upNextEvent.startTime.hour * 60 + upNextEvent.startTime.minute) -
            nowMin
        : 0;

    final List<String> weekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    final List<String> months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    final String todayLabel =
        "${weekdays[_now.weekday - 1]}, ${months[_now.month - 1]} ${_now.day}";

    return Container(
      width: 300,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE0E4F0), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            todayLabel,
            style: GoogleFonts.redditSans(
              fontWeight: FontWeight.w700,
              fontSize: 14,
              color: const Color(0xFF1F1F1F),
            ),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0x80E0E4F0),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFE0E4F0), width: 1),
                ),
                child: Row(
                  children: [
                    Text(
                      "$classCount",
                      style: GoogleFonts.redditSans(
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                        color: const Color(0xFF0569FF),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "classes",
                      style: GoogleFonts.redditSans(
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                        color: const Color(0xFF838A97),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 5,
                height: 5,
                decoration: const BoxDecoration(
                  color: Color(0xFFE0E4F0),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0x80E0E4F0),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFE0E4F0), width: 1),
                ),
                child: Row(
                  children: [
                    Text(
                      "$personalCount",
                      style: GoogleFonts.redditSans(
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                        color: const Color(0xFFC27719),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "personal plans",
                      style: GoogleFonts.redditSans(
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                        color: const Color(0xFF838A97),
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
                color: const Color(0x260569FF),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                "Active",
                style: GoogleFonts.redditSans(
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                  color: const Color(0xFF0569FF),
                ),
              ),
            ),
            const SizedBox(height: 15),
            _buildEventTile(activeEvent),
          ],
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "UP NEXT",
                style: GoogleFonts.redditSans(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: const Color(0x80838A97),
                ),
              ),
              if (upNextEvent != null)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0x260569FF),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "$minutesUntilNext minutes later",
                    style: GoogleFonts.redditSans(
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                      color: const Color(0xFF0569FF),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 15),
          if (upNextEvent != null)
            _buildEventTile(upNextEvent)
          else
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                "No upcoming events today",
                style: GoogleFonts.redditSans(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  color: const Color(0xFF838A97),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
