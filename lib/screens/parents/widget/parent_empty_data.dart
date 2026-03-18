import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tamdansers_app/constants/app_colors.dart';
import 'package:tamdansers_app/constants/app_images.dart';
import 'package:tamdansers_app/constants/app_number.dart';
import 'package:tamdansers_app/constants/text_style.dart';
import 'package:tamdansers_app/routes/app_routes.dart';

class ParentEmptyData extends StatelessWidget {
  const ParentEmptyData({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.35,
          child: SvgPicture.asset(AppImages.noData),
        ),
        Text(
          "មិនទាន់ភ្ចាប់ទៅកាន់គណនីរបស់សិស្ស",
          style: AppTextStyle.subtitle18,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          "សូមភ្ជាប់ទៅកាន់គណនីរបស់សិស្សដើម្បីចាប់ផ្ដើម",
          style: AppTextStyle.body,
        ),
        SizedBox(
          height: 30,
        ),
        SizedBox(
          height: 40,
          width: 120,
          child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.parentConnectStudent);
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
                    Icons.link_outlined,
                    color: AppColors.white,
                    size: AppNumber.iconMedium,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "ភ្ជាប់",
                    style: AppTextStyle.buttonText16White,
                  )
                ],
              )),
        ),
      ],
    );
  }
}
