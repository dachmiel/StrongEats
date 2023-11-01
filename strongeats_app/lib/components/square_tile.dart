import 'package:flutter/material.dart';

class SquareTile extends StatelessWidget {
  final String imagePath;
  final Color boxColor;
  final Color borderColor;
  const SquareTile({
    super.key,
    required this.imagePath,
    required this.boxColor,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 180),
      decoration: BoxDecoration(
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(8),
        color: boxColor,
      ),
      child: Image.asset(
        imagePath,
        height: 20,
      ),
    );
  }
}
