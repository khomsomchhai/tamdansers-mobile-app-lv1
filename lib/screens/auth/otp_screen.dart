import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:tamdansers_app/constants/app_animation.dart';
import 'package:tamdansers_app/constants/app_colors.dart';
import 'package:tamdansers_app/constants/app_images.dart';
import 'package:tamdansers_app/constants/app_number.dart';
import 'package:tamdansers_app/constants/text_style.dart';
import 'package:tamdansers_app/routes/app_routes.dart';
import 'package:tamdansers_app/widget/custom_dialog.dart';

class OtpScreen extends StatefulWidget {
  final String role;
  final int? userId;
  const OtpScreen({super.key, required this.role, this.userId});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  late String selectedRole;
  String currentCode = "";
  int secondRemaining = 90;
  Timer? timer;
  bool isLoading = false;
  void startTimer(){
    timer = Timer.periodic(Duration(seconds: 1), (timer){
      if(secondRemaining > 0){
        setState(() {
          secondRemaining--;
        });
      }else{
        timer.cancel();
      }
    });
  }
  String formatTime(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;

    return "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedRole = widget.role;
    startTimer();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.primaryText,
            size: AppNumber.iconMedium,
          )
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),
            _buildBody()
          ],
        ),
      ),
    );
  
  }
  Widget _buildHeader() {
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.2,
          child: SvgPicture.asset(
            AppImages.otpVeriy
          ),
        ),
        SizedBox(height: 26,),
        
      ],
    );
  }
  Widget _buildBody(){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              "លេខកូដផ្ទៀងផ្ទៀត់",
              style: AppTextStyle.sectionTitle20,
            ),
          ),
          SizedBox(height: 16,),
          Center(
            child: Text(
              "សូមបញ្ចូលលេខកូដដែលបានផ្ញើទៅអ៊ីម៉ែល ឬ លេខទូរស័ព្ទរបស់អ្នក។",
              style: AppTextStyle.body,
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 16, 30, 16),
            child: PinCodeTextField(
              appContext: context,
              length: 6,
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  currentCode = value;
                });
              },
              cursorColor: AppColors.primaryMain,
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.underline,
                activeColor: AppColors.primaryMain,
                selectedColor: AppColors.primaryMain,
                inactiveColor: AppColors.neutral500,
                activeFillColor: AppColors.primaryMain
              
              ),
              onCompleted: (value) async {

                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppNumber.radiusMedium),
                    ),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 80,
                          child: Lottie.asset(
                            AppAnimations.loading,
                            repeat: true, 
                          ),
                        ),
                        SizedBox(height: 12),
                        Text(
                          "កំពុងដំណើរការ...",
                          style: AppTextStyle.body,
                        ),
                      ],
                    ),
                  ),
                );
                await Future.delayed(Duration(seconds: 3));

                Navigator.pop(context);

                showDialog(
                  context: context,
                  builder: (context) => CustomDialog(
                    title: "ជោគជ័យ",
                    description: "លេខកូដរបស់អ្នកត្រូវបានផ្ទៀងផ្ទាត់ដោយជោគជ័យ។",
                    label: widget.userId != null ? "កំណត់ពាក្យសម្ងាត់ថ្មី" : "ចូលគណនី",
                    onPressed: (){
                      if (widget.userId != null) {
                        Navigator.pushNamed(
                          context, 
                          AppRoutes.resetPassword,
                          arguments: widget.userId
                        );
                      } else {
                        Navigator.pushNamedAndRemoveUntil(
                          context, 
                          AppRoutes.loginScreen, 
                          (route) => false,
                          arguments: selectedRole
                        );
                      }
                    },
                  )
                );
              },
            ),
          ),
          Center(
            child: Text(
              formatTime(secondRemaining),
              style: AppTextStyle.size18Primary,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "មិនទាន់ទទួលបានលេខកូដមែនទេ?",
                style: AppTextStyle.body,
              ),
              TextButton(
                onPressed: (){}, 
                child: Text(
                  "ផ្ញើម្ដងទៀត",
                  style: AppTextStyle.bodyPrimary,
                )
              )
            ],
          )
        ],
      ),
    );
  }
}