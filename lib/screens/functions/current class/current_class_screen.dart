import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unec_assistant/models/calendar_event.dart';
import 'package:unec_assistant/presentation/components/cards/current_class_detailed_card.dart';
import 'package:unec_assistant/presentation/components/cards/subject_attendance_card.dart';
import 'package:unec_assistant/presentation/components/cards/teaching_materials_card.dart';
import 'package:unec_assistant/providers/theme_provider.dart';
import 'package:unec_assistant/providers/current_class_provider.dart';
import '../../../presentation/components/lists/labels.dart';
import 'package:unec_assistant/providers/locale_provider.dart';
import 'package:unec_assistant/l10n/translations.dart';

class CurrentClassScreen extends ConsumerWidget {
  const CurrentClassScreen({super.key});

  Widget _activeBadge(AppStrings tr) {
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
            tr.currentClassActive,
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

  String _dateLabel(DateTime d, AppStrings tr) =>
      '${tr.weekdays[d.weekday - 1]}, ${tr.monthsFull[d.month - 1]} ${d.day}';

  String _nextWhenMessage(NextClassWhen when, CalendarEvent event, AppStrings tr) {
    switch (when) {
      case NextClassWhen.today:
        return tr.currentClassLaterToday;
      case NextClassWhen.tomorrow:
        return tr.currentClassTakesPlaceTomorrow;
      case NextClassWhen.later:
        return '${tr.currentClassNext} · ${_dateLabel(event.startTime, tr)}';
    }
  }

  Widget _classSections({
    required TrackedClass tracked,
    required bool forceZeroProgress,
    required AppStrings tr,
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
        SectionLabel(tr.sectionClassAttendance),
        const SizedBox(height: 10),
        SubjectAttendanceCard(subject: tracked.subject),
        const SizedBox(height: 10),
        SectionLabel(tr.sectionAcademic),
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
    final tr = ref.watch(strProvider);

    return Scaffold(
      backgroundColor: appColors.background,
      appBar: CustomAppBar(
        title: tr.drawerCurrentClass,
        trailing: state.hasActive ? _activeBadge(tr) : null,
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
                tr: tr,
              ),
            ] else if (state.hasNext) ...[
              Text(
                tr.currentClassNoActive,
                style: GoogleFonts.redditSans(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: appColors.textSecondary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _nextWhenMessage(state.nextWhen, state.nextClass!.event, tr),
                style: GoogleFonts.redditSans(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: appColors.primary,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                state.nextWhen == NextClassWhen.today ? tr.currentClassUpNext : tr.currentClassComingUp,
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
                tr: tr,
              ),
            ] else ...[
              Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Center(
                  child: Text(
                    tr.currentClassNoUpcoming,
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
