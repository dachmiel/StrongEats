import 'package:flutter/material.dart';

class SquareTile extends StatelessWidget {
  final String text;
  final String imagePath;
  final Color boxColor;
  final Color borderColor;
  final Color textColor;
  final Function()? onTap;

  const SquareTile({
    super.key,
    required this.text,
    required this.imagePath,
    required this.boxColor,
    required this.borderColor,
    required this.textColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:
            EdgeInsets.symmetric(vertical: 17, horizontal: 25), //size of image
        width: 380,
        height: 60,
        decoration: BoxDecoration(
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(8),
          color: boxColor,
        ),
        child: Row(
          children: [
            Image.asset(
              imagePath,
              // height: 25,
            ),
            Expanded(
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  'Continue with ' + text,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 16,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
