import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unec_assistant/providers/theme_provider.dart';
import 'package:unec_assistant/providers/locale_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../models/about_app_info.dart';

Future<void> showContactRedirectDialog(
  BuildContext context,
  ContactMethod data,
) async {
  return showDialog(
    context: context,
    builder: (context) {
      return _ContactRedirectDialogContent(data: data);
    },
  );
}

class _ContactRedirectDialogContent extends ConsumerWidget {
  const _ContactRedirectDialogContent({required this.data});

  final ContactMethod data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appColors = ref.watch(appColorsProvider);
    final tr = ref.watch(strProvider);

    return Dialog(
      backgroundColor: appColors.cardBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: appColors.borderColor),
      ),
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
              tr.dialogOpenTitle(data.label),
              style: GoogleFonts.redditSans(
                fontWeight: FontWeight.w700,
                fontSize: 15,
                color: appColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              tr.dialogOpenBody(data.label),
              textAlign: TextAlign.center,
              style: GoogleFonts.redditSans(
                fontWeight: FontWeight.w500,
                fontSize: 11,
                color: appColors.textSecondary,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      decoration: BoxDecoration(
                        color: appColors.surface,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: appColors.borderColor),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Center(
                        child: Text(
                          tr.dialogCancel,
                          style: GoogleFonts.redditSans(
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                            color: appColors.textPrimary,
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
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      decoration: BoxDecoration(
                        color: data.brandColor,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Center(
                        child: Text(
                          tr.dialogOpen,
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
  }
}
