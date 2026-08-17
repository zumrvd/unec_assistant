import 'package:flutter/material.dart';
import 'seminar_entry.dart';

class SubjectDetail {
  final String subjectId;
  final String subjectCode;
  final String subjectName;
  final String subjectTag;
  final String teacherName;
  final String teacherRank;
  final String teacherEmail;
  final String semesterLabel;
  final String semesterType;
  final String startDate;
  final String endDate;
  final int totalCredits;
  final int totalSubjects;
  final int totalHours;
  final int auditoriumHours;
  final int lectureHours;
  final int seminarHours;
  final int labHours;
  final int subjectTotalHours;
  final int subjectAuditoriumHours;
  final int subjectLectureHours;
  final int subjectSeminarHours;
  final int sessionsPerWeek;
  final int hrsPerWeek;
  final String classDays;
  final int subjectCredit;

  // Grade fields
  final String gradeTag;
  final int midtermScore;
  final int midtermMax;
  final bool midtermScheduled;
  final String midtermNote;
  final String midtermExamCode;
  final String midtermDate;
  final int seminarMax;
  final int seminarsTotal;
  final List<SeminarEntry> seminarEntries;
  final int finalScore;
  final int finalMax;
  final bool finalScheduled;
  final String finalNote;

  // Attendance fields
  final int absencesUsed;
  final int absenceLimit;

  // Material fields
  final int fileCount;
  final IconData icon;
  final Color iconColor;
  final Color iconBg;

  const SubjectDetail({
    required this.subjectId,
    required this.subjectCode,
    required this.subjectName,
    required this.subjectTag,
    required this.teacherName,
    required this.teacherRank,
    required this.teacherEmail,
    required this.semesterLabel,
    required this.semesterType,
    required this.startDate,
    required this.endDate,
    required this.totalCredits,
    required this.totalSubjects,
    required this.totalHours,
    required this.auditoriumHours,
    required this.lectureHours,
    required this.seminarHours,
    required this.labHours,
    required this.subjectTotalHours,
    required this.subjectAuditoriumHours,
    required this.subjectLectureHours,
    required this.subjectSeminarHours,
    required this.sessionsPerWeek,
    required this.hrsPerWeek,
    required this.classDays,
    required this.subjectCredit,
    required this.gradeTag,
    required this.midtermScore,
    required this.midtermMax,
    required this.midtermScheduled,
    required this.midtermNote,
    required this.midtermExamCode,
    required this.midtermDate,
    required this.seminarMax,
    required this.seminarsTotal,
    required this.seminarEntries,
    required this.finalScore,
    required this.finalMax,
    required this.finalScheduled,
    required this.finalNote,
    required this.absencesUsed,
    required this.absenceLimit,
    required this.fileCount,
    required this.icon,
    required this.iconColor,
    required this.iconBg,
  });

  int get seminarScore {
    if (seminarEntries.isEmpty) return 0;
    final double sum =
        seminarEntries.fold(0, (total, entry) => total + entry.score);
    // Corrected Formula: (sum * 2) / seminarsTotal
    return (sum * 2 / seminarsTotal).round();
  }

  int get seminarsGraded => seminarEntries.length;

  int get currentScore => seminarScore + midtermScore + finalScore;

  int get maxScore => seminarMax + midtermMax + finalMax;

  bool get needsAttention => (absencesUsed / absenceLimit) >= 0.5;

  String get finalExamDate => endDate;

  SubjectDetail copyWith({
    String? subjectId,
    String? subjectCode,
    String? subjectName,
    String? subjectTag,
    String? teacherName,
    String? teacherRank,
    String? teacherEmail,
    String? semesterLabel,
    String? semesterType,
    String? startDate,
    String? endDate,
    int? totalCredits,
    int? totalSubjects,
    int? totalHours,
    int? auditoriumHours,
    int? lectureHours,
    int? seminarHours,
    int? labHours,
    int? subjectTotalHours,
    int? subjectAuditoriumHours,
    int? subjectLectureHours,
    int? subjectSeminarHours,
    int? sessionsPerWeek,
    int? hrsPerWeek,
    String? classDays,
    int? subjectCredit,
    String? gradeTag,
    int? midtermScore,
    int? midtermMax,
    bool? midtermScheduled,
    String? midtermNote,
    String? midtermExamCode,
    String? midtermDate,
    int? seminarMax,
    int? seminarsTotal,
    List<SeminarEntry>? seminarEntries,
    int? finalScore,
    int? finalMax,
    bool? finalScheduled,
    String? finalNote,
    int? absencesUsed,
    int? absenceLimit,
    int? fileCount,
    IconData? icon,
    Color? iconColor,
    Color? iconBg,
  }) {
    return SubjectDetail(
      subjectId: subjectId ?? this.subjectId,
      subjectCode: subjectCode ?? this.subjectCode,
      subjectName: subjectName ?? this.subjectName,
      subjectTag: subjectTag ?? this.subjectTag,
      teacherName: teacherName ?? this.teacherName,
      teacherRank: teacherRank ?? this.teacherRank,
      teacherEmail: teacherEmail ?? this.teacherEmail,
      semesterLabel: semesterLabel ?? this.semesterLabel,
      semesterType: semesterType ?? this.semesterType,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      totalCredits: totalCredits ?? this.totalCredits,
      totalSubjects: totalSubjects ?? this.totalSubjects,
      totalHours: totalHours ?? this.totalHours,
      auditoriumHours: auditoriumHours ?? this.auditoriumHours,
      lectureHours: lectureHours ?? this.lectureHours,
      seminarHours: seminarHours ?? this.seminarHours,
      labHours: labHours ?? this.labHours,
      subjectTotalHours: subjectTotalHours ?? this.subjectTotalHours,
      subjectAuditoriumHours:
          subjectAuditoriumHours ?? this.subjectAuditoriumHours,
      subjectLectureHours: subjectLectureHours ?? this.subjectLectureHours,
      subjectSeminarHours: subjectSeminarHours ?? this.subjectSeminarHours,
      sessionsPerWeek: sessionsPerWeek ?? this.sessionsPerWeek,
      hrsPerWeek: hrsPerWeek ?? this.hrsPerWeek,
      classDays: classDays ?? this.classDays,
      subjectCredit: subjectCredit ?? this.subjectCredit,
      gradeTag: gradeTag ?? this.gradeTag,
      midtermScore: midtermScore ?? this.midtermScore,
      midtermMax: midtermMax ?? this.midtermMax,
      midtermScheduled: midtermScheduled ?? this.midtermScheduled,
      midtermNote: midtermNote ?? this.midtermNote,
      midtermExamCode: midtermExamCode ?? this.midtermExamCode,
      midtermDate: midtermDate ?? this.midtermDate,
      seminarMax: seminarMax ?? this.seminarMax,
      seminarsTotal: seminarsTotal ?? this.seminarsTotal,
      seminarEntries: seminarEntries ?? this.seminarEntries,
      finalScore: finalScore ?? this.finalScore,
      finalMax: finalMax ?? this.finalMax,
      finalScheduled: finalScheduled ?? this.finalScheduled,
      finalNote: finalNote ?? this.finalNote,
      absencesUsed: absencesUsed ?? this.absencesUsed,
      absenceLimit: absenceLimit ?? this.absenceLimit,
      fileCount: fileCount ?? this.fileCount,
      icon: icon ?? this.icon,
      iconColor: iconColor ?? this.iconColor,
      iconBg: iconBg ?? this.iconBg,
    );
  }
}
