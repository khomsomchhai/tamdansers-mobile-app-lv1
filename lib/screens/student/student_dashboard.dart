import 'package:flutter/material.dart';
import 'package:motion_tab_bar/MotionTabBar.dart';
import 'package:motion_tab_bar/MotionTabBarController.dart';
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

class _StudentDashboardState extends State<StudentDashboard>
    with SingleTickerProviderStateMixin {

  late MotionTabBarController _motionTabBarController;

  @override
  void initState() {
    super.initState();
    _motionTabBarController = MotionTabBarController(
      initialIndex: 0,
      length: 4,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _motionTabBarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBg,

      body: IndexedStack(
        index: _motionTabBarController.index,
        children: const [
          Homepage(),
          Homework(),
          Attendance(),
          Profile(),
        ],
      ),

      bottomNavigationBar: MotionTabBar(
        controller: _motionTabBarController,
        labels: const [
          "ទំព័រដើម",
          "កិច្ចការផ្ទះ",
          "វត្តមាន",
          "ប្រវត្តិរូប"
        ],
        icons: const [
          Icons.home,
          Icons.class_,
          Icons.assignment,
          Icons.person
        ],

        initialSelectedTab: "ទំព័រដើម",

        tabSize: 50,
        tabBarHeight: 60,
        textStyle: AppTextStyle.body,
        
        tabIconColor: Colors.white70,
        tabIconSelectedColor: AppColors.primary300,
        tabSelectedColor: AppColors.white,
        tabBarColor: AppColors.primaryMain,
        

        onTabItemSelected: (int value) {
          setState(() {
            _motionTabBarController.index = value;
          });
        },
      ),
    );
  }
}