import 'package:flutter/material.dart';
import 'package:tamdansers_app/routes/app_routes.dart';
import 'package:tamdansers_app/screens/auth/auth_option_teacher_screen.dart';
import 'package:tamdansers_app/screens/auth/login_teacher_screen.dart';
import 'package:tamdansers_app/screens/auth/role_selection_screen.dart';
import 'package:tamdansers_app/screens/auth/sign_up_teacher_screen.dart';
import 'package:tamdansers_app/screens/auth/splash_screen.dart';
import 'package:tamdansers_app/screens/parents/parent_connect_student.dart';
import 'package:tamdansers_app/screens/parents/parent_first_screen.dart';
import 'package:tamdansers_app/screens/parents/parent_login.dart';
import 'package:tamdansers_app/screens/student/join_class_screen.dart';
import 'package:tamdansers_app/screens/student/student_dashboard.dart';
import 'package:tamdansers_app/screens/student/student_first_screen.dart';
import 'package:tamdansers_app/screens/teacher/link_parent.dart';
import 'package:tamdansers_app/screens/teacher/manage_all_class.dart';
import 'package:tamdansers_app/screens/teacher/manage_class.dart';
import 'package:tamdansers_app/screens/teacher/manage_student_screen.dart';
import 'package:tamdansers_app/screens/teacher/score_detail_screen.dart';
import 'package:tamdansers_app/screens/teacher/student_detail_screen.dart';
import 'package:tamdansers_app/screens/teacher/teacher_dashboard.dart';

import '../screens/student/menu/deatil_teacher.dart';
import '../screens/student/menu/deatilscreen.dart';
import '../screens/student/menu/homework.dart';
import '../screens/student/menu/submmit_screen.dart';

class PageRoutes {
  static Map<String, Widget Function(BuildContext)> routes = {
    AppRoutes.splashScreen: (context) => SplashScreen(),
    AppRoutes.roleSelectionScreen: (context) => RoleSelectionScreen(),
    // Teacher routes
    AppRoutes.authOptionTeacherScreen: (context) => AuthOptionTeacherScreen(),
    AppRoutes.loginTeacherScreen: (context) => LoginTeacherScreen(),
    AppRoutes.signUpTeacherScreen: (context) => SignUpTeacherScreen(),
    AppRoutes.teacherDashboard: (context) => TeacherDashboard(),
    AppRoutes.manageClass: (context) => ManageClass(),
    AppRoutes.manageAllClass: (context) => ManageAllClass(),
    AppRoutes.manageStudentScreen: (context) => ManageStudentScreen(),
    AppRoutes.studentDetailScreen: (context) => StudentDetailScreen(),
    AppRoutes.linkParentScreen: (context) => LinkParentScreen(),
    AppRoutes.scoreDetailScreen: (context) => ScoreDetailScreen(),
    // Student routes
    AppRoutes.studentFirstScreen: (context) => StudentFirstScreen(),
    AppRoutes.joinClassSreen: (context) => JoinClassScreen(),
    AppRoutes.studentDashboard: (context) => StudentDashboard(),
    AppRoutes.submitted: (context) => SubmmitScreen(),
    AppRoutes.homework: (context) => Homework(),
    AppRoutes.detail: (context) => Deatilscreen(),
    AppRoutes.detailTeach: (context) => DeatilTeacher(),
    
    // Parent routes
    AppRoutes.parentFirstScreen: (context) => ParentFirstScreen(),
    AppRoutes.parentConnectStudent: (context) => ParentConnectStudent(),
    
    AppRoutes.parentDashboardScreen: (context) => ParentLogin(),
  };
}
