// import 'package:flutter/material.dart';

// class AuthRadio extends StatefulWidget {
//   final String value;
//   const AuthRadio({
//     super.key,
//     required this.value,
//     required this.gender,
//   });

//   @override
//   State<AuthRadio> createState() => _AuthRadioState();
// }

// class _AuthRadioState extends State<AuthRadio> {
//   @override
//   Widget build(BuildContext context) {
//     return Radio(
//       value: widget.value,
//       groupValue: widget.gender,
//       onChanged: (value) {
//         setState(() {
//           widget.gender = value!;
//         });
//       },
//     );
//   }
// }