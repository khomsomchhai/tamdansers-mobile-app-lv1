// import 'package:flutter/material.dart';
// import 'package:tamdansers_app/routes/app_routes.dart';

// // import all screens
// import 'package:tamdansers_app/screens/auth/auth_option_teacher_screen.dart';
// import 'package:tamdansers_app/screens/auth/login_screen.dart';
// import 'package:tamdansers_app/screens/auth/otp_screen.dart';
// import 'package:tamdansers_app/screens/auth/role_selection_screen.dart';
// import 'package:tamdansers_app/screens/auth/sign_up_screen.dart';
// import 'package:tamdansers_app/screens/auth/splash_screen.dart';
// import 'package:tamdansers_app/screens/parents/parent_connect_student.dart';
// import 'package:tamdansers_app/screens/parents/parent_first_screen.dart';
// import 'package:tamdansers_app/screens/parents/parent_list_stu_class.dart';
// import 'package:tamdansers_app/screens/parents/parent_login.dart';
// import 'package:tamdansers_app/screens/student/join_class_screen.dart';
// import 'package:tamdansers_app/screens/student/menu/change_pw.dart';
// import 'package:tamdansers_app/screens/student/menu/homepage.dart';
// import 'package:tamdansers_app/screens/student/menu/homework.dart';
// import 'package:tamdansers_app/screens/student/menu/info_personal.dart';
// import 'package:tamdansers_app/screens/student/menu/notification.dart';
// import 'package:tamdansers_app/screens/student/menu/profile.dart';
// import 'package:tamdansers_app/screens/student/result.dart';
// import 'package:tamdansers_app/screens/student/scedeul.dart';
// import 'package:tamdansers_app/screens/student/student_dashboard.dart';
// import 'package:tamdansers_app/screens/student/student_first_screen.dart';
// import 'package:tamdansers_app/screens/student/subjects.dart';
// import 'package:tamdansers_app/screens/teacher/add_student.dart';
// import 'package:tamdansers_app/screens/teacher/add_task.dart';
// import 'package:tamdansers_app/screens/teacher/attendance_screen.dart';
// import 'package:tamdansers_app/screens/teacher/homework_screen.dart';
// import 'package:tamdansers_app/screens/teacher/link_parent.dart';
// import 'package:tamdansers_app/screens/teacher/manage_all_class.dart';
// import 'package:tamdansers_app/screens/teacher/manage_class.dart';
// import 'package:tamdansers_app/screens/teacher/manage_student_screen.dart';
// import 'package:tamdansers_app/screens/teacher/score_detail_screen.dart';
// import 'package:tamdansers_app/screens/teacher/student_detail_screen.dart';
// import 'package:tamdansers_app/screens/teacher/teacher_dashboard.dart';
// import 'package:tamdansers_app/screens/teacher/teacher_main_screen.dart';

// import '../screens/parents/menu/Monthy_result_Ranking.dart';
// import '../screens/parents/menu/comment_signature .dart';
// import '../screens/student/menu/deatil_teacher.dart';
// import '../screens/student/menu/deatilscreen.dart';
// import '../screens/student/menu/submmit_screen.dart';

// class PageRoutes {

//   static Widget? getPage(String? routeName) {
//     switch (routeName) {

//       case AppRoutes.splashScreen:
//         return SplashScreen();
        
//       case AppRoutes.roleSelectionScreen:
//         return RoleSelectionScreen();
      
//       case AppRoutes.otpScreen:
//         return OtpScreen();
//       case AppRoutes.loginScreen:
//         return LoginScreen();

//       case AppRoutes.signUpScreen:
//         return SignUpScreen();
      

//       case AppRoutes.authOptionTeacherScreen:
//         return AuthOptionTeacherScreen();

//       case AppRoutes.teacherDashboard:
//         return TeacherDashboard();

//       case AppRoutes.manageAllClass:
//         return ManageAllClass();

//       case AppRoutes.linkParentScreen:
//         return LinkParentScreen();

//       case AppRoutes.scoreDetailScreen:
//         return ScoreDetailScreen();

//       case AppRoutes.studentFirstScreen:
//         return StudentFirstScreen();

//       case AppRoutes.joinClassSreen:
//         return JoinClassScreen();

