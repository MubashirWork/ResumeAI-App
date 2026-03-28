import 'package:flutter/material.dart';
import 'package:resume_ai/core/constants/app_pdf_fonts.dart';
import 'package:resume_ai/ui/screens/splash/splash_screen.dart';

// Starting point of app
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Loading fonts
  await AppPdfFonts.load();
  runApp(const ResumeAI());
}

class ResumeAI extends StatelessWidget {
  const ResumeAI({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Resume AI',

      // First splash screen
      home: const SplashScreen(),
    );
  }
}



