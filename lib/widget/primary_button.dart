import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tamdansers_app/constants/app_colors.dart';

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  const PrimaryButton({super.key, required this.label , required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryMain,
          padding: EdgeInsets.symmetric(vertical: 10)
        ),
        onPressed: onPressed, 
        child: Text(
          label,
          style: GoogleFonts.kantumruyPro(
            fontSize: 26,
            color: AppColors.white,
            fontWeight: FontWeight.bold
          ),
        )
      ),
    );
  }
}