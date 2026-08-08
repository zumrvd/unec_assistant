import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unec_assistant/models/lecture_material.dart';
import 'package:unec_assistant/providers/materials_provider.dart';

class TeachingMaterialsCard extends StatelessWidget {
  const TeachingMaterialsCard({
    required this.subjectId,
    this.lecture,
    super.key,
  });

  final String subjectId;
  final LectureMaterial? lecture;

  static const _primaryBlue = Color(0xFF0569FF);
  static const _valueBlack = Color(0xFF1F1F1F);
  static const _labelGrey = Color(0xFF838A97);
  static const _borderColor = Color(0xFFE0E4F0);
  static const _seeAllBackground = Color(0xFFE8F0FE);
  static const _bundleLabelColor = Color(0xFFE8F0FE);
  static const _bundleMetaColor = Color(0x80E0E4F0);
  static const _bundleIncludingColor = Color(0x80838A97);
  static const _downloadButtonBg = Color(0x80E0E4F0);
  static const _downloadButtonIcon = Color(0x80838A97);

  Widget _fileRow(
    IconData fileIcon,
    Color iconColor,
    Color iconBg,
    String title,
    String meta, {
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
                  const Icon(
                    Icons.subdirectory_arrow_right_outlined,
                    size: 25,
                    weight: 0.5,
                    color: _borderColor,
                  ),
                  const SizedBox(width: 3),
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: iconBg,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      fileIcon,
                      size: 20,
                      color: iconColor,
                    ),
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
                            color: _valueBlack,
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
                            color: _labelGrey,
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
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: _downloadButtonBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.file_download_outlined,
                  size: 18,
                  color: _downloadButtonIcon,
                ),
              ),
            ),
          ],
        ),
        if (!isLast) ...[
          const SizedBox(height: 15),
          const Divider(
            color: _borderColor,
            thickness: 1,
            height: 1,
          ),
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
  Widget build(BuildContext context) {
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
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: _borderColor,
          width: 1,
        ),
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
                  color: _primaryBlue,
                ),
              ),
              GestureDetector(
                onTap: () => context.push(
                  '/functions/teaching-materials/subject/$subjectId',
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: _seeAllBackground,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 5,
                  ),
                  child: Text(
                    'See all',
                    style: GoogleFonts.redditSans(
                      fontWeight: FontWeight.w400,
                      fontSize: 11,
                      color: _primaryBlue,
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
                    color: _bundleLabelColor,
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
                        color: _bundleLabelColor,
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
                                color: _bundleMetaColor,
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
                              color: _bundleLabelColor,
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
              color: _bundleIncludingColor,
            ),
          ),
          const SizedBox(height: 10),
          if (files.isEmpty)
            Text(
              'No files in this bundle',
              style: GoogleFonts.redditSans(
                fontWeight: FontWeight.w600,
                fontSize: 12,
                color: _labelGrey,
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
                    isLast: i == files.length - 1,
                  ),
              ],
            ),
        ],
      ),
    );
  }
}
