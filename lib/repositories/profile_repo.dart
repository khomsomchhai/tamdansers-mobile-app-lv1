import 'package:sqflite/sqflite.dart';
import 'package:tamdansers_app/database/db_helper.dart';

class ProfileRepo {
  final DbHelper _dbHelper = DbHelper();

  Future<void> saveImage(String imagePath) async {
    final Database db = await _dbHelper.initDatabase();

    await db.insert(
      'profile',
      {
        'id': 1,
        'image': imagePath,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<String?> getImage() async {
    final Database db = await _dbHelper.initDatabase();

    final result = await db.query(
      'profile',
      where: 'id = ?',
      whereArgs: [1],
    );

    if (result.isNotEmpty) {
      return result.first['image'] as String;
    }
    return null;
  }
}