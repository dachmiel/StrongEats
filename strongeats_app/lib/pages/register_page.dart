import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:strongeats/custom_classes/myButton.dart';
import 'package:strongeats/custom_classes/registerTextField.dart';
import 'package:strongeats/custom_classes/selectorTextField.dart';
import 'package:strongeats/custom_classes/text_box.dart';

class RegisterPage extends StatefulWidget {
  final VoidCallback showLoginPage;
  const RegisterPage({Key? key, required this.showLoginPage}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // text controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmpasswordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _ageController = TextEditingController();
  final _sexController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final _goalController = TextEditingController();

  final _formfield = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmpasswordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _ageController.dispose();
    _sexController.dispose();
    _weightController.dispose();
    _goalController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future signUp() async {
    if (_formfield.currentState!.validate()) {
      if (passwordConfirmed()) {
        showDialog(
          context: context,
          builder: (context) {
            return Center(child: CircularProgressIndicator());
          },
        );
        // create user
        try {
          UserCredential userCredential =
              await _auth.createUserWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );

          var age = int.parse(_ageController.text.trim());
          var weight = int.parse(_weightController.text.trim());
          var goal = int.parse(_goalController.text.trim());
          // var heightList = _heightController.text.trim().split('\'');
          // var feet = int.parse(heightList[0]);
          // var inches = int.parse(heightList[1]);

          // print(feet);
          // print(inches);
          // var height =
          //     (12 * int.parse(heightList[0])) + int.parse(heightList[1]);
          // var male = (_sexController.text.trim().toLowerCase() == "male");

          // var maintenance = 0;
          // var calorieGoal = 0;

          // if (male) {
          //   maintenance =
          //       ((66 + (6.2 * weight) + (12.7 * height) - (6.76 * age)) * 1.465)
          //           .round();
          // } else {
          //   maintenance =
          //       ((655 + (4.35 * weight) + (4.7 * height) - (4.7 * age)) * 1.465)
          //           .round();
          // }

          // if (goal < weight) {
          //   calorieGoal = maintenance - 250;
          // } else if (goal > weight) {
          //   calorieGoal = maintenance + 250;
          // } else {
          //   calorieGoal = maintenance;
          // }

          //initialize values of user account info in database
          FirebaseFirestore.instance
              .collection('users')
              .doc(userCredential.user!.email)
              .set({
            'email': _emailController.text.trim(),
            'username': _emailController.text.split('@')[0], //initial username
            'first name': _firstNameController.text.trim(),
            'last name': _lastNameController.text.trim(),
            'age': _ageController.text.trim(),
            'sex': _sexController.text.trim(),
            'weight': _weightController.text.trim(),
            'goal weight': _goalController.text.trim(),
            'height': _heightController.text.trim(),
            'maintenance calories': 'maintenance',
            'goal calories': 'calorieGoal',
            'bmi': '',
            'intensity': '',
            'birthday': '',
          });

          Navigator.of(context).pop();
        } on FirebaseAuthException catch (e) {
          print(e);
          Navigator.of(context).pop();
        }
      }
    }
  }

  bool passwordConfirmed() {
    if (_passwordController.text.trim() ==
        _confirmpasswordController.text.trim()) {
      return true;
    } else {
      return false;
    }
  }

  calculateAge(DateTime birthdate) {
    DateTime now = DateTime.now();
    int age = now.year - birthdate.year;

    if (now.month < birthdate.month ||
        (now.month == birthdate.month && now.day < birthdate.day)) {
      age--;
    }

    // Use the age as needed
    return age;
  }

