import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tamdansers_app/constants/app_colors.dart';
import 'package:tamdansers_app/constants/app_images.dart';
import 'package:tamdansers_app/constants/text_style.dart';
import 'package:tamdansers_app/routes/app_routes.dart';
import 'package:tamdansers_app/widget/primary_button.dart';

class AuthOptionTeacherScreen extends StatelessWidget {
  const AuthOptionTeacherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context), 
          icon: Icon(
            Icons.arrow_back_ios,
            color: AppColors.primaryText,
          )
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(
              height: size.height*0.35,
              child: SvgPicture.asset(
                AppImages.imageClassroom,
                fit: BoxFit.contain,
              ),
<<<<<<< HEAD
            ),
            Spacer(),
            Text(
              "សូមជ្រើសរើសវិធីសាស្រ្ត",
              style: AppTextStyle.title28,
            ),
            Text(
              "ចូលប្រើប្រាស់",
              style: AppTextStyle.title28,
            ),
            Spacer(),
            //custom widget
            PrimaryButton(
              label: "ចូលគណនី",
              backgroundColor: AppColors.primaryMain,
              foregroundColor: AppColors.white,
              onPressed: () => Navigator.pushNamed(
                context, 
                AppRoutes.loginTeacherScreen
              )
            ),
            SizedBox(height: 20,),
            PrimaryButton(
              label: "ចុះឈ្មោះ",
              backgroundColor: AppColors.white,
              foregroundColor: AppColors.primaryMain,
              onPressed: (){}
            ),
            SizedBox(height: 30,)
          ],
=======
              Spacer(),
              Text(
                "សូមជ្រើសរើសវិធីសាស្រ្ត",
                style: AppTextStyle.title32,
              ),
              Text(
                "ចូលប្រើប្រាស់",
                style: AppTextStyle.title32,
              ),
              Spacer(),
              //custom widget
              PrimaryButton(
                label: "ចូលគណនី",
                backgroundColor: AppColors.primaryMain,
                foregroundColor: AppColors.white,
                onPressed: (){
                  Navigator.pushNamed(context, AppRoutes.TeacherDashboardScreen);
                }
              ),
              SizedBox(height: 20,),
              PrimaryButton(
                label: "ចុះឈ្មោះ",
                backgroundColor: AppColors.white,
                foregroundColor: AppColors.primaryMain,
                onPressed: (){}
              ),
              SizedBox(height: 30,)
            ],
          ),
>>>>>>> 3ec662d4e7c3a33f2476dbdfc02f0d2578a4da1a
        ),
      ),
    );
  }
}