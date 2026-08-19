import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unec_assistant/models/calendar_event.dart';
import 'package:unec_assistant/presentation/components/calendar/event_details_popup.dart';
import 'package:unec_assistant/presentation/components/calendar/event_editor_sheet.dart';
import 'package:unec_assistant/providers/theme_provider.dart';
import 'package:unec_assistant/presentation/theme/app_colors.dart';
import 'package:unec_assistant/providers/calendar_provider.dart';

enum CalendarView { month, week, day }

class CalendarCard extends ConsumerStatefulWidget {
  const CalendarCard({
    required this.onActiveClassTap,
    this.initialDate,
    this.initialView,
    this.initialScrollTime,
    super.key,
  });

  final VoidCallback onActiveClassTap;
  final DateTime? initialDate;
  final CalendarView? initialView;
  final TimeOfDay? initialScrollTime;

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
  final ScrollController _weekHorizontalController = ScrollController();
  final ScrollController _weekHeaderHorizontalController = ScrollController();

  static const _hourHeight = 65.0;
  static const _weekDayWidth = 72.0;
  static const _totalGridHeight = 24 * _hourHeight;
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

  static const _weekdayAbbr = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  @override
  void initState() {
    super.initState();

    if (widget.initialView != null) {
      _view = widget.initialView!;
    }
    if (widget.initialDate != null) {
      _focusedDate = widget.initialDate!;
      _selectedDate = widget.initialDate!;
    }

    _nowTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      if (!mounted) return;
      setState(() => _now = DateTime.now());
    });

    double initialOffset = 8 * _hourHeight;
    if (widget.initialScrollTime != null) {
      initialOffset =
          (widget.initialScrollTime!.hour +
              widget.initialScrollTime!.minute / 60.0) *
          _hourHeight;
    }

    _weekScrollController = ScrollController(
      initialScrollOffset: initialOffset,
    );
    _dayScrollController = ScrollController(initialScrollOffset: initialOffset);

    // Sync horizontal scrolls
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      _weekHorizontalController.addListener(() {
        if (_weekHeaderHorizontalController.hasClients &&
            _weekHeaderHorizontalController.offset !=
                _weekHorizontalController.offset) {
          _weekHeaderHorizontalController.jumpTo(
            _weekHorizontalController.offset,
          );
        }
      });

      _weekHeaderHorizontalController.addListener(() {
        if (_weekHorizontalController.hasClients &&
            _weekHorizontalController.offset !=
                _weekHeaderHorizontalController.offset) {
          _weekHorizontalController.jumpTo(
            _weekHeaderHorizontalController.offset,
          );
        }
      });
    });
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

  (double top, double height) _segmentOnDay(CalendarEvent event, DateTime day) {
    final dayStart = normalizeDay(day);
    final dayEnd = dayStart.add(const Duration(days: 1));
    final start = event.startTime.isBefore(dayStart)
        ? dayStart
        : event.startTime;
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
    required AppColors appColors,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: appColors.iconBoxArrowBg,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Icon(icon, size: 25, color: appColors.textSecondary),
      ),
    );
  }

  Widget _buildViewToggle(AppColors appColors) {
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
              behavior: HitTestBehavior.opaque,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: _view == options[i].$2
                      ? appColors.primary
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
                        : appColors.textSecondary,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMonthView(AppColors appColors) {
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
                appColors: appColors,
              ),
              Text(
                _monthName(_focusedDate.month),
                style: GoogleFonts.redditSans(
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                  color: appColors.textPrimary,
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
                appColors: appColors,
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
                      color: appColors.textSecondary,
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
          itemBuilder: (context, index) =>
              _buildMonthCell(days[index], appColors),
        ),
      ],
    );
  }

  Color _chipColor(EventType type, AppColors appColors) {
    switch (type) {
      case EventType.classEvent:
        return appColors.primary;
      case EventType.personalEvent:
        return appColors.attendanceOrange;
      case EventType.exam:
        return appColors.success;
    }
  }

  Widget _buildMonthCell(DateTime date, AppColors appColors) {
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
      behavior: HitTestBehavior.opaque,
      child: Container(
        decoration: BoxDecoration(
          color: appColors.surface,
          border: Border.all(color: appColors.borderColor, width: 0.5),
        ),
        padding: const EdgeInsets.all(4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isToday)
              Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  color: appColors.primary,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${date.day}',
                    style: GoogleFonts.redditSans(
                      fontSize: 10,
                      color: const Color(0xFFF8F9FC),
                    ),
                  ),
                ),
              )
            else
              Text(
                '${date.day}',
                style: GoogleFonts.redditSans(
                  fontSize: 10,
                  color: isCurrentMonth
                      ? appColors.textPrimary
                      : appColors.textMuted,
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
                      color: _chipColor(event.type, appColors),
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
                        color: isCurrentMonth
                            ? appColors.textPrimary
                            : appColors.textMuted,
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

  Widget _buildWeekView(AppColors appColors) {
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
                appColors: appColors,
              ),
              Text(
                _weekCycleLabel(weekStart),
                style: GoogleFonts.redditSans(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: appColors.primary,
                ),
              ),
              _navButton(
                icon: Icons.chevron_right_rounded,
                onTap: () => setState(() {
                  _focusedDate = _focusedDate.add(const Duration(days: 7));
                  _selectedDate = _weekStart(_focusedDate);
                }),
                appColors: appColors,
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(height: 540, child: _buildWeekPage(weekStart, appColors)),
      ],
    );
  }

  Widget _buildWeekPage(DateTime weekStart, AppColors appColors) {
    final weekDays = List.generate(
      7,
      (i) => DateTime(weekStart.year, weekStart.month, weekStart.day + i),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // STICKY Date Headers
        Container(
          color: appColors.cardBackground,
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              const SizedBox(width: 50), // Align with time column
              Expanded(
                child: SingleChildScrollView(
                  controller: _weekHeaderHorizontalController,
                  scrollDirection: Axis.horizontal,
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
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
                          behavior: HitTestBehavior.opaque,
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
                                        ? appColors.primary
                                        : appColors.textSecondary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                if (_isToday(day))
                                  Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: appColors.primary,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Text(
                                        '${day.day}',
                                        style: GoogleFonts.redditSans(
                                          fontSize: 12,
                                          color: const Color(0xFFF8F9FC),
                                        ),
                                      ),
                                    ),
                                  )
                                else
                                  Text(
                                    '${day.day}',
                                    style: GoogleFonts.redditSans(
                                      fontSize: 12,
                                      color: appColors.textPrimary,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      const SizedBox(width: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Divider(height: 1, color: appColors.borderColor),
        // Scrollable Content
        Expanded(
          child: SingleChildScrollView(
            controller: _weekScrollController,
            physics: const ClampingScrollPhysics(),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Fixed Time Column
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
                                color: appColors.textSecondary,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                // Grid Content (Horizontal)
                Expanded(
                  child: SingleChildScrollView(
                    controller: _weekHorizontalController,
                    scrollDirection: Axis.horizontal,
                    physics: const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics(),
                    ),
                    child: SizedBox(
                      height: _totalGridHeight,
                      width: 7 * _weekDayWidth + 20,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          // Background Grid Lines
                          for (var h = 0; h < 24; h++)
                            Positioned(
                              top: h * _hourHeight,
                              left: 0,
                              right: 0,
                              child: Container(
                                height: _hourHeight,
                                decoration: BoxDecoration(
                                  border: Border(
                                    top: BorderSide(
                                      color: appColors.borderColor,
                                      width: 0.5,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          // Events
                          for (var i = 0; i < weekDays.length; i++)
                            for (final event in _eventsForDate(weekDays[i]))
                              Builder(
                                builder: (context) {
                                  final (top, height) = _segmentOnDay(
                                    event,
                                    weekDays[i],
                                  );
                                  return Positioned(
                                    top: top,
                                    left: i * _weekDayWidth + 2,
                                    width: _weekDayWidth - 4,
                                    height: height,
                                    child: _buildWeekEventTile(
                                      event,
                                      height: height,
                                      isActive: _isActiveNow(event),
                                      appColors: appColors,
                                    ),
                                  );
                                },
                              ),
                          // Now Indicator
                          for (var i = 0; i < weekDays.length; i++)
                            if (_isToday(weekDays[i]))
                              Positioned(
                                top: _nowTop() - 4,
                                left: i * _weekDayWidth,
                                width: _weekDayWidth,
                                child: IgnorePointer(
                                  child: _buildNowIndicator(
                                    width: _weekDayWidth,
                                    appColors: appColors,
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

  Color _tileBackground(EventType type, bool isActive, AppColors appColors) {
    switch (type) {
      case EventType.classEvent:
        return isActive ? appColors.primary : appColors.primaryContainer;
      case EventType.personalEvent:
        return isActive
            ? appColors.attendanceOrange
            : appColors.attendanceOrange.withValues(alpha: 0.15);
      case EventType.exam:
        return isActive
            ? appColors.success
            : appColors.success.withValues(alpha: 0.15);
    }
  }

  Color _barColor(EventType type, bool isActive, AppColors appColors) {
    switch (type) {
      case EventType.classEvent:
        return isActive ? const Color(0xFF0052CE) : appColors.primary;
      case EventType.personalEvent:
        return isActive ? const Color(0xFFC27719) : appColors.attendanceOrange;
      case EventType.exam:
        return isActive ? const Color(0xFF0A5442) : appColors.success;
    }
  }

  Color _titleColor(bool isActive, AppColors appColors) =>
      isActive ? const Color(0xFFF8F9FC) : appColors.textPrimary;

  Color _detailColor(EventType type, bool isActive, AppColors appColors) {
    if (isActive) {
      return const Color(0x80F8F9FC);
    }
    switch (type) {
      case EventType.classEvent:
        return appColors.primary.withValues(alpha: 0.8);
      case EventType.personalEvent:
        return appColors.attendanceOrange.withValues(alpha: 0.8);
      case EventType.exam:
        return appColors.success.withValues(alpha: 0.8);
    }
  }

  Widget _buildWeekEventTile(
    CalendarEvent e, {
    required double height,
    required bool isActive,
    required AppColors appColors,
  }) {
    return GestureDetector(
      onTap: () => _openDetails(e),
      behavior: HitTestBehavior.opaque,
      child: Container(
        decoration: BoxDecoration(
          color: _tileBackground(e.type, isActive, appColors),
          borderRadius: BorderRadius.circular(6),
        ),
        clipBehavior: Clip.hardEdge,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(width: 3, color: _barColor(e.type, isActive, appColors)),
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
                        color: _titleColor(isActive, appColors),
                      ),
                    ),
                    Text(
                      e.subtype,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.redditSans(
                        fontSize: 9,
                        color: _detailColor(e.type, isActive, appColors),
                      ),
                    ),
                    if (e.location.isNotEmpty)
                      Text(
                        e.location,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.redditSans(
                          fontSize: 9,
                          color: _detailColor(e.type, isActive, appColors),
                        ),
                      ),
                    Text(
                      e.displayTimeRange,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.redditSans(
                        fontSize: 9,
                        color: _detailColor(e.type, isActive, appColors),
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

  Widget _buildDayView(AppColors appColors) {
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
                  _selectedDate = _selectedDate.subtract(
                    const Duration(days: 1),
                  );
                  _focusedDate = _selectedDate;
                }),
                appColors: appColors,
              ),
              Text(
                '${_monthName(_selectedDate.month)} ${_selectedDate.day}',
                style: GoogleFonts.redditSans(
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                  color: appColors.textPrimary,
                ),
              ),
              _navButton(
                icon: Icons.chevron_right_rounded,
                onTap: () => setState(() {
                  _selectedDate = _selectedDate.add(const Duration(days: 1));
                  _focusedDate = _selectedDate;
                }),
                appColors: appColors,
              ),
            ],
          ),
        ),
        const SizedBox(height: 15),
        SizedBox(
          height: 500,
          child: _buildDayPage(_selectedDate, events, appColors),
        ),
      ],
    );
  }

  List<(CalendarEvent event, int column, int columnCount)> _layoutOverlaps(
    List<CalendarEvent> events,
    DateTime day,
  ) {
    if (events.isEmpty) return [];

    final segments = events.map((e) {
      final (top, height) = _segmentOnDay(e, day);
      return (event: e, top: top, bottom: top + height);
    }).toList()..sort((a, b) => a.top.compareTo(b.top));

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
    return [for (final (event, col) in temp) (event, col, maxCols)];
  }

  Widget _buildDayPage(
    DateTime day,
    List<CalendarEvent> events,
    AppColors appColors,
  ) {
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
                          color: appColors.textSecondary,
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
                              decoration: BoxDecoration(
                                border: Border(
                                  top: BorderSide(
                                    color: appColors.borderColor,
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
                              color: appColors.textSecondary,
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
                                appColors: appColors,
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
                              appColors: appColors,
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
    required AppColors appColors,
  }) {
    return GestureDetector(
      onTap: () => _openDetails(e),
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: _tileBackground(e.type, isActive, appColors),
          borderRadius: BorderRadius.circular(6),
        ),
        clipBehavior: Clip.hardEdge,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(width: 3, color: _barColor(e.type, isActive, appColors)),
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
                        color: _titleColor(isActive, appColors),
                      ),
                    ),
                    Text(
                      e.subtype,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.redditSans(
                        fontSize: 10,
                        color: _detailColor(e.type, isActive, appColors),
                      ),
                    ),
                    if (e.location.isNotEmpty)
                      Text(
                        e.location,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.redditSans(
                          fontSize: 10,
                          color: _detailColor(e.type, isActive, appColors),
                        ),
                      ),
                    Text(
                      e.displayTimeRange,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.redditSans(
                        fontSize: 10,
                        color: _detailColor(e.type, isActive, appColors),
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

  Widget _buildNowIndicator({
    required double width,
    required AppColors appColors,
  }) {
    final nowColor = appColors.error;
    return SizedBox(
      width: width == double.infinity ? null : width,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: nowColor, shape: BoxShape.circle),
          ),
          Expanded(
            child: SizedBox(height: 2, child: ColoredBox(color: nowColor)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appColors = ref.watch(appColorsProvider);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: appColors.cardBackground,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: appColors.borderColor, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildViewToggle(appColors),
          if (_view == CalendarView.month)
            KeyedSubtree(
              key: const ValueKey('cal_view_month'),
              child: _buildMonthView(appColors),
            ),
          if (_view == CalendarView.week)
            KeyedSubtree(
              key: const ValueKey('cal_view_week'),
              child: _buildWeekView(appColors),
            ),
          if (_view == CalendarView.day)
            KeyedSubtree(
              key: const ValueKey('cal_view_day'),
              child: _buildDayView(appColors),
            ),
        ],
      ),
    );
  }
}