  void saveAge(int age) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.email)
        .set({'age': age.toString()});
  }

  void saveBirthday(DateTime birthday) async {
    // Convert DateTime to a formatted string
    String formattedBirthday = birthday.toIso8601String();

    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.email)
        .set({'birthday': formattedBirthday});
  }

  Future<void> editAgeField() async {
    DateTime dateTime = DateTime.now();
    // Retrieve user's current height from Firebase

    await showCupertinoModalPopup(
      context: context,
      builder: (context) => Center(
        child: SingleChildScrollView(
          child: AlertDialog(
            backgroundColor: Colors.grey[900],
            title: Text(
              "Birthday",
              style: const TextStyle(color: Colors.white),
            ),
            content: Container(
              width:
                  MediaQuery.of(context).size.width * 0.8, // Set the width here

              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 250,
                    child: CupertinoDatePicker(
                      initialDateTime: dateTime,
                      onDateTimeChanged: (DateTime newTime) {
                        setState(() => dateTime = newTime);
                      },
                      use24hFormat: true,
                      mode: CupertinoDatePickerMode.date,
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          saveAge(calculateAge(dateTime));
                          saveBirthday(dateTime);
                          Navigator.of(context).pop(dateTime);
                        },
                        child: Text(
                          'Save',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          'Cancel',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formfield,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 25),
                  // Hello again!
                  Text(
                    'Hello There!',
                    style: GoogleFonts.bebasNeue(
                      color: Colors.white,
                      fontSize: 52,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Register below with your details!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),

                  const SizedBox(height: 50),

                  // first name textfield
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: RegisterTextField(
                      obscureText: false,
                      controller: _firstNameController,
                      text: "First name",
                      validator: (text) {
                        if (text!.isEmpty) {
                          return "Enter first name";
                        }
                        return null;
                      },
                    ),
                  ),

                  const SizedBox(height: 10),

                  // last name textfield
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: RegisterTextField(
                      controller: _lastNameController,
                      text: "Last name",
                      validator: (text) {
                        if (text!.isEmpty) {
                          return "Enter last name";
                        }
                        return null;
                      },
                      obscureText: false,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // email textfield
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: RegisterTextField(
                      controller: _emailController,
                      text: 'Email',
                      validator: (text) {
                        bool emailValid = EmailValidator.validate(text!);
                        if (text.isEmpty) {
                          return "Enter email";
                        } else if (!emailValid) {
                          return "Enter a valid email";
                        }
                        return null;
                      },
                      obscureText: false,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // password textfield
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: RegisterTextField(
                      controller: _passwordController,
                      text: 'Password',
                      validator: (text) {
                        if (text!.isEmpty) {
                          return "Enter password";
                        } else if (text.length < 6) {
                          return "Your password must be at least 6 characters long";
                        }
                        return null;
                      },
                      obscureText: true,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // confirm password textfield
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: RegisterTextField(
                      controller: _confirmpasswordController,
                      text: 'Confirm Password',
                      validator: (text) {
                        if (text!.isEmpty) {
                          return "Enter password";
                        } else if (!passwordConfirmed()) {
                          return "Make sure passwords entered are the same";
                        }
                        return null;
                      },
                      obscureText: true,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Age textfield
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: RegisterTextField(
                      controller: _ageController,
                      text: "Age",
                      validator: (text) {
                        if (text!.isEmpty) {
                          return "Age";
                        }
                        return null;
                      },
                      obscureText: false,
                    ),
                  ),

                  // // Age textfield
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  //   child: SelectorTextField(
                  //     controller: _ageController,
                  //     sectionName: 'Age',
                  //     onPressed: () => editAgeField(),
                  //     text: "Age",
                  //   ),
                  // ),

                  const SizedBox(height: 10),

                  // Sex textfield
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: RegisterTextField(
                      controller: _sexController,
                      text: "Sex",
                      validator: (text) {
                        if (text!.isEmpty) {
                          return "Sex";
                        }
                        return null;
                      },
                      obscureText: false,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Weight textfield
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: RegisterTextField(
                      controller: _weightController,
                      text: "Weight",
                      validator: (text) {
                        if (text!.isEmpty) {
                          return "Weight";
                        }
                        return null;
                      },
                      obscureText: false,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Goal Weight textfield
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: RegisterTextField(
                      controller: _goalController,
                      text: "Goal Weight",
                      validator: (text) {
                        if (text!.isEmpty) {
                          return "Goal Weight";
                        }
                        return null;
                      },
                      obscureText: false,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Height textfield
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: RegisterTextField(
                      controller: _heightController,
                      text: "Height",
                      validator: (text) {
                        if (text!.isEmpty) {
                          return "Height";
                        }
                        return null;
                      },
                      obscureText: false,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // sign up button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: MyButton(
                      onTap: signUp,
                      text: "Sign Up",
                    ),
                  ),
                  const SizedBox(height: 25),

                  // you are a member? login now
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'I am a member!',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GestureDetector(
                        onTap: widget.showLoginPage,
                        child: Text(
                          ' Login Now',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
