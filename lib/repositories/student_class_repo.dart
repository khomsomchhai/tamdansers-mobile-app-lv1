import 'package:tamdansers_app/database/db_helper.dart';

class StudentClassRepo {
  /// Check if a student with the same phone or email already exists in this class.
  Future<bool> isDuplicateInClass(int classId, {String? phone, String? email}) async {
    final db = await DbHelper().initDatabase();
    if (phone != null && phone.isNotEmpty) {
      final rows = await db.query(
        'tbl_student_class',
        where: "class_id = ? AND phone = ?",
        whereArgs: [classId, phone],
        limit: 1,
      );
      if (rows.isNotEmpty) return true;
    }
    if (email != null && email.isNotEmpty) {
      final rows = await db.query(
        'tbl_student_class',
        where: "class_id = ? AND email = ?",
        whereArgs: [classId, email],
        limit: 1,
      );
      if (rows.isNotEmpty) return true;
    }
    return false;
  }

  Future<int> addStudent({
    required String firstName,
    required String lastName,
    required String gender,
    required int classId,
    String? dob,
    String? email,
    String? phone,
    String? photoPath,
    int? linkedUserId,
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
      "linked_user_id": linkedUserId,
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
    // Join with tbl_student_class to get the correct sc.id (used by attendance/scores)
    final selfJoined = await db.rawQuery(
      '''
      SELECT sc.id, COALESCE(sc.first_name, u.first_name) as first_name,
             COALESCE(sc.last_name, u.last_name) as last_name,
             COALESCE(sc.gender, u.gender) as gender,
             u.phone, u.email, sc.dob, sc.photo_path,
             sc.class_id, uc.joined_at as created_at,
             sc.linked_user_id
      FROM tbl_user_class uc
      INNER JOIN tbl_user u ON uc.user_id = u.id
      INNER JOIN tbl_student_class sc ON sc.linked_user_id = u.id AND sc.class_id = uc.class_id
      WHERE uc.class_id = ?
      ORDER BY u.first_name ASC
      ''',
      [classId],
    );
    final selfJoinedWithSource =
        selfJoined.map((s) => {...s, '_source': 'tbl_student_class'}).toList();
    return [...manualWithSource, ...selfJoinedWithSource];
  }

  Future<List<Map<String, dynamic>>> searchStudents(
      int classId, String query) async {
    final db = await DbHelper().initDatabase();
    return await db.query(
      "tbl_student_class",
      where:
          "class_id = ? AND (first_name LIKE ? OR last_name LIKE ? OR phone LIKE ? OR email LIKE ?)",
      whereArgs: [classId, "%$query%", "%$query%", "%$query%", "%$query%"],
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

  Future<List<Map<String, dynamic>>> getEnrolledClassesByEmail(
      String email) async {
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

  Future<List<Map<String, dynamic>>> searchStudentsInOtherClasses(
      int excludeClassId, String query) async {
    final db = await DbHelper().initDatabase();
    // First get IDs of students already in this class (by phone/email) to exclude duplicates
    final existing = await db.query(
      'tbl_student_class',
      columns: ['phone', 'email'],
      where: 'class_id = ?',
      whereArgs: [excludeClassId],
    );
    final existingPhones = existing
        .map((e) => e['phone'] as String?)
        .where((p) => p != null && p.isNotEmpty)
        .toSet();
    final existingEmails = existing
        .map((e) => e['email'] as String?)
        .where((e) => e != null && e.isNotEmpty)
        .toSet();

    final results = await db.rawQuery(
      '''SELECT sc.*, c.grade AS class_grade, c.section AS class_section
         FROM tbl_student_class sc
         LEFT JOIN tbl_class c ON sc.class_id = c.id
         WHERE sc.class_id != ?
           AND (sc.first_name LIKE ? OR sc.last_name LIKE ? OR sc.phone LIKE ? OR sc.email LIKE ?)
         ORDER BY sc.first_name ASC''',
      [excludeClassId, "%$query%", "%$query%", "%$query%", "%$query%"],
    );

    // Deduplicate: only show each student once (by phone or email)
    final seen = <String>{};
    final deduped = <Map<String, dynamic>>[];
    for (final s in results) {
      final phone = s['phone'] as String?;
      final email = s['email'] as String?;
      // Skip if this student is already in the target class
      if (phone != null && phone.isNotEmpty && existingPhones.contains(phone)) continue;
      if (email != null && email.isNotEmpty && existingEmails.contains(email)) continue;
      // Deduplicate across multiple classes
      final key = (phone != null && phone.isNotEmpty) ? 'p:$phone' : (email != null && email.isNotEmpty) ? 'e:$email' : 'id:${s['id']}';
      if (seen.contains(key)) continue;
      seen.add(key);
      deduped.add(s);
    }
    return deduped;
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
