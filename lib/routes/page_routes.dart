import 'package:flutter/material.dart';
import 'package:tamdansers_app/routes/app_routes.dart';
import 'package:tamdansers_app/screens/auth/auth_option_teacher_screen.dart';
import 'package:tamdansers_app/screens/auth/splash_screen.dart';
import 'package:tamdansers_app/screens/parents/parent_connect_student.dart';
import 'package:tamdansers_app/screens/parents/parent_first_screen.dart';
import 'package:tamdansers_app/screens/parents/parent_login.dart';
import 'package:tamdansers_app/screens/student/join_class_screen.dart';
import 'package:tamdansers_app/screens/student/menu/change_pw.dart';
import 'package:tamdansers_app/screens/student/menu/homepage.dart';
import 'package:tamdansers_app/screens/student/menu/homework.dart';
import 'package:tamdansers_app/screens/student/menu/info_personal.dart';
import 'package:tamdansers_app/screens/student/menu/notification.dart';
import 'package:tamdansers_app/screens/student/result.dart';
import 'package:tamdansers_app/screens/student/scedeul.dart';
import 'package:tamdansers_app/screens/student/student_dashboard.dart';
import 'package:tamdansers_app/screens/student/student_first_screen.dart';
import 'package:tamdansers_app/screens/student/subjects.dart';
import 'package:tamdansers_app/screens/teacher/link_parent.dart';
import 'package:tamdansers_app/screens/teacher/manage_all_class.dart';
import 'package:tamdansers_app/screens/teacher/score_detail_screen.dart';
import 'package:tamdansers_app/screens/teacher/teacher_dashboard.dart';

import '../screens/student/menu/deatil_teacher.dart';
import '../screens/student/menu/deatilscreen.dart';
import '../screens/student/menu/submmit_screen.dart';

class PageRoutes {
  static Map<String, Widget Function(BuildContext)> routes = {
    AppRoutes.splashScreen: (context) => SplashScreen(),
    AppRoutes.authOptionTeacherScreen: (context) => AuthOptionTeacherScreen(),
    AppRoutes.teacherDashboard: (context) => TeacherDashboard(),
    AppRoutes.manageAllClass: (context) => ManageAllClass(),
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
    
    AppRoutes.homepage: (context) => Homepage(),
    AppRoutes.scedeul: (context) => Scedeul(),
    AppRoutes.result: (context) => Result(),
    AppRoutes.changePassword: (context) => ChangePw(),
    AppRoutes.info:(contex)=>InfoPersonal(),
    AppRoutes.subject: (context) => Subjects(),
    AppRoutes.notifications:(contex)=>Notifications(),
    // Parent routes
    AppRoutes.parentFirstScreen: (context) => ParentFirstScreen(),
    AppRoutes.parentConnectStudent: (context) => ParentConnectStudent(),
    
    AppRoutes.parentDashboardScreen: (context) => ParentLogin(),
  };
}
