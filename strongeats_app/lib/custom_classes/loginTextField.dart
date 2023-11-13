import 'package:flutter/material.dart';

class LoginTextField extends StatefulWidget {
  final TextEditingController controller;
  final String text;
  final String? Function(String?)? validator; // Validator function
  final Widget? suffixIcon; // Add a parameter for the suffixIcon
  final bool obscureText; // Add a parameter for the obscureText property

  LoginTextField({
    required this.controller,
    required this.text,
    required this.validator, // Validator function is optional
    this.suffixIcon,
    required this.obscureText,
  });

  @override
  State<LoginTextField> createState() => _LoginTextFieldState();
}

class _LoginTextFieldState extends State<LoginTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.obscureText,
      decoration: InputDecoration(
        hintText: widget.text,
        labelText: widget.text,
        labelStyle: TextStyle(
          color: Colors.white,
        ),
        hintStyle: TextStyle(
          color: Colors.black,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xFF757575),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(6),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.blue,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(6),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xFFD32F2F),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(6),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xFFD32F2F),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(6),
        ),
        fillColor: Colors.black,
        filled: true,
        suffixIcon: widget.suffixIcon,
      ),
      style: TextStyle(
        color: Colors.white,
      ),
      validator: widget.validator,
    );
  }
}
