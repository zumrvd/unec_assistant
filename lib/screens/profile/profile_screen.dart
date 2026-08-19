import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unec_assistant/presentation/components/cards/feedback_card.dart';
import 'package:unec_assistant/presentation/components/cards/setting_card1.dart';
import 'package:unec_assistant/presentation/components/cards/setting_card2.dart';
import 'package:unec_assistant/presentation/components/cards/student_id_card.dart';
import 'package:unec_assistant/providers/student_card_customization_provider.dart';
import 'package:unec_assistant/providers/theme_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  Future<void> _launchUnecCabinet() async {
    final Uri url = Uri.parse('http://kabinet.unec.edu.az/az/login');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appColors = ref.watch(appColorsProvider);
    final cardState = ref.watch(studentCardCustomizationProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Scaffold(
        backgroundColor: appColors.background,
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: StudentIdCard(
                        studentName: 'Zümrüd Verdiyeva',
                        groupCode: '575-1',
                        faculty: 'İnformasiya Texnologiyaları',
                        sabahGroup: 'SABAH grupları',
                        years: '2025-2029',
                        yearBadge: '1-ci kurs',
                        quote: cardState.selectedQuote,
                        profileImage: cardState.selectedAvatar,
                        theme: cardState.selectedTheme,
                        onTap: () => context.push('/profile/student_card'),
                      ),
                    ),

                    const SizedBox(height: 20),

                    Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Text(
                        'Academic',
                        style: GoogleFonts.redditSans(
                          color: appColors.textSecondary,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    Center(
                      child: SettingsCard1(
                        onProfileInfoTap: () =>
                            context.push('/profile/academic_profile'),
                        onUnecCabinetTap: _launchUnecCabinet,
                        onChangePassTap: () =>
                            context.push('/profile/change_pass'),
                      ),
                    ),

                    const SizedBox(height: 10),

                    Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Text(
                        'Application',
                        style: GoogleFonts.redditSans(
                          color: appColors.textSecondary,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    Center(
                      child: SettingsCard2(
                        onAboutAppTap: () => context.push('/profile/about'),
                      ),
                    ),

                    const SizedBox(height: 10),

                    Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Text(
                        'Feedback & Support',
                        style: GoogleFonts.redditSans(
                          color: appColors.textSecondary,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    const Center(child: FeedbackCard()),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
