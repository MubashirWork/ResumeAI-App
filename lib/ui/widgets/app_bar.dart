import 'package:flutter/material.dart';
import 'package:resume_ai/core/constants/app_colors.dart';
import 'package:resume_ai/ui/widgets/app_text.dart';

// Custom appbar
class Appbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final IconData? leadingIcon;

  const Appbar({required this.title, this.leadingIcon, super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.royalBlue,
      leading: leadingIcon != null
          ? IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(leadingIcon, color: Colors.white,),
            )
          : null,
      title: AppText(
        data: title,
        size: 18,
        color: Colors.white,
        weight: FontWeight.bold,
      ),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
