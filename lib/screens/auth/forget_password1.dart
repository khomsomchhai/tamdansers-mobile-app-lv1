import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tamdansers_app/constants/app_colors.dart';
import 'package:tamdansers_app/constants/app_images.dart';
import 'package:tamdansers_app/constants/app_number.dart';
import 'package:tamdansers_app/constants/text_style.dart';
import 'package:tamdansers_app/constants/validators.dart';
import 'package:tamdansers_app/repositories/user_repo.dart';
import 'package:tamdansers_app/routes/app_routes.dart';
import 'package:tamdansers_app/screens/widget/auth_field.dart';
import 'package:tamdansers_app/screens/widget/custom_snackbar.dart';
import 'package:tamdansers_app/screens/widget/primary_button_2.dart';

class ForgetPassword1 extends StatefulWidget {
  const ForgetPassword1({super.key});

  @override
  State<ForgetPassword1> createState() => _ForgetPassword1State();
}

class _ForgetPassword1State extends State<ForgetPassword1> {
  var identifierCtrl = TextEditingController();
  var formKey = GlobalKey<FormState>();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading:IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.primaryText,
            size: AppNumber.iconMedium,
          ),
        )
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.2,
                child: SvgPicture.asset(
                  AppImages.appLogoblue,
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(height: 30,),
              Text(
                "ភ្លេចពាក្យសម្ងាត់",
                style: AppTextStyle.screenTitle24,
              ),
              SizedBox(height: 20,),
              Text(
                "សូមបញ្ចូលអ៊ីម៉ែល​ ឬ លេខទូរស័ព្ទដែលបានភ្ជាប់ជាមួយគណនីរបស់អ្នក។",
                style: AppTextStyle.body,
              ),
              SizedBox(height: 20,),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    AuthField(
                      validator: Validators.emailOrPhone,
                      textController: identifierCtrl,
                      hintText: "បញ្ចូលអ៊ីម៉ែល ឬ លេខទូរស័ព្ទរបស់អ្នក",
                      icon: Icon(
                        Icons.email_outlined,
                        size: 20,
                        color: AppColors.secondaryText,
                      ),
                    ),
                    SizedBox(height: 20,),
                    PrimaryButton2(
                      label: isLoading ? "" : "ដាក់ស្នើ",
                      backgroundColor: AppColors.primaryMain,
                      foregroundColor: AppColors.white,
                      processIndicator: isLoading ? SizedBox(
                        width: 26,
                        height: 26,
                        child: CircularProgressIndicator(
                          color: AppColors.white,
                          strokeWidth: 2,
                        ),
                      ): null,
                      onPressed: () async{
                        String identifier = identifierCtrl.text.trim();
                        bool isEmail = identifier.contains("@");
        
                        String? email;
                        String? phone;
        
                        if (isEmail) {
                          email = identifier;
                        } else {
                          phone = identifier;
                        }
                        if (formKey.currentState!.validate()) {
                          Map<String, dynamic>? existingUser;
                          if (email != null) {
                            existingUser = await UserRepo().getUserByEmail(email);
                          }
                          if (existingUser == null && phone != null) {
                            existingUser = await UserRepo().getUserByPhone(phone);
                          }
                          if (existingUser == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: AppColors.transparent,
                                elevation: 0,
                                behavior: SnackBarBehavior.floating,
                                margin: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                                content: CustomSnackbar(
                                  title: "កហុស!", 
                                  message: "គណនីនេះមិនអាចរកឃើញ", 
                                  icon: Icons.close, 
                                  color: AppColors.error
                                )
                              ),
                            );
                          } else {
                            Navigator.pushNamed(
                              context, 
                              AppRoutes.otpScreen,
                              arguments: {
                                'role': UserRepo().getRoleById(existingUser['id']),
                                'userId': existingUser['id']
                              }
                            );
                          }
                        }
                      },
                    ),
                  ],
                ),
              ),
              
            ],
          ),
        ),
      ),
    );
  }
}