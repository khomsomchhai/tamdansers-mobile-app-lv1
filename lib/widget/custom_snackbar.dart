import 'package:flutter/material.dart';
import 'package:tamdansers_app/constants/app_colors.dart';
import 'package:tamdansers_app/constants/app_number.dart';
import 'package:tamdansers_app/constants/text_style.dart';

class CustomSnackbar extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final Color color;

  const CustomSnackbar({
    super.key,
    required this.title,
    required this.message,
    required this.icon,
    required this.color
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.primaryText,
        borderRadius: BorderRadius.circular(AppNumber.radiusMedium),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryText.withValues(alpha: 0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: AppColors.white,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTextStyle.buttonText18White
                      ),
                      SizedBox(height: 6),
                      Text(
                        message,
                        style: AppTextStyle.caption13White
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 4,
            width: MediaQuery.sizeOf(context).width*0.9,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(AppNumber.radiusLarge),
              ),
            ),
          ),
        ],
      ),
    );
  }
}