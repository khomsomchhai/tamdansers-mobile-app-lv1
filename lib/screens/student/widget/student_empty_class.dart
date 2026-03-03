import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tamdansers_app/constants/app_colors.dart';
import 'package:tamdansers_app/constants/app_images.dart';
import 'package:tamdansers_app/constants/app_number.dart';
import 'package:tamdansers_app/constants/text_style.dart';
import 'package:tamdansers_app/routes/app_routes.dart';

class StudentEmptyClass extends StatelessWidget {
  // final VoidCallback onJoinPressed;
  const StudentEmptyClass({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.35,
          child: SvgPicture.asset(AppImages.noData),
        ),
        Text(
          "មិនទាន់មានថ្នាក់រៀន",
          style: AppTextStyle.subtitle18,
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          "សូមចូលថ្នាក់រៀនដើម្បីចាប់ផ្ដើម",
          style: AppTextStyle.body,
        ),
        SizedBox(
          height: 30,
        ),
        SizedBox(
          height: 40,
          width: 160,
          child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.joinClassSreen);
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryMain,
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppNumber.radiusSmall))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.class_outlined,
                    color: AppColors.white,
                    size: AppNumber.icon16,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "ចូលថ្នាក់រៀន",
                    style: AppTextStyle.buttonText16White,
                  )
                ],
              )),
        ),
      ],
    );
  }
}
