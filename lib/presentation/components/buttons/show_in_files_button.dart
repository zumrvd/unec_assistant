import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ShowInFilesButton extends StatelessWidget {
  final VoidCallback? onTap;

  const ShowInFilesButton({
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
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.folder_rounded,
                  size: 20,
                  color: Color(0xFFF8F9FC),
                ),
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Show in File Manager",
                      style: GoogleFonts.redditSans(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: const Color(0xFFF8F9FC),
                      ),
                    ),
                    Text(
                      "See & manage downloaded files",
                      style: GoogleFonts.redditSans(
                        fontWeight: FontWeight.w600,
                        fontSize: 10,
                        color: const Color(0x80F8F9FC),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(width: 20),
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
