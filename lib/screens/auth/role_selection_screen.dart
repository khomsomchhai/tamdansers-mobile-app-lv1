import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tamdansers_app/constants/app_images.dart';
import 'package:tamdansers_app/constants/text_style.dart';
import 'package:tamdansers_app/widget/primary_button.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              SizedBox(
                height: size.height*0.35,
                child: SvgPicture.asset(
                  AppImages.imageSelectRole,
                  fit: BoxFit.contain,
                ),
              ),
              Spacer(),
              Text(
                "សូមជ្រើសរើសមុខងារ",
                style: AppTextStyle.title32,
              ),
              Text(
                "ចូលប្រើប្រាស់",
                style: AppTextStyle.title32,
              ),
              Spacer(),
              //custom widget
              PrimaryButton(
                label: "គ្រូបង្រៀន", 
                onPressed: (){}
              ),
              SizedBox(height: 20,),
              PrimaryButton(
                label: "សិស្ស", 
                onPressed: (){}
              ),
              SizedBox(height: 20,),
              PrimaryButton(
                label: "អាណាព្យាបាលសិស្ស", 
                onPressed: (){}
              ),
              SizedBox(height: 30,)
            ],
          ),
        ),
      ),
    );
  }
}