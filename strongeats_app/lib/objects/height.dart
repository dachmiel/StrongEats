import 'package:flutter/material.dart';

class MyFeet extends StatelessWidget {
  final int feet;
  final Color selectedColor;

  MyFeet({required this.feet, required this.selectedColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Container(
        child: Center(
          child: Text(
            feet.toString(),
            style: TextStyle(
              fontSize: 20,
              color: selectedColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class MyInches extends StatelessWidget {
  int inches;

  MyInches({required this.inches});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Container(
        child: Center(
          child: Text(
            inches.toString(),
            style: TextStyle(
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }
}

class CmIn extends StatelessWidget {
  final bool isItCm;

  CmIn({required this.isItCm});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Container(
        child: Center(
          child: Text(
            isItCm == true ? 'cm' : 'in',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }
}
