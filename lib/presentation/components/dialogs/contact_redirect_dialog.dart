import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../models/about_app_info.dart';

Future<void> showContactRedirectDialog(BuildContext context, ContactMethod data) async {
  return showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        backgroundColor: const Color(0xFFFFFFFF),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: data.brandColor.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: SvgPicture.asset(
                    data.iconAsset,
                    width: 28,
                    height: 28,
                    placeholderBuilder: (context) => Icon(
                      Icons.circle_outlined,
                      size: 28,
                      color: data.brandColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                "Open ${data.label}?",
                style: GoogleFonts.redditSans(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  color: const Color(0xFF1F1F1F),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "You'll be redirected to ${data.label} to contact the developer.",
                textAlign: TextAlign.center,
                style: GoogleFonts.redditSans(
                  fontWeight: FontWeight.w500,
                  fontSize: 11,
                  color: const Color(0xFF838A97),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0x4DE0E4F0),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Center(
                          child: Text(
                            "Cancel",
                            style: GoogleFonts.redditSans(
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                              color: const Color(0xFF1F1F1F),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        Navigator.pop(context);
                        final Uri url = Uri.parse(data.url);
                        if (await canLaunchUrl(url)) {
                          await launchUrl(url);
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: data.brandColor,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Center(
                          child: Text(
                            "Open",
                            style: GoogleFonts.redditSans(
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                              color: const Color(0xFFFFFFFF),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
