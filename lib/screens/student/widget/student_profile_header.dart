import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tamdansers_app/constants/app_colors.dart';
import 'package:tamdansers_app/constants/app_icon.dart';
import 'package:tamdansers_app/constants/app_images.dart';
import 'package:tamdansers_app/constants/app_number.dart';
import 'package:tamdansers_app/constants/text_style.dart';

class StudentProfileHeader extends StatelessWidget {
  final Map<String, dynamic>? user;
  const StudentProfileHeader({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: AppNumber.avatarSmall,
          backgroundColor: AppColors.white,
          backgroundImage: AssetImage(
            (() {
              final g = (user?['gender'] ?? '').toString().toLowerCase();
              if (g.contains('f') || g.contains('female')) return AppIcon.femaleAvatar;
              return AppIcon.maleAvatar;
            })(),
          ),
        ),
        SizedBox(width: 10,),
        Text(
          (() {
            final first = user?['last_name'] ?? '';
            final last = user?['first_name'] ?? '';
            final full = ('$first $last').trim();
            return full.isNotEmpty ? full : 'រុន​ លីមហុង';
          })(),
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