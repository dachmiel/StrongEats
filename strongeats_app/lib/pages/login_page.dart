import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:strongeats/components/myButton.dart';
import 'package:strongeats/components/loginTextField.dart';
import 'package:strongeats/components/square_tile.dart';
import 'package:strongeats/services/auth_service.dart';

import 'forgot_pw_page.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback showRegisterPage;
  const LoginPage({Key? key, required this.showRegisterPage}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // text controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formfield = GlobalKey<FormState>();
  bool passToggle = true;
  bool invalidEmailPasswordVisible = false;

  // sign user in method
  Future signIn() async {
    // show loading circle

    // try sign in
    if (_formfield.currentState!.validate()) {
      showDialog(
        context: context,
        builder: (context) {
          return Center(child: CircularProgressIndicator());
        },
      );

      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        // pop the loading circle
        Navigator.of(context).pop();
      } on FirebaseAuthException catch (e) {
        // pop the loading circle
        print(e);
        Navigator.of(context).pop();

        setState(() {
          // Show the error message
          invalidEmailPasswordVisible = true;
        });
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
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
                  Image.asset(
                    'lib/assets/barbell_trans.png',
                    height: 150,
                  ),
                  // const SizedBox(height: 50),
                  // Hello again!
                  Text(
                    'Hello Again!',
                    style: GoogleFonts.bebasNeue(
                      fontSize: 52,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Ready to stay fit?',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 50),

                  // email textfield
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: LoginTextField(
                      obscureText: false,
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
                    ),
                  ),
                  const SizedBox(height: 10),

                  // password textfield
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: LoginTextField(
                      obscureText: passToggle,
                      controller: _passwordController,
                      text: 'Password',
                      validator: (text) {
                        if (text!.isEmpty) {
                          return "Enter password";
                        }
                        return null;
                      },
                      suffixIcon: InkWell(
                        onTap: () {
                          setState(() {
                            passToggle = !passToggle;
                          });
                        },
                        child: Icon(
                          passToggle ? Icons.visibility_off : Icons.visibility,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Visibility(
                    visible: invalidEmailPasswordVisible,
                    child: Text(
                      'Invalid email or password',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.red[
                            700], // You can change the color to your preference
                      ),
                    ),
                  ),

                  const SizedBox(height: 5),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return ForgotPasswordPage();
                                },
                              ),
                            );
                          },
                          child: Text(
                            'Forgot password?',
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // log in button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: MyButton(
                      onTap: signIn,
                      text: "Log In",
                    ),
                  ),
                  const SizedBox(height: 25),

                  // or continue with
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: Colors.grey[400],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            'Or',
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // apple and google sign in
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // apple button
                      SquareTile(
                        text: 'Apple',
                        imagePath: 'lib/assets/apple.png',
                        boxColor: Colors.white,
                        borderColor: Colors.white,
                        textColor: Colors.black,
                        onTap: () {},
                      ),

                      const SizedBox(
                        height: 20,
                      ),

                      // google button
                      SquareTile(
                        text: 'Google',
                        imagePath: 'lib/assets/google.png',
                        boxColor: Colors.black,
                        borderColor: Colors.white,
                        textColor: Colors.white,
                        onTap: () => AuthService().signInWithGoogle(),
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  // not a member? register now
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account?",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GestureDetector(
                        onTap: widget.showRegisterPage,
                        child: Text(
                          ' Register now',
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
