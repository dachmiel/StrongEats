import 'package:flutter/material.dart';

class UserProfile extends StatelessWidget {
  final String name = 'Profile';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                'Profile Page',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
