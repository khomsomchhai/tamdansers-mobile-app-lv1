import 'package:flutter/material.dart';
import 'package:tamdansers_app/routes/app_routes.dart';
import 'package:tamdansers_app/screens/auth/login_teacher_screen.dart';
import 'package:tamdansers_app/screens/auth/role_selection_screen.dart';
import 'package:tamdansers_app/screens/auth/sign_up_teacher_screen.dart';
import 'package:tamdansers_app/screens/auth/splash_screen.dart';
import 'package:tamdansers_app/screens/student/menu/attendance.dart';
import 'package:tamdansers_app/screens/student/menu/homepage.dart';
import 'package:tamdansers_app/screens/student/menu/homework.dart';
import 'package:tamdansers_app/screens/student/menu/profile.dart';
import 'package:tamdansers_app/screens/student/result.dart';
import 'package:tamdansers_app/screens/student/student_dashboard.dart';
import 'package:tamdansers_app/screens/teacher/manage_all_class.dart';
import 'package:tamdansers_app/screens/teacher/manage_class.dart';
import 'package:tamdansers_app/screens/teacher/teacher_dashboard.dart';

class PageRoutes {
  static Map<String, Widget Function(BuildContext)> routes = {
    AppRoutes.splashScreen: (context) => SplashScreen(),
    AppRoutes.roleSelectionScreen: (context) => RoleSelectionScreen(),
    // Teacher routes
    AppRoutes.loginTeacherScreen: (context) => LoginTeacherScreen(),
    AppRoutes.signUpTeacherScreen: (context) => SignUpTeacherScreen(),
    AppRoutes.teacherDashboard: (context) => TeacherDashboard(),
    AppRoutes.manageClass: (context) => ManageClass(),
    AppRoutes.manageAllClass: (context) => ManageAllClass(),

    // Student routes
    AppRoutes.studentDashboard: (context) => StudentDashboard(),
    AppRoutes.profile: (context) => Profile(),
    AppRoutes.attendance: (context) => Attendance(),
    AppRoutes.homework: (context) => Homework(),
    AppRoutes.homepage: (context) => Homepage(),
    AppRoutes.result: (context) => Result(),
  };
}
