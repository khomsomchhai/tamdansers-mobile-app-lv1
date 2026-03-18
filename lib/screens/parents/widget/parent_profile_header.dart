import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tamdansers_app/constants/app_colors.dart';
import 'package:tamdansers_app/constants/app_icon.dart';
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

  double _fs(double base, BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return base * (width / 390).clamp(0.78, 1.15);
  }

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

  String getKhmerDate() {
    DateTime now = DateTime.now();

    List<String> khmerWeekDays = [
      "ថ្ងៃច័ន្ទ",
      "ថ្ងៃអង្គារ",
      "ថ្ងៃពុធ",
      "ថ្ងៃព្រហស្បតិ៍",
      "ថ្ងៃសុក្រ",
      "ថ្ងៃសៅរ៍",
      "ថ្ងៃអាទិត្យ",
    ];

    List<String> khmerMonths = [
      "មករា",
      "កុម្ភៈ",
      "មីនា",
      "មេសា",
      "ឧសភា",
      "មិថុនា",
      "កក្កដា",
      "សីហា",
      "កញ្ញា",
      "តុលា",
      "វិច្ឆិកា",
      "ធ្នូ",
    ];

    String weekDay = khmerWeekDays[now.weekday - 1];
    String month = khmerMonths[now.month - 1];

    return "$weekDay ទី ${now.day} ខែ $month ឆ្នាំ ${now.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 12,
        left: 16,
        right: 16,
        bottom: 70,
      ),
      decoration: const BoxDecoration(
        color: AppColors.primary300,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  getKhmerDate(),
                  style: AppTextStyle.body18White
                      .copyWith(fontSize: _fs(12, context)),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.parent_nothi);
                },
                child: _circleIcon(Icons.notifications_none_rounded, context),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () => _confirmLogout(context),
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.white, width: 2),
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      AppIcon.profileParent,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Icon(
                          Icons.person_rounded,
                          color: AppColors.white,
                          size: 22),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            getGreeting(),
            style: AppTextStyle.title28White.copyWith(
                fontSize: _fs(22, context), fontWeight: FontWeight.w600),
          ),
          Text(
            "${getPrefix()} $name",
            style: AppTextStyle.title28White.copyWith(
                fontSize: _fs(22, context), fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _circleIcon(IconData icon, BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.white.withOpacity(0.2),
      ),
      child: Icon(icon, color: AppColors.white, size: 20),
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.backgroundLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppNumber.radiusLarge),
        ),
        title: Text("ចាកចេញ?", style: AppTextStyle.subtitle18),
        content: Text(
          "តើអ្នកពិតជាចង់ចាកចេញពីគណនីនេះមែនទេ?",
          style: AppTextStyle.body14,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text("បោះបង់", style: AppTextStyle.bodyPrimary),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final pref = await SharedPreferences.getInstance();
              await pref.setBool("isLogin", false);
              await pref.remove("role");
              await pref.remove("userId");
              if (context.mounted) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.roleSelectionScreen,
                  (route) => false,
                );
              }
            },
            child: Text(
              "ចាកចេញ",
              style: AppTextStyle.subtitle16.copyWith(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}
