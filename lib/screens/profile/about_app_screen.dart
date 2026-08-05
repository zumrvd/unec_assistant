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
          children: [
            const DeveloperIdCard(),
            const SizedBox(height: 20),
            const SectionLabel('About Us'),
            const SizedBox(height: 10),
            const AboutUsCard(),
            const SizedBox(height: 20),
            const SectionLabel('Contact Us'),
            const SizedBox(height: 10),
            const ContactUsRow(items: kContactMethods),
            const SizedBox(height: 20),
            const SectionLabel('About App'),
            const SizedBox(height: 10),
            const AboutAppCard(items: kAboutAppInfo),
            const SizedBox(height: 20),
            const Center(child: AboutAppFooter()),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
