import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OpenActionButton extends StatelessWidget {
  final String label;
  final String sublabel;
  final IconData icon;
  final VoidCallback? onTap;

  const OpenActionButton({
    required this.label,
    required this.sublabel,
    required this.icon,
    this.onTap,
    super.key,
  });

  static const _buttonGradient = LinearGradient(
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
    return GestureDetector(
      onTap: onTap ?? () {},
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: _buttonGradient,
          borderRadius: BorderRadius.circular(18),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 28,
              color: const Color(0xFFF8F9FC),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    label,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.redditSans(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: const Color(0xFFF8F9FC),
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    sublabel,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.redditSans(
                      fontWeight: FontWeight.w700,
                      fontSize: 9,
                      color: const Color(0x80F8F9FC),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.arrow_outward_rounded,
              size: 20,
              color: Color(0xFFF8F9FC),
            ),
          ],
        ),
      ),
    );
  }
}
