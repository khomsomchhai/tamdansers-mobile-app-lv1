class SubjectResult {
  final String subjectName;
  final String teacherName;
  final double score;

  SubjectResult({
    required this.subjectName,
    required this.teacherName,
    required this.score,
  });
}

class MontResult {
  final double totalScore;
  final double maxScore;
  final int rank;
  final double average;
  final List<SubjectResult> subjects;

  MontResult({
    required this.totalScore,
    required this.maxScore,
    required this.rank,
    required this.average,
    required this.subjects,
  });
}