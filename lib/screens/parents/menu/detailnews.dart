import 'package:flutter/material.dart';
import 'package:tamdansers_app/constants/app_colors.dart';
import 'package:tamdansers_app/constants/app_number.dart';
import 'package:tamdansers_app/constants/text_style.dart';

class DetailNewsScreen extends StatelessWidget {
  final String category;
  final String title;
  final String description;
  final String author;
  final IconData icon;
  final Color iconColor;
  final List<String> importantPoints;

  const DetailNewsScreen({
    super.key,
    required this.category,
    required this.title,
    required this.description,
    required this.author,
    required this.icon,
    required this.iconColor,
    required this.importantPoints,
  });

  double _fs(double base, BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return base * (width / 390).clamp(0.78, 1.15);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundLight,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'ព័ត៌មានលម្អិត',
          style: AppTextStyle.sectionTitle20.copyWith(
            fontSize: _fs(20, context),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppNumber.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppNumber.radiusLarge),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: iconColor.withValues(alpha: 0.14),
                          borderRadius:
                              BorderRadius.circular(AppNumber.radiusSmall),
                        ),
                        child: Icon(icon, color: iconColor, size: 20),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: iconColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(
                              AppNumber.radiusRounded,
                            ),
                          ),
                          child: Text(
                            category,
                            style: AppTextStyle.caption12Secondary.copyWith(
                              color: iconColor,
                              fontWeight: FontWeight.w600,
                              fontSize: _fs(12, context),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    title,
                    style: AppTextStyle.subtitle18.copyWith(
                      fontSize: _fs(18, context),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: AppTextStyle.body14.copyWith(
                      fontSize: _fs(14, context),
                      color: AppColors.secondaryText,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        Icons.person_outline_rounded,
                        size: 18,
                        color: AppColors.secondaryText,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        author,
                        style: AppTextStyle.caption13Secondary.copyWith(
                          fontSize: _fs(13, context),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'ចំណុចសំខាន់ៗ',
              style: AppTextStyle.subtitle18.copyWith(
                fontSize: _fs(18, context),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppNumber.radiusLarge),
              ),
              child: Column(
                children: List.generate(importantPoints.length, (index) {
                  final point = importantPoints[index];
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: index == importantPoints.length - 1 ? 0 : 10,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 7),
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: AppColors.primaryMain,
                            borderRadius: BorderRadius.circular(99),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            point,
                            style: AppTextStyle.body14.copyWith(
                              fontSize: _fs(14, context),
                              color: AppColors.primaryText,
                              height: 1.35,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
