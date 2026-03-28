import 'package:flutter/material.dart';

// Custom elevated button
class AppElevatedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;
  final Color backgroundColor;
  final double radius;
  final double height;
  final double width;

  const AppElevatedButton({
    required this.onPressed,
    required this.child,
    this.backgroundColor = Colors.amber,
    this.radius = 8,
    this.width = double.infinity,
    this.height = 40,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ElevatedButton(onPressed: onPressed, style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        minimumSize: Size(width, height),
        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius)
        )
      ), child: child),
    );
  }
}
