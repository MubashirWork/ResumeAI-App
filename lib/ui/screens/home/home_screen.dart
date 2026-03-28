import 'package:flutter/material.dart';
import 'package:resume_ai/ui/screens/form/resume_form_screen.dart';
import 'package:resume_ai/ui/screens/home/modal/home_screen_model.dart';
import 'package:resume_ai/ui/screens/myResume/my_resumes.dart';
import 'package:resume_ai/ui/widgets/app_bar.dart';
import 'package:resume_ai/ui/widgets/app_text.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final List<HomeScreenModel> myList = [
    HomeScreenModel(
      icon: Icons.folder_copy,
      title: 'Open My Resumes',
      desc: 'View all your saved resumes',
      iconColor: Colors.amber,
      titleColor: Colors.blue,
    ),
    HomeScreenModel(
      icon: Icons.edit_document,
      title: 'Create New Resume',
      desc: 'Start a new resume from scratch',
      iconColor: Colors.green,
      titleColor: Colors.green,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Appbar(title: 'Resume Builder'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const AppText(
                  data: 'Create a new resume or open your saved resumes',
                  size: 16,
                  weight: FontWeight.w500,
                  align: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView.separated(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    shrinkWrap: true,
                    itemCount: myList.length,
                    itemBuilder: (context, index) {
                      final item = myList[index];
                      return InkResponse(
                        containedInkWell: true,
                        borderRadius: BorderRadius.circular(16),
                        onTap: () {
                          if (index == 0) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MyResumes(),
                              ),
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ResumeFormScreen(),
                              ),
                            );
                          }
                        },
                        child: Card(
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Column(
                              children: [
                                Icon(
                                  item.icon,
                                  size: 38,
                                  color: item.iconColor,
                                ),
                                const SizedBox(height: 8),
                                AppText(
                                  data: item.title,
                                  color: item.titleColor,
                                  size: 18,
                                  weight: FontWeight.w700,
                                ),
                                const SizedBox(height: 4),
                                AppText(data: item.desc),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        const SizedBox(height: 8),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
