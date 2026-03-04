import 'package:flutter/material.dart';
import 'package:tamdansers_app/routes/app_routes.dart';
import 'package:tamdansers_app/screens/auth/login_screen.dart';
import 'package:tamdansers_app/screens/auth/otp_screen.dart';
import 'package:tamdansers_app/screens/auth/role_selection_screen.dart';
import 'package:tamdansers_app/screens/auth/sign_up_screen.dart';
import 'package:tamdansers_app/screens/auth/splash_screen.dart';
import 'package:tamdansers_app/screens/student/join_class_screen.dart';
import 'package:tamdansers_app/screens/student/menu/attendance.dart';
import 'package:tamdansers_app/screens/student/menu/change_pw.dart';
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
import 'package:tamdansers_app/screens/teacher/student_detail_screen.dart';

class AppRouter {
  static Route generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splashScreen:
        return _fadeRouter(SplashScreen());

      //------------ Auth ----------------
      case AppRoutes.roleSelectionScreen:
        return _fadeRouter(RoleSelectionScreen());
      case AppRoutes.loginScreen:
        final role = settings.arguments as String?;
        return _slideRoute(
          LoginScreen(role: role ?? "student"),
        );
      case AppRoutes.signUpScreen:
        final role = settings.arguments as String?;
        return _slideRoute(SignUpScreen(role: role ?? "student"));
      case AppRoutes.otpScreen:
        final role = settings.arguments as String?;
        return _slideRoute(OtpScreen(role: role ?? "student"));

      //------------ Teacher ----------------

      //------------ Student ----------------
      case AppRoutes.studentFirstScreen:
        final userId = settings.arguments as int;
        return _fadeRouter(StudentFirstScreen(
          userId: userId,
        ));
      case AppRoutes.studentDashboard:
        return _fadeRouter(StudentDashboard());
      case AppRoutes.homepage:
        return _fadeRouter(Homepage());

      case AppRoutes.scedeul:
        return _fadeRouter(Scedeul());

      case AppRoutes.profile:
        return _fadeRouter(Profile());
      case AppRoutes.attendance:
        return _fadeRouter(Attendance());
      case AppRoutes.homework:
        return _fadeRouter(Homework());

      case AppRoutes.notifications:
        return _fadeRouter(Notifications());
      case AppRoutes.result:
        return _fadeRouter(Result());
      case AppRoutes.info:
        return _fadeRouter(InfoPersonal());
      case AppRoutes.subject:
        return _fadeRouter(Subjects());
      case AppRoutes.changePassword:
        return _fadeRouter(ChangePw());
      case AppRoutes.detailTeach:
        return _fadeRouter(DeatilTeacher());
      case AppRoutes.submitted:
        return _fadeRouter(SubmmitScreen());
      case AppRoutes.joinClassSreen:
        return _fadeRouter(JoinClassScreen());
      case AppRoutes.studentDetailScreen:
        return _fadeRouter(StudentDetailScreen());
      case AppRoutes.detail:
        return _fadeRouter(Deatilscreen());
      
      // case AppRoutes.studentFirstScreen:
      //   final userId = settings.arguments as int;
      //   return _fadeRouter(StudentFirstScreen(
      //     userId: userId,
      //   ));
      //------------ Parent -----------------

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
  static PageRouteBuilder _fadeRouter(Widget page) {
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
