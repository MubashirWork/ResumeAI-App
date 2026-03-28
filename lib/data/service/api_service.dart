import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:resume_ai/core/constants/app_secret.dart';


class ApiService {

  static Future<String> generateResumeFromAI({
    required String fullName,
    required String professionTitle,
    String? professionalSummary,
    required String email,
    required String phoneNumber,
    String? cnic,
    required String countryCity,
    required String education,
    String? certificates,
    String? experience,
    String? professionalSkills,
    String? softSkills,
    String? project,
    String? language,
  }) async {
    try {
      final response = await http
          .post(
            // Posting link
            Uri.parse('https://router.huggingface.co/v1/chat/completions'),

            // Headers
            headers: {
              'Authorization': 'Bearer ${AppSecret.key}',
              'Content-Type': 'application/json',
            },

            // Body
            body: jsonEncode({
              'model': 'meta-llama/Llama-3.1-8B-Instruct',
              'stream': false,
              'messages': [
                {
                  'role': 'system',
                  'content': '''
            You are a professional resume writer and data formatter.

            STRICT RULES:
            - Output ONLY valid JSON.
            - Do NOT include explanations, thoughts, comments, or reasoning.
            - Do NOT include markdown.
            - Do NOT include any text outside JSON.
            - Use ONLY the user-provided data.
            - Do NOT invent or assume missing information.
            - If a field has no data, REMOVE it completely from JSON.
            - Ensure the JSON is properly formatted and parsable.

            The resume must be professional, concise, and suitable for the given profession.
            ''',
                },

                {
                  'role': 'user',
                  'content':
                      '''
            Generate a professional resume in the following JSON structure.

            JSON STRUCTURE (remove any field that has no data):

            {
              "name": "",
              "professionTitle": "",
              "contact": {
                "email": "",
                "phone": "",
                "cnic": "",
                "location": ""
              },
              "professionalSummary": "",
              "education": [],
              "certifications": [],
              "experience": [],
              "professionalSkills": [],
              "softSkills": [],
              "projects": [],
              "languages": []
            }

            IMPORTANT:
            - Arrays should contain clear, short strings.
            - Adapt wording based on profession.
            - Do not add extra keys.

            USER DATA:
            Name: $fullName
            Profession Title: $professionTitle
            Professional Summary: $professionalSummary
            Email: $email
            Phone: $phoneNumber
            CNIC: $cnic
            Location: $countryCity
            Education: $education
            Certificates: $certificates
            Experience: $experience
            Professional Skills: $professionalSkills
            Soft Skills: $softSkills
            Projects: $project
            Languages: $language
            ''',
                },
              ],
            }),
          )
          .timeout(Duration(seconds: 30));
      if (response.statusCode == 200) {
        final Map<String, dynamic> decode = jsonDecode(response.body);
        if (decode['choices'] != null &&
            decode['choices'].isNotEmpty &&
            decode['choices'][0]['message'] != null) {
          return decode['choices'][0]['message']['content'] ?? '';
        } else {
          throw Exception('Incorrect Api response format');
        }
      } else {
        throw Exception('Api Failed ${response.statusCode}');
      }
    } on TimeoutException {
      throw Exception('Server is taking too long. Please try again.');
    } catch (e) {
      throw Exception('Something went wrong.');
    }
  }
}
