import 'package:sqflite/sqflite.dart';
import 'package:tamdansers_app/database/db_helper.dart';

class HomeworkRepo {
  Future<int> createHomework({
    required String title,
    required String subject,
    required int classId,
    required int teacherId,
    String? instructions,
    String? deadline,
    String status = "active",
    String? attachmentPath,
  }) async {
    final db = await DbHelper().initDatabase();
    return await db.insert("tbl_homework", {
      "title": title,
      "subject": subject,
      "instructions": instructions,
      "class_id": classId,
      "teacher_id": teacherId,
      "deadline": deadline,
      "status": status,
      "attachment_path": attachmentPath,
      "created_at": DateTime.now().toIso8601String(),
    });
  }

  Future<List<Map<String, dynamic>>> getHomeworkByClass(int classId) async {
    final db = await DbHelper().initDatabase();
    return await db.rawQuery(
      '''
      SELECT h.*,
        COALESCE(sub_c.submitted_count, 0) AS submitted_count,
        COALESCE(stu_c.total_students, 0)  AS total_students
      FROM tbl_homework h
      LEFT JOIN (
        SELECT homework_id, COUNT(*) AS submitted_count
        FROM tbl_submission GROUP BY homework_id
      ) sub_c ON sub_c.homework_id = h.id
      LEFT JOIN (
        SELECT class_id, COUNT(*) AS total_students
        FROM tbl_student_class GROUP BY class_id
      ) stu_c ON stu_c.class_id = h.class_id
      WHERE h.class_id = ?
      ORDER BY h.created_at DESC
      ''',
      [classId],
    );
  }

  Future<List<Map<String, dynamic>>> getHomeworkByStatus(
      int classId, String status) async {
    final db = await DbHelper().initDatabase();
    return await db.query(
      "tbl_homework",
      where: "class_id = ? AND status = ?",
      whereArgs: [classId, status],
      orderBy: "created_at DESC",
    );
  }

  Future<List<Map<String, dynamic>>> getAllHomeworkByTeacher(
      int teacherId) async {
    final db = await DbHelper().initDatabase();
    return await db.rawQuery(
      '''
      SELECT h.*, c.name as class_name, c.grade as class_grade,
        COALESCE(sub_c.submitted_count, 0) AS submitted_count,
        COALESCE(stu_c.total_students, 0)  AS total_students
      FROM tbl_homework h
      LEFT JOIN tbl_class c ON h.class_id = c.id
      LEFT JOIN (
        SELECT homework_id, COUNT(*) AS submitted_count
        FROM tbl_submission GROUP BY homework_id
      ) sub_c ON sub_c.homework_id = h.id
      LEFT JOIN (
        SELECT class_id, COUNT(*) AS total_students
        FROM tbl_student_class GROUP BY class_id
      ) stu_c ON stu_c.class_id = h.class_id
      WHERE h.teacher_id = ?
      ORDER BY h.created_at DESC
      ''',
      [teacherId],
    );
  }

  Future<Map<String, dynamic>?> getHomeworkById(int id) async {
    final db = await DbHelper().initDatabase();
    final result = await db.query(
      "tbl_homework",
      where: "id = ?",
      whereArgs: [id],
    );
    if (result.isNotEmpty) return result.first;
    return null;
  }

  Future<int> updateHomeworkStatus(int id, String status) async {
    final db = await DbHelper().initDatabase();
    return await db.update(
      "tbl_homework",
      {"status": status},
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<int> updateHomework({
    required int id,
    required String title,
    required String subject,
    String? instructions,
    String? deadline,
    required String status,
    String? attachmentPath,
  }) async {
    final db = await DbHelper().initDatabase();
    return await db.update(
      "tbl_homework",
      {
        "title": title,
        "subject": subject,
        "instructions": instructions,
        "deadline": deadline,
        "status": status,
        "attachment_path": attachmentPath,
      },
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<int> deleteHomework(int id) async {
    final db = await DbHelper().initDatabase();
    return await db.delete("tbl_homework", where: "id = ?", whereArgs: [id]);
  }

  // ─── Submissions ───────────────────────────────────────────────────────────

  Future<void> submitHomework(
      {required int homeworkId, required int studentId}) async {
    final db = await DbHelper().initDatabase();
    await db.insert(
      "tbl_submission",
      {
        "homework_id": homeworkId,
        "student_id": studentId,
        "submitted_at": DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<void> unsubmitHomework(
      {required int homeworkId, required int studentId}) async {
    final db = await DbHelper().initDatabase();
    await db.delete(
      "tbl_submission",
      where: "homework_id = ? AND student_id = ?",
      whereArgs: [homeworkId, studentId],
    );
  }

  Future<List<Map<String, dynamic>>> getStudentsWithSubmissionStatus(
      {required int homeworkId, required int classId}) async {
    final db = await DbHelper().initDatabase();
    return await db.rawQuery(
      '''
      SELECT sc.id, sc.first_name, sc.last_name, sc.gender, sc.photo_path,
             CASE WHEN sub.id IS NOT NULL THEN 1 ELSE 0 END AS submitted,
             sub.submitted_at
      FROM tbl_student_class sc
      LEFT JOIN tbl_submission sub
        ON sub.student_id = sc.id AND sub.homework_id = ?
      WHERE sc.class_id = ?
      ORDER BY sc.first_name ASC
      ''',
      [homeworkId, classId],
    );
  }

  Future<List<Map<String, dynamic>>> getSubmissionsByHomework(
      int homeworkId) async {
    final db = await DbHelper().initDatabase();
    return await db.rawQuery(
      '''
      SELECT s.*, sc.first_name, sc.last_name, sc.gender
      FROM tbl_submission s
      JOIN tbl_student_class sc ON s.student_id = sc.id
      WHERE s.homework_id = ?
      ORDER BY s.submitted_at DESC
      ''',
      [homeworkId],
    );
  }

  Future<List<Map<String, dynamic>>> getHomeworkForStudent(
      int studentId, int classId) async {
    final db = await DbHelper().initDatabase();
    return await db.rawQuery(
      '''
      SELECT h.*, 
             CASE WHEN sub.id IS NOT NULL THEN 1 ELSE 0 END AS submitted,
             sub.submitted_at
      FROM tbl_homework h
      LEFT JOIN tbl_submission sub
        ON sub.homework_id = h.id AND sub.student_id = ?
      WHERE h.class_id = ?
      ORDER BY h.created_at DESC
      ''',
      [studentId, classId],
    );
  }
}
