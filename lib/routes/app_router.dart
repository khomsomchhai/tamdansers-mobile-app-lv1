import 'package:flutter/material.dart';
import 'package:tamdansers_app/routes/app_routes.dart';
import 'package:tamdansers_app/routes/page_transition.dart';
import 'package:tamdansers_app/screens/auth/change_password.dart';
import 'package:tamdansers_app/screens/auth/forget_password1.dart';
import 'package:tamdansers_app/screens/auth/login_screen.dart';
import 'package:tamdansers_app/screens/auth/otp_screen.dart';
import 'package:tamdansers_app/screens/auth/reset_password_screen.dart';
import 'package:tamdansers_app/screens/auth/role_selection_screen.dart';
import 'package:tamdansers_app/screens/auth/sign_up_screen.dart';
import 'package:tamdansers_app/screens/auth/splash_screen.dart';
import 'package:tamdansers_app/screens/parents/menu/Comment_signature .dart';
import 'package:tamdansers_app/screens/parents/menu/Monthy_result_Ranking.dart';
import 'package:tamdansers_app/screens/parents/menu/attandance_child.dart';
import 'package:tamdansers_app/screens/parents/menu/homework_quize_child.dart';
import 'package:tamdansers_app/screens/parents/menu/news.dart';
import 'package:tamdansers_app/screens/parents/menu/nothication.dart';
import 'package:tamdansers_app/screens/parents/menu/parents_dashboard.dart';
import 'package:tamdansers_app/screens/parents/menu/setting.dart';
import 'package:tamdansers_app/screens/parents/parent_connect_student.dart';
import 'package:tamdansers_app/screens/parents/parent_first_screen.dart';
import 'package:tamdansers_app/screens/parents/parent_list_stu_class.dart';
import 'package:tamdansers_app/screens/parents/parent_pending_requests.dart';
import 'package:tamdansers_app/screens/student/join_class_screen.dart';
import 'package:tamdansers_app/screens/student/menu/connection_requests.dart';
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
import 'package:tamdansers_app/screens/teacher/menu/add_student.dart';
import 'package:tamdansers_app/screens/teacher/menu/add_task.dart';
import 'package:tamdansers_app/screens/teacher/menu/attendance_screen.dart';
import 'package:tamdansers_app/screens/teacher/menu/grade_result.dart';
import 'package:tamdansers_app/screens/teacher/menu/homework_detail_screen.dart';
import 'package:tamdansers_app/screens/teacher/menu/homework_screen.dart';
import 'package:tamdansers_app/screens/teacher/menu/link_parent.dart';
import 'package:tamdansers_app/screens/teacher/menu/manage_all_class.dart';
import 'package:tamdansers_app/screens/teacher/menu/manage_class.dart';
import 'package:tamdansers_app/screens/teacher/menu/manage_student_screen.dart';
import 'package:tamdansers_app/screens/teacher/menu/score_detail_screen.dart';
import 'package:tamdansers_app/screens/teacher/menu/student_detail_screen.dart';
import 'package:tamdansers_app/screens/teacher/menu/student_submission_screen.dart';
import 'package:tamdansers_app/screens/teacher/menu/teacher_dashboard.dart';
import 'package:tamdansers_app/screens/teacher/menu/teacher_notification_screen.dart';
import 'package:tamdansers_app/screens/teacher/menu/teacher_profile_screen.dart';
import 'package:tamdansers_app/screens/teacher/teacher_main_screen.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splashScreen:
        return PageTransition.build(
          page: SplashScreen(),
          settings: settings,
          transition: PageTransitionType.fadeThrough,
        );

      //------------ Auth ----------------
      case AppRoutes.roleSelectionScreen:
        return PageTransition.build(
          page: RoleSelectionScreen(),
          settings: settings,
          transition: PageTransitionType.fadeThrough,
        );
      case AppRoutes.loginScreen:
        final role = settings.arguments as String?;
        return PageTransition.build(
          page: LoginScreen(role: role ?? "student"),
          settings: settings,
          transition: PageTransitionType.iosPush,
        );
      case AppRoutes.signUpScreen:
        final role = settings.arguments as String?;
        return PageTransition.build(
          page: SignUpScreen(role: role ?? "student"),
          settings: settings,
          transition: PageTransitionType.iosPush,
        );
      case AppRoutes.otpScreen:
        String role = "student";
        int? userId;
        if (settings.arguments is Map) {
          final args = settings.arguments as Map;
          role = args['role'] ?? "student";
          userId = args['userId'];
        } else if (settings.arguments is String) {
          role = settings.arguments as String;
        }
        return PageTransition.build(
          page: OtpScreen(role: role, userId: userId),
          settings: settings,
          transition: PageTransitionType.iosPush,
        );
      case AppRoutes.changePassword:
        return PageTransition.build(
          page: ChangePassword(),
          settings: settings,
          transition: PageTransitionType.iosPush,
        );
      case AppRoutes.resetPassword:
        final userId = settings.arguments as int?;
        return PageTransition.build(
          page: ResetPasswordScreen(userId: userId ?? 1),
          settings: settings,
          transition: PageTransitionType.iosPush,
        );
      case AppRoutes.forgetPassword1:
        return PageTransition.build(
          page: ForgetPassword1(),
          settings: settings,
          transition: PageTransitionType.iosPush,
        );

      //------------ Teacher ----------------
      case AppRoutes.teacherDashboard:
        final teacherId = settings.arguments as int?;
        return PageTransition.build(
          page: TeacherDashboard(teacherId: teacherId ?? 1),
          settings: settings,
          transition: PageTransitionType.fadeThrough,
        );
      case AppRoutes.manageAllClass:
        final teacherId = settings.arguments as int?;
        return PageTransition.build(
          page: ManageAllClass(teacherId: teacherId ?? 1),
          settings: settings,
          transition: PageTransitionType.iosPush,
        );
      case AppRoutes.manageClass:
        return PageTransition.build(
          page: ManageClass(),
          settings: settings,
          transition: PageTransitionType.iosPush,
        );
      case AppRoutes.linkParentScreen:
        return PageTransition.build(
          page: LinkParentScreen(),
          settings: settings,
          transition: PageTransitionType.iosPush,
        );
      case AppRoutes.studentDetailScreen:
        final studentId = settings.arguments as int;
        return PageTransition.build(
          page: StudentDetailScreen(studentId: studentId),
          settings: settings,
          transition: PageTransitionType.iosPush,
        );
      case AppRoutes.scoreDetailScreen:
        final scoreArgs = settings.arguments as Map<String, int>;
        return PageTransition.build(
          page: ScoreDetailScreen(
              studentId: scoreArgs['studentId']!,
              classId: scoreArgs['classId']!),
          settings: settings,
          transition: PageTransitionType.iosPush,
        );
      case AppRoutes.manageStudentScreen:
        final classId = settings.arguments as int?;
        return PageTransition.build(
          page: ManageStudentScreen(classId: classId ?? 1),
          settings: settings,
          transition: PageTransitionType.iosPush,
        );
      case AppRoutes.teacherAttendanceScreen:
        return PageTransition.build(
          page: AttendanceScreen(),
          settings: settings,
          transition: PageTransitionType.iosPush,
        );
      case AppRoutes.teacherHomeworkScreen:
        return PageTransition.build(
          page: HomeworkScreen(),
          settings: settings,
          transition: PageTransitionType.iosPush,
        );
      case AppRoutes.addTaskScreen:
        return PageTransition.build(
          page: AddTask(),
          settings: settings,
          transition: PageTransitionType.slideUpFade,
        );
      case AppRoutes.homeworkDetailScreen:
        return PageTransition.build(
          page: HomeworkDetailScreen(),
          settings: settings,
          transition: PageTransitionType.iosPush,
        );
      case AppRoutes.studentSubmissionScreen:
        return PageTransition.build(
          page: StudentSubmissionScreen(),
          settings: settings,
          transition: PageTransitionType.iosPush,
        );
      case AppRoutes.addStudentScreen:
        final addArgs = settings.arguments;
        final teacherId = addArgs is int ? addArgs : 1;
        return PageTransition.build(
          page: AddStudent(teacherId: teacherId),
          settings: settings,
          transition: PageTransitionType.slideUpFade,
        );
      case AppRoutes.teacherProfile:
        final teacherId = settings.arguments as int?;
        return _fadeRouter(TeacherProfileScreen(teacherId: teacherId ?? 1));
      case AppRoutes.teacherMainScreen:
        final userId = settings.arguments as int?;
        return PageTransition.build(
          page: TeacherMainScreen(userId: userId ?? 1),
          settings: settings,
          transition: PageTransitionType.fadeThrough,
        );
      case AppRoutes.teacherGradeResult:
        return PageTransition.build(
          page: GradeResult(),
          settings: settings,
          transition: PageTransitionType.iosPush,
        );
      case AppRoutes.teacherNotificationScreen:
        return PageTransition.build(
          page: TeacherNotificationScreen(),
          settings: settings,
          transition: PageTransitionType.slideUpFade,
        );

      //------------ Student ----------------
      case AppRoutes.studentFirstScreen:
        final userId = settings.arguments as int;
        return PageTransition.build(
          page: StudentFirstScreen(userId: userId),
          settings: settings,
          transition: PageTransitionType.fadeThrough,
        );
      case AppRoutes.connectRequest:
        return _slideRoute(ConnectionRequests());
      case AppRoutes.joinClassSreen:
        final userId = settings.arguments as int;
        return PageTransition.build(
          page: JoinClassScreen(userId: userId),
          settings: settings,
          transition: PageTransitionType.iosPush,
        );
      case AppRoutes.studentDashboard:
        final userId = settings.arguments as int?;
        return _slideRoute(StudentDashboard(userId: userId ?? 1));
      case AppRoutes.submitted:
        return PageTransition.build(
          page: SubmmitScreen(),
          settings: settings,
          transition: PageTransitionType.slideUpFade,
        );
      case AppRoutes.homework:
        return PageTransition.build(
          page: Homework(),
          settings: settings,
          transition: PageTransitionType.iosPush,
        );
      case AppRoutes.profile:
        final userId = settings.arguments as int?;
        return _slideRoute(Profile(userId: userId ?? 1));
      case AppRoutes.detail:
        return PageTransition.build(
          page: Deatilscreen(),
          settings: settings,
          transition: PageTransitionType.iosPush,
        );
      case AppRoutes.detailTeach:
        return PageTransition.build(
          page: DeatilTeacher(),
          settings: settings,
          transition: PageTransitionType.iosPush,
        );
      case AppRoutes.homepage:
        final userId = settings.arguments as int?;
        return _slideRoute(Homepage(userId: userId ?? 1));
      case AppRoutes.scedeul:
        return PageTransition.build(
          page: Scedeul(),
          settings: settings,
          transition: PageTransitionType.iosPush,
        );
      case AppRoutes.result:
        return PageTransition.build(
          page: Result(),
          settings: settings,
          transition: PageTransitionType.iosPush,
        );
      case AppRoutes.info:
        return PageTransition.build(
          page: InfoPersonal(),
          settings: settings,
          transition: PageTransitionType.iosPush,
        );
      case AppRoutes.subject:
        return PageTransition.build(
          page: Subjects(),
          settings: settings,
          transition: PageTransitionType.iosPush,
        );
      case AppRoutes.notifications:
        return PageTransition.build(
          page: Notifications(),
          settings: settings,
          transition: PageTransitionType.slideUpFade,
        );

      //------------ Parent -----------------
      case AppRoutes.parentFirstScreen:
        return PageTransition.build(
          page: ParentFirstScreen(),
          settings: settings,
          transition: PageTransitionType.fadeThrough,
        );
      case AppRoutes.parentPendingRequests:
        return _slideRoute(ParentPendingRequests());
      case AppRoutes.parentListStuClass:
        final student = settings.arguments as Map<String, dynamic>?;
        return _slideRoute(ParentListStuClass(student: student));
      case AppRoutes.parentConnectStudent:
        return PageTransition.build(
          page: ParentConnectStudent(),
          settings: settings,
          transition: PageTransitionType.iosPush,
        );
      case AppRoutes.ParentsDashboard:
        return PageTransition.build(
          page: ParentsDashboard(),
          settings: settings,
          transition: PageTransitionType.fadeThrough,
        );
      case AppRoutes.AttandanceScreen:
        return PageTransition.build(
          page: AttandanceScreen(),
          settings: settings,
          transition: PageTransitionType.iosPush,
        );
      case AppRoutes.HomeworkQuizeScreen:
        return PageTransition.build(
          page: HomeworkQuizeScreen(),
          settings: settings,
          transition: PageTransitionType.iosPush,
        );
      case AppRoutes.parent_nothi:
        return _slideRoute(Nothication());
      case AppRoutes.commentScreen:
        return _slideRoute(CommentSignature());
      case AppRoutes.parent_setting:
        return _slideRoute(ParentSetting());
      case AppRoutes.CustomScreen:
        return _slideRoute(CustomScreen());
      case AppRoutes.NewsScreen:
        return PageTransition.build(
          page: NewsScreen(),
          settings: settings,
          transition: PageTransitionType.iosPush,
        );

      default:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const Scaffold(
            body: Center(child: Text("Route not found")),
          ),
        );
    }
  }

  // slide from right
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

  // fade
  static PageRouteBuilder _fadeRouter(Widget page) {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 400),
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
