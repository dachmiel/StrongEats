import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:strongeats/auth/auth_page.dart';
import '../pages/home_page.dart';
// import '../pages/login_page.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            // user is logged in
            if (snapshot.hasData) {
              return HomePage();
            }
            // user is NOT logged in
            else {
              return AuthPage();
            }
          }),
    );
  }
}
