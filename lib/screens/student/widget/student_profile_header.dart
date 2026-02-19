import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tamdansers_app/constants/app_colors.dart';
import 'package:tamdansers_app/constants/app_icon.dart';
import 'package:tamdansers_app/constants/app_images.dart';
import 'package:tamdansers_app/constants/app_number.dart';
import 'package:tamdansers_app/constants/text_style.dart';

class StudentProfileHeader extends StatelessWidget {
  const StudentProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: AppNumber.avatarSmall,
          backgroundColor: AppColors.grey.withValues(alpha: 0.3),
          backgroundImage: AssetImage(
            AppIcon.maleAvatar
          ),
        ),
        SizedBox(width: 10,),
        Text(
          "រុន​ លីមហុង",
          style: AppTextStyle.subtitle18
        ),
        Spacer(),
        SvgPicture.asset(
          AppImages.notification,
          height: AppNumber.iconSmall,
        )
      ],
    );
  }
}