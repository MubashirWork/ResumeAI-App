import 'dart:async';

import 'package:flutter/material.dart';
import 'package:resume_ai/core/constants/app_assets.dart';
import 'package:resume_ai/ui/screens/home/home_screen.dart';
import 'package:resume_ai/ui/widgets/app_text.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Navigates to select screen
    Timer( const Duration(seconds: 2), () {

      if(!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(color: Colors.blue),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Splash screen logo
                Image.asset(
                  AppAssets.splashLogo,
                  height: size.height * 0.15,
                  width: size.width * 0.5,
                ),

                // Title text
                const AppText(
                  data: 'ResumeAI',
                  color: Colors.white,
                  size: 40,
                  weight: FontWeight.bold,
                  align: TextAlign.center,
                ),

                SizedBox(
                  width: size.width * 0.48,
                  child: const Divider(color: Colors.white38, thickness: 0.4),
                ),

                // Subtitle text
                const AppText(
                  data: 'AI-powered Resume Generator',
                  color: Colors.white,
                  align: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
