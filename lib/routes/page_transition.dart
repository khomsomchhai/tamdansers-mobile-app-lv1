import 'dart:ui';

import 'package:flutter/material.dart';

class PageTransition {
  static const Duration _fast = Duration(milliseconds: 220);
  static const Duration _normal = Duration(milliseconds: 320);
  static const Duration _slow = Duration(milliseconds: 420);

  static Offset detectPosition(Offset globalPosition, BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Offset(
      globalPosition.dx / size.width,
      globalPosition.dy / size.height,
    );
  }

  static Route<T> build<T>({
    required Widget page,
    RouteSettings? settings,
    PageTransitionType transition = PageTransitionType.iosPushParallax,
    bool fullscreenDialog = false,
    bool maintainState = true,
    Offset? circleRevealCenter,
    Duration? duration,
    Duration? reverseDuration,
  }) {
    switch (transition) {
      case PageTransitionType.none:
        return _noAnim<T>(page, settings ?? const RouteSettings());

      case PageTransitionType.fade:
        return _fade<T>(
          page,
          settings ?? const RouteSettings(),
          duration: duration,
          reverseDuration: reverseDuration,
        );

      case PageTransitionType.fadeThrough:
        return _fadeThrough<T>(
          page,
          settings ?? const RouteSettings(),
          duration: duration,
          reverseDuration: reverseDuration,
        );

      case PageTransitionType.sharedAxisX:
        return _sharedAxisX<T>(
          page,
          settings ?? const RouteSettings(),
          duration: duration,
          reverseDuration: reverseDuration,
        );

      case PageTransitionType.sharedAxisY:
        return _sharedAxisY<T>(
          page,
          settings ?? const RouteSettings(),
          duration: duration,
          reverseDuration: reverseDuration,
        );

      case PageTransitionType.iosPush:
        return _iosPush<T>(
          page,
          settings ?? const RouteSettings(),
          duration: duration,
          reverseDuration: reverseDuration,
        );

      case PageTransitionType.iosPushParallax:
        return _iosPushParallax<T>(
          page,
          settings ?? const RouteSettings(),
          duration: duration,
          reverseDuration: reverseDuration,
        );

      case PageTransitionType.scaleFade:
        return _scaleFade<T>(
          page,
          settings ?? const RouteSettings(),
          duration: duration,
          reverseDuration: reverseDuration,
        );

      case PageTransitionType.slideUpFade:
        return _slideUpFade<T>(
          page,
          settings ?? const RouteSettings(),
          duration: duration,
          reverseDuration: reverseDuration,
        );

      case PageTransitionType.bottomSheet:
        return _bottomSheet<T>(
          page,
          settings ?? const RouteSettings(),
          maintainState: maintainState,
          duration: duration,
          reverseDuration: reverseDuration,
        );

      case PageTransitionType.dialogBlur:
        return _dialogBlur<T>(
          page,
          settings ?? const RouteSettings(),
          maintainState: maintainState,
          duration: duration,
          reverseDuration: reverseDuration,
        );

      case PageTransitionType.circleReveal:
        return _circleReveal<T>(
          page,
          settings ?? const RouteSettings(),
          center: circleRevealCenter,
          duration: duration,
          reverseDuration: reverseDuration,
        );
    }
  }

  static PageRouteBuilder<T> _route<T>(
    Widget page,
    RouteSettings settings, {
    Duration duration = _normal,
    Duration? reverseDuration,
    bool opaque = true,
    Color? barrierColor,
    String? barrierLabel,
    bool barrierDismissible = false,
    bool maintainState = true,
    bool fullscreenDialog = false,
    required Widget Function(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child,
    ) transitionsBuilder,
  }) {
    return PageRouteBuilder<T>(
      settings: settings,
      transitionDuration: duration,
      reverseTransitionDuration: reverseDuration ?? duration,
      opaque: opaque,
      barrierColor: barrierColor,
      barrierLabel: barrierLabel,
      barrierDismissible: barrierDismissible,
      maintainState: maintainState,
      fullscreenDialog: fullscreenDialog,
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: transitionsBuilder,
    );
  }

  static PageRouteBuilder<T> _noAnim<T>(Widget page, RouteSettings settings) {
    return _route<T>(
      page,
      settings,
      duration: Duration.zero,
      reverseDuration: Duration.zero,
      transitionsBuilder: (_, __, ___, child) => child,
    );
  }

