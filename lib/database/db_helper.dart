import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  Database? db;
  static Future<void> _createTblUser(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS "tbl_user" (
        "id"         INTEGER,
        "first_name" TEXT NOT NULL,
        "last_name"  TEXT NOT NULL,
        "gender"     TEXT,
        "phone"      TEXT UNIQUE,
        "email"      TEXT UNIQUE,
        "password"   TEXT NOT NULL,
        "role"       TEXT NOT NULL,
        "class_id"   INTEGER,
        PRIMARY KEY("id" AUTOINCREMENT),
        FOREIGN KEY("class_id") REFERENCES "tbl_class"("id") ON DELETE SET NULL
      );
    ''');
  }

  static Future<void> _createTblClass(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS "tbl_class" (
        "id"          INTEGER,
        "name"        TEXT NOT NULL,
        "grade"       TEXT NOT NULL,
        "section"     TEXT NOT NULL,
        "teacher_id"  INTEGER NOT NULL,
        "color_hex"   TEXT NOT NULL DEFAULT "#1976D2",
        "semester"    TEXT NOT NULL DEFAULT "ឆមាសទី ១",
        "school_year" TEXT NOT NULL DEFAULT "2024-2025",
        "class_code"  TEXT UNIQUE,
        "created_at"  TEXT NOT NULL,
        PRIMARY KEY("id" AUTOINCREMENT)
      );
    ''');
  }

  static Future<void> _createTblStudentClass(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS "tbl_student_class" (
        "id"             INTEGER,
        "first_name"     TEXT NOT NULL,
        "last_name"      TEXT NOT NULL,
        "gender"         TEXT NOT NULL DEFAULT "ប្រុស",
        "dob"            TEXT,
        "email"          TEXT,
        "phone"          TEXT,
        "photo_path"     TEXT,
        "class_id"       INTEGER NOT NULL,
        "linked_user_id" INTEGER,
        "created_at"     TEXT NOT NULL,
        PRIMARY KEY("id" AUTOINCREMENT),
        FOREIGN KEY("class_id") REFERENCES "tbl_class"("id") ON DELETE CASCADE
      );
    ''');
  }

  static Future<void> _createTblHomework(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS "tbl_homework" (
        "id"              INTEGER,
        "title"           TEXT NOT NULL,
        "subject"         TEXT NOT NULL,
        "instructions"    TEXT,
        "class_id"        INTEGER NOT NULL,
        "teacher_id"      INTEGER NOT NULL,
        "deadline"        TEXT,
        "status"          TEXT NOT NULL DEFAULT "active",
        "attachment_path" TEXT,
        "created_at"      TEXT NOT NULL,
        PRIMARY KEY("id" AUTOINCREMENT),
        FOREIGN KEY("class_id") REFERENCES "tbl_class"("id") ON DELETE CASCADE
      );
    ''');
  }

  static Future<void> _createTblAttendance(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS "tbl_attendance" (
        "id"         INTEGER,
        "class_id"   INTEGER NOT NULL,
        "student_id" INTEGER NOT NULL,
        "date"       TEXT NOT NULL,
        "status"     TEXT NOT NULL DEFAULT "present",
        PRIMARY KEY("id" AUTOINCREMENT),
        FOREIGN KEY("class_id")   REFERENCES "tbl_class"("id") ON DELETE CASCADE,
        FOREIGN KEY("student_id") REFERENCES "tbl_student_class"("id") ON DELETE CASCADE,
        UNIQUE("class_id", "student_id", "date")
      );
    ''');
  }

  static Future<void> _createTblActivityLog(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS "tbl_activity_log" (
        "id"            INTEGER,
        "teacher_id"    INTEGER NOT NULL,
        "activity_type" TEXT NOT NULL,
        "title"         TEXT NOT NULL,
        "subtitle"      TEXT NOT NULL,
        "created_at"    TEXT NOT NULL,
        PRIMARY KEY("id" AUTOINCREMENT)
      );
    ''');
  }

  static Future<void> _createTblSubmission(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS "tbl_submission" (
        "id"          INTEGER,
        "homework_id" INTEGER NOT NULL,
        "student_id"  INTEGER NOT NULL,
        "submitted_at" TEXT NOT NULL,
        PRIMARY KEY("id" AUTOINCREMENT),
        FOREIGN KEY("homework_id") REFERENCES "tbl_homework"("id") ON DELETE CASCADE,
        FOREIGN KEY("student_id")  REFERENCES "tbl_student_class"("id") ON DELETE CASCADE,
        UNIQUE("homework_id", "student_id")
      );
    ''');
  }

  static Future<void> _createTblScore(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS "tbl_score" (
        "id"         INTEGER,
        "student_id" INTEGER NOT NULL,
        "class_id"   INTEGER NOT NULL,
        "subject"    TEXT NOT NULL,
        "score"      REAL NOT NULL,
        "created_at" TEXT NOT NULL,
        PRIMARY KEY("id" AUTOINCREMENT),
        FOREIGN KEY("student_id") REFERENCES "tbl_student_class"("id") ON DELETE CASCADE,
        FOREIGN KEY("class_id")   REFERENCES "tbl_class"("id") ON DELETE CASCADE
      );
    ''');
  }

  static Future<void> _createTblParentStudent(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS "tbl_parent_student" (
        "id"         INTEGER,
        "parent_id"  INTEGER NOT NULL,
        "student_id" INTEGER NOT NULL,
        "status"     TEXT NOT NULL DEFAULT "pending",
        "created_at" TEXT NOT NULL,
        PRIMARY KEY("id" AUTOINCREMENT),
        FOREIGN KEY("parent_id")  REFERENCES "tbl_user"("id") ON DELETE CASCADE,
        FOREIGN KEY("student_id") REFERENCES "tbl_student_class"("id") ON DELETE CASCADE,
        UNIQUE("parent_id", "student_id")
      );
    ''');
  }
  static Future<void> _createTblProfile(Database db) async {
  await db.execute('''
    CREATE TABLE IF NOT EXISTS profile(
      id INTEGER PRIMARY KEY,
      image TEXT
    )
  ''');
}

  static Future<void> _createTblUserClass(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS "tbl_user_class" (
        "id"         INTEGER,
        "user_id"    INTEGER NOT NULL,
        "class_id"   INTEGER NOT NULL,
        "joined_at"  TEXT NOT NULL,
        PRIMARY KEY("id" AUTOINCREMENT),
        FOREIGN KEY("user_id")  REFERENCES "tbl_user"("id") ON DELETE CASCADE,
        FOREIGN KEY("class_id") REFERENCES "tbl_class"("id") ON DELETE CASCADE,
        UNIQUE("user_id", "class_id")
      );
    ''');
  }

  Future<Database> _getDatabase() async {
    var dbPath = await getDatabasesPath();
    var path = join(dbPath, "tamdansers.db");
    db = await openDatabase(
      path,
      version: 10,
      onCreate: (db, version) async {
        await _createTblUser(db);
        await _createTblClass(db);
        await _createTblStudentClass(db);
        await _createTblHomework(db);
        await _createTblAttendance(db);
        await _createTblActivityLog(db);
        await _createTblSubmission(db);
        await _createTblParentStudent(db);
        await _createTblScore(db);
        await _createTblUserClass(db);
        await _createTblProfile(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await _createTblClass(db);
          await _createTblStudentClass(db);
          await _createTblHomework(db);
          await _createTblAttendance(db);
          await _createTblActivityLog(db);

          await _createTblProfile(db);
        }
        if (oldVersion < 3) {
          await _createTblSubmission(db);
        }
        if (oldVersion < 4) {
          await _createTblParentStudent(db);
        }
        if (oldVersion < 5) {
          await db.execute(
              'ALTER TABLE tbl_homework ADD COLUMN attachment_path TEXT');
        }
        if (oldVersion < 6) {
          await db
              .execute('ALTER TABLE tbl_student_class ADD COLUMN phone TEXT');
          await db.execute(
              'ALTER TABLE tbl_student_class ADD COLUMN photo_path TEXT');
        }
        if (oldVersion < 7) {
          await _createTblScore(db);
        }
        if (oldVersion < 8) {
          await _createTblUserClass(db);
          // Migrate existing class_id values from tbl_user into tbl_user_class
          final users = await db.query('tbl_user',
              columns: ['id', 'class_id'], where: 'class_id IS NOT NULL');
          for (final u in users) {
            await db.insert(
              'tbl_user_class',
              {
                'user_id': u['id'],
                'class_id': u['class_id'],
                'joined_at': DateTime.now().toIso8601String(),
              },
              conflictAlgorithm: ConflictAlgorithm.ignore,
            );
          }
        }
        if (oldVersion < 9) {
          await db.execute(
              'ALTER TABLE tbl_student_class ADD COLUMN linked_user_id INTEGER');
        }
        if (oldVersion < 10) {
          // Create tbl_student_class entries for existing self-joined students
          // who don't already have a linked row
          final userClasses = await db.rawQuery(
            '''
            SELECT uc.user_id, uc.class_id, uc.joined_at,
                   u.first_name, u.last_name, u.gender, u.phone, u.email
            FROM tbl_user_class uc
            INNER JOIN tbl_user u ON uc.user_id = u.id
            WHERE NOT EXISTS (
              SELECT 1 FROM tbl_student_class sc
              WHERE sc.class_id = uc.class_id AND sc.linked_user_id = uc.user_id
            )
            ''',
          );
          for (final row in userClasses) {
            final rawGender = row['gender'] as String? ?? 'ប្រុស';
            final gender = rawGender == 'male'
                ? 'ប្រុស'
                : rawGender == 'female'
                    ? 'ស្រី'
                    : rawGender;
            await db.insert(
              'tbl_student_class',
              {
                'first_name': row['first_name'],
                'last_name': row['last_name'],
                'gender': gender,
                'phone': row['phone'],
                'email': row['email'],
                'class_id': row['class_id'],
                'linked_user_id': row['user_id'],
                'created_at': row['joined_at'],
              },
              conflictAlgorithm: ConflictAlgorithm.ignore,
            );
          }
        }
      },
    );
    return db!;
  }

  Future<Database> initDatabase() async {
    if (db != null) {
      return db!;
    } else {
      Database database = await _getDatabase();
      var result = await database.rawQuery("SELECT name FROM sqlite_master WHERE type='table' AND name='profile'");
      if (result.isEmpty) {
        await _createTblProfile(database);
      }
      return database;
    }
  }
}
