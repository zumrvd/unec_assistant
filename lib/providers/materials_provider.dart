import 'package:flutter/material.dart';
import '../models/lecture_material.dart';

const List<LectureMaterial> kProgLectures = [
  LectureMaterial(
    lectureLabel: 'Lecture 1',
    lectureTitle: 'Proqramlaşdırmanın əsaslarına giriş',
    bundleFileName: 'Lecture 1: Proqramlaşdır...',
    bundleSize: '2.4MB',
    bundleUploadedAgo: '1 week ago',
    files: [
      LectureFile(fileTitle: 'Lecture 1 : Lecture', fileType: 'Lecture', fileSize: '68KB', uploadedAgo: '1 week ago'),
      LectureFile(fileTitle: 'Lecture 1 : Presentation', fileType: 'Presentation', fileSize: '1.1MB', uploadedAgo: '1 week ago'),
      LectureFile(fileTitle: 'Lecture 1 : Quiz', fileType: 'Quiz', fileSize: '35KB', uploadedAgo: '1 week ago'),
      LectureFile(fileTitle: 'Lecture 1 : Seminar', fileType: 'Seminar', fileSize: '670KB', uploadedAgo: '1 week ago'),
      LectureFile(fileTitle: 'Lecture 1 : Other', fileType: 'Other', fileSize: '320KB', uploadedAgo: '1 week ago'),
    ],
  ),
  LectureMaterial(
    lectureLabel: 'Lecture 2',
    lectureTitle: 'Dəyişənlər və məlumat tipləri',
    bundleFileName: 'Lecture 2: Dəyişənlər...',
    bundleSize: '1.8MB',
    bundleUploadedAgo: '6 days ago',
    files: [
      LectureFile(fileTitle: 'Lecture 2 : Lecture', fileType: 'Lecture', fileSize: '68KB', uploadedAgo: '3 days ago'),
    ],
  ),
  LectureMaterial(
    lectureLabel: 'Lecture 3',
    lectureTitle: 'Şərti ifadələr və döngülər',
    bundleFileName: 'Lecture 3: Şərti ifadə...',
    bundleSize: '3.1MB',
    bundleUploadedAgo: '5 days ago',
    files: [],
  ),
  LectureMaterial(
    lectureLabel: 'Lecture 4',
    lectureTitle: 'Funksiyalar və modul yanaşma',
    bundleFileName: 'Lecture 4: Funksiyalar...',
    bundleSize: '2.0MB',
    bundleUploadedAgo: '4 days ago',
    files: [],
  ),
  LectureMaterial(
    lectureLabel: 'Lecture 5',
    lectureTitle: 'Obyekt yönümlü proqramlaşdırma',
    bundleFileName: 'Lecture 5: Obyekt yönümlü...',
    bundleSize: '4.5MB',
    bundleUploadedAgo: '3 days ago',
    files: [],
  ),
  LectureMaterial(
    lectureLabel: 'Lecture 6',
    lectureTitle: 'Məlumat strukturları',
    bundleFileName: 'Lecture 6: Məlumat strukt...',
    bundleSize: '2.7MB',
    bundleUploadedAgo: '2 days ago',
    files: [],
  ),
  LectureMaterial(
    lectureLabel: 'Lecture 7',
    lectureTitle: 'Alqoritmlərin analizi',
    bundleFileName: 'Lecture 7: Alqoritmlər...',
    bundleSize: '1.5MB',
    bundleUploadedAgo: '1 day ago',
    files: [],
  ),
  LectureMaterial(
    lectureLabel: 'Lecture 8',
    lectureTitle: 'Massivlər və sətirlər',
    bundleFileName: 'Lecture 8: Massivlər...',
    bundleSize: '2.2MB',
    bundleUploadedAgo: '20 hours ago',
    files: [],
  ),
  LectureMaterial(
    lectureLabel: 'Lecture 9',
    lectureTitle: 'Stek, Növbə və Siyahılar',
    bundleFileName: 'Lecture 9: Stek, Növbə...',
    bundleSize: '1.9MB',
    bundleUploadedAgo: '15 hours ago',
    files: [],
  ),
  LectureMaterial(
    lectureLabel: 'Lecture 10',
    lectureTitle: 'Rekursiv alqoritmlər',
    bundleFileName: 'Lecture 10: Rekursiv...',
    bundleSize: '2.6MB',
    bundleUploadedAgo: '10 hours ago',
    files: [],
  ),
  LectureMaterial(
    lectureLabel: 'Lecture 11',
    lectureTitle: 'Fayl sistemi ilə iş',
    bundleFileName: 'Lecture 11: Fayl sist...',
    bundleSize: '3.3MB',
    bundleUploadedAgo: '5 hours ago',
    files: [],
  ),
  LectureMaterial(
    lectureLabel: 'Lecture 12',
    lectureTitle: 'İstisnaların idarə olunması',
    bundleFileName: 'Lecture 12: İstisnalar...',
    bundleSize: '1.2MB',
    bundleUploadedAgo: '2 hours ago',
    files: [],
  ),
  LectureMaterial(
    lectureLabel: 'Lecture 13',
    lectureTitle: 'Yekun layihə və təkrar',
    bundleFileName: 'Lecture 13: Yekun...',
    bundleSize: '5.0MB',
    bundleUploadedAgo: '1 hour ago',
    files: [],
  ),
];

