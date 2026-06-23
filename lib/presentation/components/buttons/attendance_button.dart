import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AttendanceButton extends StatelessWidget {
  const AttendanceButton({
    required this.onTap,
    super.key,
  });

  final VoidCallback onTap;

  static const _primaryRed = Color(0xFF993C1D);
  static const _titleColor = Color(0xFF1F1F1F);
  static const _subtitleColor = Color(0x80838A97);
  static const _borderColor = Color(0xFFE0E4F0);
  static const _iconBackgroundColor = Color(0x26993C1D);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: _borderColor,
            width: 1,
          ),
        ),
        padding: const EdgeInsets.only(
          top: 18,
          right: 11,
          bottom: 18,
          left: 11,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _iconBackgroundColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.front_hand_outlined,
                size: 23,
                color: _primaryRed,
              ),
            ),
            const SizedBox(width: 13),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Attendance',
                  style: GoogleFonts.redditSans(
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                    color: _titleColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Absence count',
                  style: GoogleFonts.redditSans(
                    fontWeight: FontWeight.w700,
                    fontSize: 7,
                    color: _subtitleColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
