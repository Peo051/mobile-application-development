import 'package:flutter/material.dart';

class MusicControlButton extends StatelessWidget {
  final IconData icon;
  final double width;
  final double height;
  final double iconSize;
  final VoidCallback onPressed;

  const MusicControlButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.width = 65,
    this.height = 65,
    this.iconSize = 30,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFFF1F1F1),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 8,
            offset: Offset(3, 4),
          ),
          BoxShadow(color: Colors.white, blurRadius: 8, offset: Offset(-3, -3)),
        ],
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, size: iconSize, color: const Color(0xFF313131)),
      ),
    );
  }
}
