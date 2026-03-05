import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  Database? db;

  // ─── Table creation helpers ───────────────────────────────────────────────

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
        "id"         INTEGER,
        "first_name" TEXT NOT NULL,
        "last_name"  TEXT NOT NULL,
        "gender"     TEXT NOT NULL DEFAULT "ប្រុស",
        "dob"        TEXT,
        "email"      TEXT,
        "class_id"   INTEGER NOT NULL,
        "created_at" TEXT NOT NULL,
        PRIMARY KEY("id" AUTOINCREMENT),
        FOREIGN KEY("class_id") REFERENCES "tbl_class"("id") ON DELETE CASCADE
      );
    ''');
  }

  static Future<void> _createTblHomework(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS "tbl_homework" (
        "id"           INTEGER,
        "title"        TEXT NOT NULL,
        "subject"      TEXT NOT NULL,
        "instructions" TEXT,
        "class_id"     INTEGER NOT NULL,
        "teacher_id"   INTEGER NOT NULL,
        "deadline"     TEXT,
        "status"       TEXT NOT NULL DEFAULT "active",
        "created_at"   TEXT NOT NULL,
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

  // ─── Open / init ──────────────────────────────────────────────────────────

  Future<Database> _getDatabase() async {
    var dbPath = await getDatabasesPath();
    var path = join(dbPath, "tamdansers.db");
    db = await openDatabase(
      path,
      version: 3,
      onCreate: (db, version) async {
        await _createTblUser(db);
        await _createTblClass(db);
        await _createTblStudentClass(db);
        await _createTblHomework(db);
        await _createTblAttendance(db);
        await _createTblActivityLog(db);
        await _createTblSubmission(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await _createTblClass(db);
          await _createTblStudentClass(db);
          await _createTblHomework(db);
          await _createTblAttendance(db);
          await _createTblActivityLog(db);
        }
        if (oldVersion < 3) {
          await _createTblSubmission(db);
        }
      },
    );
    return db!;
  }

  Future<Database> initDatabase() async {
    if (db != null) {
      return db!;
    } else {
      return await _getDatabase();
    }
  }
}
