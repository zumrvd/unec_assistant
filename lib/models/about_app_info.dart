import 'package:flutter/material.dart';

class ContactMethod {
  final String label;      // 'WhatsApp' | 'LinkedIn' | 'Gmail'
  final String iconAsset;  // path to brand icon asset
  final Color brandColor;  // brand-specific border/accent color
  final String url;        // deep link or web url

  const ContactMethod({
    required this.label,
    required this.iconAsset,
    required this.brandColor,
    required this.url,
  });
}

class AboutAppInfoRow {
  final String label;
  final String value;

  const AboutAppInfoRow({required this.label, required this.value});
}
