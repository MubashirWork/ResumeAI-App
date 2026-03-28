import 'package:flutter/material.dart';
import 'package:resume_ai/core/constants/app_assets.dart';
import 'package:resume_ai/data/database/dao/resume_dao.dart';
import 'package:resume_ai/data/model/resume_model.dart';
import 'package:resume_ai/ui/screens/resume_templates/midnight_resume.dart';
import 'package:resume_ai/ui/screens/resume_templates/classic_professional.dart';
import 'package:resume_ai/ui/screens/resume_templates/clean_edge.dart';
import 'package:resume_ai/ui/screens/resume_templates/simple_clean.dart';
import 'package:resume_ai/ui/screens/resume_templates/modern_minimal.dart';
import 'package:resume_ai/ui/screens/template_selection/template_model/template_model.dart';
import 'package:resume_ai/ui/widgets/app_bar.dart';
import 'package:resume_ai/ui/widgets/app_text.dart';

class SelectTemplate extends StatefulWidget {
  final ResumeModel resume;
  final int? resumeId;

  const SelectTemplate({required this.resume, this.resumeId, super.key});

  @override
  State<SelectTemplate> createState() => _SelectTemplateState();
}

class _SelectTemplateState extends State<SelectTemplate> {
  // Templates list
  final List<TemplateModal> myItems = [
    TemplateModal(
      image: AppAssets.classicProfessional,
      content: "Classic Professional",
      templateNo: 1,
    ),
    TemplateModal(
      image: AppAssets.simpleClean,
      content: "Simple Clean",
      templateNo: 2,
    ),
    TemplateModal(
      image: AppAssets.modernMinimal,
      content: "Modern Minimal",
      templateNo: 3,
    ),
    TemplateModal(
      image: AppAssets.cleanEdge,
      content: "Clean Edge",
      templateNo: 4,
    ),
    TemplateModal(
      image: AppAssets.midnightResume,
      content: "Midnight Resume",
      templateNo: 5,
    ),
  ];

  // Storing, updating and navigate
  Future storeAndNavigate(int id) async {
    final jsonString = widget.resume.objectToJson();
    if (widget.resumeId != null) {
      await ResumeDao.instance.updateResume(
        widget.resumeId!,
        jsonString,
        widget.resume.name,
        id,
      );
    } else {
      await ResumeDao.instance.storeResume(jsonString, id, widget.resume.name);
    }
    Widget template;
    switch (id) {
      case 1:
        template = ClassicProfessional(
          resume: widget.resume,
          resumeId: widget.resumeId,
        );
        break;
      case 2:
        template = SimpleClean(
          resume: widget.resume,
          resumeId: widget.resumeId,
        );
        break;
      case 3:
        template = ModernMinimal(
          resume: widget.resume,
          resumeId: widget.resumeId,
        );
        break;
      case 4:
        template = CleanEdge(
            resume: widget.resume,
            resumeId: widget.resumeId
        );
        break;
      case 5:
        template = MidnightResume(
          resume: widget.resume,
          resumeId: widget.resumeId,
        );
        break;
      default:
        template = ClassicProfessional(
          resume: widget.resume,
          resumeId: widget.resumeId,
        );
    }
    if(!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => template),
      (route) => route.isFirst,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Appbar(
        title: 'Choose Template',
        leadingIcon: Icons.arrow_back,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          // Showing list of template in gridview form
          child: GridView.builder(
            itemCount: myItems.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.75,
            ),
            itemBuilder: (context, index) {
              final item = myItems[index];
              return InkResponse(
                containedInkWell: true,
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  storeAndNavigate(item.templateNo);
                },
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Expanded(child: Image.asset(item.image)),
                        const SizedBox(height: 8),
                        AppText(data: item.content, weight: FontWeight.w400),
                      ],
                    ),
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