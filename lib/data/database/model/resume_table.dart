import 'package:resume_ai/data/database/constants/resume_constants.dart';

class ResumeTable {
  static const String createTable = '''
  CREATE TABLE 
  ${ResumeConstants.tableName} (
    ${ResumeConstants.id} INTEGER PRIMARY KEY AUTOINCREMENT,
    ${ResumeConstants.jsonString} TEXT,
    ${ResumeConstants.templateId} INTEGER,
    ${ResumeConstants.fileName} TEXT
  )
  ''';
}