const List<LectureMaterial> kFizikaLectures = [
  LectureMaterial(
    lectureLabel: 'Lecture 1',
    lectureTitle: 'Mexanikanın əsasları',
    bundleFileName: 'Fizika Lecture 1...',
    bundleSize: '2.0MB',
    bundleUploadedAgo: '1 week ago',
    files: [],
  ),
  LectureMaterial(lectureLabel: 'Lecture 2', lectureTitle: 'Kinematika', bundleFileName: '', bundleSize: '', bundleUploadedAgo: '', files: []),
  LectureMaterial(lectureLabel: 'Lecture 3', lectureTitle: 'Dinamika', bundleFileName: '', bundleSize: '', bundleUploadedAgo: '', files: []),
  LectureMaterial(lectureLabel: 'Lecture 4', lectureTitle: 'Statika', bundleFileName: '', bundleSize: '', bundleUploadedAgo: '', files: []),
  LectureMaterial(lectureLabel: 'Lecture 5', lectureTitle: 'İş və Enerji', bundleFileName: '', bundleSize: '', bundleUploadedAgo: '', files: []),
  LectureMaterial(lectureLabel: 'Lecture 6', lectureTitle: 'İmpuls', bundleFileName: '', bundleSize: '', bundleUploadedAgo: '', files: []),
  LectureMaterial(lectureLabel: 'Lecture 7', lectureTitle: 'Molekulyar fizika', bundleFileName: '', bundleSize: '', bundleUploadedAgo: '', files: []),
  LectureMaterial(lectureLabel: 'Lecture 8', lectureTitle: 'Termodinamika', bundleFileName: '', bundleSize: '', bundleUploadedAgo: '', files: []),
  LectureMaterial(lectureLabel: 'Lecture 9', lectureTitle: 'Elektrostatika', bundleFileName: '', bundleSize: '', bundleUploadedAgo: '', files: []),
  LectureMaterial(lectureLabel: 'Lecture 10', lectureTitle: 'Sabit cərəyan', bundleFileName: '', bundleSize: '', bundleUploadedAgo: '', files: []),
  LectureMaterial(lectureLabel: 'Lecture 11', lectureTitle: 'Maqnit sahəsi', bundleFileName: '', bundleSize: '', bundleUploadedAgo: '', files: []),
  LectureMaterial(lectureLabel: 'Lecture 12', lectureTitle: 'Optika', bundleFileName: '', bundleSize: '', bundleUploadedAgo: '', files: []),
  LectureMaterial(lectureLabel: 'Lecture 13', lectureTitle: 'Atom fizikası', bundleFileName: '', bundleSize: '', bundleUploadedAgo: '', files: []),
];