  static PageRouteBuilder<T> _fade<T>(
    Widget page,
    RouteSettings settings, {
    Duration? duration,
    Duration? reverseDuration,
  }) {
    return _route<T>(
      page,
      settings,
      duration: duration ?? _fast,
      reverseDuration: reverseDuration,
      transitionsBuilder: (_, animation, __, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOut,
        );
        return FadeTransition(opacity: curved, child: child);
      },
    );
  }

  static PageRouteBuilder<T> _fadeThrough<T>(
    Widget page,
    RouteSettings settings, {
    Duration? duration,
    Duration? reverseDuration,
  }) {
    return _route<T>(
      page,
      settings,
      duration: duration ?? _normal,
      reverseDuration: reverseDuration,
      transitionsBuilder: (_, animation, __, child) {
        final fadeIn = CurvedAnimation(
          parent: animation,
          curve: const Interval(0.25, 1.0, curve: Curves.easeOut),
        );
        final scale = CurvedAnimation(
          parent: animation,
          curve: const Cubic(0.2, 0.0, 0.0, 1.0),
        );
        return FadeTransition(
          opacity: fadeIn,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.96, end: 1.0).animate(scale),
            child: child,
          ),
        );
      },
    );
  }

  static PageRouteBuilder<T> _sharedAxisX<T>(
    Widget page,
    RouteSettings settings, {
    Duration? duration,
    Duration? reverseDuration,
  }) {
    return _route<T>(
      page,
      settings,
      duration: duration ?? _normal,
      reverseDuration: reverseDuration,
      transitionsBuilder: (_, animation, secondary, child) {
        final inCurve = CurvedAnimation(
          parent: animation,
          curve: const Cubic(0.2, 0.0, 0.0, 1.0),
        );
        final outCurve = CurvedAnimation(
          parent: secondary,
          curve: const Cubic(0.2, 0.0, 0.0, 1.0),
        );
        return Stack(
          children: [
            SlideTransition(
              position: Tween<Offset>(
                begin: Offset.zero,
                end: const Offset(-0.08, 0),
              ).animate(outCurve),
              child: FadeTransition(
                opacity: Tween<double>(begin: 1, end: 0).animate(
                  CurvedAnimation(parent: secondary, curve: Curves.easeOut),
                ),
                child: const SizedBox.shrink(),
              ),
            ),
            SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.10, 0),
                end: Offset.zero,
              ).animate(inCurve),
              child: FadeTransition(
                opacity: CurvedAnimation(
                  parent: animation,
                  curve: const Interval(0.1, 1.0),
                ),
                child: child,
              ),
            ),
          ],
        );
      },
    );
  }

  static PageRouteBuilder<T> _sharedAxisY<T>(
    Widget page,
    RouteSettings settings, {
    Duration? duration,
    Duration? reverseDuration,
  }) {
    return _route<T>(
      page,
      settings,
      duration: duration ?? _normal,
      reverseDuration: reverseDuration,
      transitionsBuilder: (_, animation, __, child) {
        final curve = CurvedAnimation(
          parent: animation,
          curve: const Cubic(0.2, 0.0, 0.0, 1.0),
        );
        return FadeTransition(
          opacity: CurvedAnimation(
            parent: animation,
            curve: const Interval(0.05, 1.0),
          ),
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.06),
              end: Offset.zero,
            ).animate(curve),
            child: child,
          ),
        );
      },
    );
  }

  static PageRouteBuilder<T> _iosPush<T>(
    Widget page,
    RouteSettings settings, {
    Duration? duration,
    Duration? reverseDuration,
  }) {
    return _route<T>(
      page,
      settings,
      duration: duration ?? const Duration(milliseconds: 380),
      reverseDuration: reverseDuration,
      transitionsBuilder: (_, animation, __, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        );
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(curved),
          child: child,
        );
      },
    );
  }

  static PageRouteBuilder<T> _iosPushParallax<T>(
    Widget page,
    RouteSettings settings, {
    Duration? duration,
    Duration? reverseDuration,
  }) {
    return _route<T>(
      page,
      settings,
      duration: duration ?? const Duration(milliseconds: 420),
      reverseDuration: reverseDuration,
      transitionsBuilder: (_, animation, secondary, child) {
        final inCurve = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        );
        final outCurve = CurvedAnimation(
          parent: secondary,
          curve: Curves.easeOutCubic,
        );
        final incoming = SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0),
            end: Offset.zero,
          ).animate(inCurve),
          child: child,
        );
        final previousParallax = SlideTransition(
          position: Tween<Offset>(
            begin: Offset.zero,
            end: const Offset(-0.12, 0),
          ).animate(outCurve),
          child: const SizedBox.shrink(),
        );
        return Stack(children: [previousParallax, incoming]);
      },
    );
  }

  static PageRouteBuilder<T> _scaleFade<T>(
    Widget page,
    RouteSettings settings, {
    Duration? duration,
    Duration? reverseDuration,
  }) {
    return _route<T>(
      page,
      settings,
      duration: duration ?? _normal,
      reverseDuration: reverseDuration,
      transitionsBuilder: (_, animation, __, child) {
        final curve = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        );
        return FadeTransition(
          opacity: curve,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.98, end: 1.0).animate(curve),
            child: child,
          ),
        );
      },
    );
  }

  static PageRouteBuilder<T> _slideUpFade<T>(
    Widget page,
    RouteSettings settings, {
    Duration? duration,
    Duration? reverseDuration,
  }) {
    return _route<T>(
      page,
      settings,
      duration: duration ?? _normal,
      reverseDuration: reverseDuration,
      transitionsBuilder: (_, animation, __, child) {
        final curve = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        );
        return FadeTransition(
          opacity: CurvedAnimation(
            parent: animation,
            curve: const Interval(0.05, 1.0),
          ),
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.08),
              end: Offset.zero,
            ).animate(curve),
            child: child,
          ),
        );
      },
    );
  }

  static PageRouteBuilder<T> _bottomSheet<T>(
    Widget page,
    RouteSettings settings, {
    bool maintainState = true,
    Duration? duration,
    Duration? reverseDuration,
  }) {
    return _route<T>(
      page,
      settings,
      duration: duration ?? _slow,
      reverseDuration: reverseDuration ?? _normal,
      opaque: false,
      maintainState: maintainState,
      barrierColor: Colors.black54,
      barrierDismissible: true,
      barrierLabel: 'Dismiss',
      transitionsBuilder: (_, animation, __, child) {
        final curve = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        );
        return Stack(
          children: [
            FadeTransition(
              opacity: curve,
              child: Container(color: Colors.black54),
            ),
            SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 1),
                end: Offset.zero,
              ).animate(curve),
              child: child,
            ),
          ],
        );
      },
    );
  }

  static PageRouteBuilder<T> _dialogBlur<T>(
    Widget page,
    RouteSettings settings, {
    bool maintainState = true,
    Duration? duration,
    Duration? reverseDuration,
  }) {
    return _route<T>(
      page,
      settings,
      duration: duration ?? _normal,
      reverseDuration: reverseDuration ?? _fast,
      opaque: false,
      maintainState: maintainState,
      barrierColor: Colors.black45,
      barrierDismissible: true,
      barrierLabel: 'Dismiss',
      transitionsBuilder: (_, animation, __, child) {
        final curve = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        );
        return Stack(
          children: [
            FadeTransition(
              opacity: curve,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(color: Colors.black26),
              ),
            ),
            FadeTransition(
              opacity: curve,
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.98, end: 1.0).animate(curve),
                child: child,
              ),
            ),
          ],
        );
      },
    );
  }

  static PageRouteBuilder<T> _circleReveal<T>(
    Widget page,
    RouteSettings settings, {
    Offset? center,
    Duration? duration,
    Duration? reverseDuration,
  }) {
    return _route<T>(
      page,
      settings,
      duration: duration ?? const Duration(milliseconds: 450),
      reverseDuration: reverseDuration ?? _normal,
      transitionsBuilder: (context, animation, __, child) {
        final curve = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        );
        final revealCenter = center ?? const Offset(0.5, 0.5);
        return AnimatedBuilder(
          animation: curve,
          builder: (context, child) {
            return ClipPath(
              clipper: CircleRevealClipper(
                fraction: curve.value,
                center: revealCenter,
              ),
              child: child,
            );
          },
          child: child,
        );
      },
    );
  }
}

