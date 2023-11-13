import 'package:flutter/material.dart';

class RegisterTextField extends StatefulWidget {
  final TextEditingController controller;
  final String text;
  final String? Function(String?)? validator; // Validator function
  final Widget? suffixIcon; // Add a parameter for the suffixIcon
  final bool obscureText; // Add a parameter for the obscureText property

  RegisterTextField({
    required this.controller,
    required this.text,
    required this.validator,
    this.suffixIcon,
    required this.obscureText,
  });

  @override
  State<RegisterTextField> createState() => _RegisterTextFieldState();
}

class _RegisterTextFieldState extends State<RegisterTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: widget.obscureText,
      controller: widget.controller,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xFF757575),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(6),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xFF757575),
            width: 1,
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
        hintText: widget.text,
        hintStyle: TextStyle(
          color: Colors.grey,
        ),
        fillColor: Colors.black,
        filled: true,
      ),
      style: TextStyle(
        color: Colors.white,
      ),
      validator: widget.validator,
    );
  }
}
