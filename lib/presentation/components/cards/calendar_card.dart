import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unec_assistant/providers/calendar_providers.dart';

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
  DateTime _focusedDate = DateTime(2026, 11, 16);
  DateTime _selectedDate = DateTime(2026, 11, 16);
  late Timer _nowTimer;
  DateTime _now = DateTime.now();
  late ScrollController _weekScrollController;
  late ScrollController _dayScrollController;

  static const _hourHeight = 65.0;
  static const _weekDayWidth = 68.6;
  static const _dayColumnWidth = 282.0;
  static const _borderColor = Color(0xFFE0E4F0);
  static const _primaryBlue = Color(0xFF0569FF);
  static const _textDark = Color(0xFF1F1F1F);
  static const _textGrey = Color(0xFF838A97);
  static const _textMuted = Color(0x80838A97);
  static const _lightSurface = Color(0xFFF8F9FC);
  static const _nowRed = Color(0xFFF65959);

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
      (_) => setState(() => _now = DateTime.now()),
    );
    _weekScrollController = ScrollController(
      initialScrollOffset: 8 * _hourHeight,
    );
    _dayScrollController = ScrollController(
      initialScrollOffset: 8 * _hourHeight,
    );
  }

  @override
  void dispose() {
    _nowTimer.cancel();
    _weekScrollController.dispose();
    _dayScrollController.dispose();
    super.dispose();
  }

  List<CalendarEvent> _eventsForDate(DateTime d) {
    final events = ref.watch(calendarEventsProvider);
    return events
        .where(
          (e) =>
              e.date.year == d.year &&
              e.date.month == d.month &&
              e.date.day == d.day,
        )
        .toList();
  }

  bool _isActiveNow(CalendarEvent e) {
    final nowMinutes = _now.hour * 60 + _now.minute;
    final start = e.startHour * 60 + e.startMinute;
    final end = e.endHour * 60 + e.endMinute;
    return _now.year == e.date.year &&
        _now.month == e.date.month &&
        _now.day == e.date.day &&
        nowMinutes >= start &&
        nowMinutes <= end;
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  bool _isToday(DateTime d) => _isSameDay(d, _now);

  DateTime _weekStart(DateTime d) {
    final weekday = d.weekday; // Mon=1 ... Sun=7
    return DateTime(d.year, d.month, d.day - (weekday - 1));
  }

  String _monthName(int month) => _monthNames[month - 1];

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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 25, color: Color(0x80838A97)),
          ],
        )
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
    final firstDayOfMonth = DateTime(_focusedDate.year, _focusedDate.month, 1);
    final startOffset = firstDayOfMonth.weekday - 1; // Monday-based
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
          Row(mainAxisAlignment: MainAxisAlignment.center,
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

  Widget _buildMonthCell(DateTime date) {
    final isCurrentMonth = date.month == _focusedDate.month;
    final isToday = _isToday(date);
    final events = _eventsForDate(date);
    final isHbd = _isSameDay(date, kHbdDate);

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedDate = date;
          if (_isToday(date)) {
            _view = CalendarView.day;
          }
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
            for (final event in events)
              Row(
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: event.type == EventType.classEvent
                          ? _primaryBlue
                          : const Color(0xFF985909),
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
    final weekStart = _weekStart(_focusedDate);
    final weekDays = List.generate(
      7,
      (i) => DateTime(weekStart.year, weekStart.month, weekStart.day + i),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(width: 50),
              Text(
                'Üst həftə',
                style: GoogleFonts.redditSans(
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                  color: _primaryBlue,
                ),
              ),
              for (final day in weekDays)
                SizedBox(
                  width: _weekDayWidth,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        _weekdayAbbr[day.weekday - 1],
                        style: GoogleFonts.redditSans(
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                          color: _isToday(day) ? _primaryBlue : _textGrey,
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
            ],
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 500,
          child: SingleChildScrollView(
            controller: _weekScrollController,
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
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        for (final day in weekDays)
                          SizedBox(
                            width: _weekDayWidth,
                            height: 24 * _hourHeight,
                            child: Stack(
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
                                  Positioned(
                                    top: (event.startHour * 60 +
                                            event.startMinute) /
                                        60 *
                                        _hourHeight,
                                    left: 2,
                                    child: _buildWeekEventTile(
                                      event,
                                      isActive: _isActiveNow(event),
                                    ),
                                  ),
                                if (_isToday(day))
                                  Positioned(
                                    top: (_now.hour * 60 + _now.minute) /
                                            60 *
                                            _hourHeight -
                                        1,
                                    left: 0,
                                    child: _buildNowIndicator(
                                      width: _weekDayWidth,
                                    ),
                                  ),
                              ],
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
      ],
    );
  }

  Color _tileBackground(EventType type, bool isActive) {
    if (type == EventType.classEvent) {
      return isActive ? _primaryBlue : const Color(0xFFE8F0FE);
    }
    return isActive ? const Color(0xFFE3993C) : const Color(0xFFF0EAE0);
  }

  Color _barColor(EventType type, bool isActive) {
    if (type == EventType.classEvent) {
      return isActive ? const Color(0xFF0052CE) : _primaryBlue;
    }
    return isActive ? const Color(0xFFC27719) : const Color(0xFFE3993C);
  }

  Color _titleColor(bool isActive) =>
      isActive ? const Color(0xFFF8F9FC) : _textDark;

  Color _detailColor(EventType type, bool isActive) {
    if (type == EventType.classEvent) {
      return isActive
          ? const Color(0x80F8F9FC)
          : const Color(0x800569FF);
    }
    return isActive
        ? const Color(0xFFF0EAE0)
        : const Color(0x80E3993C);
  }

  double _eventHeight(CalendarEvent e) {
    final durationMinutes =
        (e.endHour * 60 + e.endMinute) - (e.startHour * 60 + e.startMinute);
    return durationMinutes / 60 * _hourHeight;
  }

  Widget _buildWeekEventTile(CalendarEvent e, {required bool isActive}) {
    final canTap = isActive && e.type == EventType.classEvent;

    return GestureDetector(
      onTap: canTap ? widget.onActiveClassTap : null,
      child: Container(
        width: 64,
        height: _eventHeight(e),
        decoration: BoxDecoration(
          color: _tileBackground(e.type, isActive),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 3,
              color: _barColor(e.type, isActive),
            ),
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
                      e.timeRange,
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
                onTap: () => setState(
                  () => _selectedDate =
                      _selectedDate.subtract(const Duration(days: 1)),
                ),
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
                onTap: () => setState(
                  () => _selectedDate =
                      _selectedDate.add(const Duration(days: 1)),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 15),
        SizedBox(
          height: 500,
          child: SingleChildScrollView(
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
                SizedBox(
                  width: _dayColumnWidth,
                  height: 24 * _hourHeight,
                  child: Stack(
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
                      for (final event in events)
                        Positioned(
                          top: (event.startHour * 60 + event.startMinute) /
                              60 *
                              _hourHeight,
                          left: 0,
                          child: _buildDayEventTile(
                            event,
                            isActive: _isActiveNow(event),
                          ),
                        ),
                      if (_isToday(_selectedDate))
                        Positioned(
                          top: (_now.hour * 60 + _now.minute) /
                                  60 *
                                  _hourHeight -
                              1,
                          left: 0,
                          child: _buildNowIndicator(width: _dayColumnWidth),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDayEventTile(CalendarEvent e, {required bool isActive}) {
    final canTap = isActive && e.type == EventType.classEvent;

    return GestureDetector(
      onTap: canTap ? widget.onActiveClassTap : null,
      child: Container(
        width: _dayColumnWidth,
        height: _eventHeight(e),
        decoration: BoxDecoration(
          color: _tileBackground(e.type, isActive),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 3,
              color: _barColor(e.type, isActive),
            ),
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
                      e.timeRange,
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
      width: width,
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
              height: 1.5,
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
