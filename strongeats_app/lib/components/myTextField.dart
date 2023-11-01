// import 'package:email_validator/email_validator.dart';
// import 'package:flutter/material.dart';

// class MyTextField extends StatefulWidget {
//   final String text;
//   final TextEditingController ctrl;
//   const MyTextField({
//     super.key,
//     required this.text,
//     required this.ctrl,
//   });

//   @override
//   State<MyTextField> createState() => _MyTextFieldState();
// }

// class _MyTextFieldState extends State<MyTextField> {
//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       controller: ctrl,
//       decoration: InputDecoration(
//         labelText: widget.text,
//         enabledBorder: OutlineInputBorder(
//           borderSide: BorderSide(
//             color: Colors.grey,
//             width: 1,
//           ),
//           borderRadius: BorderRadius.circular(8),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderSide: BorderSide(
//             color: Colors.blue,
//             width: 2,
//           ),
//           borderRadius: BorderRadius.circular(8),
//         ),
//         hintText: 'Email',
//         fillColor: Colors.black,
//         filled: true,
//       ),
//     );
//   }
// }
