import 'package:flutter/material.dart';
import '../../providers/about_app_provider.dart';
import '../../presentation/components/cards/developer_id_card.dart';
import '../../presentation/components/cards/about_us_card.dart';
import '../../presentation/components/lists/contact_us_row.dart';
import '../../presentation/components/cards/about_app_card.dart';
import '../../presentation/components/lists/labels.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),
      appBar: const CustomAppBar(title: 'About App'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10,
          children: [
            const DeveloperIdCard(),
            const SectionLabel('About Us'),
            const AboutUsCard(),
            const SectionLabel('Contact Us'),
            const ContactUsRow(items: kContactMethods),
            const SectionLabel('About App'),
            const AboutAppCard(items: kAboutAppInfo),
            const Center(child: AboutAppFooter()),
          ],
        ),
      ),
    );
  }
}
