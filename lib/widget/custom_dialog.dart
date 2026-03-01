import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:tamdansers_app/constants/app_animation.dart';
import 'package:tamdansers_app/constants/app_colors.dart';
import 'package:tamdansers_app/constants/app_number.dart';
import 'package:tamdansers_app/constants/text_style.dart';

class CustomDialog extends StatelessWidget {
  const CustomDialog({
    super.key, 
    required this.label,
    required this.title,
    required this.description,
    required this.onPressed,
  });
  final String label;
  final String title;
  final String description;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppNumber.radiusMedium)
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 150,
            child: Lottie.asset(
              AppAnimations.successful,
              repeat: false,
            ),
          ),
          SizedBox(height: 20,),
          Text(
            title,
            style: AppTextStyle.sectionTitle20,
          ),
          SizedBox(height: 16,),
          Text(
            description,
            style: AppTextStyle.body,
            textAlign: TextAlign.center,
          ),
        ],
      ),
      actions: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryMain,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppNumber.radiusSmall)
              )
            ),
            child: Text(
              label,
              style: AppTextStyle.buttonText16White,
            )
          ),
        ),
      ],
    );
  }
}