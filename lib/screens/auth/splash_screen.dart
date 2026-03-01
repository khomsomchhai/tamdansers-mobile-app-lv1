import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tamdansers_app/constants/app_animation.dart';
import 'package:tamdansers_app/constants/app_colors.dart';
import 'package:tamdansers_app/constants/app_images.dart';
import 'package:tamdansers_app/routes/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  void checkLogin() async{
    var pref = await SharedPreferences.getInstance();
    var role = pref.getString("role") ?? "";
    var isLogin = pref.getBool("isLogin") ?? false;
    if(isLogin){
      if(role == "teacher"){
        Navigator.pushReplacementNamed(
          context, 
          AppRoutes.teacherDashboard,
        );
      } else if(role == "student"){
        Navigator.pushReplacementNamed(
          context, 
          AppRoutes.studentFirstScreen,
        );
      } else if(role == "parent"){
        Navigator.pushReplacementNamed(
          context, 
          AppRoutes.parentFirstScreen,
        );
      }
    }else{
      Navigator.pushReplacementNamed(
        context, 
        AppRoutes.roleSelectionScreen,
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 4), (){
      checkLogin();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryMain,
      appBar: AppBar(
        backgroundColor: AppColors.transparent,
        elevation: 0,
        surfaceTintColor: AppColors.transparent,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Spacer(),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.2,
            child: SvgPicture.asset(
              AppImages.appLogoWhite,
            ),
          ),
          Spacer(),
          SizedBox(
            height: 150,
            child: Lottie.asset(
              AppAnimations.loadingCircle,
              repeat: true
            ),
          ),
          SizedBox(height: 60,)
        ],
      ),
    );
  }
}