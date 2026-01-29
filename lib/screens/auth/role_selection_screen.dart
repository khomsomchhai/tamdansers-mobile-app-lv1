import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tamdansers_app/constants/app_colors.dart';
import 'package:tamdansers_app/constants/app_images.dart';
import 'package:tamdansers_app/constants/text_style.dart';
import 'package:tamdansers_app/routes/app_routes.dart';
import 'package:tamdansers_app/widget/primary_button.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(
              height: size.height*0.30,
              child: SvgPicture.asset(
                AppImages.imageSelectRole,
                fit: BoxFit.contain,
              ),
            ),
            Spacer(),
            Text(
              "សូមជ្រើសរើសមុខងារ",
              style: AppTextStyle.title28,
            ),
            Text(
              "ចូលប្រើប្រាស់",
              style: AppTextStyle.title28,
            ),
            Spacer(),
            //custom widget
            PrimaryButton(
              label: "គ្រូបង្រៀន",
              backgroundColor: AppColors.primaryMain,
              foregroundColor: AppColors.white, 
              onPressed: (){
                Navigator.pushNamed(
                  context, 
                  AppRoutes.loginTeacherScreen
                );
              }
            ),
            SizedBox(height: 20,),
            PrimaryButton(
              label: "សិស្ស",
              backgroundColor: AppColors.primaryMain,
              foregroundColor: AppColors.white,
              onPressed: (){}
            ),
            SizedBox(height: 20,),
            PrimaryButton(
              label: "អាណាព្យាបាលសិស្ស",
              backgroundColor: AppColors.primaryMain,
              foregroundColor: AppColors.white,
              onPressed: (){}
            ),
            SizedBox(height: 50,)
          ],
        ),
      ),
    );
  }
}