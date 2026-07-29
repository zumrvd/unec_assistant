import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ScheduleButton extends StatelessWidget {
  const ScheduleButton({
    required this.onTap,
    super.key,
  });

  final VoidCallback onTap;

  static const _primaryGreen = Color(0xFF0F6E56);
  static const _titleColor = Color(0xFF1F1F1F);
  static const _subtitleColor = Color(0x80838A97);
  static const _borderColor = Color(0xFFE0E4F0);
  static const _iconBackgroundColor = Color(0x260F6E56);

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
          top: 20,
          right: 10,
          bottom: 20,
          left: 10,
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
                Icons.calendar_today_outlined,
                size: 25,
                color: _primaryGreen,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Schedule',
                    style: GoogleFonts.redditSans(
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                      color: _titleColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'For the semester',
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
    );
  }
}
