import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unec_assistant/models/calendar_event.dart';
import 'package:unec_assistant/presentation/components/calendar/event_details_popup.dart';
import 'package:unec_assistant/presentation/components/calendar/event_editor_sheet.dart';
import 'package:unec_assistant/providers/calendar_provider.dart';

enum CalendarView { month, week, day }

class CalendarCard extends ConsumerStatefulWidget {
  const CalendarCard({
    required this.onActiveClassTap,
    super.key,
  });

  final VoidCallback onActiveClassTap;

  @override
  ConsumerState<CalendarCard> createState() => _CalendarCardState();
}

class _CalendarCardState extends ConsumerState<CalendarCard> {
  CalendarView _view = CalendarView.month;
  DateTime _focusedDate = DateTime.now();
  DateTime _selectedDate = DateTime.now();
  late Timer _nowTimer;
  DateTime _now = DateTime.now();
  late ScrollController _weekScrollController;
  late ScrollController _dayScrollController;
  late ScrollController _weekHorizontalController;
  late ScrollController _weekHeaderHorizontalController;

  static const _hourHeight = 65.0;
  static const _weekDayWidth = 68.6;
  static const _totalGridHeight = 24 * _hourHeight;
  static const _borderColor = Color(0xFFE0E4F0);
  static const _primaryBlue = Color(0xFF0569FF);
  static const _textDark = Color(0xFF1F1F1F);
  static const _textGrey = Color(0xFF838A97);
  static const _textMuted = Color(0x80838A97);
  static const _lightSurface = Color(0xFFF8F9FC);
  static const _nowRed = Color(0xFFF65959);
  static final _semesterStart = DateTime(2026, 9, 1);

  static const _monthNames = [
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
    'December',
  ];

