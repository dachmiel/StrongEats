import 'package:flutter/material.dart';

class UserHome extends StatelessWidget {
  final String name = 'Home';
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                'Home Page',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
