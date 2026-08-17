import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unec_assistant/presentation/providers/theme_provider.dart';

Future<bool?> showDiscardChangesDialog(BuildContext context) async {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return const _DiscardChangesDialogContent();
    },
  );
}

class _DiscardChangesDialogContent extends ConsumerWidget {
  const _DiscardChangesDialogContent();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appColors = ref.watch(appColorsProvider);

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
                color: appColors.error.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  Icons.delete_outline_rounded,
                  size: 28,
                  color: appColors.error,
                ),
              ),
            ),
            const SizedBox(height: 14),
            Text(
              "Discard changes?",
              style: GoogleFonts.redditSans(
                fontWeight: FontWeight.w700,
                fontSize: 15,
                color: appColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "If you go back now, your post draft will be lost.",
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
                    onTap: () => Navigator.pop(context, false),
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
                          "Cancel",
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
                    onTap: () => Navigator.pop(context, true),
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      decoration: BoxDecoration(
                        color: appColors.error,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Center(
                        child: Text(
                          "Discard",
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

