import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:unec_assistant/presentation/components/cards/feedback_card.dart';
import 'package:unec_assistant/presentation/components/cards/setting_card1.dart';
import 'package:unec_assistant/presentation/components/cards/setting_card2.dart';
import 'package:unec_assistant/presentation/components/cards/student_id_card.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _launchUnecCabinet() async {
    final Uri url = Uri.parse('http://kabinet.unec.edu.az/az/login');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
                        quote: '"too pretty to worry about midterms"',
                        profileImage:
                            const AssetImage('assets/images/profile.jpg'),
                      ),
                    ),

                    const SizedBox(height: 20),

                    const Padding(
                      padding: EdgeInsets.only(bottom: 10.0),
                      child: Text(
                        'Academic',
                        style: TextStyle(
                          color: Color(0xFF838A97),
                          fontSize: 15,
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

                    const Padding(
                      padding: EdgeInsets.only(bottom: 10.0),
                      child: Text(
                        'Application',
                        style: TextStyle(
                          color: Color(0xFF838A97),
                          fontSize: 15,
                        ),
                      ),
                    ),

                    Center(
                      child: SettingsCard2(
                        onAboutAppTap: () => context.push('/profile/about'),
                      ),
                    ),

                    const SizedBox(height: 10),

                    const Padding(
                      padding: EdgeInsets.only(bottom: 10.0),
                      child: Text(
                        'Feedback & Support',
                        style: TextStyle(
                          color: Color(0xFF838A97),
                          fontSize: 15,
                        ),
                      ),
                    ),

                    const Center(
                      child: FeedbackCard(),
                    ),
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
