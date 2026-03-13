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
    // Link any pre-added placeholder in tbl_student_class
    await _linkPlaceholder(db, userId, classId);
    return result != 0;
  }

  Future<void> _linkPlaceholder(Database db, int userId, int classId) async {
    final users =
        await db.query('tbl_user', where: 'id = ?', whereArgs: [userId]);
    if (users.isEmpty) return;
    final user = users.first;

    List<Map<String, dynamic>> match = [];

    // 1. Match by email
    final email = user['email'] as String?;
    if (email != null && email.isNotEmpty) {
      match = await db.query(
        'tbl_student_class',
        where: 'class_id = ? AND email = ? AND linked_user_id IS NULL',
        whereArgs: [classId, email],
      );
    }

    // 2. Match by phone
    if (match.isEmpty) {
      final phone = user['phone'] as String?;
      if (phone != null && phone.isNotEmpty) {
        match = await db.query(
          'tbl_student_class',
          where: 'class_id = ? AND phone = ? AND linked_user_id IS NULL',
          whereArgs: [classId, phone],
        );
      }
    }

    // 3. Match by full name (case-insensitive)
    if (match.isEmpty) {
      match = await db.rawQuery(
        'SELECT * FROM tbl_student_class WHERE class_id = ? AND LOWER(first_name) = LOWER(?) AND LOWER(last_name) = LOWER(?) AND linked_user_id IS NULL',
        [classId, user['first_name'], user['last_name']],
      );
    }

    if (match.isNotEmpty) {
      // Link the existing placeholder
      await db.update(
        'tbl_student_class',
        {'linked_user_id': userId},
        where: 'id = ?',
        whereArgs: [match.first['id']],
      );
    } else {
      // No placeholder — create one so this student appears in attendance/homework
      final existing = await db.query(
        'tbl_student_class',
        where: 'class_id = ? AND linked_user_id = ?',
        whereArgs: [classId, userId],
      );
      if (existing.isEmpty) {
        final rawGender = user['gender'] as String? ?? 'ប្រុស';
        final gender = rawGender == 'male'
            ? 'ប្រុស'
            : rawGender == 'female'
                ? 'ស្រី'
                : rawGender;
        await db.insert('tbl_student_class', {
          'first_name': user['first_name'],
          'last_name': user['last_name'],
          'gender': gender,
          'phone': user['phone'],
          'email': user['email'],
          'class_id': classId,
          'linked_user_id': userId,
          'created_at': DateTime.now().toIso8601String(),
        });
      }
    }
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