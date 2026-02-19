import 'package:flutter/material.dart';
import 'package:tamdansers_app/screens/parents/widget/parent_profile_header.dart';

class ParentFirstScreen extends StatefulWidget {
  const ParentFirstScreen({super.key});

  @override
  State<ParentFirstScreen> createState() => _ParentFirstScreenState();
}

class _ParentFirstScreenState extends State<ParentFirstScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ParentProfileHeader(name: "Piseth", gender: "male",),
        ],
      ),
    );
  }
}