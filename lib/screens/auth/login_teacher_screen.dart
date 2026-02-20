import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tamdansers_app/constants/app_colors.dart';
import 'package:tamdansers_app/constants/app_images.dart';
import 'package:tamdansers_app/constants/text_style.dart';
import 'package:tamdansers_app/constants/validators.dart';
import 'package:tamdansers_app/routes/app_routes.dart';
import 'package:tamdansers_app/widget/auth_field.dart';
import 'package:tamdansers_app/widget/button_with_icon.dart';
import 'package:tamdansers_app/widget/primary_button.dart';

class LoginTeacherScreen extends StatefulWidget {
  const LoginTeacherScreen({super.key});

  @override
  State<LoginTeacherScreen> createState() => _LoginTeacherScreenState();
}

class _LoginTeacherScreenState extends State<LoginTeacherScreen> {
  var emailCtrl = TextEditingController();
  var pwdCtrl = TextEditingController();
  var formKey = GlobalKey<FormState>();
  bool isCheck = false;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: AppColors.primaryText,
            )),
      ),
      body: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _buildHeader(size),
                  SizedBox(height: 24),
                  _buildForm(),
                  SizedBox(height: 10),
                  Spacer(),
                  _buildFooter(),
                  SizedBox(height: 26),
                ],
              ),
            ),
          ),
        ],
      ),

      // body: SingleChildScrollView(
      //   child: Padding(
      //     padding: const EdgeInsets.symmetric(horizontal: 20),
      //     child: Column(
      //       children: [
      //         _buildHeader(size),
      //         SizedBox(height: 24,),
      //         _buildForm(),
      //         SizedBox(height: 24,),
      //         _buildFooter(),
      //         SizedBox(height: 20,),
      //       ],
      //     ),
      //   ),
      // ),
    );
  }

  Widget _buildHeader(Size size) {
    return Column(
      children: [
        SizedBox(
          height: size.height * 0.2,
          child: SvgPicture.asset(
            AppImages.imgLogin,
            fit: BoxFit.contain,
          ),
        ),
        SizedBox(height: 16,),
        Text(
          "ចូលគណនីរបស់អ្នក",
          style: AppTextStyle.screenTitle24,
        ),
      ],
    );
  }

  Widget _buildForm() {
    return Form(
      key: formKey,
      child: Column(
        children: [
          AuthField(
            validator: Validators.emailOrPhone,
            textController: emailCtrl,
            hintText: "បញ្ចូលអ៊ីម៉ែល ឬ លេខទូរស័ព្ទរបស់អ្នក",
            icon: Icon(
              Icons.email_outlined,
              size: 20,
              color: AppColors.secondaryText,
            ),
          ),
          SizedBox(height: 16,),
          AuthField(
            validator: Validators.password,
            textController: pwdCtrl,
            hintText: "បញ្ចូលពាក្យសម្ងាត់របស់អ្នក",
            icon: Icon(
              Icons.lock_outline_rounded,
              size: 20,
              color: AppColors.secondaryText,
            ),
            isPwd: true,
          ),
          Row(
            children: [
              Checkbox(
                value: isCheck,
                activeColor: AppColors.primaryMain,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4)),
                onChanged: (value) {
                  setState(() {
                    isCheck = value!;
                  });
                },
              ),
              Text(
                "ចងចាំ",
                style: AppTextStyle.body,
              ),
              Spacer(),
              GestureDetector(
                onTap: () {},
                child: Text(
                  "ភ្លេចពាក្យសម្ងាត់?",
                  style: GoogleFonts.kantumruyPro(
                      fontSize: 16, color: AppColors.primaryMain),
                ),
              )
            ],
          ),
          SizedBox(height: 8,),
          PrimaryButton(
            label: "ចូលគណនី",
            backgroundColor: AppColors.primaryMain,
            foregroundColor: AppColors.white,
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Navigator.pushReplacementNamed(
                  context,
                  AppRoutes.teacherDashboard,
                );
              }
            },
          ),
        ],
      ),
    );
  }
  Widget _buildFooter(){
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "មិនទាន់មានគណនីមែនទេ?",
              style: AppTextStyle.body,
            ),
            SizedBox(width: 10,),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                  context, 
                  AppRoutes.signUpTeacherScreen
                );
              },
              child: Text(
                "ចុះឈ្មោះ",
                style: GoogleFonts.kantumruyPro(
                  fontSize: 16,
                  color: AppColors.primaryMain
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 8,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                height: 1,
                decoration: BoxDecoration(
                  color: AppColors.secondaryText
                ),
              ),
            ),
            SizedBox(width: 10,),
            Text(
              "ឬ",
              style: AppTextStyle.body
            ),
            SizedBox(width: 10,),
            Expanded(
              child: Container(
                height: 1,
                decoration: BoxDecoration(
                  color: AppColors.secondaryText
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 15,),
        SizedBox(
          width: double.infinity,
          child: ButtonWithIcon(
            onPressed: () {
              
            },
            label: "ភ្ចាប់ជាមួយ Telegram",
            icon: Icon(
              Icons.telegram_outlined,size: 30,
              color: AppColors.primaryMain,
            )
          ),
        ),
        SizedBox(height: 12,),
        SizedBox(
          width: double.infinity,
          child: ButtonWithIcon(
            onPressed: () {
              
            },
            label: "ភ្ចាប់ជាមួយ Google",
            icon: SvgPicture.asset(
              AppImages.googleIcon,
              fit: BoxFit.contain,
              width: 30,
            )
          ),
        ),
      ],
    );
  }
}