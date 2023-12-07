import 'package:flutter/material.dart';

class MySex extends StatelessWidget {
  final bool isItMale;

  MySex({required this.isItMale});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Container(
        child: Center(
          child: Text(
            isItMale == true ? 'Male' : 'Female',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }
}
