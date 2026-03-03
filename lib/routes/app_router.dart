import 'package:flutter/material.dart';
import 'package:tamdansers_app/routes/app_routes.dart';
import 'package:tamdansers_app/screens/auth/login_screen.dart';
import 'package:tamdansers_app/screens/auth/otp_screen.dart';
import 'package:tamdansers_app/screens/auth/role_selection_screen.dart';
import 'package:tamdansers_app/screens/auth/sign_up_screen.dart';
import 'package:tamdansers_app/screens/auth/splash_screen.dart';
import 'package:tamdansers_app/screens/student/student_first_screen.dart';

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
      
      //------------ Teacher ----------------



      //------------ Student ----------------
      case AppRoutes.studentFirstScreen:
      final userId = settings.arguments as int;
      return _fadeRouter(
        StudentFirstScreen(userId: userId,)
      );



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