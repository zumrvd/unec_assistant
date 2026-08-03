import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../providers/smart_sync_provider.dart';
import '../../presentation/components/cards/smart_sync_card.dart';
import '../../presentation/components/buttons/smart_sync_button.dart';
import '../../presentation/components/buttons/show_in_files_button.dart';

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
                Expanded(
                  child: Row(
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
                      Expanded(
                        child: Text(
                          'Smart Sync',
                          style: GoogleFonts.redditSans(
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                            color: const Color(0xFF838A97),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
              ],
            ),
          ),
        ),
      ),
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
