import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SmartSyncButton extends StatelessWidget {
  final VoidCallback? onTap;

  const SmartSyncButton({
    this.onTap,
    super.key,
  });

  static const _gradient = LinearGradient(
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
          gradient: _gradient,
          borderRadius: BorderRadius.circular(18),
        ),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Manage & See Smart Sync Files",
                          style: GoogleFonts.redditSans(
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                            color: const Color(0xFFF8F9FC),
                          ),
                          softWrap: true,
                        ),
                        Text(
                          "Set your Auto-Download preferences",
                          style: GoogleFonts.redditSans(
                            fontWeight: FontWeight.w600,
                            fontSize: 10,
                            color: const Color(0x80F8F9FC),
                          ),
                          softWrap: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              size: 25,
              color: Color(0xFFF8F9FC),
            ),
          ],
        ),
      ),
    );
  }
}
