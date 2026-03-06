import 'package:flutter/material.dart';
import 'package:tamdansers_app/routes/app_routes.dart';
import 'package:tamdansers_app/screens/auth/change_password.dart';
import 'package:tamdansers_app/screens/auth/login_screen.dart';
import 'package:tamdansers_app/screens/auth/otp_screen.dart';
import 'package:tamdansers_app/screens/auth/role_selection_screen.dart';
import 'package:tamdansers_app/screens/auth/sign_up_screen.dart';
import 'package:tamdansers_app/screens/auth/splash_screen.dart';
import 'package:tamdansers_app/screens/parents/parent_connect_student.dart';
import 'package:tamdansers_app/screens/parents/parent_first_screen.dart';
import 'package:tamdansers_app/screens/parents/parents_dashboard.dart';
import 'package:tamdansers_app/screens/student/join_class_screen.dart';
import 'package:tamdansers_app/screens/student/menu/deatil_teacher.dart';
import 'package:tamdansers_app/screens/student/menu/deatilscreen.dart';
import 'package:tamdansers_app/screens/student/menu/homepage.dart';
import 'package:tamdansers_app/screens/student/menu/homework.dart';
import 'package:tamdansers_app/screens/student/menu/info_personal.dart';
import 'package:tamdansers_app/screens/student/menu/notification.dart';
import 'package:tamdansers_app/screens/student/menu/profile.dart';
import 'package:tamdansers_app/screens/student/menu/submmit_screen.dart';
import 'package:tamdansers_app/screens/student/result.dart';
import 'package:tamdansers_app/screens/student/scedeul.dart';
import 'package:tamdansers_app/screens/student/student_dashboard.dart';
import 'package:tamdansers_app/screens/student/student_first_screen.dart';
import 'package:tamdansers_app/screens/student/subjects.dart';
import 'package:tamdansers_app/screens/teacher/add_student.dart';
import 'package:tamdansers_app/screens/teacher/add_task.dart';
import 'package:tamdansers_app/screens/teacher/attendance_screen.dart';
import 'package:tamdansers_app/screens/teacher/grade_result.dart';
import 'package:tamdansers_app/screens/teacher/homework_screen.dart';
import 'package:tamdansers_app/screens/teacher/link_parent.dart';
import 'package:tamdansers_app/screens/teacher/manage_all_class.dart';
import 'package:tamdansers_app/screens/teacher/manage_class.dart';
import 'package:tamdansers_app/screens/teacher/manage_student_screen.dart';
import 'package:tamdansers_app/screens/teacher/score_detail_screen.dart';
import 'package:tamdansers_app/screens/teacher/student_detail_screen.dart';
import 'package:tamdansers_app/screens/teacher/teacher_dashboard.dart';
import 'package:tamdansers_app/screens/teacher/teacher_main_screen.dart';
import 'package:tamdansers_app/screens/teacher/teacher_notification_screen.dart';
import 'package:tamdansers_app/screens/teacher/teacher_profile_screen.dart';

