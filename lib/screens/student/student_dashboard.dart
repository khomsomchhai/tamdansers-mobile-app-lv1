import 'package:flutter/material.dart';
import 'package:tamdansers_app/constants/app_colors.dart';
import 'package:tamdansers_app/constants/text_style.dart';
import 'package:tamdansers_app/screens/student/menu/attendance.dart';
import 'package:tamdansers_app/screens/student/menu/homepage.dart';
import 'package:tamdansers_app/screens/student/menu/homework.dart';
import 'package:tamdansers_app/screens/student/menu/profile.dart';

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({super.key});

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  var index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading:
            CircleAvatar(child: SvgPicture.asset("assets/images/app_logo_blue.svg")),
        title: Column(
          children: [
            Text(
              'Run Limhong',
              style: TextStyle(
                  color: AppColors.primaryText,
                  fontSize: AppTextStyle.sectionTitle20.fontSize),
            ),
            Text(
              'ID: 12345678',
              style: TextStyle(
                  color: AppColors.secondaryText,
                  fontSize: AppTextStyle.fontsize18.fontSize),
            ),
          ],
        ),
        
      ),
    );
  }
}
