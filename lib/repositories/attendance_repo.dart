import 'package:tamdansers_app/database/db_helper.dart';

class AttendanceRepo {
  Future<int> saveAttendance({
    required int classId,
    required int studentId,
    required String date,
    required String status,
  }) async {
    final db = await DbHelper().initDatabase();
    return await db.rawInsert(
      '''INSERT OR REPLACE INTO tbl_attendance
         (class_id, student_id, date, status)
         VALUES (?, ?, ?, ?)''',
      [classId, studentId, date, status],
    );
  }

  Future<List<Map<String, dynamic>>> getAttendanceWithStudents(
      int classId, String date) async {
    final db = await DbHelper().initDatabase();
    return await db.rawQuery(
      '''SELECT s.id as student_id, s.first_name, s.last_name, s.gender,
                s.photo_path,
                COALESCE(a.status, 'present') as status
         FROM tbl_student_class s
         LEFT JOIN tbl_attendance a
           ON a.student_id = s.id AND a.class_id = ? AND a.date = ?
         WHERE s.class_id = ?
         ORDER BY s.first_name ASC''',
      [classId, date, classId],
    );
  }

  Future<Map<String, int>> getAttendanceSummary(
      int classId, String date) async {
    final db = await DbHelper().initDatabase();
    final result = await db.rawQuery(
      '''SELECT status, COUNT(*) as count
         FROM tbl_attendance
         WHERE class_id = ? AND date = ?
         GROUP BY status''',
      [classId, date],
    );
    final total = await db.rawQuery(
      "SELECT COUNT(*) as count FROM tbl_student_class WHERE class_id = ?",
      [classId],
    );
    final totalCount = total.first["count"] as int;
    final Map<String, int> summary = {
      "present": 0,
      "absent": 0,
      "late": 0,
      "total": totalCount,
    };
    for (final row in result) {
      summary[row["status"] as String] = row["count"] as int;
    }
    final recorded =
        summary["present"]! + summary["absent"]! + summary["late"]!;
    summary["present"] = summary["present"]! + (totalCount - recorded);
    return summary;
  }

  Future<int> updateAttendance(int id, String status) async {
    final db = await DbHelper().initDatabase();
    return await db.update(
      "tbl_attendance",
      {"status": status},
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<List<String>> getDistinctDates(int classId) async {
    final db = await DbHelper().initDatabase();
    final result = await db.rawQuery(
      '''SELECT DISTINCT date FROM tbl_attendance
         WHERE class_id = ?
         ORDER BY date DESC''',
      [classId],
    );
    return result.map((r) => r["date"] as String).toList();
  }

  Future<List<Map<String, dynamic>>> getAttendanceHistoryForStudent(
      int studentId, int classId) async {
    final db = await DbHelper().initDatabase();
    return await db.rawQuery(
      '''SELECT a.date, a.status
         FROM tbl_attendance a
         WHERE a.student_id = ? AND a.class_id = ?
         ORDER BY a.date DESC''',
      [studentId, classId],
    );
  }

  Future<List<Map<String, dynamic>>> getAttendanceByStudentAndMonth(
      int studentId, int classId, String month) async {
    final db = await DbHelper().initDatabase();
    return await db.rawQuery(
      '''SELECT id, date, status
         FROM tbl_attendance
         WHERE student_id = ? AND class_id = ? AND date LIKE ?
         ORDER BY date DESC''',
      [studentId, classId, '$month%'],
    );
  }

  Future<Map<String, int>> getAttendanceSummaryForStudent(
      int studentId, int classId, String month) async {
    final db = await DbHelper().initDatabase();
    final result = await db.rawQuery(
      '''SELECT status, COUNT(*) as count
         FROM tbl_attendance
         WHERE student_id = ? AND class_id = ? AND date LIKE ?
         GROUP BY status''',
      [studentId, classId, '$month%'],
    );
    final Map<String, int> summary = {
      "present": 0,
      "absent": 0,
      "late": 0,
      "total": 0,
    };
    for (final row in result) {
      final status = row["status"] as String;
      final count = row["count"] as int;
      summary[status] = count;
      summary["total"] = summary["total"]! + count;
    }
    return summary;
  }
}
