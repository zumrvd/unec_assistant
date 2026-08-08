import 'package:flutter/material.dart';
import '../../../../providers/smart_sync_provider.dart';
import '../../../../presentation/components/cards/smart_sync_card.dart';
import '../../../../presentation/components/buttons/materials/show_in_files_button.dart';
import '../../../../presentation/components/lists/labels.dart';

class SmartSyncScreen extends StatefulWidget {
  const SmartSyncScreen({super.key});

  @override
  State<SmartSyncScreen> createState() => _SmartSyncScreenState();
}

class _SmartSyncScreenState extends State<SmartSyncScreen> {
  final SmartSyncPreferences _prefs = SmartSyncPreferences();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),
      appBar: const CustomAppBar(title: 'Smart Sync'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10,
          children: [
            ShowInFilesButton(onTap: () {}),
            SmartSyncCard(prefs: _prefs),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