//       case AppRoutes.studentDashboard:
//         return StudentDashboard();

//       case AppRoutes.submitted:
//         return SubmmitScreen();

//       case AppRoutes.homework:
//         return Homework();

//       case AppRoutes.profile:
//         return Profile();

//       case AppRoutes.detail:
//         return Deatilscreen();

//       case AppRoutes.detailTeach:
//         return DeatilTeacher();

//       case AppRoutes.homepage:
//         return Homepage();

//       case AppRoutes.scedeul:
//         return Scedeul();

//       case AppRoutes.result:
//         return Result();

//       case AppRoutes.changePassword:
//         return ChangePw();

//       case AppRoutes.info:
//         return InfoPersonal();

//       case AppRoutes.subject:
//         return Subjects();
 

//       case AppRoutes.notifications:
//         return Notifications();

//       case AppRoutes.parentFirstScreen:
//         return ParentFirstScreen();

//       case AppRoutes.parentConnectStudent:
//         return ParentConnectStudent();

//       case AppRoutes.parentDashboardScreen:
//         return ParentLogin();

//       default:
//         return null;
//     }
//   }
//   static Map<String, Widget Function(BuildContext)> routes = {
//     AppRoutes.splashScreen: (context) => SplashScreen(),
//     AppRoutes.roleSelectionScreen: (context) => RoleSelectionScreen(),
//     AppRoutes.otpScreen: (context) => OtpScreen(),
//     // Teacher routes
//     AppRoutes.authOptionTeacherScreen: (context) => AuthOptionTeacherScreen(),
//     AppRoutes.loginScreen: (context) => LoginScreen(),
//     AppRoutes.signUpScreen: (context) => SignUpScreen(),
//     AppRoutes.teacherDashboard: (context) => TeacherMainScreen(),
//     AppRoutes.manageAllClass: (context) => ManageAllClass(),
//     AppRoutes.manageClass: (context) => ManageClass(),
//     AppRoutes.manageStudentScreen: (context) => ManageStudentScreen(
//           classId: ModalRoute.of(context)!.settings.arguments as int? ?? 0,
//         ),
//     AppRoutes.studentDetailScreen: (context) => StudentDetailScreen(),
//     AppRoutes.linkParentScreen: (context) => LinkParentScreen(),
//     AppRoutes.scoreDetailScreen: (context) => ScoreDetailScreen(),
//     AppRoutes.teacherAttendanceScreen: (context) => AttendanceScreen(),
//     AppRoutes.teacherHomeworkScreen: (context) => HomeworkScreen(),
//     AppRoutes.addTaskScreen: (context) => AddTask(),
//     AppRoutes.addStudentScreen: (context) => AddStudent(),
//     // Student routes
//     AppRoutes.studentFirstScreen: (context) => StudentFirstScreen(),
//     AppRoutes.joinClassSreen: (context) => JoinClassScreen(),
//     AppRoutes.studentDashboard: (context) => StudentDashboard(),
//     AppRoutes.submitted: (context) => SubmmitScreen(),
//     AppRoutes.homework: (context) => Homework(),
//     AppRoutes.detail: (context) => Deatilscreen(),
//     AppRoutes.detailTeach: (context) => DeatilTeacher(),

//     AppRoutes.homepage: (context) => Homepage(),
//     AppRoutes.scedeul: (context) => Scedeul(),
//     AppRoutes.result: (context) => Result(),
//     AppRoutes.changePassword: (context) => ChangePw(),
//     AppRoutes.info: (contex) => InfoPersonal(),
//     AppRoutes.subject: (context) => Subjects(),
//     AppRoutes.notifications: (contex) => Notifications(),
//     // Parent routes
//     AppRoutes.parentFirstScreen: (context) => ParentFirstScreen(),
//     AppRoutes.parentConnectStudent: (context) => ParentConnectStudent(),
//     AppRoutes.parentListStuClass: (context) => ParentListStuClass(),

//     AppRoutes.parentDashboardScreen: (context) => ParentLogin(),
//     AppRoutes.monthly: (context) => CustomScreen(),
//     AppRoutes.commentScreen: (context) => CommentSignature(),
//   };
// }
  