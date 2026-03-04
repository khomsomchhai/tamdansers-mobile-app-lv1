import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tamdansers_app/constants/app_colors.dart';
import 'package:tamdansers_app/constants/app_number.dart';
import 'package:tamdansers_app/constants/text_style.dart';

class AuthField extends StatefulWidget {
  final String hintText;
  final Widget icon;
  final bool isPwd;
  final TextEditingController textController;
  final String? Function(String?)? validator;
  const AuthField({
    super.key, 
    required this.hintText, 
    required this.icon, 
    this.isPwd = false,
    required this.textController,
    this.validator
    });

  @override
  State<AuthField> createState() => _AuthFieldState();
}

class _AuthFieldState extends State<AuthField> {
  bool isHide = true;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextFormField(
        textAlignVertical: TextAlignVertical.center,
        validator: widget.validator,
        controller: widget.textController,
        obscureText: widget.isPwd && isHide? true: false,
        style: AppTextStyle.body,
        decoration: InputDecoration(
          filled: true,
          fillColor: AppColors.white,
          hintText: widget.hintText,
          prefixIcon: widget.icon,
          errorStyle: GoogleFonts.kantumruyPro(
            fontSize: 16,
            color: AppColors.error
          ),
          suffixIcon: widget.isPwd
          ? GestureDetector(
            onTap: () {
              setState(() {
                isHide = !isHide;
              });
            },
            child: Icon(
              isHide? Icons.visibility_off_outlined: Icons.visibility_outlined, 
              color: AppColors.secondaryText,
              size: 20,
              ),
          )
          : null,
          hintStyle: AppTextStyle.hintText,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppNumber.radiusMedium),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppNumber.radiusMedium),
            borderSide: BorderSide(
              color: AppColors.primaryMain,
            )
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppNumber.radiusMedium),
            borderSide: BorderSide(
              color: AppColors.error,
            )
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppNumber.radiusMedium),
            borderSide: BorderSide(
              color: AppColors.error,
            )
          )
        ),
      ),
    );
  }
}