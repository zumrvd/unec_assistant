import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DownloadCurriculumButton extends StatelessWidget {
  final VoidCallback? onTap;

  const DownloadCurriculumButton({
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
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Dowload & See Curriculum Plan",
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.redditSans(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: const Color(0xFFF8F9FC),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "4 year - full curriculum plan of your major",
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.redditSans(
                      fontWeight: FontWeight.w700,
                      fontSize: 10,
                      color: const Color(0x80F8F9FC),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 5),
            const Icon(
              Icons.download_rounded,
              size: 30,
              color: Color(0xFFF8F9FC),
            ),
          ],
        ),
      ),
    );
  }
}
