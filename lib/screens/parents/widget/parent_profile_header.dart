import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tamdansers_app/constants/app_colors.dart';
import 'package:tamdansers_app/constants/app_icon.dart';
import 'package:tamdansers_app/constants/app_images.dart';
import 'package:tamdansers_app/constants/app_number.dart';
import 'package:tamdansers_app/constants/text_style.dart';
import 'package:tamdansers_app/routes/app_routes.dart';

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
        borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(AppNumber.radiusPill)),
      ),
      child: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text("${getGreeting()},\n${getPrefix()} $name!",
                  style: AppTextStyle.title28White),
            ),
            _circleIcon(SvgPicture.asset(
              AppImages.notification,
            )),
            SizedBox(width: 10),
            GestureDetector(
              onTap: () => _confirmLogout(context),
              child: CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.backgroundLight,
                child: const Icon(Icons.logout_rounded,
                    size: 18, color: AppColors.error),
              ),
            ),
            SizedBox(width: 10),
            CircleAvatar(
              // radius: 20,
              backgroundColor: AppColors.backgroundLight,
              backgroundImage: AssetImage(AppIcon.profileParent),
            ),
          ],
        ),
      ),
    );
  }

  Widget _circleIcon(Widget icon) {
    return CircleAvatar(
      radius: 20,
      backgroundColor: AppColors.backgroundLight,
      child: icon,
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('ចាកចេញ?'),
        content: const Text('តើអ្នកពិតជាចង់ចាកចេញពីគណនីនេះមែនទេ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('បោះបង់'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final pref = await SharedPreferences.getInstance();
              await pref.setBool('isLogin', false);
              await pref.remove('role');
              if (context.mounted) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.roleSelectionScreen,
                  (route) => false,
                );
              }
            },
            child: const Text('ចាកចេញ', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
