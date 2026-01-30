import 'package:flutter/material.dart';
import 'package:tamdansers_app/constants/app_colors.dart';
import 'package:tamdansers_app/routes/app_routes.dart';
import 'package:tamdansers_app/screens/auth/auth_option_teacher_screen.dart';
import 'package:tamdansers_app/screens/auth/login_teacher_screen.dart';
import 'package:tamdansers_app/screens/auth/role_selection_screen.dart';
import 'package:tamdansers_app/screens/auth/sign_up_teacher_screen.dart';
import 'package:tamdansers_app/screens/auth/splash_screen.dart';
import 'package:tamdansers_app/screens/student/scedeul.dart';
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
      initialRoute: AppRoutes.roleSelectionScreen,
      routes: {
        "/splash_screen": (context) => SplashScreen(),
        "/role_selection_screen": (context) => RoleSelectionScreen(),
        "/auth_option_teacher_screen": (context) => AuthOptionTeacherScreen(),
        "/login_teacher_screen": (context) => LoginTeacherScreen(),
        "/sign_up_teacher_screen": (context) => SignUpTeacherScreen(),

        //student
        "/student_dashboard": (context) => StudentDashboard(),
        "/student_scedeul": (context) => Scedeul(),
      },
    );
  }
}
