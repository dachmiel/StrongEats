import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:strongeats/components/myButton.dart';
import 'package:strongeats/components/registerTextField.dart';

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
  final _formfield = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmpasswordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
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
          UserCredential result = await _auth.createUserWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );

          // add user details
          addUserDetails(_firstNameController.text.trim(),
              _lastNameController.text.trim(), _emailController.text.trim());

          Navigator.of(context).pop();
        } on FirebaseAuthException catch (e) {
          print(e);
          Navigator.of(context).pop();
        }
      }
    }
  }

  Future addUserDetails(String firstName, String lastName, String email) async {
    await FirebaseFirestore.instance.collection('users').add({
      'first name': firstName,
      'last name': lastName,
      'email': email,
    });
  }

  bool passwordConfirmed() {
    if (_passwordController.text.trim() ==
        _confirmpasswordController.text.trim()) {
      return true;
    } else {
      return false;
    }
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
