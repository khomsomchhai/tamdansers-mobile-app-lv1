import 'package:flutter/material.dart';
import 'package:tamdansers_app/constants/app_colors.dart';
<<<<<<< HEAD
import 'package:tamdansers_app/constants/app_number.dart';
=======
>>>>>>> a3d0fb9 (update more about spacing in teacher auth)
import 'package:tamdansers_app/constants/text_style.dart';

class ButtonWithIcon extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;
  final Widget icon;
  const ButtonWithIcon({
    super.key,
    required  this.onPressed, 
    required this.label,
    required this.icon
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        onPressed;
      }, 
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 10),
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.primaryText,
<<<<<<< HEAD
        shadowColor: AppColors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppNumber.radiusMedium)
        )
=======
        shadowColor: AppColors.transparent
>>>>>>> a3d0fb9 (update more about spacing in teacher auth)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon,
          SizedBox(width: 20,),
          Text(
            label,
<<<<<<< HEAD
            style: AppTextStyle.buttonText18Black
=======
            style: AppTextStyle.fontsize18,
>>>>>>> a3d0fb9 (update more about spacing in teacher auth)
          ),
        ],
      )
    );
  }
}