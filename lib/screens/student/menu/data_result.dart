import 'package:tamdansers_app/screens/student/menu/data_schedule.dart';

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

class ResultMapper {
  static SubjectModel getSubjectModel(String subjectName) {
    switch (subjectName) {
      case 'គណិតវិទ្យា':
        return SubjectModel.math;
      case 'ភាសាខ្មែរ':
        return SubjectModel.khmer;
      case 'ភូមិវិទ្យា':
        return SubjectModel.geography;
      case 'ជីវវិទ្យា':
        return SubjectModel.biology;
      case 'រូបវិទ្យា':
        return SubjectModel.physics;
      case 'គីមីវិទ្យា':
        return SubjectModel.chemistry;
      case 'ប្រវត្តិវិទ្យា':
        return SubjectModel.history;
      case 'ភាសាអង់គ្លេស':
        return SubjectModel.english;
      default:
        return SubjectModel.math;
    }
  }
  static TeacherModel getTeacherModel(String teacherName) {
    switch (teacherName) {
      case 'លោក សុខា':
        return Teachers.sokha;
      case 'លោក ចន្ទ':
        return Teachers.chan;
      case 'លោក រ័ត្ន':
        return Teachers.rith;
      case 'លោក ចន្ទ្រា':
        return Teachers.chanda;
      case 'លោក វីរៈ':
        return Teachers.virak;
      case 'លោក លីណា':
        return Teachers.lina;
      case 'លោក សុផល':
        return Teachers.sophal;
      case 'លោក បូផា':
        return Teachers.bopha;
      case 'លោក ពេជ្រ':
        return Teachers.pich;
      default:
        return Teachers.sokha;
    }
  }
}
