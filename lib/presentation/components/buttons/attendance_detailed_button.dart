import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AttendanceButton extends StatelessWidget {
  const AttendanceButton({
    required this.onTap,
    super.key,
  });

  final VoidCallback onTap;

  static const _primaryRed = Color(0xFF993C1D);
  static const _primaryOrange = Color(0xFFD56829);
  static const _titleColor = Color(0xFF1F1F1F);
  static const _subtitleColor = Color(0xFF838A97);
  static const _borderColor = Color(0xFFE0E4F0);
  static const _lightLabelGrey = Color(0x80838A97);

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
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '4',
                  style: GoogleFonts.redditSans(
                    fontWeight: FontWeight.w700,
                    fontSize: 55,
                    color: _titleColor,
                    height: 1,
                  ),
                ),
                Text(
                  'used',
                  style: GoogleFonts.redditSans(
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    color: _subtitleColor,
                    height: 1,
                  ),
                ),
              ],
            ),

            const SizedBox(width: 20),

            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Limit : 7 · 3 absence remains ',
                      style: GoogleFonts.redditSans(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: _subtitleColor,
                        height: 2,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 8),

                    LayoutBuilder(
                      builder: (context, constraints) {
                        final width = constraints.maxWidth;
                        return Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              width: width,
                              height: 12,
                              decoration: BoxDecoration(
                                color: _lightLabelGrey,
                                borderRadius: BorderRadius.circular(7),
                              ),
                            ),
                            SizedBox(
                              width: width * 0.6,
                              child: FractionallySizedBox(
                                widthFactor: 1.0,
                                child: Container(
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: _primaryOrange,
                                    borderRadius: BorderRadius.circular(7),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),

                    const SizedBox(height: 12),

                    Row(
                      children: [
                        const Icon(
                          Icons.warning_rounded,
                          size: 20,
                          color: _primaryRed,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text.rich(
                            TextSpan(
                              children: [
                                const TextSpan(text: 'Warning : '),
                                TextSpan(
                                  text: 'You are in danger zone. More than 50%',
                                  style: TextStyle(color: _titleColor),
                                ),
                                const TextSpan(
                                  text: ' of your absence allowance is used. Use the rest wisely.',
                                ),
                              ],
                            ),
                            style: GoogleFonts.redditSans(
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                              color: _subtitleColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ]
              ),
            ),
          ],
        ),
      ),
    );
  }
}
