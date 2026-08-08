import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unec_assistant/models/calendar_event.dart';
import 'package:unec_assistant/models/subject_detail.dart';

class CurrentClassDetailedCard extends StatelessWidget {
  const CurrentClassDetailedCard({
    required this.subject,
    required this.event,
    this.forceZeroProgress = false,
    this.now,
    super.key,
  });

  final SubjectDetail subject;
  final CalendarEvent event;

  /// When true (State B — up next), progress is computed as if now == start.
  final bool forceZeroProgress;

  /// Optional clock override for tests / parent timers; defaults to [DateTime.now].
  final DateTime? now;

  static const _primaryBlue = Color(0xFF0569FF);
  static const _labelGrey = Color(0xFF838A97);
  static const _valueBlack = Color(0xFF1F1F1F);
  static const _borderColor = Color(0xFFE0E4F0);
  static const _iconBackgroundColor = Color(0x260569FF);
  static const _lightLabelGrey = Color(0x80838A97);
  static const _completedOrange = Color(0xFFE3993C);

  static String _pad(int n) => n.toString().padLeft(2, '0');

  static String _roomNumber(String location) {
    final match = RegExp(r'Room\s+(\S+)', caseSensitive: false).firstMatch(location);
    if (match != null) return match.group(1)!;
    return location;
  }

  static String? _floorHint(String roomNumber) {
    final n = int.tryParse(roomNumber);
    if (n == null || n < 100) return null;
    final floor = n ~/ 100;
    final suffix = switch (floor) {
      1 => 'st',
      2 => 'nd',
      3 => 'rd',
      _ => 'th',
    };
    return 'on the $floor$suffix floor';
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: _iconBackgroundColor,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(
            icon,
            size: 16,
            color: _primaryBlue,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          label,
          style: GoogleFonts.redditSans(
            fontWeight: FontWeight.w700,
            fontSize: 10,
            color: _labelGrey,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            value,
            softWrap: true,
            style: GoogleFonts.redditSans(
              fontWeight: FontWeight.w800,
              fontSize: 13,
              color: _valueBlack,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final clock = now ?? DateTime.now();
    final startMin = event.startTime.hour * 60 + event.startTime.minute;
    final endMin = event.endTime.hour * 60 + event.endTime.minute;
    final duration = (endMin - startMin).clamp(1, 24 * 60);
    final effectiveNowMin = forceZeroProgress
        ? startMin
        : clock.hour * 60 + clock.minute;
    final elapsed = (effectiveNowMin - startMin).clamp(0, duration);
    final remaining = duration - elapsed;
    final completedRatio = elapsed / duration;
    final timeLeftRatio = remaining / duration;

    final roomNumber = _roomNumber(event.location);
    final floorHint = _floorHint(roomNumber);
    final startLabel =
        '${_pad(event.startTime.hour)}:${_pad(event.startTime.minute)}';
    final endLabel =
        '${_pad(event.endTime.hour)}:${_pad(event.endTime.minute)}';

    return Container(
      width: .maxFinite,
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: _borderColor,
          width: 1,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'CURRENT CLASS',
            style: GoogleFonts.redditSans(
              fontWeight: FontWeight.w700,
              fontSize: 16,
              color: _primaryBlue,
            ),
          ),
          const SizedBox(height: 13),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                'Room',
                style: GoogleFonts.redditSans(
                  fontWeight: FontWeight.w700,
                  fontSize: 10,
                  color: _labelGrey,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                roomNumber,
                style: GoogleFonts.redditSans(
                  fontWeight: FontWeight.w700,
                  fontSize: 40,
                  color: _valueBlack,
                ),
              ),
              if (floorHint != null) ...[
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    floorHint,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.redditSans(
                      fontWeight: FontWeight.w700,
                      fontSize: 10,
                      color: _labelGrey,
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 13),
          _infoRow(Icons.book_outlined, 'Subject', subject.subjectName),
          const SizedBox(height: 8),
          _infoRow(Icons.compare_outlined, 'Type', '   ${event.subtype}'),
          const SizedBox(height: 13),
          _infoRow(Icons.badge_outlined, 'Teacher', subject.teacherName),
          const SizedBox(height: 20),

          const Divider(
            color: _borderColor,
            thickness: 1,
            height: 1,
          ),

          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Progress Line',
                textAlign: TextAlign.center,
                style: GoogleFonts.redditSans(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color: _valueBlack,
                ),
              ),
            ],
          ),

          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'starts',
                    style: GoogleFonts.redditSans(
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                      color: _lightLabelGrey,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    startLabel,
                    style: GoogleFonts.redditSans(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                      color: _labelGrey,
                    ),
                  ),
                ],
              ),

              const SizedBox(width: 20),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final width = constraints.maxWidth;
                        final factor = completedRatio.clamp(0.0, 1.0);
                        return Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              width: width,
                              height: 10,
                              decoration: BoxDecoration(
                                color: _lightLabelGrey,
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            FractionallySizedBox(
                              widthFactor: factor,
                              child: Container(
                                height: 10,
                                decoration: BoxDecoration(
                                  color: _primaryBlue,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                            ),
                            Positioned(
                              left: (width * factor - 6).clamp(0.0, width - 12),
                              top: -3,
                              child: Container(
                                width: 15,
                                height: 15,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFFFFF),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: _primaryBlue,
                                    width: 3,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 20),

              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'ends',
                    style: GoogleFonts.redditSans(
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                      color: _lightLabelGrey,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    endLabel,
                    style: GoogleFonts.redditSans(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                      color: _labelGrey,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 30),

          Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 25,
            runSpacing: 15,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Time left',
                    style: GoogleFonts.redditSans(
                      fontWeight: FontWeight.w700,
                      fontSize: 10,
                      color: _labelGrey,
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 56,
                    height: 56,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 56,
                          height: 56,
                          child: CircularProgressIndicator(
                            value: timeLeftRatio.clamp(0.0, 1.0),
                            strokeWidth: 7,
                            strokeCap: StrokeCap.round,
                            color: _primaryBlue,
                            backgroundColor: _borderColor,
                          ),
                        ),
                        Text(
                          '${remaining}min',
                          style: GoogleFonts.redditSans(
                            fontWeight: FontWeight.w700,
                            fontSize: 11,
                            color: _valueBlack,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Completed',
                    style: GoogleFonts.redditSans(
                      fontWeight: FontWeight.w700,
                      fontSize: 10,
                      color: _labelGrey,
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 56,
                    height: 56,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 56,
                          height: 56,
                          child: CircularProgressIndicator(
                            value: completedRatio.clamp(0.0, 1.0),
                            strokeWidth: 7,
                            strokeCap: StrokeCap.round,
                            color: _completedOrange,
                            backgroundColor: _borderColor,
                          ),
                        ),
                        Text(
                          '${(completedRatio * 100).round()}%',
                          style: GoogleFonts.redditSans(
                            fontWeight: FontWeight.w700,
                            fontSize: 11,
                            color: _valueBlack,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
