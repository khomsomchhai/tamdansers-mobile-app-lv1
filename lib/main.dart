import 'package:flutter/material.dart';
import 'package:tamdansers_app/constants/app_colors.dart';
import 'package:tamdansers_app/routes/app_routes.dart';
import 'package:tamdansers_app/screens/auth/auth_option_teacher_screen.dart';
import 'package:tamdansers_app/screens/auth/role_selection_screen.dart';
import 'package:tamdansers_app/screens/auth/splash_screen.dart';
import 'package:tamdansers_app/screens/student/student_dashboard.dart';
import 'package:tamdansers_app/screens/teacher/manage_all_class.dart';
import 'package:tamdansers_app/screens/teacher/manage_class.dart';
import 'package:tamdansers_app/screens/teacher/teacher_dashboard.dart';

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
      initialRoute: AppRoutes.teacherDashboard,
      routes: {
        AppRoutes.teacherDashboard: (context) => TeacherDashboard(),
        AppRoutes.splashScreen: (context) => SplashScreen(),
        AppRoutes.roleSelectionScreen: (context) => RoleSelectionScreen(),
        AppRoutes.authOptionTeacherScreen: (context) =>
            AuthOptionTeacherScreen(),
        AppRoutes.studentDashboard: (context) => StudentDashboard(),
        AppRoutes.manageClass: (context) => ManageClass(),
        AppRoutes.manageAllClass: (context) => ManageAllClass(),
      },
    );
  }
}
