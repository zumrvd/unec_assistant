import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unec_assistant/presentation/providers/theme_provider.dart';
import '../../providers/about_app_provider.dart';
import '../../presentation/components/cards/developer_id_card.dart';
import '../../presentation/components/cards/about_us_card.dart';
import '../../presentation/components/lists/contact_us_row.dart';
import '../../presentation/components/cards/about_app_card.dart';
import '../../presentation/components/lists/labels.dart';

class AboutAppScreen extends ConsumerWidget {
  const AboutAppScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appColors = ref.watch(appColorsProvider);

    return Scaffold(
      backgroundColor: appColors.background,
      appBar: const CustomAppBar(title: 'About App'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10,
          children: const [
            DeveloperIdCard(),
            SectionLabel('About Us'),
            AboutUsCard(),
            SectionLabel('Contact Us'),
            ContactUsRow(items: kContactMethods),
            SectionLabel('About App'),
            AboutAppCard(items: kAboutAppInfo),
            Center(child: AboutAppFooter()),
          ],
        ),
      ),
    );
  }
}

