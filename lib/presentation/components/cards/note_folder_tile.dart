import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unec_assistant/providers/theme_provider.dart';
import 'package:unec_assistant/providers/locale_provider.dart';
import '../../../models/note_folder.dart';

class NoteFolderTile extends ConsumerWidget {
  final NoteFolder data;
  final int noteCount;
  final VoidCallback? onTap;

  const NoteFolderTile({
    super.key,
    required this.data,
    required this.noteCount,
    this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appColors = ref.watch(appColorsProvider);
    final String noteText = noteCount == 1 ? ref.watch(strProvider).noteFolderOneNote : ref.watch(strProvider).noteFolderNotes(noteCount);

    return GestureDetector(
      onTap: onTap ?? () {},
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: appColors.cardBackground,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: appColors.borderColor, width: 1),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Icon Container
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: data.iconBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Icon(data.icon, size: 22, color: data.iconColor),
              ),
            ),
            const SizedBox(width: 12),
            // Title & Subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    data.folderName,
                    maxLines: 2,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.redditSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: appColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    noteText,
                    style: GoogleFonts.redditSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: appColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: appColors.iconBoxArrowBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Icon(
                  Icons.chevron_right_rounded,
                  size: 16,
                  color: appColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
