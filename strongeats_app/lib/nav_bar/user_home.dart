import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class UserHome extends StatelessWidget {
  final _formfield = GlobalKey<FormState>();

  final _mealsStream = FirebaseFirestore.instance
      .collection('mealHistory')
      .doc(FirebaseAuth.instance.currentUser!.email)
      .collection('userMeals')
      .snapshots();

  @override
  Widget build(BuildContext context) {
    /* return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Home Page'),
        ],
      ),
    );
  }*/
    var today = DateFormat("MMMM dd, yyyy").format(DateTime.now());

    return Scaffold(
      backgroundColor: Colors.black,
      body: StreamBuilder(
        stream: _mealsStream,
        builder: (context, snapshot) {
          return SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Form(
                  key: _formfield,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'lib/assets/barbell_trans.png',
                        height: 150,
                      ),
                      // const SizedBox(height: 50),
                      // Hello again!
                      Text(
                        'Welcome back!',
                        style: GoogleFonts.bebasNeue(
                          fontSize: 52,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Lets Get Fit',
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 50),
                      Text(
                        'Today\'s Calorie Progress:',
                        style: GoogleFonts.inter(
                          fontSize: 24,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      CircularProgressIndicator(
                          value: 700 / 2100,
                          backgroundColor: Color.fromARGB(221, 61, 58, 58),
                          color: Colors.green),
                      const SizedBox(height: 10),
                      Text(
                        '700 / 2100 Calories',
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
