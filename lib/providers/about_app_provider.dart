import 'package:flutter/material.dart';
import '../models/about_app_info.dart';

const String kDeveloperName = 'Zümrüd Verdiyeva';
const String kDeveloperGreeting = 'Hey there! I\'m,';
const String kDeveloperSubtitle = 'a.k.a The Developer of This App';
const String kDeveloperRoleTags = 'Junior · Full-Stack · Developer';

const List<ContactMethod> kContactMethods = [
  ContactMethod(
    label: 'WhatsApp',
    iconAsset: 'assets/icons/whatsapp.svg',
    brandColor: Color(0xFF25D366),
    url: 'https://wa.me/+994775601699',
  ),
  ContactMethod(
    label: 'LinkedIn',
    iconAsset: 'assets/icons/linkedin.svg',
    brandColor: Color(0xFF0A66C2),
    url: 'https://www.linkedin.com/in/zümrüd-verdiyeva-8a8a92385',
  ),
  ContactMethod(
    label: 'Gmail',
    iconAsset: 'assets/icons/gmail.svg',
    brandColor: Color(0xFFD54829),
    url: 'mailto:zverdiyevaa9@gmail.com',
  ),
];

const List<AboutAppInfoRow> kAboutAppInfo = [
  AboutAppInfoRow(label: 'Platforms', value: 'Android · iOS'),
  AboutAppInfoRow(label: 'Version', value: 'v 1.1.0 IT team inc.'),
  AboutAppInfoRow(label: 'Minimum SDK', value: 'Android 8.0+'),
  AboutAppInfoRow(label: 'License', value: 'License'),
  AboutAppInfoRow(label: 'Framework', value: 'Flutter'),
  AboutAppInfoRow(label: 'Language', value: 'Dart · Python'),
];

const String kFooterCopyright = '© 2026 Zümrüd · UNEC Köməki';
const String kFooterRights = 'Bütün hüquqlar qorunur';
const String kFooterMadeWith = 'Bu tətbiq UNEC tələbələri üçün sevgi ilə hazırlanmışdır <3';
