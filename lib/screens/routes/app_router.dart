import 'package:flutter/material.dart';
import 'package:tamdansers_app/routes/app_routes.dart';
import 'package:tamdansers_app/screens/auth/login_screen.dart';
import 'package:tamdansers_app/screens/auth/otp_screen.dart';
import 'package:tamdansers_app/screens/auth/role_selection_screen.dart';
import 'package:tamdansers_app/screens/auth/sign_up_screen.dart';
import 'package:tamdansers_app/screens/auth/splash_screen.dart';
import 'package:tamdansers_app/screens/parents/menu/Monthy_result_Ranking.dart';
import 'package:tamdansers_app/screens/parents/parent_connect_student.dart';
import 'package:tamdansers_app/screens/parents/parent_first_screen.dart';
import 'package:tamdansers_app/screens/parents/parent_list_stu_class.dart';
import 'package:tamdansers_app/screens/parents/parents_dashboard.dart';
import 'package:tamdansers_app/screens/student/menu/attendance.dart';
import 'package:tamdansers_app/screens/student/menu/homepage.dart';
import 'package:tamdansers_app/screens/student/menu/homework.dart';
import 'package:tamdansers_app/screens/student/menu/info_personal.dart';
import 'package:tamdansers_app/screens/student/menu/notification.dart';
import 'package:tamdansers_app/screens/student/menu/profile.dart';
import 'package:tamdansers_app/screens/student/result.dart';
import 'package:tamdansers_app/screens/student/scedeul.dart';
import 'package:tamdansers_app/screens/student/student_dashboard.dart';
import 'package:tamdansers_app/screens/student/student_first_screen.dart';
import 'package:tamdansers_app/screens/student/subjects.dart';
import 'package:tamdansers_app/screens/teacher/add_student.dart';
import 'package:tamdansers_app/screens/teacher/add_task.dart';
import 'package:tamdansers_app/screens/teacher/attendance_screen.dart';
import 'package:tamdansers_app/screens/teacher/homework_detail_screen.dart';
import 'package:tamdansers_app/screens/teacher/homework_screen.dart';
import 'package:tamdansers_app/screens/teacher/link_parent.dart';
import 'package:tamdansers_app/screens/teacher/manage_all_class.dart';
import 'package:tamdansers_app/screens/teacher/manage_class.dart';
import 'package:tamdansers_app/screens/teacher/manage_student_screen.dart';
import 'package:tamdansers_app/screens/teacher/score_detail_screen.dart';
import 'package:tamdansers_app/screens/teacher/student_detail_screen.dart';
import 'package:tamdansers_app/screens/teacher/student_submission_screen.dart';
import 'package:tamdansers_app/screens/teacher/teacher_main_screen.dart';

class AppRouter {
  static Route generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splashScreen:
        return _fadeRouter(SplashScreen(), settings);

      //------------ Auth ----------------
      case AppRoutes.roleSelectionScreen:
        return _fadeRouter(RoleSelectionScreen(), settings);
      case AppRoutes.loginScreen:
        final role = settings.arguments as String?;
        return _slideRoute(
          LoginScreen(role: role ?? "student"),
          settings,
        );
      case AppRoutes.signUpScreen:
        final role = settings.arguments as String?;
        return _slideRoute(SignUpScreen(role: role ?? "student"), settings);
      case AppRoutes.otpScreen:
        final role = settings.arguments as String?;
        return _slideRoute(OtpScreen(role: role ?? "student"), settings);

      //------------ Teacher ----------------
      case AppRoutes.teacherDashboard:
        return _fadeRouter(const TeacherMainScreen(), settings);

      case AppRoutes.manageAllClass:
        return _slideRoute(const ManageAllClass(), settings);

      case AppRoutes.manageClass:
        return _slideRoute(const ManageClass(), settings);

      case AppRoutes.manageStudentScreen:
        final classId = settings.arguments as int? ?? 0;
        return _slideRoute(ManageStudentScreen(classId: classId), settings);

      case AppRoutes.studentDetailScreen:
        return _slideRoute(const StudentDetailScreen(), settings);

      case AppRoutes.linkParentScreen:
        return _slideRoute(const LinkParentScreen(), settings);

      case AppRoutes.scoreDetailScreen:
        return _slideRoute(const ScoreDetailScreen(), settings);

      case AppRoutes.teacherAttendanceScreen:
        final classId = settings.arguments as int?;
        return _slideRoute(AttendanceScreen(classId: classId), settings);

      case AppRoutes.teacherHomeworkScreen:
        return _slideRoute(const HomeworkScreen(), settings);

      case AppRoutes.homeworkDetailScreen:
        return _slideRoute(const HomeworkDetailScreen(), settings);

      case AppRoutes.addTaskScreen:
        return _slideRoute(const AddTask(), settings);

      case AppRoutes.addStudentScreen:
        return _slideRoute(const AddStudent(), settings);

      case AppRoutes.studentSubmissionScreen:
        return _slideRoute(const StudentSubmissionScreen(), settings);

      //------------ Student ----------------
      case AppRoutes.studentFirstScreen:
        final userId = settings.arguments as int;
        return _fadeRouter(StudentFirstScreen(userId: userId), settings);
      case AppRoutes.studentDashboard:
        return _fadeRouter(StudentDashboard(), settings);
      case AppRoutes.homepage:
        return _fadeRouter(Homepage(), settings);

      case AppRoutes.scedeul:
        return _fadeRouter(Scedeul(), settings);

      case AppRoutes.profile:
        return _fadeRouter(Profile(), settings);
      case AppRoutes.attendance:
        return _fadeRouter(Attendance(), settings);
      case AppRoutes.homework:
        return _fadeRouter(Homework(), settings);

      case AppRoutes.notifications:
        return _fadeRouter(Notifications(), settings);
      case AppRoutes.result:
        return _fadeRouter(Result(), settings);
      case AppRoutes.info:
        return _fadeRouter(InfoPersonal(), settings);
      case AppRoutes.subject:
        return _fadeRouter(Subjects(), settings);
      //------------ Parent -----------------
      case AppRoutes.parentDashboardScreen:
        return _fadeRouter(const ParentsDashboard(), settings);

      case AppRoutes.parentFirstScreen:
        return _slideRoute(const ParentFirstScreen(), settings);

      case AppRoutes.parentConnectStudent:
        return _slideRoute(const ParentConnectStudent(), settings);

      case AppRoutes.parentListStuClass:
        return _slideRoute(const ParentListStuClass(), settings);

      case AppRoutes.monthly:
        return _slideRoute(const CustomScreen(), settings);

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text("Route not found")),
          ),
        );
    }
  }

  //slide from right
  static PageRouteBuilder _slideRoute(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
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
  static PageRouteBuilder _fadeRouter(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
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
