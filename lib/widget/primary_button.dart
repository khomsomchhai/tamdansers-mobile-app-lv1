import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tamdansers_app/constants/app_colors.dart';

class PrimaryButton extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final Color foregroundColor;
  final VoidCallback onPressed;
  const PrimaryButton({
    super.key, 
    required this.label, 
    required this.backgroundColor,
    required this.foregroundColor,
    required this.onPressed
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shadowColor: AppColors.transparent,
          backgroundColor: backgroundColor,
          padding: EdgeInsets.symmetric(vertical: 12),
        ),
        onPressed: onPressed, 
        child: Text(
          label,
          style: GoogleFonts.kantumruyPro(
            fontSize: 18,
            color: foregroundColor,
            fontWeight: FontWeight.bold
          ),
        )
      ),
    );
  }
}