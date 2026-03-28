import 'dart:convert';

class ResumeModel {

  // Properties of ResumeModel
  final String name;
  final String professionTitle;
  final Contact contact;
  final String professionalSummary;
  final List<String> education;
  final List<String> certifications;
  final List<String> experience;
  final List<String> professionalSkills;
  final List<String> softSkills;
  final List<String> projects;
  final List<String> languages;

  const ResumeModel({
    required this.name,
    required this.professionTitle,
    required this.contact,
    required this.professionalSummary,
    required this.education,
    required this.certifications,
    required this.experience,
    required this.professionalSkills,
    required this.softSkills,
    required this.projects,
    required this.languages,
  });

  // Json to ResumeModel object
  factory ResumeModel.fromJson(Map<String, dynamic> json) {
    return ResumeModel(
      name: json['name'] ?? '',
      professionTitle: json['professionTitle'] ?? '',
      contact: Contact.fromJson(json['contact'] ?? {}),
      professionalSummary: json['professionalSummary'] ?? '',
      education: List<String>.from(json['education'] ?? []),
      certifications: List<String>.from(json['certifications'] ?? []),
      experience: List<String>.from(json['experience'] ?? []),
      professionalSkills: List<String>.from(json['professionalSkills'] ?? []),
      softSkills: List<String>.from(json['softSkills'] ?? []),
      projects: List<String>.from(json['projects'] ?? []),
      languages: List<String>.from(json['languages'] ?? []),
    );
  }

  // Json string to ResumeModel object directly
  factory ResumeModel.jsonToObject(String str) => ResumeModel.fromJson(jsonDecode(str));

  // Preparing map to convert it into json
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'professionTitle': professionTitle,
      'contact': contact.toMap(),
      'professionalSummary': professionalSummary,
      'education': education,
      'certifications': certifications,
      'experience': experience,
      'professionalSkills': professionalSkills,
      'softSkills': softSkills,
      'projects': projects,
      'languages': languages,
    };
  }

  // ResumeModel object to json string
  String objectToJson() => jsonEncode(toMap());
}

class Contact {
  // Properties of ResumeModel
  final String email;
  final String phone;
  final String location;
  final String cnic;

  const Contact({
    required this.email,
    required this.phone,
    required this.location,
    required this.cnic,
  });

  // Json string to ResumeModel object
  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      location: json['location'] ?? '',
      cnic: json['cnic'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'phone': phone,
      'location': location,
      'cnic': cnic,
    };
  }
}