const List<LectureMaterial> kAzLectures = [
  LectureMaterial(
    lectureLabel: 'Lecture 1',
    lectureTitle: 'Dil və nitq',
    bundleFileName: 'Azərbaycan dili L1...',
    bundleSize: '1.5MB',
    bundleUploadedAgo: '1 week ago',
    files: [],
  ),
  LectureMaterial(lectureLabel: 'Lecture 2', lectureTitle: 'Üslublar', bundleFileName: '', bundleSize: '', bundleUploadedAgo: '', files: []),
  LectureMaterial(lectureLabel: 'Lecture 3', lectureTitle: 'İşgüzar sənədlər', bundleFileName: '', bundleSize: '', bundleUploadedAgo: '', files: []),
  LectureMaterial(lectureLabel: 'Lecture 4', lectureTitle: 'Akademik yazı', bundleFileName: '', bundleSize: '', bundleUploadedAgo: '', files: []),
  LectureMaterial(lectureLabel: 'Lecture 5', lectureTitle: 'Nitq mədəniyyəti', bundleFileName: '', bundleSize: '', bundleUploadedAgo: '', files: []),
  LectureMaterial(lectureLabel: 'Lecture 6', lectureTitle: 'Orfoqrafiya', bundleFileName: '', bundleSize: '', bundleUploadedAgo: '', files: []),
  LectureMaterial(lectureLabel: 'Lecture 7', lectureTitle: 'Punktuasiya', bundleFileName: '', bundleSize: '', bundleUploadedAgo: '', files: []),
  LectureMaterial(lectureLabel: 'Lecture 8', lectureTitle: 'Leksikologiya', bundleFileName: '', bundleSize: '', bundleUploadedAgo: '', files: []),
  LectureMaterial(lectureLabel: 'Lecture 9', lectureTitle: 'Frazeologiya', bundleFileName: '', bundleSize: '', bundleUploadedAgo: '', files: []),
  LectureMaterial(lectureLabel: 'Lecture 10', lectureTitle: 'Morfologiya', bundleFileName: '', bundleSize: '', bundleUploadedAgo: '', files: []),
  LectureMaterial(lectureLabel: 'Lecture 11', lectureTitle: 'Sintaksis', bundleFileName: '', bundleSize: '', bundleUploadedAgo: '', files: []),
  LectureMaterial(lectureLabel: 'Lecture 12', lectureTitle: 'Nitq etiketi', bundleFileName: '', bundleSize: '', bundleUploadedAgo: '', files: []),
  LectureMaterial(lectureLabel: 'Lecture 13', lectureTitle: 'Təqdimat bacarıqları', bundleFileName: '', bundleSize: '', bundleUploadedAgo: '', files: []),
];

