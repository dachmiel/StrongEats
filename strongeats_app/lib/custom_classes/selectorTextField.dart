import 'package:flutter/material.dart';

class SelectorTextField extends StatefulWidget {
  final TextEditingController controller;

  final String text;
  final Widget? suffixIcon; // Add a parameter for the suffixIcon
  final String sectionName;
  final void Function()? onPressed;

  SelectorTextField({
    required this.controller,
    required this.text,
    this.suffixIcon,
    required this.sectionName,
    required this.onPressed,
  });

  @override
  State<SelectorTextField> createState() => _SelectorTextFieldState();
}

class _SelectorTextFieldState extends State<SelectorTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.only(
        left: 5,
        bottom: 5,
      ),
      margin: const EdgeInsets.only(
        left: 15,
        right: 15,
        top: 15,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextFormField(
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
                style: TextStyle(color: Colors.white),
              ),
              IconButton(
                onPressed: widget.onPressed,
                icon: Icon(
                  Icons.edit,
                  color: Colors.grey[400],
                ),
              ),
            ],
          ),
          Text(
            widget.text,
            style: TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }
}
