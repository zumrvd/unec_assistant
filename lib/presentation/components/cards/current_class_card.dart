import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CurrentClassCard extends StatelessWidget {
  const CurrentClassCard({
    required this.onTap,
    super.key,
  });

  final VoidCallback onTap;

  static const _primaryBlue = Color(0xFF0569FF);
  static const _labelGrey = Color(0xFF838A97);
  static const _valueBlack = Color(0xFF1F1F1F);
  static const _borderColor = Color(0xFFE0E4F0);
  static const _iconBackgroundColor = Color(0x260569FF);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 300,
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
          right: 20,
          bottom: 20,
          left: 25,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'CURRENT CLASS',
                  style: GoogleFonts.redditSans(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: _primaryBlue,
                  ),
                ),
                Image.asset(
                  'assets/images/red_dot.gif',
                  width: 28,
                  height: 28,
                  gaplessPlayback: true,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  'Room',
                  style: GoogleFonts.redditSans(
                    fontWeight: FontWeight.w700,
                    fontSize: 10,
                    color: _labelGrey,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  '316',
                  style: GoogleFonts.redditSans(
                    fontWeight: FontWeight.w700,
                    fontSize: 40,
                    color: _valueBlack,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: _iconBackgroundColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(
                    Icons.book_outlined,
                    size: 16,
                    color: _primaryBlue,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Subject',
                  style: GoogleFonts.redditSans(
                    fontWeight: FontWeight.w700,
                    fontSize: 10,
                    color: _labelGrey,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Müasir programlaşdırma dilləri',
                    softWrap: true,
                    style: GoogleFonts.redditSans(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      color: _valueBlack,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: _iconBackgroundColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(
                    Icons.compare_outlined,
                    size: 16,
                    color: _primaryBlue,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Type',
                  style: GoogleFonts.redditSans(
                    fontWeight: FontWeight.w700,
                    fontSize: 10,
                    color: _labelGrey,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Mühazirə',
                  style: GoogleFonts.redditSans(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: _valueBlack,
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