const List<LectureMaterial> kXettiLectures = [
  LectureMaterial(
    lectureLabel: 'Lecture 1',
    lectureTitle: 'Matrislər və determinantlar',
    bundleFileName: 'Matematika L1...',
    bundleSize: '2.5MB',
    bundleUploadedAgo: '1 week ago',
    files: [],
  ),
  LectureMaterial(lectureLabel: 'Lecture 2', lectureTitle: 'Xətti tənliklər sistemi', bundleFileName: '', bundleSize: '', bundleUploadedAgo: '', files: []),
  LectureMaterial(lectureLabel: 'Lecture 3', lectureTitle: 'Vektorlar', bundleFileName: '', bundleSize: '', bundleUploadedAgo: '', files: []),
  LectureMaterial(lectureLabel: 'Lecture 4', lectureTitle: 'Analitik həndəsə', bundleFileName: '', bundleSize: '', bundleUploadedAgo: '', files: []),
  LectureMaterial(lectureLabel: 'Lecture 5', lectureTitle: 'Müstəvi üzərində düz xətt', bundleFileName: '', bundleSize: '', bundleUploadedAgo: '', files: []),
  LectureMaterial(lectureLabel: 'Lecture 6', lectureTitle: 'İkinci tərtib əyrilər', bundleFileName: '', bundleSize: '', bundleUploadedAgo: '', files: []),
  LectureMaterial(lectureLabel: 'Lecture 7', lectureTitle: 'Fəzada müstəvi', bundleFileName: '', bundleSize: '', bundleUploadedAgo: '', files: []),
  LectureMaterial(lectureLabel: 'Lecture 8', lectureTitle: 'Xətti operatorlar', bundleFileName: '', bundleSize: '', bundleUploadedAgo: '', files: []),
  LectureMaterial(lectureLabel: 'Lecture 9', lectureTitle: 'Məxsusi ədədlər', bundleFileName: '', bundleSize: '', bundleUploadedAgo: '', files: []),
  LectureMaterial(lectureLabel: 'Lecture 10', lectureTitle: 'Kvadratik formalar', bundleFileName: '', bundleSize: '', bundleUploadedAgo: '', files: []),
  LectureMaterial(lectureLabel: 'Lecture 11', lectureTitle: 'Evklid fəzası', bundleFileName: '', bundleSize: '', bundleUploadedAgo: '', files: []),
  LectureMaterial(lectureLabel: 'Lecture 12', lectureTitle: 'Kompleks ədədlər', bundleFileName: '', bundleSize: '', bundleUploadedAgo: '', files: []),
  LectureMaterial(lectureLabel: 'Lecture 13', lectureTitle: 'Təkrar və yekun', bundleFileName: '', bundleSize: '', bundleUploadedAgo: '', files: []),
];

const List<LectureMaterial> kInfoLectures = [
  LectureMaterial(
    lectureLabel: 'Lecture 1',
    lectureTitle: 'İT-nin inkişaf tarixi',
    bundleFileName: 'İnfo L1...',
    bundleSize: '1.2MB',
    bundleUploadedAgo: '1 week ago',
    files: [],
  ),
  LectureMaterial(lectureLabel: 'Lecture 2', lectureTitle: 'Kompüterin arxitekturası', bundleFileName: '', bundleSize: '', bundleUploadedAgo: '', files: []),
  LectureMaterial(lectureLabel: 'Lecture 3', lectureTitle: 'Əməliyyat sistemləri', bundleFileName: '', bundleSize: '', bundleUploadedAgo: '', files: []),
  LectureMaterial(lectureLabel: 'Lecture 4', lectureTitle: 'Proqram təminatı', bundleFileName: '', bundleSize: '', bundleUploadedAgo: '', files: []),
  LectureMaterial(lectureLabel: 'Lecture 5', lectureTitle: 'Alqoritmləşdirmə', bundleFileName: '', bundleSize: '', bundleUploadedAgo: '', files: []),
  LectureMaterial(lectureLabel: 'Lecture 6', lectureTitle: 'Şəbəkə texnologiyaları', bundleFileName: '', bundleSize: '', bundleUploadedAgo: '', files: []),
  LectureMaterial(lectureLabel: 'Lecture 7', lectureTitle: 'İnternet xidmətləri', bundleFileName: '', bundleSize: '', bundleUploadedAgo: '', files: []),
  LectureMaterial(lectureLabel: 'Lecture 8', lectureTitle: 'Verilənlər bazası', bundleFileName: '', bundleSize: '', bundleUploadedAgo: '', files: []),
  LectureMaterial(lectureLabel: 'Lecture 9', lectureTitle: 'İnformasiya təhlükəsizliyi', bundleFileName: '', bundleSize: '', bundleUploadedAgo: '', files: []),
  LectureMaterial(lectureLabel: 'Lecture 10', lectureTitle: 'Bulud texnologiyaları', bundleFileName: '', bundleSize: '', bundleUploadedAgo: '', files: []),
  LectureMaterial(lectureLabel: 'Lecture 11', lectureTitle: 'Süni intellekt', bundleFileName: '', bundleSize: '', bundleUploadedAgo: '', files: []),
  LectureMaterial(lectureLabel: 'Lecture 12', lectureTitle: 'Multimedia', bundleFileName: '', bundleSize: '', bundleUploadedAgo: '', files: []),
  LectureMaterial(lectureLabel: 'Lecture 13', lectureTitle: 'Gələcək trendlər', bundleFileName: '', bundleSize: '', bundleUploadedAgo: '', files: []),
];

