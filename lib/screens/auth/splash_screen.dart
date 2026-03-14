import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tamdansers_app/constants/app_colors.dart';
import 'package:tamdansers_app/constants/app_images.dart';
import 'package:tamdansers_app/routes/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  void checkLogin() async {
  final pref = await SharedPreferences.getInstance();

  final role = pref.getString("role");
  final id = pref.getInt("userId");
  final isLogin = pref.getBool("isLogin") ?? false;

  if (!mounted) return;

  if (isLogin && role != null && id != null) {

    switch (role) {
      case "teacher":
        // use the main screen which contains the bottom navigation bar
        Navigator.pushReplacementNamed(
          context,
          AppRoutes.teacherMainScreen,
          arguments: id,
        );
        break;

      case "student":
        Navigator.pushReplacementNamed(
          context,
          AppRoutes.studentFirstScreen,
          arguments: id,
        );
        break;

      case "parent":
        Navigator.pushReplacementNamed(
          context,
          AppRoutes.parentFirstScreen,
          arguments: id,
        );
        break;

      default:
        _goToRoleSelection();
    }

  } else {
    _goToRoleSelection();
  }
}

void _goToRoleSelection() {
  Navigator.pushNamedAndRemoveUntil(
    context,
    AppRoutes.roleSelectionScreen,
    (route) => false,
  );
}

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 3), (){
      checkLogin();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryMain,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.2,
              child: SvgPicture.asset(
                AppImages.appLogoWhite,
              ),
            ),
          ),
        ],
      ),
    );
  }
}