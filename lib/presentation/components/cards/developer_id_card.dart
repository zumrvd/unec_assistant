import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../providers/about_app_provider.dart';

class DeveloperIdCard extends StatelessWidget {
  const DeveloperIdCard({super.key});

  static const _cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF0569FF),
      Color(0xCC0569FF),
      Color(0xFF035CE1),
    ],
    stops: [0.0, 0.5, 1.0],
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: _cardGradient,
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.all(20),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: -10,
            right: -10,
            child: Image.asset(
              'assets/images/robot_mascot.png',
              width: 100,
              height: 100,
              errorBuilder: (context, error, stackTrace) => const SizedBox(width: 100, height: 100),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                kDeveloperGreeting,
                style: GoogleFonts.redditSans(
                  fontWeight: FontWeight.w600,
                  fontSize: 11,
                  color: const Color(0x80F8F9FC),
                ),
              ),
              const SizedBox(height: 2),
              SizedBox(
                width: 180,
                child: Text(
                  kDeveloperName,
                  softWrap: true,
                  style: GoogleFonts.redditSans(
                    fontWeight: FontWeight.w800,
                    fontSize: 26,
                    color: const Color(0xFFF8F9FC),
                    height: 1.1,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                kDeveloperSubtitle,
                style: GoogleFonts.redditSans(
                  fontWeight: FontWeight.w600,
                  fontSize: 11,
                  color: const Color(0x80F8F9FC),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                kDeveloperRoleTags,
                style: GoogleFonts.redditSans(
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                  color: const Color(0xFFF8F9FC),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
