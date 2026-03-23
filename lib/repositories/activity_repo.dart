import 'package:tamdansers_app/database/db_helper.dart';

class ActivityRepo {
  Future<int> logActivity({
    required int teacherId,
    required String activityType,
    required String title,
    required String subtitle,
  }) async {
    final db = await DbHelper().initDatabase();
    return await db.insert("tbl_activity_log", {
      "teacher_id": teacherId,
      "activity_type": activityType,
      "title": title,
      "subtitle": subtitle,
      "created_at": DateTime.now().toIso8601String(),
    });
  }

  Future<int> logParentActivity({
    required int parentId,
    required String activityType,
    required String title,
    required String subtitle,
    int? studentClassId,
  }) async {
    final db = await DbHelper().initDatabase();
    return await db.insert("tbl_activity_log", {
      "teacher_id": parentId,
      "activity_type": activityType,
      "title": title,
      "subtitle":
          studentClassId != null ? "$subtitle|SC:$studentClassId" : subtitle,
      "created_at": DateTime.now().toIso8601String(),
    });
  }

  Future<List<Map<String, dynamic>>> getActivitiesByStudent(
    int parentId,
    int studentClassId, {
    int limit = 10,
  }) async {
    final db = await DbHelper().initDatabase();
    final activities = await db.query(
      "tbl_activity_log",
      where: "teacher_id = ? AND subtitle LIKE ?",
      whereArgs: [parentId, "%SC:$studentClassId%"],
      orderBy: "created_at DESC",
      limit: limit,
    );
    return activities
        .map((activity) => {
              ...activity,
              'subtitle': (activity['subtitle'] as String)
                  .replaceAll("|SC:$studentClassId", "")
            })
        .toList();
  }

  Future<List<Map<String, dynamic>>> getRecentActivities(
    int teacherId, {
    int limit = 10,
  }) async {
    final db = await DbHelper().initDatabase();
    return await db.query(
      "tbl_activity_log",
      where: "teacher_id = ?",
      whereArgs: [teacherId],
      orderBy: "created_at DESC",
      limit: limit,
    );
  }

  Future<int> deleteActivity(int id) async {
    final db = await DbHelper().initDatabase();
    return await db.delete(
      "tbl_activity_log",
      where: "id = ?",
      whereArgs: [id],
    );
  }
}
