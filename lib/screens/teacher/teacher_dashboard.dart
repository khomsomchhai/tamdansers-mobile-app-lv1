import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tamdansers_app/constants/app_colors.dart';
import 'package:tamdansers_app/constants/app_icon.dart';
import 'package:tamdansers_app/constants/text_style.dart';

class TeacherDashboard extends StatefulWidget {
  const TeacherDashboard({super.key});

  @override
  State<TeacherDashboard> createState() => _TeacherDashboardState();
}

class _TeacherDashboardState extends State<TeacherDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: CircleAvatar(
              child: Image.asset(
                  "assets/images/profile_test.png")), // will get from user profile data later
        ),
        title: Text(
          // will get from user profile data later
          "ទេព​ ធីតា",
          style: AppTextStyle.sectionTitle20,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: Icon(
                Icons.notifications), // will get from user profile data later
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            RichText(
                text: TextSpan(
              text: "សួស្តី, អ្នកគ្រូ​ ",
              style: AppTextStyle.screenTitle28,
              children: [
                TextSpan(
                  text: "ទេព​ ធីតា", // will get from user profile data later
                  style: AppTextStyle.screenTitle28
                      .copyWith(color: AppColors.primaryMain),
                ),
              ],
            )),
            SizedBox(height: 20),
            _buildDashboardScard(),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardScard() {
    return Column(children: [
      SvgPicture.asset(AppIcon.classroom),
    ]);
  }
}
