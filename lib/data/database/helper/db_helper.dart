import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:resume_ai/data/database/constants/data_constants.dart';
import 'package:resume_ai/data/database/model/resume_data.dart';
import 'package:resume_ai/data/database/model/resume_table.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {

  // Private constructor
  const DBHelper._init();

  // Singleton
  static const DBHelper instance = DBHelper._init();

  // Database object
  static Database? _database;

  // Initializing database
  Future<Database> initDatabase() async {
    _database ??= await createDatabase();
    return _database!;
  }

  // Database creation
  Future<Database> createDatabase() async {
    Directory appDir = await getApplicationDocumentsDirectory();
    final String path = join(appDir.path, 'resume.db');
    return await openDatabase(
      path,
      onCreate: (db, version) async {
        await db.execute(ResumeTable.createTable);
        await db.execute(ResumeData.createTable);
      },
      version: 1,
    );
  }
}
