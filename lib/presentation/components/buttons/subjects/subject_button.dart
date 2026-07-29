import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

export 'subject1_button.dart';
export 'subject2_button.dart';
export 'subject3_button.dart';
export 'subject4_button.dart';
export 'subject5_button.dart';
export 'subject6_button.dart';

class SubjectButton extends StatelessWidget {
  final String subjectName;
  final String subjectTag;
  final Color iconColor;
  final Color iconBg;
  final VoidCallback onTap;

  const SubjectButton({
    required this.subjectName,
    required this.subjectTag,
    required this.iconColor,
    required this.iconBg,
    required this.onTap,
    super.key,
  });

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
            color: const Color(0xFFE0E4F0),
            width: 1,
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: iconBg,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.book_outlined,
                      size: 22,
                      color: iconColor,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          subjectName,
                          softWrap: true,
                          style: GoogleFonts.redditSans(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: const Color(0xFF1F1F1F),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0x260569FF),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            subjectTag,
                            style: GoogleFonts.redditSans(
                              fontWeight: FontWeight.w400,
                              fontSize: 10,
                              color: const Color(0xFF0569FF),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: const Color(0x26838A97),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.chevron_right_rounded,
                size: 18,
                color: Color(0x80838A97),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
