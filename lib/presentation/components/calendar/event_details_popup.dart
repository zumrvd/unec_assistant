import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unec_assistant/models/calendar_event.dart';
import 'package:unec_assistant/presentation/providers/theme_provider.dart';
import 'package:unec_assistant/presentation/theme/app_colors.dart';

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

class _EventDetailsCard extends ConsumerWidget {
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

  Color _badgeColor(AppColors appColors) {
    switch (event.type) {
      case EventType.classEvent:
        return appColors.primary;
      case EventType.personalEvent:
        return appColors.attendanceOrange;
      case EventType.exam:
        return appColors.success;
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
  Widget build(BuildContext context, WidgetRef ref) {
    final appColors = ref.watch(appColorsProvider);
    final day = event.startDay;
    final badgeColor = _badgeColor(appColors);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: appColors.cardBackground,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: appColors.borderColor),
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
                    color: appColors.textPrimary,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                behavior: HitTestBehavior.opaque,
                child: Icon(Icons.close_rounded, color: appColors.textSecondary, size: 22),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: badgeColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              _typeLabel,
              style: GoogleFonts.redditSans(
                fontWeight: FontWeight.w700,
                fontSize: 11,
                color: badgeColor,
              ),
            ),
          ),
          const SizedBox(height: 14),
          _infoRow(Icons.schedule_rounded, event.displayTimeRange, appColors),
          const SizedBox(height: 8),
          _infoRow(
            Icons.calendar_today_outlined,
            '${day.day}/${day.month}/${day.year}',
            appColors,
          ),
          if (event.location.isNotEmpty) ...[
            const SizedBox(height: 8),
            _infoRow(Icons.place_outlined, event.location, appColors),
          ],
          if (event.subtype.isNotEmpty) ...[
            const SizedBox(height: 8),
            _infoRow(Icons.label_outline_rounded, event.subtype, appColors),
          ],
          if (event.description.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              event.description,
              style: GoogleFonts.redditSans(
                fontSize: 13,
                color: appColors.textSecondary,
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
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: appColors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: appColors.borderColor),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Edit',
                      style: GoogleFonts.redditSans(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        color: appColors.textPrimary,
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
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: appColors.error.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Delete',
                      style: GoogleFonts.redditSans(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        color: appColors.error,
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
              behavior: HitTestBehavior.opaque,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: appColors.primary,
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

  Widget _infoRow(IconData icon, String text, AppColors appColors) {
    return Row(
      children: [
        Icon(icon, size: 16, color: appColors.textSecondary),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.redditSans(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: appColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}

