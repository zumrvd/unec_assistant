import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CurrentClassButton extends StatelessWidget {
  const CurrentClassButton({
    required this.onTap,
    super.key,
  });

  final VoidCallback onTap;

  static const _primaryBlue = Color(0xFF0569FF);
  static const _titleColor = Color(0xFF1F1F1F);
  static const _subtitleColor = Color(0x80838A97);
  static const _borderColor = Color(0xFFE0E4F0);
  static const _iconBackgroundColor = Color(0x260569FF);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _borderColor,
            width: 1,
          ),
        ),
        padding: const EdgeInsets.only(
          top: 18,
          right: 15,
          bottom: 18,
          left: 18,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      color: _iconBackgroundColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      size: 40,
                      Icons.bolt_outlined,
                      color: _primaryBlue,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Current class',
                          style: GoogleFonts.redditSans(
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                            color: _titleColor,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "Ongoing class, it's materials and info",
                          style: GoogleFonts.redditSans(
                            fontWeight: FontWeight.w700,
                            fontSize: 10,
                            color: _subtitleColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Image.asset(
              'assets/images/red_dot.gif',
              width: 30,
              height: 30,
              gaplessPlayback: true,
            ),
          ],
        ),
      ),
    );
  }
}
