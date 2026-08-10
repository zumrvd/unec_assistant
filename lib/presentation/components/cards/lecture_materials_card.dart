import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../models/lecture_material.dart';
import '../../../providers/materials_provider.dart';

class LectureMaterialsCard extends StatefulWidget {
  final LectureMaterial data;
  final VoidCallback? onDownloadBundle;
  final void Function(LectureFile file)? onDownloadFile;

  const LectureMaterialsCard({
    required this.data,
    this.onDownloadBundle,
    this.onDownloadFile,
    super.key,
  });

  @override
  State<LectureMaterialsCard> createState() => _LectureMaterialsCardState();
}

class _LectureMaterialsCardState extends State<LectureMaterialsCard> {
  bool _isExpanded = false;

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

  Widget _fileRow(LectureFile file) {
    final IconData icon = kFileTypeIcons[file.fileType] ?? Icons.insert_drive_file_rounded;
    final Color color = kFileTypeColors[file.fileType] ?? const Color(0xFF838A97);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Icon(
          Icons.subdirectory_arrow_right_rounded,
          size: 14,
          color: Color(0x80838A97),
        ),
        const SizedBox(width: 8),
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 15, color: color),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                file.fileTitle,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.redditSans(
                  fontWeight: FontWeight.w700,
                  fontSize: 11,
                  color: const Color(0xFF1F1F1F),
                ),
              ),
              Text(
                "${file.fileSize} · ${file.uploadedAgo}",
                style: GoogleFonts.redditSans(
                  fontWeight: FontWeight.w600,
                  fontSize: 8,
                  color: const Color(0xFF838A97),
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () => widget.onDownloadFile?.call(file),
          child: Container(
            width: 28,
            height: 28,
            decoration: const BoxDecoration(
              color: Color(0x4DE0E4F0),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.file_download_outlined, size: 14, color: Color(0xFF838A97)),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFE0E4F0),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(text: "${widget.data.lectureLabel}: "),
                        TextSpan(text: widget.data.lectureTitle),
                      ],
                    ),
                    softWrap: true,
                    style: GoogleFonts.redditSans(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: const Color(0xFF0569FF),
                    ),
                  ),
                ),
                AnimatedRotation(
                  turns: _isExpanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 20,
                    color: Color(0xFF0569FF),
                  ),
                ),
              ],
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox(height: 0, width: double.infinity),
            secondChild: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: _gradient,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Materials bundle for ${widget.data.lectureLabel}:",
                        style: GoogleFonts.redditSans(
                          fontWeight: FontWeight.w700,
                          fontSize: 10,
                          color: const Color(0x80F8F9FC),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.folder_zip_rounded,
                              size: 15,
                              color: Color(0xFFF8F9FC),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.data.bundleFileName,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.redditSans(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12,
                                    color: const Color(0xFFF8F9FC),
                                  ),
                                ),
                                Text(
                                  "${widget.data.bundleSize} · ${widget.data.bundleUploadedAgo}",
                                  style: GoogleFonts.redditSans(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 8,
                                    color: const Color(0x80F8F9FC),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: widget.onDownloadBundle,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Download Bundle",
                                style: GoogleFonts.redditSans(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 10,
                                  color: const Color(0xFFF8F9FC),
                                ),
                              ),
                              const SizedBox(width: 6),
                              const Icon(Icons.download_rounded, size: 13, color: Color(0xFFF8F9FC)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "Bundle including :",
                  style: GoogleFonts.redditSans(
                    fontWeight: FontWeight.w700,
                    fontSize: 10,
                    color: const Color(0xFF838A97),
                  ),
                ),
                const SizedBox(height: 8),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.data.files.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 8),
                  itemBuilder: (context, index) => _fileRow(widget.data.files[index]),
                ),
              ],
            ),
            crossFadeState: _isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
            sizeCurve: Curves.easeInOut,
          ),
        ],
      ),
    );
  }
}
