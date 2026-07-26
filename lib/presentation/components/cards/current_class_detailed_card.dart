import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CurrentClassDetailedCard extends StatelessWidget {
  const CurrentClassDetailedCard({super.key});

  static const _primaryBlue = Color(0xFF0569FF);
  static const _labelGrey = Color(0xFF838A97);
  static const _valueBlack = Color(0xFF1F1F1F);
  static const _borderColor = Color(0xFFE0E4F0);
  static const _iconBackgroundColor = Color(0x260569FF);
  static const _lightLabelGrey = Color(0x80838A97);
  static const _completedOrange = Color(0xFFE3993C);

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: _iconBackgroundColor,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(
            icon,
            size: 16,
            color: _primaryBlue,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          label,
          style: GoogleFonts.redditSans(
            fontWeight: FontWeight.w700,
            fontSize: 10,
            color: _labelGrey,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            value,
            softWrap: true,
            style: GoogleFonts.redditSans(
              fontWeight: FontWeight.w800,
              fontSize: 13,
              color: _valueBlack,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: .maxFinite,
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: _borderColor,
          width: 1,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
      child: Column(
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
          const SizedBox(height: 13),
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
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  'on the 3rd floor',
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.redditSans(
                    fontWeight: FontWeight.w700,
                    fontSize: 10,
                    color: _labelGrey,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 13),
          _infoRow(Icons.book_outlined, 'Subject', 'Müasir programlaşdırma dilləri'),
          const SizedBox(height: 8),
          _infoRow(Icons.compare_outlined, 'Type', '   Mühazirə'),
          const SizedBox(height: 13),
          _infoRow(Icons.badge_outlined, 'Teacher', 'Prof. Əli Həsənov'),
          const SizedBox(height: 20),

          const Divider(
            color: _borderColor,
            thickness: 1,
            height: 1,
          ),

          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
            'Progress Line',
            textAlign: TextAlign.center,
            style: GoogleFonts.redditSans(
              fontWeight: FontWeight.w800,
              fontSize: 15,
              color: _valueBlack,
            ),
          ),
      ],
    ),

          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'starts',
                    style: GoogleFonts.redditSans(
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                      color: _lightLabelGrey,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '14:00',
                    style: GoogleFonts.redditSans(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                      color: _labelGrey,
                    ),
                  ),
                ],
              ),

              const SizedBox(width: 20),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final width = constraints.maxWidth;
                        return Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              width: width,
                              height: 10,
                              decoration: BoxDecoration(
                                color: _lightLabelGrey,
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            FractionallySizedBox(
                              widthFactor: 0.6,
                              child: Container(
                                height: 10,
                                decoration: BoxDecoration(
                                  color: _primaryBlue,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                            ),
                            Positioned(
                              left: width * 0.6 - 6,
                              top: -3,
                              child: Container(
                                width: 15,
                                height: 15,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFFFFF),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: _primaryBlue,
                                    width: 3,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 20),

              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'ends',
                    style: GoogleFonts.redditSans(
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                      color: _lightLabelGrey,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '15:20',
                    style: GoogleFonts.redditSans(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                      color: _labelGrey,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 30),

          Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 25,
            runSpacing: 15,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Time left',
                    style: GoogleFonts.redditSans(
                      fontWeight: FontWeight.w700,
                      fontSize: 10,
                      color: _labelGrey,
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 56,
                    height: 56,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 56,
                          height: 56,
                          child: CircularProgressIndicator(
                            value: 0.64,
                            strokeWidth: 7,
                            strokeCap: StrokeCap.round,
                            color: _primaryBlue,
                            backgroundColor: _borderColor,
                          ),
                        ),
                        Text(
                          '34min',
                          style: GoogleFonts.redditSans(
                            fontWeight: FontWeight.w700,
                            fontSize: 11,
                            color: _valueBlack,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Completed',
                    style: GoogleFonts.redditSans(
                      fontWeight: FontWeight.w700,
                      fontSize: 10,
                      color: _labelGrey,
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 56,
                    height: 56,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 56,
                          height: 56,
                          child: CircularProgressIndicator(
                            value: 0.64,
                            strokeWidth: 7,
                            strokeCap: StrokeCap.round,
                            color: _completedOrange,
                            backgroundColor: _borderColor,
                          ),
                        ),
                        Text(
                          '64%',
                          style: GoogleFonts.redditSans(
                            fontWeight: FontWeight.w700,
                            fontSize: 11,
                            color: _valueBlack,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