class AppRouter {
  static Route generateRoute(RouteSettings settings) {
    switch (settings.name) {

      case AppRoutes.splashScreen:
      return _fadeRouter(
        SplashScreen()
      );

      //------------ Auth ----------------
      case AppRoutes.roleSelectionScreen:
      return _fadeRouter(
        RoleSelectionScreen()
      );
      case AppRoutes.loginScreen:
      final role = settings.arguments as String?;
      return _slideRoute(
        LoginScreen(role: role ?? "student"),
      );
      case AppRoutes.signUpScreen:
      final role = settings.arguments as String?;
      return _slideRoute(
        SignUpScreen(role: role ?? "student")
      );
      case AppRoutes.otpScreen:
      final role = settings.arguments as String?;
      return _slideRoute(
        OtpScreen(role: role ?? "student")
      );
      case AppRoutes.changePassword:
      return _slideRoute(
        ChangePassword()
      );
      //------------ Teacher ----------------
      case AppRoutes.teacherDashboard:
      return _fadeRouter(
        TeacherDashboard()
      );
      case AppRoutes.manageAllClass:
      return _slideRoute(
        ManageAllClass()
      );
      case AppRoutes.manageClass:
      return _slideRoute(
        ManageClass()
      );
      case AppRoutes.linkParentScreen:
      return _slideRoute(
        LinkParentScreen()
      );
      case AppRoutes.studentDetailScreen:
      return _slideRoute(
        StudentDetailScreen()
      );
      case AppRoutes.scoreDetailScreen:
      return _slideRoute(
        ScoreDetailScreen()
      );
      case AppRoutes.manageStudentScreen:
      final classId = settings.arguments as int?;
      return _slideRoute(
        ManageStudentScreen(classId: classId ?? 1)
      );
      case AppRoutes.teacherAttendanceScreen:
      return _slideRoute(
        AttendanceScreen()
      );
      case AppRoutes.teacherHomeworkScreen:
      return _slideRoute(
        HomeworkScreen()
      );
      case AppRoutes.addTaskScreen:
      return _slideRoute(
        AddTask()
      );
      case AppRoutes.addStudentScreen:
      return _slideRoute(
        AddStudent()
      );
      case AppRoutes.teacherProfile:
      return _fadeRouter(
        TeacherProfileScreen()
      );
      case AppRoutes.teacherMainScreen:
      final userId = settings.arguments as int?;
      return _fadeRouter(
        TeacherMainScreen(userId: userId ?? 1)
      );
      case AppRoutes.teacherGradeResult:
      return _slideRoute(
        GradeResult()
      );
      case AppRoutes.teacherNotificationScreen:
      return _slideRoute(
        TeacherNotificationScreen()
      );
      
      

      //------------ Student ----------------
      case AppRoutes.studentFirstScreen:
      final userId = settings.arguments as int;
      return _fadeRouter(
        StudentFirstScreen(userId: userId,)
      );
      case AppRoutes.joinClassSreen:
      final userId = settings.arguments as int;
      return _slideRoute(
        JoinClassScreen(userId: userId,)
      );
      case AppRoutes.studentDashboard:
      return _slideRoute(
        StudentDashboard()
      );
      case AppRoutes.submitted:
      return _slideRoute(
        SubmmitScreen()
      );
      case AppRoutes.homework:
      return _slideRoute(
        Homework()
      );
      case AppRoutes.profile:
      return _slideRoute(
        Profile()
      );
      case AppRoutes.detail:
      return _slideRoute(
        Deatilscreen()
      );
      case AppRoutes.detailTeach:
      return _slideRoute(
        DeatilTeacher()
      );
      case AppRoutes.homepage:
      return _slideRoute(
        Homepage()
      );
      case AppRoutes.scedeul:
      return _slideRoute(
        Scedeul()
      );
      case AppRoutes.result:
      return _slideRoute(
        Result()
      );
      case AppRoutes.info:
      return _slideRoute(
        InfoPersonal()
      );
      case AppRoutes.subject:
      return _slideRoute(
        Subjects()
      );
      case AppRoutes.notifications:
      return _slideRoute(
        Notifications()
      );

      //------------ Parent -----------------
      case AppRoutes.parentFirstScreen:
      return _fadeRouter(
        ParentFirstScreen()
      );
      case AppRoutes.parentConnectStudent:
      return _slideRoute(
        ParentConnectStudent()
      );
      case AppRoutes.parentDashboardScreen:
      return _slideRoute(
        ParentsDashboard()
      );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text("Route not found")),
          ),
        );
    }
  }


  //slide from right
  static PageRouteBuilder _slideRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: const Duration(milliseconds: 350),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {

        final tween = Tween(
          begin: const Offset(1, 0),
          end: Offset.zero,
        ).chain(CurveTween(curve: Curves.easeInOut));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  //fade
  static PageRouteBuilder _fadeRouter(Widget page){
    return PageRouteBuilder(
      transitionDuration: Duration(milliseconds: 400),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }
}