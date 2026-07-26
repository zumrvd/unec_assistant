import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unec_assistant/models/calendar_event.dart';

Future<void> showEventDetailsPopup(
  BuildContext context, {
  required CalendarEvent event,
  required VoidCallback onEdit,
  required VoidCallback onDelete,
  VoidCallback? onActiveClassTap,
}) {
  return showDialog<void>(
    context: context,
    barrierColor: Colors.black26,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 28),
        child: _EventDetailsCard(
          event: event,
          onEdit: onEdit,
          onDelete: onDelete,
          onActiveClassTap: onActiveClassTap,
        ),
      );
    },
  );
}

class _EventDetailsCard extends StatelessWidget {
  const _EventDetailsCard({
    required this.event,
    required this.onEdit,
    required this.onDelete,
    this.onActiveClassTap,
  });

  final CalendarEvent event;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback? onActiveClassTap;

  static const _border = Color(0xFFE0E4F0);
  static const _blue = Color(0xFF0569FF);
  static const _grey = Color(0xFF838A97);
  static const _dark = Color(0xFF1F1F1F);

  Color get _badgeColor {
    switch (event.type) {
      case EventType.classEvent:
        return _blue;
      case EventType.personalEvent:
        return const Color(0xFFE3993C);
      case EventType.exam:
        return const Color(0xFF534AB7);
    }
  }

  String get _typeLabel {
    switch (event.type) {
      case EventType.classEvent:
        return 'Class';
      case EventType.personalEvent:
        return 'Personal';
      case EventType.exam:
        return 'Exam';
    }
  }

  @override
  Widget build(BuildContext context) {
    final day = event.startDay;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _border),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  event.title,
                  style: GoogleFonts.redditSans(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: _dark,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: const Icon(Icons.close_rounded, color: _grey, size: 22),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: _badgeColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              _typeLabel,
              style: GoogleFonts.redditSans(
                fontWeight: FontWeight.w700,
                fontSize: 11,
                color: _badgeColor,
              ),
            ),
          ),
          const SizedBox(height: 14),
          _infoRow(Icons.schedule_rounded, event.displayTimeRange),
          const SizedBox(height: 8),
          _infoRow(
            Icons.calendar_today_outlined,
            '${day.day}/${day.month}/${day.year}',
          ),
          if (event.location.isNotEmpty) ...[
            const SizedBox(height: 8),
            _infoRow(Icons.place_outlined, event.location),
          ],
          if (event.subtype.isNotEmpty) ...[
            const SizedBox(height: 8),
            _infoRow(Icons.label_outline_rounded, event.subtype),
          ],
          if (event.description.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              event.description,
              style: GoogleFonts.redditSans(
                fontSize: 13,
                color: _grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                    onEdit();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F9FC),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: _border),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Edit',
                      style: GoogleFonts.redditSans(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        color: _dark,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                    onDelete();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0x26F65959),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Delete',
                      style: GoogleFonts.redditSans(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        color: const Color(0xFFF65959),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (onActiveClassTap != null) ...[
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
                onActiveClassTap!();
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _blue,
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Text(
                  'Open current class',
                  style: GoogleFonts.redditSans(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: const Color(0xFFF8F9FC),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: _grey),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.redditSans(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: _dark,
            ),
          ),
        ),
      ],
    );
  }
}
