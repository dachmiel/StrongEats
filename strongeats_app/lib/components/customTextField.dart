import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String text;
  final String? Function(String?)? validator; // Validator function
  final Widget? suffixIcon; // Add a parameter for the suffixIcon
  final bool obscureText; // Add a parameter for the obscureText property
  final Color fillColor;
  final Color borderColor;
  final Color textColor;

  CustomTextField({
    required this.controller,
    required this.text,
    this.validator, // Validator function is optional
    this.suffixIcon,
    required this.obscureText,
    required this.fillColor,
    required this.borderColor,
    required this.textColor,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: widget.obscureText,
      controller: widget.controller,
      decoration: InputDecoration(
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: widget.borderColor,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(6),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: widget.borderColor,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(6),
        ),
        errorBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xFFD32F2F),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(6),
        ),
        focusedErrorBorder: UnderlineInputBorder(
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
        fillColor: widget.fillColor,
        filled: true,
      ),
      style: TextStyle(
        color: widget.textColor,
      ),
      validator: widget.validator,
    );
  }
}
