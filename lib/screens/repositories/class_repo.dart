import 'package:tamdansers_app/database/db_helper.dart';

class ClassRepo {
  Future<int> createClass({
    required String name,
    required String grade,
    required String section,
    required int teacherId,
    required String colorHex,
    String semester = "ឆមាសទី ១",
    String schoolYear = "2024-2025",
  }) async {
    final db = await DbHelper().initDatabase();
    final id = await db.insert("tbl_class", {
      "name": name,
      "grade": grade,
      "section": section,
      "teacher_id": teacherId,
      "color_hex": colorHex,
      "semester": semester,
      "school_year": schoolYear,
      "created_at": DateTime.now().toIso8601String(),
    });
    return id;
  }

  Future<List<Map<String, dynamic>>> getClassesByTeacher(int teacherId) async {
    final db = await DbHelper().initDatabase();
    return await db.query(
      "tbl_class",
      where: "teacher_id = ?",
      whereArgs: [teacherId],
      orderBy: "created_at DESC",
    );
  }

  Future<List<Map<String, dynamic>>> getClassesByTeacherAndGrade(
      int teacherId, String grade) async {
    final db = await DbHelper().initDatabase();
    return await db.query(
      "tbl_class",
      where: "teacher_id = ? AND grade = ?",
      whereArgs: [teacherId, grade],
      orderBy: "created_at DESC",
    );
  }

  Future<Map<String, dynamic>?> getClassById(int id) async {
    final db = await DbHelper().initDatabase();
    final result = await db.query(
      "tbl_class",
      where: "id = ?",
      whereArgs: [id],
    );
    if (result.isNotEmpty) return result.first;
    return null;
  }

  Future<int> updateClass({
    required int id,
    required String name,
    required String grade,
    required String section,
    required String colorHex,
    required String semester,
    required String schoolYear,
  }) async {
    final db = await DbHelper().initDatabase();
    return await db.update(
      "tbl_class",
      {
        "name": name,
        "grade": grade,
        "section": section,
        "color_hex": colorHex,
        "semester": semester,
        "school_year": schoolYear,
      },
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<int> deleteClass(int id) async {
    final db = await DbHelper().initDatabase();
    return await db.delete("tbl_class", where: "id = ?", whereArgs: [id]);
  }

  Future<int> getClassCountByTeacher(int teacherId) async {
    final db = await DbHelper().initDatabase();
    final result = await db.rawQuery(
      "SELECT COUNT(*) as count FROM tbl_class WHERE teacher_id = ?",
      [teacherId],
    );
    return result.first["count"] as int;
  }
}
