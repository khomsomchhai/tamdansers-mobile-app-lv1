import 'package:tamdansers_app/database/db_helper.dart';

class StudentClassRepo {
  Future<int> addStudent({
    required String firstName,
    required String lastName,
    required String gender,
    required int classId,
    String? dob,
    String? email,
    String? phone,
    String? photoPath,
  }) async {
    final db = await DbHelper().initDatabase();
    return await db.insert("tbl_student_class", {
      "first_name": firstName,
      "last_name": lastName,
      "gender": gender,
      "dob": dob,
      "email": email,
      "phone": phone,
      "photo_path": photoPath,
      "class_id": classId,
      "created_at": DateTime.now().toIso8601String(),
    });
  }

  Future<List<Map<String, dynamic>>> getStudentsByClass(int classId) async {
    final db = await DbHelper().initDatabase();
    // Manually added students (exclude rows linked to a real user account)
    final manual = await db.query(
      "tbl_student_class",
      where: "class_id = ? AND linked_user_id IS NULL",
      whereArgs: [classId],
      orderBy: "first_name ASC",
    );
    final manualWithSource =
        manual.map((s) => {...s, '_source': 'tbl_student_class'}).toList();
    // Self-registered students who joined via class code
    final selfJoined = await db.rawQuery(
      '''
      SELECT u.id, u.first_name, u.last_name, u.gender,
             u.phone, u.email, NULL as dob, NULL as photo_path,
             ? as class_id, uc.joined_at as created_at
      FROM tbl_user_class uc
      INNER JOIN tbl_user u ON uc.user_id = u.id
      WHERE uc.class_id = ?
      ORDER BY u.first_name ASC
      ''',
      [classId, classId],
    );
    final selfJoinedWithSource =
        selfJoined.map((s) => {...s, '_source': 'tbl_user'}).toList();
    return [...manualWithSource, ...selfJoinedWithSource];
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
    String? phone,
    String? photoPath,
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
        "phone": phone,
        "photo_path": photoPath,
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

  /// Find the student record that matches the logged-in user's email or phone.
  /// Used to auto-link a student's account to their assigned class.
  Future<Map<String, dynamic>?> getStudentByEmailOrPhone(
      String? email, String? phone) async {
    if ((email == null || email.isEmpty) && (phone == null || phone.isEmpty))
      return null;
    final db = await DbHelper().initDatabase();
    final result = await db.rawQuery(
      '''
      SELECT * FROM tbl_student_class
      WHERE (email IS NOT NULL AND email != '' AND email = ?)
         OR (phone IS NOT NULL AND phone != '' AND phone = ?)
      LIMIT 1
      ''',
      [email ?? '', phone ?? ''],
    );
    if (result.isNotEmpty) return result.first;
    return null;
  }

  Future<int> getStudentCountByClass(int classId) async {
    final db = await DbHelper().initDatabase();
    // Count manually-added students (exclude linked placeholders)
    final manual = await db.rawQuery(
      "SELECT COUNT(*) as count FROM tbl_student_class WHERE class_id = ? AND linked_user_id IS NULL",
      [classId],
    );
    // Count self-registered students who joined via class code
    final selfJoined = await db.rawQuery(
      "SELECT COUNT(*) as count FROM tbl_user_class WHERE class_id = ?",
      [classId],
    );
    return (manual.first["count"] as int) + (selfJoined.first["count"] as int);
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

  Future<int> getMaleCountByClass(int classId) async {
    final db = await DbHelper().initDatabase();
    final manual = await db.rawQuery(
      "SELECT COUNT(*) as count FROM tbl_student_class WHERE class_id = ? AND linked_user_id IS NULL AND (gender = 'ប្រុស' OR gender = 'male')",
      [classId],
    );
    final selfJoined = await db.rawQuery(
      "SELECT COUNT(*) as count FROM tbl_user_class uc INNER JOIN tbl_user u ON uc.user_id = u.id WHERE uc.class_id = ? AND (u.gender = 'ប្រុស' OR u.gender = 'male')",
      [classId],
    );
    return (manual.first["count"] as int) + (selfJoined.first["count"] as int);
  }

  Future<int> getFemaleCountByClass(int classId) async {
    final db = await DbHelper().initDatabase();
    final manual = await db.rawQuery(
      "SELECT COUNT(*) as count FROM tbl_student_class WHERE class_id = ? AND linked_user_id IS NULL AND (gender = 'ស្រី' OR gender = 'female')",
      [classId],
    );
    final selfJoined = await db.rawQuery(
      "SELECT COUNT(*) as count FROM tbl_user_class uc INNER JOIN tbl_user u ON uc.user_id = u.id WHERE uc.class_id = ? AND (u.gender = 'ស្រី' OR u.gender = 'female')",
      [classId],
    );
    return (manual.first["count"] as int) + (selfJoined.first["count"] as int);
  }
}
