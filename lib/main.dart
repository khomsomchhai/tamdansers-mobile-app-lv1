import 'package:flutter/material.dart';
import 'package:tamdansers_app/constants/app_colors.dart';
import 'package:tamdansers_app/routes/app_routes.dart';
import 'package:tamdansers_app/screens/auth/auth_option_teacher_screen.dart';
import 'package:tamdansers_app/screens/auth/role_selection_screen.dart';
import 'package:tamdansers_app/screens/auth/splash_screen.dart';
import 'package:tamdansers_app/screens/student/menu/attendance.dart';
import 'package:tamdansers_app/screens/student/menu/homepage.dart';
import 'package:tamdansers_app/screens/student/menu/homework.dart';
import 'package:tamdansers_app/screens/student/menu/profile.dart';
import 'package:tamdansers_app/screens/student/student_dashboard.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          scaffoldBackgroundColor: AppColors.backgroundLight,
          appBarTheme: AppBarTheme(
            backgroundColor: AppColors.backgroundLight,
            elevation: 0,
            surfaceTintColor: AppColors.transparent,
          )),
      home: Scaffold(),
      initialRoute: AppRoutes.scedeul,
      routes: {
        "/splash_screen": (context) => SplashScreen(),
        "/role_selection_screen": (context) => RoleSelectionScreen(),
        "/auth_option_teacher_screen": (context) => AuthOptionTeacherScreen(),
        "/student_dashboard": (context) => StudentDashboard(),
        "/student_profile": (context) => Profile(),
        "/student_attendance": (context) => Attendance(),
        "/student_homework": (context) => Homework(),
        "/student_homepage": (context) => Homepage(),
      },
    );
  }
}
