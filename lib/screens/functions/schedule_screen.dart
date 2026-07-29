import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unec_assistant/presentation/components/calendar/event_editor_sheet.dart';
import 'package:unec_assistant/presentation/components/cards/calendar_card.dart';
import 'package:unec_assistant/presentation/components/cards/todays_events_card.dart';
import 'package:unec_assistant/providers/calendar_providers.dart';

class ScheduleScreen extends ConsumerWidget {
  const ScheduleScreen({super.key});

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
    final now = DateTime.now();
    final todaysEvents = allEvents.where((e) =>
      e.startTime.year == now.year &&
      e.startTime.month == now.month &&
      e.startTime.day == now.day
    ).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),
      floatingActionButton: GestureDetector(
        onTap: () => _openCreateSheet(context, ref),
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: const Color(0xFF0569FF),
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Color(0x330569FF),
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(Icons.add_rounded, color: Colors.white, size: 32),
        ),
      ),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(85),
        child: Container(
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: Color(0xFFE0E4F0), width: 1),
                bottom: BorderSide(color: Color(0xFFE0E4F0), width: 1),
              ),
            ),
            child: Container(
              height: 70,
              width: double.infinity,
              color: const Color(0xFFF8F9FC),
              padding: const EdgeInsets.symmetric(horizontal: 35.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () => context.pop(),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: const Color(0x80E0E4F0),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.arrow_back,
                            size: 20,
                            color: Color(0x80838A97),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        'Schedule',
                        style: GoogleFonts.redditSans(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                          color: const Color(0xFF838A97),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TodaysEventsCard(events: todaysEvents),
              const SizedBox(height: 20),
              CalendarCard(
                onActiveClassTap: () =>
                    context.push('/functions/current_class_function'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
