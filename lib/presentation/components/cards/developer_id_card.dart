import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unec_assistant/providers/locale_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../providers/about_app_provider.dart';

class DeveloperIdCard extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final tr = ref.watch(strProvider);
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: _cardGradient,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Mascot peeking from the right
          Positioned(
            top: 0,
            right: -19,
            bottom: 5,
            child: Image.asset(
              'assets/images/robot_mascot.PNG',
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tr.developerGreeting,
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
                  tr.developerSubtitle,
                  style: GoogleFonts.redditSans(
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                    color: const Color(0x80F8F9FC),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  tr.developerRoleTags,
                  style: GoogleFonts.redditSans(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: const Color(0xFFF8F9FC),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
