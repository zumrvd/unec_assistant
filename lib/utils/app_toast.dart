import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Shared custom toast overlay. Replaces all bare Material SnackBars.
/// White background, 1dp #E0E4F0 border, 12dp radius, dark Reddit Sans text.
abstract final class AppToast {
  static void show(BuildContext context, String message, {Color? textColor}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 3),
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          padding: EdgeInsets.zero,
          content: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFFFF),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE0E4F0), width: 1),
            ),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.redditSans(
                color: textColor ?? const Color(0xFF1F1F1F),
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
        ),
      );
  }
}
