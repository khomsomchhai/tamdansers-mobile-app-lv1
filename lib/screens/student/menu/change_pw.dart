// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:tamdansers_app/constants/text_style.dart';

class ChangePw extends StatefulWidget {
  const ChangePw({super.key});

  @override
  State<ChangePw> createState() => _ChangePwState();
}

class _ChangePwState extends State<ChangePw> {
  final TextEditingController pwNowController = TextEditingController();
  final TextEditingController pwNewController = TextEditingController();
  final TextEditingController pwConfirmController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ប្ដូរពាក្យសម្ងាត់', style: AppTextStyle.sectionTitle20),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 20),
            BuilTextfield(
              txt: 'លេខសម្ងាត់បច្ចុប្បន្ន',
              hint: 'លេខសម្ងាត់បច្ចុប្បន្ន',
              controller: pwNowController,
              leadingIcon: Icons.lock,
              trailingIcon: Icons.visibility,
            ),
            SizedBox(height: 20),
            BuilTextfield(
              txt: 'លេខសម្ងាត់ថ្មី',
              hint: 'លេខសម្ងាត់ថ្មី',
              controller: pwNewController,
              leadingIcon: Icons.lock,
              trailingIcon: Icons.visibility,
            ),
            SizedBox(height: 20),
            BuilTextfield(
              txt: 'លេខសម្ងាត់បញ្ជាក់ថ្មី',
              hint: 'លេខសម្ងាត់បញ្ជាក់ថ្មី',
              controller: pwConfirmController,
              leadingIcon: Icons.lock,
              trailingIcon: Icons.visibility,
            )
          ],
        ),
      ),
    );
  }
}

class BuilTextfield extends StatefulWidget {
  final String txt;
  final String hint;
  final TextEditingController controller;
  final IconData leadingIcon;
  final IconData trailingIcon;
  const BuilTextfield(
      {super.key,
      required this.txt,
      required this.hint,
      required this.controller,
      required this.leadingIcon,
      required this.trailingIcon});

  @override
  State<BuilTextfield> createState() => _BuilTextfieldState();
}

class _BuilTextfieldState extends State<BuilTextfield> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.txt, style: AppTextStyle.fontsize18),
        SizedBox(height: 8),
        TextField(
          controller: widget.controller,
          decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
              prefixIcon: Icon(widget.leadingIcon),
              suffixIcon: Icon(widget.trailingIcon),
              hintText: widget.hint,
              hintStyle: AppTextStyle.body
            ),
        )
      ],
    );
  }
}
