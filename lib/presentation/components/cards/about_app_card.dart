import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../models/about_app_info.dart';

class AboutAppCard extends StatelessWidget {
  final List<AboutAppInfoRow> items;

  const AboutAppCard({
    required this.items,
    super.key,
  });

  Widget _infoRow(AboutAppInfoRow row) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            row.label,
            style: GoogleFonts.redditSans(
              fontWeight: FontWeight.w600,
              fontSize: 12,
              color: const Color(0xFF838A97),
            ),
          ),
          Text(
            row.value,
            style: GoogleFonts.redditSans(
              fontWeight: FontWeight.w700,
              fontSize: 12,
              color: const Color(0xFF1F1F1F),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFE0E4F0),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: items.length,
        separatorBuilder: (context, index) => const Divider(
          color: Color(0xFFE0E4F0),
          thickness: 1,
          height: 1,
        ),
        itemBuilder: (context, index) => _infoRow(items[index]),
      ),
    );
  }
}
