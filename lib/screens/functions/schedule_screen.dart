import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:unec_assistant/presentation/components/cards/calendar_card.dart';

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CalendarCard(
              onActiveClassTap: () => context.push('/functions/function1'),
            ),
          ],
        ),
      ),
    );
  }
}
