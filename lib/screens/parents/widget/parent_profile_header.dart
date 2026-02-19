import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:tamdansers_app/constants/app_colors.dart';
import 'package:tamdansers_app/constants/app_images.dart';
import 'package:tamdansers_app/constants/app_number.dart';
import 'package:tamdansers_app/constants/text_style.dart';

class ParentProfileHeader extends StatelessWidget {
  final String name;
  final String gender;

  const ParentProfileHeader({
    super.key,
    required this.name,
    required this.gender,
  });
  String getPrefix() {
  switch (gender) {
    case "male":
      return "លោក";
    case "female":
      return "អ្នកស្រី";
  }
  return "";
}

  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return "អរុណសួស្តី";
    } else if (hour < 17) {
      return "ទិវាសួស្ដី";
    } else {
      return "សាយណ្ហសួស្ដី";
    }
  }

  String getFormattedDate() {
    return DateFormat("EEEE, dd MMMM").format(DateTime.now());
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: AppColors.primaryMain,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(AppNumber.radiusPill)),
      ),
      child: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Text(
                  //   getFormattedDate(),
                  //   style: AppTextStyle.bodyWhite
                  // ),
                  SizedBox(height: 6),
                  Text(
                    "${getGreeting()},\n${getPrefix()} $name!",
                    style: AppTextStyle.title28White
                  ), 
                ],
              ),
            ),
            _circleIcon(SvgPicture.asset(
              AppImages.notification,

            )),
            SizedBox(width: 10),
            CircleAvatar(
              backgroundColor: AppColors.white,
              child: Icon(
                Icons.person,
                color: AppColors.primaryText,
              )),
          ],
        ),
      ),
    );
  }
  Widget _circleIcon(Widget icon) {
    return CircleAvatar(
      backgroundColor: AppColors.white,
      child: icon,
    );
  }
}