  static const _weekdayAbbr = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun',
  ];

  @override
  void initState() {
    super.initState();
    _nowTimer = Timer.periodic(
      const Duration(minutes: 1),
      (_) {
        if (!mounted) return;
        setState(() => _now = DateTime.now());
      },
    );
    _weekScrollController = ScrollController(
      initialScrollOffset: 8 * _hourHeight,
    );
    _dayScrollController = ScrollController(
      initialScrollOffset: 8 * _hourHeight,
    );
    _weekHorizontalController = ScrollController();
    _weekHeaderHorizontalController = ScrollController();
  }

  @override
  void dispose() {
    _nowTimer.cancel();
    _weekScrollController.dispose();
    _dayScrollController.dispose();
    _weekHorizontalController.dispose();
    _weekHeaderHorizontalController.dispose();
    super.dispose();
  }

  List<CalendarEvent> _eventsForDate(DateTime d) {
    return ref.read(calendarEventsProvider.notifier).getEventsForDay(d);
  }

  bool _isActiveNow(CalendarEvent e) {
    final now = _now;
    if (!isSameCalendarDay(now, e.startTime) &&
        !isSameCalendarDay(now, e.endTime)) {
      // Cross-midnight: active if now is between start and end.
      if (!(now.isAfter(e.startTime) && now.isBefore(e.endTime))) {
        return false;
      }
    }
    return !now.isBefore(e.startTime) && !now.isAfter(e.endTime);
  }

  bool _isToday(DateTime d) => isSameCalendarDay(d, _now);

  DateTime _weekStart(DateTime d) {
    final weekday = d.weekday;
    return normalizeDay(d).subtract(Duration(days: weekday - 1));
  }

  String _monthName(int month) => _monthNames[month - 1];

  String _weekCycleLabel(DateTime weekStart) {
    final days = normalizeDay(weekStart).difference(_semesterStart).inDays;
    final cycleIndex = (days ~/ 7) % 2;
    return cycleIndex == 0 ? 'Üst həftə' : 'Alt həftə';
  }

  double _topForTime(DateTime time) {
    final minutes = time.hour * 60 + time.minute;
    return (minutes / (24 * 60)) * _totalGridHeight;
  }

  double _nowTop() {
    final topRatio = (_now.hour * 60 + _now.minute) / (24 * 60);
    return topRatio * _totalGridHeight;
  }

  /// Visible segment of [event] on [day] for positioning in the grid.
  (double top, double height) _segmentOnDay(CalendarEvent event, DateTime day) {
    final dayStart = normalizeDay(day);
    final dayEnd = dayStart.add(const Duration(days: 1));
    final start = event.startTime.isBefore(dayStart) ? dayStart : event.startTime;
    final end = event.endTime.isAfter(dayEnd) ? dayEnd : event.endTime;
    final top = _topForTime(start);
    final bottom = _topForTime(end);
    return (top, math.max(bottom - top, 20));
  }

  Future<void> _openDetails(CalendarEvent event) async {
    final isActiveClass =
        _isActiveNow(event) && event.type == EventType.classEvent;

    await showEventDetailsPopup(
      context,
      event: event,
      onActiveClassTap: isActiveClass ? widget.onActiveClassTap : null,
      onEdit: () async {
        final updated = await showEventEditorSheet(
          context,
          existing: event,
          initialDay: event.startDay,
        );
        if (updated != null && mounted) {
          ref.read(calendarEventsProvider.notifier).updateEvent(updated);
        }
      },
      onDelete: () {
        ref.read(calendarEventsProvider.notifier).deleteEvent(event.id);
      },
    );
  }

  Widget _navButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 30,
        height: 30,
        decoration: const BoxDecoration(
          color: Color(0x26838A97),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Icon(icon, size: 25, color: Color(0x80838A97)),
      ),
    );
  }

  Widget _buildViewToggle() {
    final options = <(String, CalendarView)>[
      ('Month', CalendarView.month),
      ('Week', CalendarView.week),
      ('Day', CalendarView.day),
    ];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (var i = 0; i < options.length; i++) ...[
            if (i > 0) const SizedBox(width: 30),
            GestureDetector(
              onTap: () => setState(() => _view = options[i].$2),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                decoration: BoxDecoration(
                  color: _view == options[i].$2
                      ? _primaryBlue
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  options[i].$1,
                  style: GoogleFonts.redditSans(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: _view == options[i].$2
                        ? const Color(0xFFF8F9FC)
                        : _textGrey,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMonthView() {
    // Keep provider watched so month cells refresh on CRUD.
    ref.watch(calendarEventsProvider);

    final firstDayOfMonth = DateTime(_focusedDate.year, _focusedDate.month, 1);
    final startOffset = firstDayOfMonth.weekday - 1;
    final gridStart = firstDayOfMonth.subtract(Duration(days: startOffset));
    final days = List.generate(
      42,
      (i) => DateTime(gridStart.year, gridStart.month, gridStart.day + i),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _navButton(
                icon: Icons.arrow_left_rounded,
                onTap: () => setState(
                  () => _focusedDate = DateTime(
                    _focusedDate.year,
                    _focusedDate.month - 1,
                    1,
                  ),
                ),
              ),
              Text(
                _monthName(_focusedDate.month),
                style: GoogleFonts.redditSans(
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                  color: _textDark,
                ),
              ),
              _navButton(
                icon: Icons.arrow_right_rounded,
                onTap: () => setState(
                  () => _focusedDate = DateTime(
                    _focusedDate.year,
                    _focusedDate.month + 1,
                    1,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (final day in _weekdayAbbr)
              Expanded(
                child: Center(
                  child: Text(
                    day,
                    style: GoogleFonts.redditSans(
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                      color: _textGrey,
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 15),
        GridView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: days.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            childAspectRatio: 7 / 10,
          ),
          itemBuilder: (context, index) => _buildMonthCell(days[index]),
        ),
      ],
    );
  }

  Color _chipColor(EventType type) {
    switch (type) {
      case EventType.classEvent:
        return _primaryBlue;
      case EventType.personalEvent:
        return const Color(0xFF985909);
      case EventType.exam:
        return const Color(0xFF534AB7);
    }
  }

  Widget _buildMonthCell(DateTime date) {
    final isCurrentMonth = date.month == _focusedDate.month;
    final isToday = _isToday(date);
    final events = _eventsForDate(date);
    final isHbd = isSameCalendarDay(date, kHbdDate);

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedDate = date;
          _focusedDate = date;
          _view = CalendarView.day;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0x80F8F9FC),
          border: Border.all(color: _borderColor, width: 0.5),
        ),
        padding: const EdgeInsets.all(4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isToday)
              Container(
                width: 18,
                height: 18,
                decoration: const BoxDecoration(
                  color: _primaryBlue,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${date.day}',
                    style: GoogleFonts.redditSans(
                      fontSize: 10,
                      color: _lightSurface,
                    ),
                  ),
                ),
              )
            else
              Text(
                '${date.day}',
                style: GoogleFonts.redditSans(
                  fontSize: 10,
                  color: isCurrentMonth ? _textDark : _textMuted,
                ),
              ),
            if (isHbd)
              Text(
                '🎂 HBD',
                style: GoogleFonts.redditSans(
                  fontSize: 8,
                  color: const Color(0xFF950031),
                ),
              ),
            for (final event in events.take(3))
              Row(
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: _chipColor(event.type),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      event.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.redditSans(
                        fontSize: 8,
                        color: isCurrentMonth ? _textDark : _textMuted,
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeekView() {
    ref.watch(calendarEventsProvider);
    final weekStart = _weekStart(_focusedDate);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _navButton(
                icon: Icons.chevron_left_rounded,
                onTap: () => setState(() {
                  _focusedDate = _focusedDate.subtract(const Duration(days: 7));
                  _selectedDate = _weekStart(_focusedDate);
                }),
              ),
              Text(
                _weekCycleLabel(weekStart),
                style: GoogleFonts.redditSans(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: _primaryBlue,
                ),
              ),
              _navButton(
                icon: Icons.chevron_right_rounded,
                onTap: () => setState(() {
                  _focusedDate = _focusedDate.add(const Duration(days: 7));
                  _selectedDate = _weekStart(_focusedDate);
                }),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 540,
          child: _buildWeekPage(weekStart),
        ),
      ],
    );
  }

  Widget _buildWeekPage(DateTime weekStart) {
    final weekDays = List.generate(
      7,
      (i) => DateTime(weekStart.year, weekStart.month, weekStart.day + i),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Headers Row
        Row(
          children: [
            const SizedBox(width: 50),
            Expanded(
              child: NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  if (notification is ScrollUpdateNotification &&
                      notification.metrics.axis == Axis.horizontal) {
                    _weekHorizontalController
                        .jumpTo(_weekHeaderHorizontalController.offset);
                  }
                  return false;
                },
                child: SingleChildScrollView(
                  controller: _weekHeaderHorizontalController,
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (final day in weekDays)
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedDate = day;
                              _focusedDate = day;
                              _view = CalendarView.day;
                            });
                          },
                          child: SizedBox(
                            width: _weekDayWidth,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  _weekdayAbbr[day.weekday - 1],
                                  style: GoogleFonts.redditSans(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                    color: _isToday(day)
                                        ? _primaryBlue
                                        : _textGrey,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                if (_isToday(day))
                                  Container(
                                    width: 24,
                                    height: 24,
                                    decoration: const BoxDecoration(
                                      color: _primaryBlue,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Text(
                                        '${day.day}',
                                        style: GoogleFonts.redditSans(
                                          fontSize: 12,
                                          color: _lightSurface,
                                        ),
                                      ),
                                    ),
                                  )
                                else
                                  Text(
                                    '${day.day}',
                                    style: GoogleFonts.redditSans(
                                      fontSize: 12,
                                      color: _textDark,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Expanded(
          child: SingleChildScrollView(
            controller: _weekScrollController,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Time column
                SizedBox(
                  width: 50,
                  child: Column(
                    children: [
                      for (var h = 0; h < 24; h++)
                        SizedBox(
                          height: _hourHeight,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Text(
                              '${h.toString().padLeft(2, '0')}:00',
                              style: GoogleFonts.redditSans(
                                fontSize: 10,
                                color: _textGrey,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                // Grid and events
                Expanded(
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (notification) {
                      if (notification is ScrollUpdateNotification &&
                          notification.metrics.axis == Axis.horizontal) {
                        _weekHeaderHorizontalController
                            .jumpTo(_weekHorizontalController.offset);
                      }
                      return false;
                    },
                    child: SingleChildScrollView(
                      controller: _weekHorizontalController,
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          for (final day in weekDays)
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedDate = day;
                                  _focusedDate = day;
                                  _view = CalendarView.day;
                                });
                              },
                              child: SizedBox(
                                width: _weekDayWidth,
                                height: _totalGridHeight,
                                child: Stack(
                                  clipBehavior: Clip.hardEdge,
                                  children: [
                                    Column(
                                      children: [
                                        for (var h = 0; h < 24; h++)
                                          Container(
                                            height: _hourHeight,
                                            decoration: const BoxDecoration(
                                              border: Border(
                                                top: BorderSide(
                                                  color: _borderColor,
                                                  width: 0.5,
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                    for (final event in _eventsForDate(day))
                                      Builder(
                                        builder: (context) {
                                          final (top, height) =
                                              _segmentOnDay(event, day);
                                          return Positioned(
                                            top: top,
                                            left: 2,
                                            child: SizedBox(
                                              height: height,
                                              child: _buildWeekEventTile(
                                                event,
                                                height: height,
                                                isActive: _isActiveNow(event),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    if (_isToday(day))
                                      Positioned(
                                        top: _nowTop() - 4,
                                        left: 0,
                                        child: IgnorePointer(
                                          child: _buildNowIndicator(
                                            width: _weekDayWidth,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Color _tileBackground(EventType type, bool isActive) {
    switch (type) {
      case EventType.classEvent:
        return isActive ? _primaryBlue : const Color(0xFFE8F0FE);
      case EventType.personalEvent:
        return isActive ? const Color(0xFFE3993C) : const Color(0xFFF0EAE0);
      case EventType.exam:
        return isActive ? const Color(0xFF534AB7) : const Color(0xFFE8E6F8);
    }
  }

  Color _barColor(EventType type, bool isActive) {
    switch (type) {
      case EventType.classEvent:
        return isActive ? const Color(0xFF0052CE) : _primaryBlue;
      case EventType.personalEvent:
        return isActive ? const Color(0xFFC27719) : const Color(0xFFE3993C);
      case EventType.exam:
        return isActive ? const Color(0xFF3D3690) : const Color(0xFF534AB7);
    }
  }

  Color _titleColor(bool isActive) =>
      isActive ? const Color(0xFFF8F9FC) : _textDark;

  Color _detailColor(EventType type, bool isActive) {
    switch (type) {
      case EventType.classEvent:
        return isActive
            ? const Color(0x80F8F9FC)
            : const Color(0x800569FF);
      case EventType.personalEvent:
        return isActive
            ? const Color(0xFFF0EAE0)
            : const Color(0x80E3993C);
      case EventType.exam:
        return isActive
            ? const Color(0x80F8F9FC)
            : const Color(0x80534AB7);
    }
  }

  Widget _buildWeekEventTile(
    CalendarEvent e, {
    required double height,
    required bool isActive,
  }) {
    return GestureDetector(
      onTap: () => _openDetails(e),
      child: Container(
        width: 64,
        height: height,
        decoration: BoxDecoration(
          color: _tileBackground(e.type, isActive),
          borderRadius: BorderRadius.circular(6),
        ),
        clipBehavior: Clip.hardEdge,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(width: 3, color: _barColor(e.type, isActive)),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      e.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.redditSans(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: _titleColor(isActive),
                      ),
                    ),
                    Text(
                      e.subtype,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.redditSans(
                        fontSize: 9,
                        color: _detailColor(e.type, isActive),
                      ),
                    ),
                    if (e.location.isNotEmpty)
                      Text(
                        e.location,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.redditSans(
                          fontSize: 9,
                          color: _detailColor(e.type, isActive),
                        ),
                      ),
                    Text(
                      e.displayTimeRange,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.redditSans(
                        fontSize: 9,
                        color: _detailColor(e.type, isActive),
                      ),
                    ),
                    if (isActive && e.type == EventType.classEvent)
                      Container(
                        margin: const EdgeInsets.only(top: 2),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0052CE),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Active',
                          style: GoogleFonts.redditSans(
                            fontSize: 9,
                            color: const Color(0xFFF8F9FC),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDayView() {
    ref.watch(calendarEventsProvider);
    final events = _eventsForDate(_selectedDate);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _navButton(
                icon: Icons.chevron_left_rounded,
                onTap: () => setState(() {
                  _selectedDate =
                      _selectedDate.subtract(const Duration(days: 1));
                  _focusedDate = _selectedDate;
                }),
              ),
              Text(
                '${_monthName(_selectedDate.month)} ${_selectedDate.day}',
                style: GoogleFonts.redditSans(
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                  color: _textDark,
                ),
              ),
              _navButton(
                icon: Icons.chevron_right_rounded,
                onTap: () => setState(() {
                  _selectedDate = _selectedDate.add(const Duration(days: 1));
                  _focusedDate = _selectedDate;
                }),
              ),
            ],
          ),
        ),
        const SizedBox(height: 15),
        SizedBox(
          height: 500,
          child: _buildDayPage(_selectedDate, events),
        ),
      ],
    );
  }

  /// Assigns columns for overlapping events to avoid RenderFlex overflow.
  List<(CalendarEvent event, int column, int columnCount)> _layoutOverlaps(
    List<CalendarEvent> events,
    DateTime day,
  ) {
    if (events.isEmpty) return [];

    final segments = events.map((e) {
      final (top, height) = _segmentOnDay(e, day);
      return (event: e, top: top, bottom: top + height);
    }).toList()
      ..sort((a, b) => a.top.compareTo(b.top));

    final columnEnds = <double>[];
    final temp = <(CalendarEvent, int)>[];

    for (final seg in segments) {
      var col = 0;
      while (col < columnEnds.length && columnEnds[col] > seg.top + 0.5) {
        col++;
      }
      if (col == columnEnds.length) {
        columnEnds.add(seg.bottom);
      } else {
        columnEnds[col] = seg.bottom;
      }
      temp.add((seg.event, col));
    }

    final maxCols = columnEnds.isEmpty ? 1 : columnEnds.length;
    return [
      for (final (event, col) in temp) (event, col, maxCols),
    ];
  }

  Widget _buildDayPage(DateTime day, List<CalendarEvent> events) {
    final laidOut = _layoutOverlaps(events, day);

    return SingleChildScrollView(
      controller: _dayScrollController,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 50,
            child: Column(
              children: [
                for (var h = 0; h < 24; h++)
                  SizedBox(
                    height: _hourHeight,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Text(
                        '${h.toString().padLeft(2, '0')}:00',
                        style: GoogleFonts.redditSans(
                          fontSize: 10,
                          color: _textGrey,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: SizedBox(
              height: _totalGridHeight,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final fullWidth = constraints.maxWidth;
                  return Stack(
                    clipBehavior: Clip.hardEdge,
                    children: [
                      Column(
                        children: [
                          for (var h = 0; h < 24; h++)
                            Container(
                              height: _hourHeight,
                              decoration: const BoxDecoration(
                                border: Border(
                                  top: BorderSide(
                                    color: _borderColor,
                                    width: 0.5,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      if (events.isEmpty)
                        Positioned(
                          top: 8 * _hourHeight,
                          left: 16,
                          right: 16,
                          child: Text(
                            'No events scheduled for this day',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.redditSans(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: _textGrey,
                            ),
                          ),
                        ),
                      for (final (event, col, colCount) in laidOut)
                        Builder(
                          builder: (context) {
                            final (top, height) = _segmentOnDay(event, day);
                            final width = fullWidth / colCount;
                            return Positioned(
                              top: top,
                              left: col * width,
                              width: width - 4,
                              height: height,
                              child: _buildDayEventTile(
                                event,
                                height: height,
                                isActive: _isActiveNow(event),
                              ),
                            );
                          },
                        ),
                      if (_isToday(day))
                        Positioned(
                          top: _nowTop() - 4,
                          left: 0,
                          right: 0,
                          child: IgnorePointer(
                            child: _buildNowIndicator(
                              width: fullWidth,
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayEventTile(
    CalendarEvent e, {
    required double height,
    required bool isActive,
  }) {
    return GestureDetector(
      onTap: () => _openDetails(e),
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: _tileBackground(e.type, isActive),
          borderRadius: BorderRadius.circular(6),
        ),
        clipBehavior: Clip.hardEdge,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(width: 3, color: _barColor(e.type, isActive)),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      e.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.redditSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: _titleColor(isActive),
                      ),
                    ),
                    Text(
                      e.subtype,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.redditSans(
                        fontSize: 10,
                        color: _detailColor(e.type, isActive),
                      ),
                    ),
                    if (e.location.isNotEmpty)
                      Text(
                        e.location,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.redditSans(
                          fontSize: 10,
                          color: _detailColor(e.type, isActive),
                        ),
                      ),
                    Text(
                      e.displayTimeRange,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.redditSans(
                        fontSize: 10,
                        color: _detailColor(e.type, isActive),
                      ),
                    ),
                    if (isActive && e.type == EventType.classEvent)
                      Container(
                        margin: const EdgeInsets.only(top: 2),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0052CE),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Active',
                          style: GoogleFonts.redditSans(
                            fontSize: 9,
                            color: const Color(0xFFF8F9FC),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNowIndicator({required double width}) {
    return SizedBox(
      width: width == double.infinity ? null : width,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: _nowRed,
              shape: BoxShape.circle,
            ),
          ),
          const Expanded(
            child: SizedBox(
              height: 2,
              child: ColoredBox(color: _nowRed),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _borderColor, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildViewToggle(),
          if (_view == CalendarView.month) _buildMonthView(),
          if (_view == CalendarView.week) _buildWeekView(),
          if (_view == CalendarView.day) _buildDayView(),
        ],
      ),
    );
  }
}
