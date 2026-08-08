import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../models/note_folder.dart';

class NoteFolderTile extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final String noteText = noteCount == 1 ? '1 note' : '$noteCount notes';

    return GestureDetector(
      onTap: onTap ?? () {},
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: const Color(0xFFE0E4F0),
            width: 1,
          ),
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
                child: Icon(
                  data.icon,
                  size: 22,
                  color: data.iconColor,
                ),
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
                      color: const Color(0xFF1F1F1F),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    noteText,
                    style: GoogleFonts.redditSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF838A97),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: const Color(0x4DE0E4F0),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(
                child: Icon(
                  Icons.chevron_right_rounded,
                  size: 16,
                  color: Color(0xFF838A97),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}