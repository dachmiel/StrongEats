import 'package:flutter/material.dart';

class UserWorkouts extends StatelessWidget {
  final String name = 'Workout Tracker';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                'Workout Page',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
