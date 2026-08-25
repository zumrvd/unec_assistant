import 'package:flutter/material.dart';

import '../models/semester_summary.dart';
import '../models/seminar_entry.dart';
import '../models/subject_detail.dart';
import 'academic_repository.dart';

/// In-memory implementation of [AcademicRepository] backed by the same
/// mock data that previously lived as `const` values inside
/// `subject_detail_provider.dart`.
///
/// ## Swapping to the real API
/// Replace this class with `ApiAcademicRepository` in
/// `lib/data/repository_providers.dart`. This file and all other files
/// remain untouched.
class MockAcademicRepository implements AcademicRepository {
  // -------------------------------------------------------------------------
  // Semester catalogue
  // -------------------------------------------------------------------------

  static final _semesters = [
    SemesterSummary(
      semesterId: 'fall-2025',
      label: 'FALL 2025',
      startDate: DateTime(2025, 9, 15),
      endDate: DateTime(2025, 12, 28),
      isCurrent: true,
    ),
  ];

  // -------------------------------------------------------------------------
  // Subject data
  // All SubjectDetail constants previously in subject_detail_provider.dart
  // live here. file-count values are pre-computed from the mock material data.
  // -------------------------------------------------------------------------

  static const _prog = SubjectDetail(
    subjectId: '1',
    subjectCode: '00035 - P1',
    subjectName: 'Programlaşdırmanın əsasları',
    subjectTag: 'Lecture · Seminar',
    teacherName: 'Prof. Əli Böyükkişiyev',
    teacherRank: 'Associate Professor, CS Dept.',
    teacherEmail: 'aliboyukkisiyev@unec.edu.az',
    semesterLabel: 'in this semester',
    semesterType: 'FALL semester, 2025',
    startDate: 'September 15',
    endDate: 'December 28',
    totalCredits: 30,
    totalSubjects: 6,
    totalHours: 900,
    auditoriumHours: 230,
    lectureHours: 120,
    seminarHours: 195,
    labHours: 15,
    subjectTotalHours: 180,
    subjectAuditoriumHours: 60,
    subjectLectureHours: 30,
    subjectSeminarHours: 35,
    sessionsPerWeek: 3,
    hrsPerWeek: 6,
    classDays: 'Mon · Fri',
    subjectCredit: 6,
    gradeTag: 'Seminar · Midterm',
    midtermScore: 28,
    midtermMax: 30,
    midtermScheduled: true,
    midtermNote: '',
    midtermExamCode: '10_25_01_575-1_00035_Proqramlaşdırmanın əsasları_sq',
    midtermDate: '11/12/2025',
    seminarMax: 20,
    seminarsTotal: 4,
    seminarEntries: [
      SeminarEntry(
        title: 'Seminar 4 - Dəyişənlər və məlumat tipləri',
        date: 'Oct 10, 2026',
        score: 10,
      ),
      SeminarEntry(
        title: 'Seminar 7 - Funksiyalar və prosedurlar',
        date: 'Nov 14, 2026',
        score: 9,
      ),
    ],
    finalScore: 0,
    finalMax: 50,
    finalScheduled: false,
    finalNote: 'Final not scheduled yet',
    absencesUsed: 2,
    absenceLimit: 7,
    // 5 files in Lecture 1 (Lecture, Presentation, Quiz, Seminar, Other)
    fileCount: 5,
    icon: Icons.menu_book_rounded,
    iconColor: Color(0xFF0569FF),
    iconBg: Color(0x260569FF),
  );

  static const _fizika = SubjectDetail(
    subjectId: '2',
    subjectCode: '00036 - F1',
    subjectName: 'Fizika',
    subjectTag: 'Lecture · Laboratory',
    teacherName: 'Doc. Rəşad Qasımov',
    teacherRank: 'Head of Physics Dept.',
    teacherEmail: 'rashadgasimov@unec.edu.az',
    semesterLabel: 'in this semester',
    semesterType: 'FALL semester, 2025',
    startDate: 'September 15',
    endDate: 'December 28',
    totalCredits: 30,
    totalSubjects: 6,
    totalHours: 900,
    auditoriumHours: 230,
    lectureHours: 120,
    seminarHours: 195,
    labHours: 15,
    subjectTotalHours: 180,
    subjectAuditoriumHours: 60,
    subjectLectureHours: 30,
    subjectSeminarHours: 0,
    sessionsPerWeek: 2,
    hrsPerWeek: 4,
    classDays: 'Tue · Thu',
    subjectCredit: 5,
    gradeTag: 'Laboratory',
    midtermScore: 0,
    midtermMax: 30,
    midtermScheduled: false,
    midtermNote: 'Midterm not scheduled yet',
    midtermExamCode: '123',
    midtermDate: '11/12/2025',
    seminarMax: 20,
    seminarsTotal: 4,
    seminarEntries: [],
    finalScore: 0,
    finalMax: 50,
    finalScheduled: false,
    finalNote: 'Final not scheduled yet',
    absencesUsed: 7,
    absenceLimit: 7,
    fileCount: 0,
    icon: Icons.menu_book_rounded,
    iconColor: Color(0xFF0F6E11),
    iconBg: Color(0x260F6E11),
  );

