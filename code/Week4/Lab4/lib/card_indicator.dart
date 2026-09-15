import 'package:flutter/material.dart';
class CardIndicator extends StatelessWidget {
  final double width;
  final Color color;

  const CardIndicator({super.key, required this.width, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 13,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
