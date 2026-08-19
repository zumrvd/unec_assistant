import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unec_assistant/models/lecture_material.dart';
import 'package:unec_assistant/providers/theme_provider.dart';
import 'package:unec_assistant/presentation/theme/app_colors.dart';
import 'package:unec_assistant/providers/materials_provider.dart';

class TeachingMaterialsCard extends ConsumerWidget {
  const TeachingMaterialsCard({
    required this.subjectId,
    this.lecture,
    super.key,
  });

  final String subjectId;
  final LectureMaterial? lecture;

  Widget _fileRow(
    IconData fileIcon,
    Color iconColor,
    Color iconBg,
    String title,
    String meta,
    AppColors appColors, {
    bool isLast = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.subdirectory_arrow_right_outlined,
                    size: 25,
                    weight: 0.5,
                    color: appColors.borderColor,
                  ),
                  const SizedBox(width: 3),
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: iconBg,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(fileIcon, size: 20, color: iconColor),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.redditSans(
                            fontWeight: FontWeight.w800,
                            fontSize: 12,
                            color: appColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          meta,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.redditSans(
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                            color: appColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {},
              behavior: HitTestBehavior.opaque,
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: appColors.iconBoxArrowBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.file_download_outlined,
                  size: 18,
                  color: appColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
        if (!isLast) ...[
          const SizedBox(height: 15),
          Divider(color: appColors.divider, thickness: 1, height: 1),
          const SizedBox(height: 15),
        ],
      ],
    );
  }

  IconData _iconForType(String fileType) =>
      kFileTypeIcons[fileType] ?? Icons.insert_drive_file_rounded;

  Color _colorForType(String fileType) =>
      kFileTypeColors[fileType] ?? const Color(0xFF838A97);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appColors = ref.watch(appColorsProvider);
    final bundle = lecture;
    final bundleTitle = bundle == null
        ? 'No materials yet'
        : '${bundle.lectureLabel} : ${bundle.lectureTitle}';
    final bundleMeta = bundle == null
        ? ''
        : [
            if (bundle.bundleSize.isNotEmpty) bundle.bundleSize,
            if (bundle.bundleUploadedAgo.isNotEmpty) bundle.bundleUploadedAgo,
          ].join(' · ');
    final files = bundle?.files ?? const <LectureFile>[];

    return Container(
      width: .maxFinite,
      decoration: BoxDecoration(
        color: appColors.cardBackground,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: appColors.borderColor, width: 1),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'TEACHING MATERIALS',
                style: GoogleFonts.redditSans(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: appColors.primary,
                ),
              ),
              GestureDetector(
                onTap: () => context.push(
                  '/functions/teaching-materials/subject/$subjectId',
                ),
                behavior: HitTestBehavior.opaque,
                child: Container(
                  decoration: BoxDecoration(
                    color: appColors.primaryContainer,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 5,
                  ),
                  child: Text(
                    'See all',
                    style: GoogleFonts.redditSans(
                      fontWeight: FontWeight.w500,
                      fontSize: 11,
                      color: appColors.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF0569FF),
                  Color(0xCC0569FF),
                  Color(0xFF035CE1),
                ],
                stops: [0.0, 0.5, 1.0],
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Materials bundle for current class :',
                  style: GoogleFonts.redditSans(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: const Color(0xFFE8F0FE),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: const Color(0x33FFFFFF),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.chrome_reader_mode_outlined,
                        size: 20,
                        color: Color(0xFFE8F0FE),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            bundleTitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.redditSans(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: const Color(0xFFFFFFFF),
                            ),
                          ),
                          if (bundleMeta.isNotEmpty)
                            Text(
                              bundleMeta,
                              style: GoogleFonts.redditSans(
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                                color: const Color(0x80E0E4F0),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () {},
                  behavior: HitTestBehavior.opaque,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0x66FFFFFF),
                          borderRadius: BorderRadius.circular(13),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 15,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Download Bundle',
                              style: GoogleFonts.redditSans(
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                                color: const Color(0xFFFFFFFF),
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.file_download_outlined,
                              size: 18,
                              color: Color(0xFFE8F0FE),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Bundle including :',
            style: GoogleFonts.redditSans(
              fontWeight: FontWeight.w700,
              fontSize: 12,
              color: appColors.textMuted,
            ),
          ),
          const SizedBox(height: 10),
          if (files.isEmpty)
            Text(
              'No files in this bundle',
              style: GoogleFonts.redditSans(
                fontWeight: FontWeight.w600,
                fontSize: 12,
                color: appColors.textSecondary,
              ),
            )
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var i = 0; i < files.length; i++)
                  _fileRow(
                    _iconForType(files[i].fileType),
                    _colorForType(files[i].fileType),
                    _colorForType(files[i].fileType).withValues(alpha: 0.15),
                    files[i].fileTitle,
                    '${files[i].fileSize} · ${files[i].uploadedAgo}',
                    appColors,
                    isLast: i == files.length - 1,
                  ),
              ],
            ),
        ],
      ),
    );
  }
}
