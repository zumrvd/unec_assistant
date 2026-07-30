class GradeCalculatorResult {
  final String selectedSubject;
  final String selectedGrade;   // 'A', 'B', 'C', 'D'
  final int currentScore;
  final int maxScore;
  final int targetMinScore;     // min score needed for selected grade
  final int ptsNeededOnFinal;
  final int finalMax;

  const GradeCalculatorResult({
    required this.selectedSubject,
    required this.selectedGrade,
    required this.currentScore,
    required this.maxScore,
    required this.targetMinScore,
    required this.ptsNeededOnFinal,
    required this.finalMax,
  });
}
