class SeminarEntry {
  final String title;
  final String date;
  final int score;
  final int maxScore;

  const SeminarEntry({
    required this.title,
    required this.date,
    required this.score,
    this.maxScore = 10,
  });
}

