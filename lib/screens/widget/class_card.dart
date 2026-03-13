import 'package:flutter/material.dart';
import 'package:tamdansers_app/constants/app_colors.dart';
import 'package:tamdansers_app/constants/app_images.dart';
import 'package:tamdansers_app/constants/text_style.dart';

class ClassCard extends StatelessWidget {
  final String className;
  final String title;
  final String students;
  final Color color;
  final String teacherName;
  final VoidCallback? onTap;

  const ClassCard({
    super.key,
    required this.className,
    required this.title,
    required this.students,
    required this.color,
    required this.teacherName,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Transform.translate(
                        offset: Offset(10, 10),
                        child: Icon(Icons.laptop_chromebook,
                            color: Colors.white.withValues(alpha: 0.2),
                            size: 100),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(height: 8),
                        Text(className,
                            style: AppTextStyle.sectionTitle20
                                .copyWith(color: AppColors.white)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 14,
                          backgroundImage: AssetImage(AppImages.userProfile),
                        ),
                        SizedBox(width: 8),
                        Flexible(
                          child: Text(teacherName,
                              style: AppTextStyle.body,
                              overflow: TextOverflow.ellipsis),
                        ),
                        SizedBox(width: 8),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Color(0xFFE3F2FD),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(title,
                              style: AppTextStyle.body.copyWith(
                                  fontSize: 12, color: AppColors.primaryMain)),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Color(0xFFE3F2FD),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.people,
                            size: 16, color: AppColors.primaryMain),
                        SizedBox(width: 4),
                        Text(students,
                            style: AppTextStyle.body.copyWith(
                                fontSize: 13, color: AppColors.primaryMain)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
