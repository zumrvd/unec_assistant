import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:unec_assistant/presentation/components/calendar/event_editor_sheet.dart';
import 'package:unec_assistant/presentation/components/cards/calendar_card.dart';
import 'package:unec_assistant/presentation/components/cards/todays_events_card.dart';
import 'package:unec_assistant/providers/theme_provider.dart';
import 'package:unec_assistant/providers/calendar_provider.dart';

import 'package:unec_assistant/presentation/components/lists/labels.dart';

class ScheduleScreen extends ConsumerWidget {
  final DateTime? initialDate;
  final CalendarView? initialView;
  final TimeOfDay? scrollToTime;

  const ScheduleScreen({
    this.initialDate,
    this.initialView,
    this.scrollToTime,
    super.key,
  });

  Future<void> _openCreateSheet(BuildContext context, WidgetRef ref) async {
    final created = await showEventEditorSheet(
      context,
      initialDay: DateTime.now(),
    );
    if (created != null) {
      ref.read(calendarEventsProvider.notifier).addEvent(created);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allEvents = ref.watch(calendarEventsProvider);
    final appColors = ref.watch(appColorsProvider);
    final now = DateTime.now();
    final todaysEvents = allEvents
        .where(
          (e) =>
              e.startTime.year == now.year &&
              e.startTime.month == now.month &&
              e.startTime.day == now.day,
        )
        .toList();

    return Scaffold(
      backgroundColor: appColors.background,
      floatingActionButton: GestureDetector(
        onTap: () => _openCreateSheet(context, ref),
        behavior: HitTestBehavior.opaque,
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: appColors.primary,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: appColors.primary.withValues(alpha: 0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(Icons.add_rounded, color: Colors.white, size: 32),
        ),
      ),
      appBar: const CustomAppBar(title: 'Schedule'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 10,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 35.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 10,
                  children: [
                    const SectionLabel('Today\'s plans'),
                    TodaysEventsCard(events: todaysEvents),
                    const SectionLabel('Calendar'),
                  ],
                ),
              ),
              CalendarCard(
                onActiveClassTap: () =>
                    context.push('/functions/current_class_function'),
                initialDate: initialDate,
                initialView: initialView,
                initialScrollTime: scrollToTime,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
