import 'package:flutter/material.dart';
import 'package:tamdansers_app/routes/app_routes.dart';
import 'package:tamdansers_app/screens/auth/auth_option_teacher_screen.dart';
import 'package:tamdansers_app/screens/auth/login_teacher_screen.dart';
import 'package:tamdansers_app/screens/auth/role_selection_screen.dart';
import 'package:tamdansers_app/screens/auth/sign_up_teacher_screen.dart';
import 'package:tamdansers_app/screens/auth/splash_screen.dart';
import 'package:tamdansers_app/screens/parents/parents_dashboard.dart';
import 'package:tamdansers_app/screens/student/menu/attendance.dart';
import 'package:tamdansers_app/screens/student/menu/deatil_teacher.dart';
import 'package:tamdansers_app/screens/student/menu/deatilscreen.dart';
import 'package:tamdansers_app/screens/student/menu/homepage.dart';
import 'package:tamdansers_app/screens/student/menu/homework.dart';
import 'package:tamdansers_app/screens/student/menu/profile.dart';
import 'package:tamdansers_app/screens/student/menu/submmit_screen.dart';
import 'package:tamdansers_app/screens/student/result.dart';
import 'package:tamdansers_app/screens/teacher/link_parent.dart';
import 'package:tamdansers_app/screens/teacher/manage_all_class.dart';
import 'package:tamdansers_app/screens/teacher/manage_class.dart';
import 'package:tamdansers_app/screens/teacher/manage_student_screen.dart';
import 'package:tamdansers_app/screens/teacher/student_detail_screen.dart';
import 'package:tamdansers_app/screens/teacher/teacher_dashboard.dart';

class PageRoutes {
  static Map<String, Widget Function(BuildContext)> routes = {
    AppRoutes.splashScreen: (context) => SplashScreen(),
    AppRoutes.roleSelectionScreen: (context) => RoleSelectionScreen(),
    AppRoutes.authOptionTeacherScreen: (context) => AuthOptionTeacherScreen(),
    //teacher
    AppRoutes.loginTeacherScreen: (context) => LoginTeacherScreen(),
    AppRoutes.signUpTeacherScreen: (context) => SignUpTeacherScreen(),
    AppRoutes.teacherDashboard: (context) => TeacherDashboard(),
    AppRoutes.manageClass: (context) => ManageClass(),
    AppRoutes.manageAllClass: (context) => ManageAllClass(),
    AppRoutes.manageStudentScreen: (context) => ManageStudentScreen(),
    AppRoutes.studentDetailScreen: (context) => StudentDetailScreen(),
    AppRoutes.linkParentScreen: (context) => LinkParentScreen(),
    
    //student
    // AppRoutes.studentDashboard: (context) => StudentDashboard(),
    AppRoutes.profile: (context) => Profile(),
    AppRoutes.attendance: (context) => Attendance(),
    AppRoutes.homework: (context) => Homework(),
    AppRoutes.homepage: (context) => Homepage(),
    // AppRoutes.scedeul: (context) => Scedeul(),
    AppRoutes.result:(context) => Result(),
    AppRoutes.detail:(context)=> Deatilscreen(),
    AppRoutes.detailTeach:(context)=> DeatilTeacher(),
    AppRoutes.submitted:(context)=>SubmmitScreen(),
    //parent
    AppRoutes.parentDashboardScreen:(contex)=> ParentsDashboard()
  };
}
