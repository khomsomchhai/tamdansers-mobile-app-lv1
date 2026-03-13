import 'package:tamdansers_app/database/db_helper.dart';

class StudentClassRepo {
  Future<int> addStudent({
    required String firstName,
    required String lastName,
    required String gender,
    required int classId,
    String? dob,
    String? email,
  }) async {
    final db = await DbHelper().initDatabase();
    return await db.insert("tbl_student_class", {
      "first_name": firstName,
      "last_name": lastName,
      "gender": gender,
      "dob": dob,
      "email": email,
      "class_id": classId,
      "created_at": DateTime.now().toIso8601String(),
    });
  }

  Future<List<Map<String, dynamic>>> getStudentsByClass(int classId) async {
    final db = await DbHelper().initDatabase();
    return await db.query(
      "tbl_student_class",
      where: "class_id = ?",
      whereArgs: [classId],
      orderBy: "first_name ASC",
    );
  }

  Future<List<Map<String, dynamic>>> searchStudents(
      int classId, String query) async {
    final db = await DbHelper().initDatabase();
    return await db.query(
      "tbl_student_class",
      where: "class_id = ? AND (first_name LIKE ? OR last_name LIKE ?)",
      whereArgs: [classId, "%$query%", "%$query%"],
      orderBy: "first_name ASC",
    );
  }

  Future<Map<String, dynamic>?> getStudentById(int id) async {
    final db = await DbHelper().initDatabase();
    final result = await db.query(
      "tbl_student_class",
      where: "id = ?",
      whereArgs: [id],
    );
    if (result.isNotEmpty) return result.first;
    return null;
  }

  Future<int> updateStudent({
    required int id,
    required String firstName,
    required String lastName,
    required String gender,
    String? dob,
    String? email,
  }) async {
    final db = await DbHelper().initDatabase();
    return await db.update(
      "tbl_student_class",
      {
        "first_name": firstName,
        "last_name": lastName,
        "gender": gender,
        "dob": dob,
        "email": email,
      },
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<int> deleteStudent(int id) async {
    final db = await DbHelper().initDatabase();
    return await db.delete(
      "tbl_student_class",
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<int> getStudentCountByClass(int classId) async {
    final db = await DbHelper().initDatabase();
    final result = await db.rawQuery(
      "SELECT COUNT(*) as count FROM tbl_student_class WHERE class_id = ?",
      [classId],
    );
    return result.first["count"] as int;
  }

  Future<int> getTotalStudentsByTeacher(int teacherId) async {
    final db = await DbHelper().initDatabase();
    final result = await db.rawQuery(
      '''SELECT COUNT(*) as count FROM tbl_student_class sc
         INNER JOIN tbl_class c ON sc.class_id = c.id
         WHERE c.teacher_id = ?''',
      [teacherId],
    );
    return result.first["count"] as int;
  }

  Future<List<Map<String, dynamic>>> getEnrolledClassesByEmail(String email) async {
    final db = await DbHelper().initDatabase();
    return await db.rawQuery(
      '''
      SELECT c.* FROM tbl_class c
      INNER JOIN tbl_student_class sc ON sc.class_id = c.id
      WHERE sc.email = ?
      GROUP BY c.id
      ORDER BY c.grade ASC, c.section ASC
      ''',
      [email],
    );
  }

  Future<int> getMaleCountByClass(int classId) async {
    final db = await DbHelper().initDatabase();
    final result = await db.rawQuery(
      "SELECT COUNT(*) as count FROM tbl_student_class WHERE class_id = ? AND gender = 'ប្រុស'",
      [classId],
    );
    return result.first["count"] as int;
  }

  Future<int> getFemaleCountByClass(int classId) async {
    final db = await DbHelper().initDatabase();
    final result = await db.rawQuery(
      "SELECT COUNT(*) as count FROM tbl_student_class WHERE class_id = ? AND gender = 'ស្រី'",
      [classId],
    );
    return result.first["count"] as int;
  }
}
