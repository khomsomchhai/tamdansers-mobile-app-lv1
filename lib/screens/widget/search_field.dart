// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:tamdansers_app/constants/app_colors.dart';
import 'package:tamdansers_app/constants/app_number.dart';
import 'package:tamdansers_app/constants/text_style.dart';

class SearchField extends StatelessWidget {
  final String hintText;
  final Widget icon;
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  const SearchField({
    super.key,
    required this.hintText,
    required this.icon,
    required this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      textAlignVertical: TextAlignVertical.center,
      style: AppTextStyle.body,
      decoration: InputDecoration(
          filled: true,
          fillColor: AppColors.primaryMain.withValues(alpha: 0.1),
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: AppTextStyle.hintText,
          prefixIcon: icon,
          enabledBorder: UnderlineInputBorder(
              borderRadius: BorderRadius.circular(AppNumber.radiusMedium),
              borderSide: BorderSide.none),
          focusedBorder: UnderlineInputBorder(
              borderRadius: BorderRadius.circular(AppNumber.radiusMedium),
              borderSide: BorderSide.none)),
    );
  }
}
