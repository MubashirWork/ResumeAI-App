import 'package:flutter/material.dart';

class HomeScreenModel {
  final IconData icon;
  final String title;
  final String desc;
  final Color iconColor;
  final Color titleColor;

  const HomeScreenModel({
    required this.iconColor,
    required this.titleColor,
    required this.icon,
    required this.title,
    required this.desc,
  });
}
