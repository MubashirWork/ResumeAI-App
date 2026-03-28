import 'package:flutter/material.dart';

// Custom text
class AppText extends StatelessWidget {
  final String data;
  final Color color;
  final double size;
  final FontWeight weight;
  final TextAlign align;
  final TextOverflow overflow;

  const AppText({
    required this.data,
    this.color = Colors.black,
    this.size = 14,
    this.weight = FontWeight.normal,
    this.align = TextAlign.start,
    this.overflow = TextOverflow.visible,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: TextStyle(color: color, fontSize: size, fontWeight: weight),
      textAlign: align,
      overflow: overflow,
    );
  }
}