class CircleRevealClipper extends CustomClipper<Path> {
  final double fraction;
  final Offset center;

  CircleRevealClipper({required this.fraction, required this.center});

  @override
  Path getClip(Size size) {
    final path = Path();
    final centerX = center.dx * size.width;
    final centerY = center.dy * size.height;
    final maxRadius = _calculateMaxRadius(size, Offset(centerX, centerY));
    final radius = maxRadius * fraction;
    path.addOval(
      Rect.fromCircle(center: Offset(centerX, centerY), radius: radius),
    );
    return path;
  }

  double _calculateMaxRadius(Size size, Offset center) {
    final topLeft = (center - Offset.zero).distance;
    final topRight = (center - Offset(size.width, 0)).distance;
    final bottomLeft = (center - Offset(0, size.height)).distance;
    final bottomRight = (center - Offset(size.width, size.height)).distance;
    return [topLeft, topRight, bottomLeft, bottomRight]
        .reduce((a, b) => a > b ? a : b);
  }

  @override
  bool shouldReclip(CircleRevealClipper oldClipper) {
    return oldClipper.fraction != fraction || oldClipper.center != center;
  }
}

enum PageTransitionType {
  none,
  fade,
  fadeThrough,
  sharedAxisX,
  sharedAxisY,
  iosPush,
  iosPushParallax,
  scaleFade,
  slideUpFade,
  bottomSheet,
  dialogBlur,
  circleReveal,
}
