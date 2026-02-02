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
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.white,
        currentIndex: index,
        onTap: (value) {
          setState(() {
            index = value;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primaryMain,
        selectedLabelStyle: AppTextStyle.body,
        unselectedLabelStyle: AppTextStyle.body,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home,size: 28,),
            label: 'ទំព័រដើម',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.class_), label: 'កិច្ចការផ្ទះ'),
          BottomNavigationBarItem(
              icon: Icon(Icons.assignment), label: "វត្តមាន"),
          BottomNavigationBarItem(
              icon: Icon(Icons.person,size: 30,), label: 'ប្រវត្តិរូប'),
        ],
      ),
      body: IndexedStack(
        index: index,
        children: [
          Homepage(),
          Homework(),
          Attendance(),
          Profile(),
        ],
      ),
    );
  }
}
