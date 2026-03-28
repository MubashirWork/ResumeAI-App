import 'package:flutter/material.dart';
import 'package:resume_ai/core/constants/app_colors.dart';

// Custom text field
class AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType keyboardType;
  final TextInputAction keyboardAction;
  final String? errorText;
  final ValueChanged<String>? onChange;

  const AppTextField({
    required this.controller,
    required this.hintText,
    this.keyboardType = TextInputType.text,
    this.keyboardAction = TextInputAction.next,
    this.errorText,
    this.onChange,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: AppColors.lightGray),
    );
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        filled: true,
        fillColor: AppColors.white,
        enabledBorder: border,
        focusedBorder: border,
        errorStyle: TextStyle(color: Colors.red),
        errorText: errorText,
        focusedErrorBorder: border.copyWith(
          borderSide: BorderSide(color: Colors.red),
        ),
        errorBorder: border.copyWith(borderSide: BorderSide(color: Colors.red)),
      ),
      keyboardType: keyboardType,
      textInputAction: keyboardAction,
      onChanged: onChange,
    );
  }
}
