import 'package:flutter/material.dart';
import 'package:resume_ai/core/constants/app_colors.dart';
import 'package:resume_ai/ui/widgets/app_text.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.darkBlue,
                AppColors.mediumBlue,
                Color(0xFF163A5F),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              // Title text
              const AppText(
                data: 'Preparing your Resume...',
                size: 18,
                color: Colors.white,
                weight: FontWeight.bold,
              ),
              const SizedBox(height: 32),

              // Circular progress indicator
              const SizedBox(
                height: 60,
                width: 60,
                child: CircularProgressIndicator(
                  strokeWidth: 5,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white70),
                  color: AppColors.white,
                ),
              ),
              const SizedBox(height: 24),

              // Subtitle text
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF0B2239).withValues(alpha: 0.85),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
                width: double.infinity,
                child: const AppText(
                  data: 'Please wait while we\nprocess your request.',
                  size: 16,
                  weight: FontWeight.w500,
                  color: Colors.white,
                  align: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
