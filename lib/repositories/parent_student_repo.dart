import 'package:tamdansers_app/database/db_helper.dart';

class ParentStudentRepo {
  Future<int> connectParentToStudent({
    required int parentId,
    required int studentId,
  }) async {
    final db = await DbHelper().initDatabase();
    return await db.insert("tbl_parent_student", {
      "parent_id": parentId,
      "student_id": studentId,
      "status": "pending",
      "created_at": DateTime.now().toIso8601String(),
    });
  }

  Future<int> approveConnection(int connectionId) async {
    final db = await DbHelper().initDatabase();
    return await db.update(
      "tbl_parent_student",
      {"status": "approved"},
      where: "id = ?",
      whereArgs: [connectionId],
    );
  }

  Future<int> rejectConnection(int connectionId) async {
    final db = await DbHelper().initDatabase();
    return await db.update(
      "tbl_parent_student",
      {"status": "rejected"},
      where: "id = ?",
      whereArgs: [connectionId],
    );
  }

  Future<List<Map<String, dynamic>>> getStudentsByParent(int parentId) async {
    final db = await DbHelper().initDatabase();
    return await db.rawQuery('''
      SELECT ps.*, sc.first_name, sc.last_name, sc.email, sc.gender, sc.dob, c.name as class_name
      FROM tbl_parent_student ps
      JOIN tbl_student_class sc ON ps.student_id = sc.id
      JOIN tbl_class c ON sc.class_id = c.id
      WHERE ps.parent_id = ? AND ps.status = 'approved'
      ORDER BY sc.first_name ASC
    ''', [parentId]);
  }

  Future<List<Map<String, dynamic>>> getPendingRequestsForStudent(int studentId) async {
    final db = await DbHelper().initDatabase();
    return await db.rawQuery('''
      SELECT ps.*, u.first_name as parent_first_name, u.last_name as parent_last_name, u.email as parent_email, u.phone as parent_phone
      FROM tbl_parent_student ps
      JOIN tbl_user u ON ps.parent_id = u.id
      WHERE ps.student_id = ? AND ps.status = 'pending'
    ''', [studentId]);
  }

  Future<Map<String, dynamic>?> getConnectionById(int connectionId) async {
    final db = await DbHelper().initDatabase();
    final result = await db.query(
      "tbl_parent_student",
      where: "id = ?",
      whereArgs: [connectionId],
    );
    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }

  Future<bool> isParentConnectedToStudent(int parentId, int studentId) async {
    final db = await DbHelper().initDatabase();
    final result = await db.query(
      "tbl_parent_student",
      where: "parent_id = ? AND student_id = ? AND status = 'approved'",
      whereArgs: [parentId, studentId],
    );
    return result.isNotEmpty;
  }
}