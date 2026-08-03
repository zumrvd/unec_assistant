class LectureFile {
  final String fileTitle;
  final String fileType; // 'Lecture' | 'Presentation' | 'Quiz' | 'Seminar' | 'Other'
  final String fileSize;
  final String uploadedAgo;

  const LectureFile({
    required this.fileTitle,
    required this.fileType,
    required this.fileSize,
    required this.uploadedAgo,
  });
}

class LectureMaterial {
  final String lectureLabel; // e.g. "Lecture 1"
  final String lectureTitle; // e.g. "Proqramlaşdırmanın əsaslarına giriş"
  final String bundleFileName;
  final String bundleSize;
  final String bundleUploadedAgo;
  final List<LectureFile> files;

  const LectureMaterial({
    required this.lectureLabel,
    required this.lectureTitle,
    required this.bundleFileName,
    required this.bundleSize,
    required this.bundleUploadedAgo,
    required this.files,
  });
}
