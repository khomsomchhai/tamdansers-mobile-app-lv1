import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tamdansers_app/constants/app_colors.dart';
import 'package:tamdansers_app/constants/app_images.dart';
import 'package:tamdansers_app/constants/text_style.dart';
import 'package:tamdansers_app/widget/auth_field.dart';

class SignUpTeacherScreen extends StatefulWidget {
  const SignUpTeacherScreen({super.key});

  @override
  State<SignUpTeacherScreen> createState() => _SignUpTeacherScreenState();
}

class _SignUpTeacherScreenState extends State<SignUpTeacherScreen> {
  var lastnameCtrl = TextEditingController();
  var firstnameCtrl = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context), 
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.primaryText,
          )
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            _buildHeader(size),
            SizedBox(height: 20,),
            _buildForm(),
          ],
        ),
      ),
    );
  }
  Widget _buildHeader(Size size){
    return Column(
      children: [
        SizedBox(
          height: size.height * 0.2,
          child: SvgPicture.asset(
            AppImages.imgSignUp,
            fit: BoxFit.contain,
          ),
        ),
        SizedBox(height: 15,),
        Text(
          "បំពេញព័ត៌មានរបស់អ្នក",
          style: AppTextStyle.screenTitle24,
        )
      ],
    );
  }
  Widget _buildForm(){
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: AuthField(
                hintText: "បញ្ចូលនាមត្រកូល", 
                icon: Icon(
                  Icons.person_outline_rounded,
                  color: AppColors.secondaryText,
                  size: 20,
                ), 
                textController: lastnameCtrl
              ),
            ),
            SizedBox(width: 10,),
            Expanded(
              child: AuthField(
                hintText: "បញ្ចូលនាមខ្លួន", 
                icon: Icon(
                  Icons.person_outline_rounded,
                  color: AppColors.secondaryText,
                  size: 20,
                ), 
                textController: firstnameCtrl
              ),
            ),
          ],
        ),
        
      ],
    );
  }
}