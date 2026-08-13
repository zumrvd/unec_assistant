class StudentProfile {
  final String studentName;
  final String studentId;
  final String initials;
  final bool isActive;
  final String faculty;
  final String major;
  final double gpa;
  final List<String> clubMemberships;
  final String groupCode;
  final String year;
  final String enrollmentDate;
  final int earnedCredits;
  final int totalCredits;

  const StudentProfile({
    required this.studentName,
    required this.studentId,
    required this.initials,
    this.isActive = true,
    required this.faculty,
    required this.major,
    required this.gpa,
    required this.clubMemberships,
    required this.groupCode,
    required this.year,
    required this.enrollmentDate,
    required this.earnedCredits,
    required this.totalCredits,
  });

  String toShareableText() {
    return '''
👤 $studentName
🎓 UNEC · $year · $groupCode
🎭 Business Info. Technologies
🏛️ $faculty
📅 Enrolled: $enrollmentDate
⭐ GPA: ${gpa.toStringAsFixed(2)} / 100.00
📊 Credits: $earnedCredits / $totalCredits ECTS
🤝 Clubs: ${clubMemberships.join(', ')}
''';
  }
}
