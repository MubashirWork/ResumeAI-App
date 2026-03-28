import 'package:resume_ai/data/database/constants/resume_constants.dart';
import 'package:resume_ai/data/database/helper/db_helper.dart';
import 'package:sqflite/sqflite.dart';

class ResumeDao {

  // Private constructor
  const ResumeDao._init();

  // Singleton
  static const ResumeDao instance = ResumeDao._init();

  // Get database
  Future<Database> get database => DBHelper.instance.initDatabase();

  /// Now performing crud operations

  // Creating or saving resumes

  Future<bool> storeResume(
    String jsonString,
    int templateId,
    String fileName,
  ) async {
    final db = await database;
    final inserted = await db.insert(ResumeConstants.tableName, {
      ResumeConstants.jsonString: jsonString,
      ResumeConstants.templateId: templateId,
      ResumeConstants.fileName: fileName,
    }, conflictAlgorithm: ConflictAlgorithm.abort);
    return inserted > 0;
  }

  // Getting or fetching resumes
  Future<List<Map<String, Object?>>> fetchResumes() async {
    final db = await database;
    final getResume = await db.query(
      ResumeConstants.tableName,
      orderBy: '${ResumeConstants.id} DESC',
    );
    return getResume;
  }

  // Update resume
  Future<bool> updateResume(
    int id,
    String jsonString,
    String fileName,
    int templateId,
  ) async {
    final db = await database;
    final int rowUpdated = await db.update(
      ResumeConstants.tableName,
      {
        ResumeConstants.jsonString: jsonString,
        ResumeConstants.fileName: fileName,
        ResumeConstants.templateId: templateId,
      },
      where: "${ResumeConstants.id} = ?",
      whereArgs: [id],
    );
    return rowUpdated > 0;
  }

  // Deleting the resume
  Future<bool> deleteResume(int id) async {
    final db = await database;
    final int resumeDeleted = await db.delete(
      ResumeConstants.tableName,
      where: "${ResumeConstants.id} = ?",
      whereArgs: [id],
    );
    return resumeDeleted > 0;
  }
}
