// ignore_for_file: file_names

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/student.dart';

class DbHelper {
  static Database? db;
  Future<void> open() async {
    final databasePath = await getDatabasesPath();
    db = await openDatabase(
      join(databasePath, 'student_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE students(id INTEGER PRIMARY KEY, firstName TEXT, lastName TEXT, grade INTEGER)',
        );
      },
      version: 1,
    );
  }

  Future<int> insertStudent(Student student) async {
    final dbH = await db;
    if (dbH != null) {
      return await dbH.insert(
        'students',
        student.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } else {
      throw Exception("Veritabanı bağlantısı başarısız oldu.");
    }
  }

  Future<int?> updateStudent(Student student) async {
    Database? dbH = DbHelper.db;
    int? id = student.id;
    return await dbH
        ?.update('students', student.toMap(), where: 'id = ?', whereArgs: [id]);
  }

  Future<int?> deleteStudent(int id) async {
    Database? dbH = DbHelper.db;
    return await dbH?.delete("students", where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Student>> getStudents() async {
    Database? dbH = await DbHelper.db;
    var result = await dbH?.query("students");
    return List.generate(result?.length ?? 0, (i) {
      return Student.fromMap(result?[i]);
    });
  }
}
