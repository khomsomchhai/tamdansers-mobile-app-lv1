import 'package:sqflite/sqflite.dart';
import 'package:tamdansers_app/database/db_helper.dart';

class UserRepo {
  Future<int> createUser({
    required String firstName,
    required String lastName,
    required String gender,
    required String? phone,
    required String? email,
    required String password,
    required String role,
  }) async {
    final db = await DbHelper().initDatabase();
    return await db.insert("tbl_user", {
      "first_name": firstName,
      "last_name": lastName,
      "gender": gender,
      "phone": phone,
      "email": email,
      "password": password,
      "role": role,
    });
  }
  Future<Map<String, dynamic>?> login(
      String identifier, String password
    ) async {
    final db = await DbHelper().initDatabase();

    final result = await db.query(
      'tbl_user',
      where: '(email = ? OR phone = ?) AND password = ?',
      whereArgs: [identifier, identifier, password],
    );

    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }
  Future<Map<String, dynamic>?> getAllUser() async {
    final db = await DbHelper().initDatabase();
    final result = await db.query('tbl_user');
    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }
  Future<Map<String, dynamic>?> getUserById(int id) async {
    final db = await DbHelper().initDatabase();
    final result = await db.query(
      "tbl_user",
      where: "id = ?",
      whereArgs: [id],
    );
    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }
  Future<Map<String, dynamic>?> getUserByPhoneOrEmail(String identifier) async {
    final db = await DbHelper().initDatabase();
    final result = await db.query(
      'tbl_user',
      where: 'email = ? OR phone = ?',
      whereArgs: [identifier, identifier],
    );
    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }
  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    final db = await DbHelper().initDatabase();
    final result = await db.query(
      'tbl_user',
      where: 'email = ?',
      whereArgs: [email],
    );
    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }
  Future<String?> getRoleById(int id) async {
    final db = await DbHelper().initDatabase();
    final result = await db.query(
      'tbl_user',
      columns: ['role'],
      where: 'id = ?',
      whereArgs: [id],
    );

    if (result.isNotEmpty) {
      return result.first['role'] as String?;
    }
    return null;
  }
  getUserByPhone(String phone) async {
    final db = await DbHelper().initDatabase();
    final result = await db.query(
      'tbl_user',
      where: 'phone = ?',
      whereArgs: [phone],
    );
    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }
  Future<bool> changePassword(int userId, String oldPassword, String newPassword) async {
    final db = await DbHelper().initDatabase();
    final result = await db.query(
      'tbl_user',
      where: 'id = ? AND password = ?',
      whereArgs: [userId, oldPassword],
    );
    
    if (result.isEmpty) {
      return false;
    }
    
    final updated = await db.update(
      'tbl_user',
      {'password': newPassword},
      where: 'id = ?',
      whereArgs: [userId],
    );
    
    return updated > 0;
  }

  Future<bool> resetPassword(int userId, String newPassword) async {
    final db = await DbHelper().initDatabase();
    final updated = await db.update(
      'tbl_user',
      {'password': newPassword},
      where: 'id = ?',
      whereArgs: [userId],
    );
    return updated > 0;
  }

  Future<bool> joinClass(int userId, int classId) async {
    final db = await DbHelper().initDatabase();
    final result = await db.insert(
      'tbl_user_class',
      {
        'user_id': userId,
        'class_id': classId,
        'joined_at': DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
    // Also keep tbl_user.class_id updated to the latest joined class
    await db.update('tbl_user', {'class_id': classId},
        where: 'id = ?', whereArgs: [userId]);
    return result != 0;
  }

  Future<List<int>> getJoinedClassIds(int userId) async {
    final db = await DbHelper().initDatabase();
    final rows = await db.query(
      'tbl_user_class',
      columns: ['class_id'],
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'joined_at ASC',
    );
    return rows.map((r) => r['class_id'] as int).toList();
  }
}