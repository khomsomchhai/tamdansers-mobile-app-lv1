import 'package:tamdansers_app/database/db_helper.dart';

class AttendanceStudentData {
  Future<List<Map<String, dynamic>>> getAttendanceByStudent(
    int studentId, {
    String? monthPrefix,
  }) async {
    final db = await DbHelper().initDatabase();

    if (monthPrefix != null && monthPrefix.isNotEmpty) {
      return await db.rawQuery(
        '''SELECT date, status
           FROM tbl_attendance
           WHERE student_id = ? AND date LIKE ?
           ORDER BY date DESC''',
        [studentId, '$monthPrefix%'],
      );
    }

    return await db.rawQuery(
      '''SELECT date, status
         FROM tbl_attendance
         WHERE student_id = ?
         ORDER BY date DESC''',
      [studentId],
    );
  }

  Future<Map<String, int>> getAttendanceSummaryByStudent(
    int studentId, {
    String? monthPrefix,
  }) async {
    final db = await DbHelper().initDatabase();

    late final List<Map<String, Object?>> result;
    if (monthPrefix != null && monthPrefix.isNotEmpty) {
      result = await db.rawQuery(
        '''SELECT status, COUNT(*) as count
           FROM tbl_attendance
           WHERE student_id = ? AND date LIKE ?
           GROUP BY status''',
        [studentId, '$monthPrefix%'],
      );
    } else {
      result = await db.rawQuery(
        '''SELECT status, COUNT(*) as count
           FROM tbl_attendance
           WHERE student_id = ?
           GROUP BY status''',
        [studentId],
      );
    }

    final summary = {
      'present': 0,
      'absent': 0,
      'late': 0,
    };

    for (final row in result) {
      final status = row['status'] as String;
      summary[status] = row['count'] as int;
    }

    return summary;
  }

  Future<List<String>> getDistinctMonthsByStudent(int studentId) async {
    final db = await DbHelper().initDatabase();
    final result = await db.rawQuery(
      '''SELECT DISTINCT substr(date, 1, 7) as month
         FROM tbl_attendance
         WHERE student_id = ?
         ORDER BY month DESC''',
      [studentId],
    );

    return result
        .map((row) => (row['month'] as String?) ?? '')
        .where((month) => month.isNotEmpty)
        .toList();
  }
}
