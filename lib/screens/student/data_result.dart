import 'package:tamdansers_app/screens/student/data_schedule.dart';

class SubjectResult {
  final SubjectModel subject;
  final TeacherModel teacher;
  final double score;

  const SubjectResult({
    required this.subject,
    required this.teacher,
    required this.score,
  });
}

class MonthResult {
  final double totalScore;
  final double maxScore;
  final int rank;
  final double average;
  final List<SubjectResult> subjects;

  const MonthResult({
    required this.totalScore,
    required this.maxScore,
    required this.rank,
    required this.average,
    required this.subjects,
  });

  double get calculatedAverage => subjects.isEmpty
      ? 0
      : subjects.map((e) => e.score).reduce((a, b) => a + b) / subjects.length;
}
