import 'package:flutter/material.dart';
import 'package:resume_ai/core/constants/app_colors.dart';

// Custom card
class AppCard extends StatelessWidget {
  final Widget child;

  const AppCard({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: AppColors.lightGray),
      ),
      shadowColor: Colors.black12,
      color: AppColors.white,
      child: Padding(padding: const EdgeInsets.all(16), child: child),
    );
  }
}
