import 'package:flutter/material.dart';
import 'package:tamdansers_app/constants/app_colors.dart';
import 'package:tamdansers_app/constants/text_style.dart';

class CardAttendance extends StatelessWidget {
  const CardAttendance({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryMain,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('វត្តមានប្រចាំខែ មករា 2026',
                  style: AppTextStyle.body.copyWith(color: AppColors.white)),
              Text('94%',
                  style: AppTextStyle.title28.copyWith(
                      color: AppColors.white, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundLight,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text("វត្តមាន​ 26",
                        style: AppTextStyle.body.copyWith(
                            color: AppColors.success,
                            fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(width: 10),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundLight,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text("អវត្តមាន​ 4",
                        style: AppTextStyle.body.copyWith(
                            color: AppColors.error,
                            fontWeight: FontWeight.bold)),
                  )
                ],
              )
            ],
          ),
          Spacer(),
          Stack(alignment: Alignment.center, children: [
            SizedBox(
              height: 60,
              width: 60,
              child: CircularProgressIndicator(
                value: 0.8,
                strokeWidth: 8,
                color: AppColors.white,
                backgroundColor: AppColors.white.withValues(alpha: 0.2),
                strokeCap: StrokeCap.round,
              ),
            ),
            Icon(Icons.check_circle, size: 20, color: AppColors.white)
          ])
        ],
      ),
    );
  }
}
