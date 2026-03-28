import 'package:flutter/material.dart';
import 'package:resume_ai/data/database/constants/resume_constants.dart';
import 'package:resume_ai/data/database/dao/resume_dao.dart';
import 'package:resume_ai/data/model/resume_model.dart';
import 'package:resume_ai/ui/screens/resume_templates/midnight_resume.dart';
import 'package:resume_ai/ui/screens/resume_templates/classic_professional.dart';
import 'package:resume_ai/ui/screens/resume_templates/clean_edge.dart';
import 'package:resume_ai/ui/screens/resume_templates/simple_clean.dart';
import 'package:resume_ai/ui/screens/resume_templates/modern_minimal.dart';
import 'package:resume_ai/ui/widgets/app_bar.dart';
import 'package:resume_ai/ui/widgets/app_text.dart';

class MyResumes extends StatefulWidget {
  const MyResumes({super.key});

  @override
  State<MyResumes> createState() => _MyResumesState();
}

class _MyResumesState extends State<MyResumes> {
  @override
  void initState() {
    super.initState();
    getResumes();
  }

  List<Map<String, dynamic>> myResumes = [];

  // Fetching resumes from db
  Future<void> getResumes() async {
    final get = await ResumeDao.instance.fetchResumes();
    if (!mounted) return;
    setState(() => myResumes = List.from(get)); // More safer
  }

  // Opening a resume
  Future openSavedResume(Map<String, dynamic> resume) async {
    final jsonString = resume[ResumeConstants.jsonString];
    final templateId = resume[ResumeConstants.templateId];
    final resumeId = resume[ResumeConstants.id];

    final stringToObject = ResumeModel.jsonToObject(jsonString);

    Widget screen;

    switch (templateId) {
      case 1:
        screen = ClassicProfessional(resume: stringToObject, resumeId: resumeId);
        break;
      case 2:
        screen = SimpleClean(resume: stringToObject, resumeId: resumeId);
        break;
      case 3:
        screen = ModernMinimal(resume: stringToObject, resumeId: resumeId);
        break;
      case 4:
        screen = CleanEdge(resume: stringToObject, resumeId: resumeId);
        break;
      case 5:
        screen = MidnightResume(resume: stringToObject, resumeId: resumeId);
        break;
      default:
        screen = ClassicProfessional(resume: stringToObject, resumeId: resumeId);
    }

    if(!mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Appbar(title: 'My Resumes', leadingIcon: Icons.arrow_back),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: myResumes.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.insert_drive_file_outlined, size: 38),
                      const SizedBox(height: 8),
                      const AppText(
                        data: 'No Resumes Yet',
                        size: 18,
                        weight: FontWeight.w600,
                        align: TextAlign.center,
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: myResumes.length,
                  itemBuilder: (context, index) {
                    final resume = myResumes[index];
                    return Dismissible(
                      key: Key(resume[ResumeConstants.id].toString()),
                      onDismissed: (direction) async {
                        await ResumeDao.instance.deleteResume(
                          resume[ResumeConstants.id],
                        );
                        if(!mounted) return;
                        setState(() => myResumes.removeAt(index));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: AppText(data: 'Resume deleted', color: Colors.white,)),
                        );
                      },
                      child: Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: ListTile(
                          leading: const Icon(
                            Icons.picture_as_pdf,
                            color: Colors.red,
                            size: 40,
                          ),
                          title: AppText(
                            data:
                                '${resume[ResumeConstants.fileName]}',
                          ),
                          subtitle: AppText(data: 'Tap to open'),
                          onTap: () {
                            openSavedResume(resume);
                          },
                        ),
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
