import 'package:sqflite/sqflite.dart';
import 'package:tamdansers_app/database/db_helper.dart';

class StudentStatRepo {
  Future<double> getAttendancePercent(int studentId, int classId) async {
    final db = await DbHelper().initDatabase();
    final total = Sqflite.firstIntValue(await db.rawQuery('''
      SELECT COUNT(*) FROM tbl_attendance WHERE student_id = ? AND class_id = ?
    ''', [studentId, classId])) ?? 0;
    final present = Sqflite.firstIntValue(await db.rawQuery('''
      SELECT COUNT(*) FROM tbl_attendance WHERE student_id = ? AND class_id = ? AND status = 'present'
    ''', [studentId, classId])) ?? 0;
    if (total == 0) return 0.0;
    return present / total * 100.0;
  }

  Future<String?> getLatestScore(int studentId, int classId) async {
    final db = await DbHelper().initDatabase();
    final result = await db.rawQuery('''
      SELECT score FROM tbl_score WHERE student_id = ? AND class_id = ? ORDER BY created_at DESC LIMIT 1
    ''', [studentId, classId]);
    if (result.isNotEmpty) {
      final score = result.first['score'];
      if (score is num) {
        if (score >= 90) return 'A';
        if (score >= 80) return 'B';
        if (score >= 70) return 'C';
        if (score >= 60) return 'D';
        return 'F';
      }
    }
    return null;
  }
}
