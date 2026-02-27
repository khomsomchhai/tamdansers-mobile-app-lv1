import 'package:flutter/material.dart';
import 'page_routes.dart';

class PageAnimations {

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {

    final page = PageRoutes.getPage(settings.name);

    if (page == null) {
      return MaterialPageRoute(
        builder: (_) => Scaffold(
          body: Center(
            child: Text('No route defined for ${settings.name}'),
          ),
        ),
      );
    }

    return ultraSmoothSlide(page);
  }

  // ================= ULTRA SMOOTH SLIDE =================

  static PageRouteBuilder ultraSmoothSlide(Widget page) {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 480),
      reverseTransitionDuration: const Duration(milliseconds: 380),
      pageBuilder: (_, animation, __) => page,
      transitionsBuilder: (_, animation, __, child) {

        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeInOutCubicEmphasized,
        );

        final slide = Tween<Offset>(
          begin: const Offset(1.0, 0.0),
          end: Offset.zero,
        ).animate(curved);

        final scale = Tween<double>(
          begin: 0.98,
          end: 1.0,
        ).animate(curved);

        final fade = Tween<double>(
          begin: 0.1,
          end: 1.0,
        ).animate(curved);

        return SlideTransition(
          position: slide,
          child: FadeTransition(
            opacity: fade,
            child: ScaleTransition(
              scale: scale,
              child: child,
            ),
          ),
        );
      },
    );
  }
}