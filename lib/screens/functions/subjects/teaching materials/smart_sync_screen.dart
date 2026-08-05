import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../../providers/smart_sync_provider.dart';
import '../../../../presentation/components/cards/smart_sync_card.dart';
import '../../../../presentation/components/buttons/smart_sync_button.dart';
import '../../../../presentation/components/buttons/show_in_files_button.dart';

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
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 16),
        child: Column(
          children: [
            ShowInFilesButton(onTap: () {}),
            const SizedBox(height: 20),
            SmartSyncCard(prefs: _prefs),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