const List<LectureMaterial> kXariciLectures = [
  LectureMaterial(
    lectureLabel: 'Lecture 1',
    lectureTitle: 'Business Communication',
    bundleFileName: 'English L1...',
    bundleSize: '2.1MB',
    bundleUploadedAgo: '1 week ago',
    files: [],
  ),
  LectureMaterial(lectureLabel: 'Lecture 2', lectureTitle: 'Academic Writing', bundleFileName: '', bundleSize: '', bundleUploadedAgo: '', files: []),
  LectureMaterial(lectureLabel: 'Lecture 3', lectureTitle: 'Presentation Skills', bundleFileName: '', bundleSize: '', bundleUploadedAgo: '', files: []),
  LectureMaterial(lectureLabel: 'Lecture 4', lectureTitle: 'Negotiation', bundleFileName: '', bundleSize: '', bundleUploadedAgo: '', files: []),
  LectureMaterial(lectureLabel: 'Lecture 5', lectureTitle: 'Vocabulary', bundleFileName: '', bundleSize: '', bundleUploadedAgo: '', files: []),
  LectureMaterial(lectureLabel: 'Lecture 6', lectureTitle: 'Grammar Review', bundleFileName: '', bundleSize: '', bundleUploadedAgo: '', files: []),
  LectureMaterial(lectureLabel: 'Lecture 7', lectureTitle: 'Listening Practice', bundleFileName: '', bundleSize: '', bundleUploadedAgo: '', files: []),
  LectureMaterial(lectureLabel: 'Lecture 8', lectureTitle: 'Reading Strategies', bundleFileName: '', bundleSize: '', bundleUploadedAgo: '', files: []),
  LectureMaterial(lectureLabel: 'Lecture 9', lectureTitle: 'Email Etiquette', bundleFileName: '', bundleSize: '', bundleUploadedAgo: '', files: []),
  LectureMaterial(lectureLabel: 'Lecture 10', lectureTitle: 'Public Speaking', bundleFileName: '', bundleSize: '', bundleUploadedAgo: '', files: []),
  LectureMaterial(lectureLabel: 'Lecture 11', lectureTitle: 'Case Studies', bundleFileName: '', bundleSize: '', bundleUploadedAgo: '', files: []),
  LectureMaterial(lectureLabel: 'Lecture 12', lectureTitle: 'Cultural Awareness', bundleFileName: '', bundleSize: '', bundleUploadedAgo: '', files: []),
  LectureMaterial(lectureLabel: 'Lecture 13', lectureTitle: 'Final Review', bundleFileName: '', bundleSize: '', bundleUploadedAgo: '', files: []),
];

const List<LectureMaterial> kEmptyLectures = [];

final Map<String, List<LectureMaterial>> kSubjectLecturesMap = {
  '1': kProgLectures,
  '2': kFizikaLectures,
  '3': kAzLectures,
  '4': kXettiLectures,
  '5': kInfoLectures,
  '6': kXariciLectures,
};

int calculateTotalFiles(List<LectureMaterial> lectures) {
  return lectures.fold(0, (total, lecture) => total + lecture.files.length);
}

Map<String, IconData> kFileTypeIcons = {
  'Lecture': Icons.menu_book_rounded,
  'Presentation': Icons.slideshow_rounded,
  'Quiz': Icons.quiz_rounded,
  'Seminar': Icons.groups_rounded,
  'Other': Icons.insert_drive_file_rounded,
};

Map<String, Color> kFileTypeColors = {
  'Lecture': const Color(0xFF0569FF),
  'Presentation': const Color(0xFFE3993C),
  'Quiz': const Color(0xFF0F6E11),
  'Seminar': const Color(0xFFDA4979),
  'Other': const Color(0xFF838A97),
};
