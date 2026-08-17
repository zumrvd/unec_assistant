import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unec_assistant/models/calendar_event.dart';
import 'package:unec_assistant/presentation/components/cards/current_class_detailed_card.dart';
import 'package:unec_assistant/presentation/components/cards/subject_attendance_card.dart';
import 'package:unec_assistant/presentation/components/cards/teaching_materials_card.dart';
import 'package:unec_assistant/presentation/providers/theme_provider.dart';
import 'package:unec_assistant/providers/current_class_provider.dart';
import '../../../presentation/components/lists/labels.dart';

class CurrentClassScreen extends ConsumerWidget {
  const CurrentClassScreen({super.key});

  static const _weekdays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];
  static const _months = [
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

  Widget _activeBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFFFE5E5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Active',
            style: GoogleFonts.redditSans(
              color: const Color(0xFFFF4D4D),
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          const SizedBox(width: 8),
          Image.asset(
            'assets/images/red_dot.gif',
            width: 12,
            height: 12,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 12,
                height: 12,
                decoration: const BoxDecoration(
                  color: Color(0xFFFF4D4D),
                  shape: BoxShape.circle,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  String _dateLabel(DateTime d) =>
      '${_weekdays[d.weekday - 1]}, ${_months[d.month - 1]} ${d.day}';

  String _nextWhenMessage(NextClassWhen when, CalendarEvent event) {
    switch (when) {
      case NextClassWhen.today:
        return 'Later today';
      case NextClassWhen.tomorrow:
        return 'This class takes place tomorrow';
      case NextClassWhen.later:
        return 'Next class · ${_dateLabel(event.startTime)}';
    }
  }

  Widget _classSections({
    required TrackedClass tracked,
    required bool forceZeroProgress,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CurrentClassDetailedCard(
          subject: tracked.subject,
          event: tracked.event,
          forceZeroProgress: forceZeroProgress,
        ),
        const SizedBox(height: 10),
        const SectionLabel('Class & Attendance'),
        const SizedBox(height: 10),
        SubjectAttendanceCard(subject: tracked.subject),
        const SizedBox(height: 10),
        const SectionLabel('Academic'),
        const SizedBox(height: 10),
        TeachingMaterialsCard(
          subjectId: tracked.subject.subjectId,
          lecture: tracked.lecture,
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(currentClassProvider);
    final appColors = ref.watch(appColorsProvider);

    return Scaffold(
      backgroundColor: appColors.background,
      appBar: CustomAppBar(
        title: 'Current Class',
        trailing: state.hasActive ? _activeBadge() : null,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 35.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            if (state.hasActive) ...[
              _classSections(
                tracked: state.activeClass!,
                forceZeroProgress: false,
              ),
            ] else if (state.hasNext) ...[
              Text(
                'No class is currently active',
                style: GoogleFonts.redditSans(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: appColors.textSecondary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _nextWhenMessage(state.nextWhen, state.nextClass!.event),
                style: GoogleFonts.redditSans(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: appColors.primary,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                state.nextWhen == NextClassWhen.today ? 'Up next' : 'Coming up',
                style: GoogleFonts.redditSans(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: appColors.textPrimary,
                ),
              ),
              const SizedBox(height: 10),
              _classSections(
                tracked: state.nextClass!,
                forceZeroProgress: true,
              ),
            ] else ...[
              Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Center(
                  child: Text(
                    'No upcoming classes in your schedule',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.redditSans(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: appColors.textSecondary,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

