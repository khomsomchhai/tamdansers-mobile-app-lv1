import 'package:flutter/material.dart';
import 'package:tamdansers_app/constants/app_colors.dart';
import 'package:tamdansers_app/constants/app_images.dart';
import 'package:tamdansers_app/constants/app_number.dart';
import 'package:tamdansers_app/constants/text_style.dart';

class LinkParentBottomSheet extends StatefulWidget {
  const LinkParentBottomSheet({super.key});

  @override
  State<LinkParentBottomSheet> createState() => LinkParentBottomSheetState();
}

class LinkParentBottomSheetState extends State<LinkParentBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(AppNumber.radiusPill)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 5,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: AppColors.grey.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(AppNumber.radiusMedium),
            ),
          ),
          Text("ភ្ជាប់អាណាព្យាបាល", style: AppTextStyle.screenTitle24),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _roleCard(
                image: AppImages.studentMale,
                title: "សិស្ស\nសុខា ចាន់",
                color: AppColors.primaryMain.withValues(alpha: 0.3),
              ),
              const SizedBox(width: 12),
              CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.primaryMain.withValues(alpha: 0.2),
                child: Icon(Icons.link, color: AppColors.primaryMain),
              ),
              const SizedBox(width: 12),
              _roleCard(
                image: AppImages.imgParent,
                title: "អាណាព្យាបាល\nចាន់ ដារ៉ា",
                color: AppColors.success.withValues(alpha: 0.3),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryMain,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppNumber.radiusRounded),
                ),
              ),
              child: Text(
                "យល់ព្រម",
                style: AppTextStyle.bodyWhite,
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(AppNumber.radiusRounded),
                  ),
                  shadowColor: AppColors.transparent),
              child: Text(
                "បោះបង់",
                style: AppTextStyle.body.copyWith(
                  color: AppColors.error,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _roleCard({
    required String image,
    required String title,
    required Color color,
  }) {
    return Container(
      width: 120,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppNumber.radiusRounded),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: AppColors.white,
            child: Icon(Icons.person, color: AppColors.grey),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTextStyle.subtitle16,
          ),
        ],
      ),
    );
  }
}
