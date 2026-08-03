import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../models/subject_material.dart';

class SubjectMaterialListItem extends StatelessWidget {
  final SubjectMaterial data;
  final VoidCallback? onTap;

  const SubjectMaterialListItem({
    required this.data,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () {},
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
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: data.iconBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Icon(
                  data.icon,
                  size: 20,
                  color: data.iconColor,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.subjectName,
                    softWrap: true,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.redditSans(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      color: const Color(0xFF1F1F1F),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "${data.fileCount} files",
                    style: GoogleFonts.redditSans(
                      fontWeight: FontWeight.w700,
                      fontSize: 10,
                      color: const Color(0xFF838A97),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              size: 20,
              color: Color(0xFF838A97),
            ),
          ],
        ),
      ),
    );
  }
}
