import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unec_assistant/models/calendar_event.dart';
import 'package:unec_assistant/providers/current_class_provider.dart';

class CurrentClassCard extends ConsumerWidget {
  const CurrentClassCard({
    required this.onTap,
    super.key,
  });

  final VoidCallback onTap;

  static const _primaryBlue = Color(0xFF0569FF);
  static const _labelGrey = Color(0xFF838A97);
  static const _valueBlack = Color(0xFF1F1F1F);
  static const _borderColor = Color(0xFFE0E4F0);
  static const _iconBackgroundColor = Color(0x260569FF);

  static String _roomNumber(String location) {
    final match = RegExp(r'Room\s+(\S+)', caseSensitive: false).firstMatch(location);
    if (match != null) return match.group(1)!;
    return location;
  }

  String _nextWhenMessage(NextClassWhen when) {
    switch (when) {
      case NextClassWhen.today:
        return 'Later today';
      case NextClassWhen.tomorrow:
        return 'Tomorrow';
      case NextClassWhen.later:
        return 'Upcoming';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(currentClassProvider);

    if (state.isEmpty) {
      return _buildEmptyState();
    }

    final isUpcoming = !state.hasActive && state.hasNext;
    final tracked = isUpcoming ? state.nextClass! : state.activeClass!;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          width: 330,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isUpcoming ? 'UP NEXT' : 'CURRENT CLASS',
                        style: GoogleFonts.redditSans(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color: _primaryBlue,
                        ),
                      ),
                      if (isUpcoming) ...[
                        const SizedBox(height: 4),
                        Text(
                          'No class is currently active',
                          style: GoogleFonts.redditSans(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                            color: _labelGrey,
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (!isUpcoming)
                    ExcludeSemantics(
                      child: Image.asset(
                        'assets/images/red_dot.gif',
                        width: 28,
                        height: 28,
                        gaplessPlayback: true,
                      ),
                    )
                  else
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F5FF),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _nextWhenMessage(state.nextWhen),
                        style: GoogleFonts.redditSans(
                          fontWeight: FontWeight.w700,
                          fontSize: 10,
                          color: _primaryBlue,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
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
                    _roomNumber(tracked.event.location),
                    style: GoogleFonts.redditSans(
                      fontWeight: FontWeight.w700,
                      fontSize: 40,
                      color: _valueBlack,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _infoRow(Icons.book_outlined, 'Subject', tracked.subject.subjectName),
              const SizedBox(height: 12),
              _infoRow(Icons.compare_outlined, 'Type', tracked.event.subtype ?? 'Mühazirə'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
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
        const SizedBox(width: 8),
        Text(
          label,
          style: GoogleFonts.redditSans(
            fontWeight: FontWeight.w700,
            fontSize: 10,
            color: _labelGrey,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            softWrap: true,
            style: GoogleFonts.redditSans(
              fontWeight: FontWeight.w700,
              fontSize: 13,
              color: _valueBlack,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: 330,
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: _borderColor,
          width: 1,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 40),
      child: Center(
        child: Text(
          'No classes scheduled',
          style: GoogleFonts.redditSans(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: _labelGrey,
          ),
        ),
      ),
    );
  }
}
