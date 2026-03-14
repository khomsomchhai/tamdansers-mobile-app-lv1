import 'package:sqflite/sqflite.dart';
import 'package:tamdansers_app/database/db_helper.dart';
import 'package:tamdansers_app/state/profile_image_state.dart';

class ProfileRepo {
  final DbHelper _dbHelper = DbHelper();

  Future<void> saveImage(String imagePath, int userId) async {
    final Database db = await _dbHelper.initDatabase();

    await db.insert(
      'profile',
      {
        'id': userId,
        'image': imagePath,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    ProfileImageState.updateImage(userId, imagePath);
  }

  Future<String?> getImage(int userId) async {
    final Database db = await _dbHelper.initDatabase();

    final result = await db.query(
      'profile',
      where: 'id = ?',
      whereArgs: [userId],
    );

    if (result.isNotEmpty) {
      return result.first['image'] as String;
    }
    return null;
  }
}