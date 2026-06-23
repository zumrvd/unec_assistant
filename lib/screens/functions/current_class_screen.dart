import 'package:flutter/material.dart';
import 'package:unec_assistant/presentation/components/cards/current_class_detailed_card.dart';

class CurrentClassScreen extends StatelessWidget {
  const CurrentClassScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 35.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CurrentClassDetailedCard(),
          ],
        ),
      ),
    );
  }
}
