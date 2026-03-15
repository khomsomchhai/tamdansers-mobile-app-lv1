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

  /// All scores for a given class + subject, joined with student name.
  Future<List<Map<String, dynamic>>> getScoresByClassAndSubject(
      int classId, String subject) async {
    final db = await DbHelper().initDatabase();
    return await db.rawQuery('''
      SELECT s.id, s.student_id, s.score, s.created_at,
             sc.first_name, sc.last_name, sc.gender
      FROM tbl_score s
      INNER JOIN tbl_student_class sc ON s.student_id = sc.id
      WHERE s.class_id = ? AND s.subject = ?
      ORDER BY sc.first_name ASC
    ''', [classId, subject]);
  }

  /// Check if a score already exists for a student+class+subject.
  Future<Map<String, dynamic>?> findScore(
      int studentId, int classId, String subject) async {
    final db = await DbHelper().initDatabase();
    final rows = await db.query(
      'tbl_score',
      where: 'student_id = ? AND class_id = ? AND subject = ?',
      whereArgs: [studentId, classId, subject],
      limit: 1,
    );
    return rows.isNotEmpty ? rows.first : null;
  }

  /// Insert or update a score for student+class+subject.
  Future<void> upsertScore({
    required int studentId,
    required int classId,
    required String subject,
    required double score,
  }) async {
    final existing = await findScore(studentId, classId, subject);
    if (existing != null) {
      await updateScore(id: existing['id'] as int, score: score);
    } else {
      await addScore(
        studentId: studentId,
        classId: classId,
        subject: subject,
        score: score,
      );
    }
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
