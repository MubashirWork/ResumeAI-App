import 'package:resume_ai/data/database/constants/data_constants.dart';
import 'package:resume_ai/data/database/helper/db_helper.dart';
import 'package:sqflite/sqflite.dart';

class ResumeDataDao {
  // Private constructor
  const ResumeDataDao._init();

  // Singleton
  static const ResumeDataDao instance = ResumeDataDao._init();

  // Making connection with helper
  Future<Database> get database => DBHelper.instance.initDatabase();

  /// Creating crud operation

  // Storing data
  Future addData({
    required String fullName,
    required String professionTitle,
    required String professionalSummary,
    required String email,
    required String phoneNo,
    required String cnic,
    required String countryCity,
    required String education,
    required String certificate,
    required String experience,
    required String professionalSkills,
    required String softSkills,
    required String project,
    required String language,
  }) async {
    final db = await database;
    await db.insert(ResumeDataConstants.tableName, {
      ResumeDataConstants.colFullName: fullName,
      ResumeDataConstants.colProfessionalTitle: professionTitle,
      ResumeDataConstants.colProfessionalSummary: professionalSummary,
      ResumeDataConstants.colEmail: email,
      ResumeDataConstants.colPhoneNo: phoneNo,
      ResumeDataConstants.colCnic: cnic,
      ResumeDataConstants.colCountryCity: countryCity,
      ResumeDataConstants.colEducation: education,
      ResumeDataConstants.colCertificates: certificate,
      ResumeDataConstants.colExperience: experience,
      ResumeDataConstants.colProfessionalSkills: professionalSkills,
      ResumeDataConstants.colSoftSkills: softSkills,
      ResumeDataConstants.colProjects: project,
      ResumeDataConstants.colLanguages: language,
    });
  }

  // Fetch data
  Future<List<Map<String, dynamic>>> fetchData() async {
    final db = await database;
    final List<Map<String, dynamic>> getData = await db.query(
      ResumeDataConstants.tableName
    );
    return getData;
  }
}
