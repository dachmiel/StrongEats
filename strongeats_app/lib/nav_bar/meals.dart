import 'package:flutter/material.dart';

class UserMeals extends StatelessWidget {
  final String name = 'Meal Tracker';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                'Meal Page',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}R