  static const _az = SubjectDetail(
    subjectId: '3',
    subjectCode: '00037 - A1',
    subjectName: 'Azərbaycan dilində işguzar və akademik kommunikasiya',
    subjectTag: 'Seminar (Online)',
    teacherName: 'Dr. Günel Məmmədova',
    teacherRank: 'Senior Lecturer',
    teacherEmail: 'gunelmammadova@unec.edu.az',
    semesterLabel: 'in this semester',
    semesterType: 'FALL semester, 2025',
    startDate: 'September 15',
    endDate: 'December 28',
    totalCredits: 30,
    totalSubjects: 6,
    totalHours: 900,
    auditoriumHours: 230,
    lectureHours: 120,
    seminarHours: 195,
    labHours: 15,
    subjectTotalHours: 120,
    subjectAuditoriumHours: 45,
    subjectLectureHours: 0,
    subjectSeminarHours: 45,
    sessionsPerWeek: 1,
    hrsPerWeek: 2,
    classDays: 'Wed',
    subjectCredit: 4,
    gradeTag: 'Seminar',
    midtermScore: 0,
    midtermMax: 30,
    midtermScheduled: false,
    midtermNote: 'Midterm not scheduled yet',
    midtermExamCode: '',
    midtermDate: '',
    seminarMax: 20,
    seminarsTotal: 4,
    seminarEntries: [],
    finalScore: 0,
    finalMax: 50,
    finalScheduled: false,
    finalNote: 'Final not scheduled yet',
    absencesUsed: 0,
    absenceLimit: 7,
    fileCount: 0,
    icon: Icons.menu_book_rounded,
    iconColor: Color(0xFF854F0B),
    iconBg: Color(0x26E3993C),
  );

  static const _xetti = SubjectDetail(
    subjectId: '4',
    subjectCode: '00038 - X1',
    subjectName: 'Xətti cəbr və analitik həndəsə',
    subjectTag: 'Lecture · Seminar',
    teacherName: 'Prof. Vaqif Quliyev',
    teacherRank: 'Member of Academy of Sciences',
    teacherEmail: 'vaqifguliyev@unec.edu.az',
    semesterLabel: 'in this semester',
    semesterType: 'FALL semester, 2025',
    startDate: 'September 15',
    endDate: 'December 28',
    totalCredits: 30,
    totalSubjects: 6,
    totalHours: 900,
    auditoriumHours: 230,
    lectureHours: 120,
    seminarHours: 195,
    labHours: 15,
    subjectTotalHours: 150,
    subjectAuditoriumHours: 60,
    subjectLectureHours: 30,
    subjectSeminarHours: 30,
    sessionsPerWeek: 2,
    hrsPerWeek: 4,
    classDays: 'Mon · Fri',
    subjectCredit: 6,
    gradeTag: 'Seminar · Midterm',
    midtermScore: 25,
    midtermMax: 30,
    midtermScheduled: true,
    midtermNote: '',
    midtermExamCode: '',
    midtermDate: '',
    seminarMax: 20,
    seminarsTotal: 4,
    seminarEntries: [],
    finalScore: 0,
    finalMax: 50,
    finalScheduled: false,
    finalNote: 'Final not scheduled yet',
    absencesUsed: 4,
    absenceLimit: 7,
    fileCount: 0,
    icon: Icons.menu_book_rounded,
    iconColor: Color(0xFF993C1D),
    iconBg: Color(0x26993C1D),
  );

