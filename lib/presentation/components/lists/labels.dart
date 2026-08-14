import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../providers/about_app_provider.dart';

class SectionLabel extends StatelessWidget {
  final String label;

  const SectionLabel(this.label, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: GoogleFonts.redditSans(
        fontWeight: FontWeight.w400,
        fontSize: 15,
        color: const Color(0xFF838A97),
      ),
    );
  }
}

class AboutAppFooter extends StatelessWidget {
  const AboutAppFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          kFooterCopyright,
          textAlign: TextAlign.center,
          style: GoogleFonts.redditSans(
            fontWeight: FontWeight.w500,
            fontSize: 10,
            color: const Color(0x80838A97),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          kFooterRights,
          textAlign: TextAlign.center,
          style: GoogleFonts.redditSans(
            fontWeight: FontWeight.w500,
            fontSize: 10,
            color: const Color(0x80838A97),
          ),
        ),
        const SizedBox(height: 8),
        Text.rich(
          TextSpan(
            children: [
              const TextSpan(text: 'Bu tətbiq '),
              TextSpan(
                text: 'UNEC tələbələri üçün',
                style: GoogleFonts.redditSans(
                  fontStyle: FontStyle.italic,
                ),
              ),
              const TextSpan(text: ' sevgi ilə hazırlanmışdır <3'),
            ],
          ),
          textAlign: TextAlign.center,
          style: GoogleFonts.redditSans(
            fontWeight: FontWeight.w500,
            fontSize: 10,
            color: const Color(0x80838A97),
          ),
        ),
      ],
    );
  }
}
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBackTap;
  final Widget? trailing;
  final Widget? leading;

  const CustomAppBar({
    required this.title,
    this.onBackTap,
    this.trailing,
    this.leading,
    super.key,
  });

  @override
  Size get preferredSize => const Size.fromHeight(70);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: preferredSize,
      child: Container(
        decoration: const BoxDecoration(
          border: Border(
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
                    leading ?? GestureDetector(
                      onTap: onBackTap ?? () => Navigator.of(context).pop(),
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
                        title,
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
              if (trailing != null) ...[
                const SizedBox(width: 12),
                trailing!,
              ],
              const SizedBox(width: 8),
            ],
          ),
        ),
      ),
    );
  }
}
