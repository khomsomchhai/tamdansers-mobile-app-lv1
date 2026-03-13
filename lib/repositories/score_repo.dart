import 'package:tamdansers_app/database/db_helper.dart';

class ScoreRepo {
  Future<int> addScore({
    required int studentId,
    required int classId,
    required String subject,
    required double score,
  }) async {
    final db = await DbHelper().initDatabase();
    return await db.insert('tbl_score', {
      'student_id': studentId,
      'class_id': classId,
      'subject': subject,
      'score': score,
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  Future<List<Map<String, dynamic>>> getScoresByStudent(int studentId) async {
    final db = await DbHelper().initDatabase();
    return await db.query(
      'tbl_score',
      where: 'student_id = ?',
      whereArgs: [studentId],
      orderBy: 'subject ASC',
    );
  }

  Future<int> updateScore({
    required int id,
    required double score,
  }) async {
    final db = await DbHelper().initDatabase();
    return await db.update(
      'tbl_score',
      {'score': score},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteScore(int id) async {
    final db = await DbHelper().initDatabase();
    return await db.delete('tbl_score', where: 'id = ?', whereArgs: [id]);
  }

  /// Returns average score of each student in a class, used to compute rank.
  Future<int> getRankInClass(int studentId, int classId) async {
    final db = await DbHelper().initDatabase();
    final rows = await db.rawQuery('''
      SELECT student_id, AVG(score) as avg_score
      FROM tbl_score
      WHERE class_id = ?
      GROUP BY student_id
      ORDER BY avg_score DESC
    ''', [classId]);
    for (int i = 0; i < rows.length; i++) {
      if (rows[i]['student_id'] == studentId) return i + 1;
    }
    return 0;
  }
}
