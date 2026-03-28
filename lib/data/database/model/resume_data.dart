import 'package:resume_ai/data/database/constants/data_constants.dart';

class ResumeData {
  static const String createTable =
      '''CREATE TABLE ${ResumeDataConstants.tableName} (
  ${ResumeDataConstants.colFullName} TEXT,
  ${ResumeDataConstants.colProfessionalTitle} TEXT,
  ${ResumeDataConstants.colProfessionalSummary} TEXT,
  ${ResumeDataConstants.colEmail} TEXT,
  ${ResumeDataConstants.colPhoneNo} TEXT,
  ${ResumeDataConstants.colCnic} TEXT,
  ${ResumeDataConstants.colCountryCity} TEXT,
  ${ResumeDataConstants.colEducation} TEXT,
  ${ResumeDataConstants.colCertificates} TEXT,
  ${ResumeDataConstants.colExperience} TEXT,
  ${ResumeDataConstants.colProfessionalSkills} TEXT,
  ${ResumeDataConstants.colSoftSkills} TEXT,
  ${ResumeDataConstants.colProjects} TEXT,
  ${ResumeDataConstants.colLanguages} TEXT
      )''';
}
