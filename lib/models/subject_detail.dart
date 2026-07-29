class SubjectDetail {
  final String subjectCode;
  final String subjectName;
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

  const SubjectDetail({
    required this.subjectCode,
    required this.subjectName,
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
  });
}
