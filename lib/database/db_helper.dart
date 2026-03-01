import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper{
  Database? db;

  Future<Database> _getDatabase() async {
    var dbPath = await getDatabasesPath();
    var path = join(dbPath, "tamdansers.db");
    db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async{
        await db.execute('''
          CREATE TABLE "tbl_user" (
            "id"	INTEGER,
            "first_name"	TEXT NOT NULL,
            "last_name"	TEXT NOT NULL,
            "gender"	TEXT,
            "phone"	TEXT UNIQUE,
            "email"	TEXT UNIQUE,
            "password"	TEXT NOT NULL,
            "role"	TEXT NOT NULL,
            PRIMARY KEY("id" AUTOINCREMENT)
          );
        '''
        );
      }
    );
    return db!;
  }

  Future<Database> initDatabase() async{
    if(db != null){
      return db!;
    }else{
      return await _getDatabase();
    }
  }
}
