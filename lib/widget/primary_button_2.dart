import 'package:flutter/material.dart';
import 'package:tamdansers_app/constants/app_colors.dart';
import 'package:tamdansers_app/constants/app_number.dart';
import 'package:tamdansers_app/constants/text_style.dart';

class PrimaryButton2 extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final Color foregroundColor;
  final Widget? processIndicator;
  final VoidCallback? onPressed;
  const PrimaryButton2({
    super.key, 
    required this.label, 
    required this.backgroundColor,
    required this.foregroundColor,
    required this.processIndicator,
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
          foregroundColor: foregroundColor,
          padding: EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppNumber.radiusMedium)
          )
        ),
        onPressed: onPressed, 
        child: processIndicator ?? Text(
          label,
          style: AppTextStyle.buttonText18White
        )
      ),
    );
  }
}