  static const _info = SubjectDetail(
    subjectId: '5',
    subjectCode: '00039 - I1',
    subjectName: 'İnformasiya texnologiyalarının əsasları',
    subjectTag: 'Lecture · Seminar',
    teacherName: 'Doc. Sevinc Abasova',
    teacherRank: 'Associate Professor',
    teacherEmail: 'sevincabasova@unec.edu.az',
    semesterLabel: 'in this semester',
    semesterType: 'FALL semester, 2025',
    startDate: 'September 15',
    endDate: 'December 28',
    totalCredits: 30,
    totalSubjects: 6,
    totalHours: 900,
    auditoriumHours: 230,
    lectureHours: 120,
    seminarHours: 195,
    labHours: 15,
    subjectTotalHours: 150,
    subjectAuditoriumHours: 60,
    subjectLectureHours: 30,
    subjectSeminarHours: 30,
    sessionsPerWeek: 3,
    hrsPerWeek: 6,
    classDays: 'Thu',
    subjectCredit: 6,
    gradeTag: 'Seminar',
    midtermScore: 0,
    midtermMax: 30,
    midtermScheduled: false,
    midtermNote: 'Midterm not scheduled yet',
    midtermExamCode: '',
    midtermDate: '',
    seminarMax: 20,
    seminarsTotal: 4,
    seminarEntries: [],
    finalScore: 0,
    finalMax: 50,
    finalScheduled: false,
    finalNote: 'Final not scheduled yet',
    absencesUsed: 4,
    absenceLimit: 7,
    fileCount: 0,
    icon: Icons.menu_book_rounded,
    iconColor: Color(0xFFDA4979),
    iconBg: Color(0x26DA4979),
  );

  static const _xarici = SubjectDetail(
    subjectId: '6',
    subjectCode: '00040 - X2',
    subjectName: 'Xarici dildə işguzar və akademik kommunikasiya',
    subjectTag: 'Seminar',
    teacherName: 'Lalə Hacıyeva',
    teacherRank: 'Senior Instructor',
    teacherEmail: 'lalahajiyeva@unec.edu.az',
    semesterLabel: 'in this semester',
    semesterType: 'FALL semester, 2025',
    startDate: 'September 15',
    endDate: 'December 28',
    totalCredits: 30,
    totalSubjects: 6,
    totalHours: 900,
    auditoriumHours: 230,
    lectureHours: 120,
    seminarHours: 195,
    labHours: 15,
    subjectTotalHours: 120,
    subjectAuditoriumHours: 45,
    subjectLectureHours: 0,
    subjectSeminarHours: 45,
    sessionsPerWeek: 1,
    hrsPerWeek: 2,
    classDays: 'Wed',
    subjectCredit: 3,
    gradeTag: 'Seminar',
    midtermScore: 0,
    midtermMax: 30,
    midtermScheduled: false,
    midtermNote: 'Midterm not scheduled yet',
    midtermExamCode: '',
    midtermDate: '',
    seminarMax: 20,
    seminarsTotal: 4,
    seminarEntries: [
      SeminarEntry(
        title: 'Seminar 6 - Past Tense and Future Tense',
        date: 'Dec 1, 2026',
        score: 1,
      ),
    ],
    finalScore: 0,
    finalMax: 50,
    finalScheduled: false,
    finalNote: 'Final not scheduled yet',
    absencesUsed: 2,
    absenceLimit: 7,
    fileCount: 0,
    icon: Icons.menu_book_rounded,
    iconColor: Color(0xFF534AB7),
    iconBg: Color(0x26534AB7),
  );

  static const _allSubjects = [_prog, _fizika, _az, _xetti, _info, _xarici];

  // -------------------------------------------------------------------------
  // AcademicRepository implementation
  // -------------------------------------------------------------------------

  @override
  Future<List<SemesterSummary>> fetchSemesters() async {
    return List.unmodifiable(_semesters);
  }

  @override
  Future<List<SubjectDetail>> fetchSubjects(String semesterId) async {
    // Mock: semester ID is ignored since we only have one semester of data.
    return List.unmodifiable(_allSubjects);
  }

  @override
  Future<SubjectDetail> fetchSubjectById(
    String subjectId,
    String semesterId,
  ) async {
    return _allSubjects.firstWhere(
      (s) => s.subjectId == subjectId,
      orElse: () => throw StateError(
        'MockAcademicRepository: subject "$subjectId" not found.',
      ),
    );
  }
}
