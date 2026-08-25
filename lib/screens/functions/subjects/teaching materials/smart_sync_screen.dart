import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unec_assistant/providers/theme_provider.dart';
import 'package:unec_assistant/providers/locale_provider.dart';
import '../../../../providers/smart_sync_provider.dart';
import '../../../../presentation/components/cards/smart_sync_card.dart';
import '../../../../presentation/components/buttons/materials/show_in_files_button.dart';
import '../../../../presentation/components/lists/labels.dart';

class SmartSyncScreen extends ConsumerStatefulWidget {
  const SmartSyncScreen({super.key});

  @override
  ConsumerState<SmartSyncScreen> createState() => _SmartSyncScreenState();
}

class _SmartSyncScreenState extends ConsumerState<SmartSyncScreen> {
  final SmartSyncPreferences _prefs = SmartSyncPreferences();

  @override
  Widget build(BuildContext context) {
    final appColors = ref.watch(appColorsProvider);
    final tr = ref.watch(strProvider);

    return Scaffold(
      backgroundColor: appColors.background,
      appBar: CustomAppBar(title: tr.smartSyncTitle),
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
