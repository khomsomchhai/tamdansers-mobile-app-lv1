import 'package:tamdansers_app/database/db_helper.dart';

class UserRepo {
  Future<int> createUser({
    required String firstName,
    required String lastName,
    required String gender,
    required String phone,
    required String email,
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
}