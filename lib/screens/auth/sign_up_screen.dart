// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tamdansers_app/constants/app_colors.dart';
import 'package:tamdansers_app/constants/app_images.dart';
import 'package:tamdansers_app/constants/app_number.dart';
import 'package:tamdansers_app/constants/text_style.dart';
import 'package:tamdansers_app/constants/validators.dart';
import 'package:tamdansers_app/repositories/user_repo.dart';
import 'package:tamdansers_app/routes/app_routes.dart';
import 'package:tamdansers_app/widget/auth_field.dart';
import 'package:tamdansers_app/widget/button_with_icon.dart';
import 'package:tamdansers_app/widget/primary_button.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  var lastnameCtrl = TextEditingController();
  var firstnameCtrl = TextEditingController();
  var identifierCtrl = TextEditingController();
  var pwdCtrl = TextEditingController();
  var cfPwdCtrl = TextEditingController();
  String gender = "male";
  var formKey = GlobalKey<FormState>();
  var selectedRole = "";
  
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    final role = ModalRoute.of(context)!.settings.arguments as String;
    setState(() {
      selectedRole = role;
    });
  }
  
  Future<void> _register() async {
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
      var existingUser = isEmail 
      ? await UserRepo().getUserByEmail(email!) 
      : await UserRepo().getUserByPhone(phone!);
      if (existingUser != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("គណនីនេះមានរួចហើយ សូមប្រើអ៊ីម៉ែល ឬ លេខទូរស័ព្ទផ្សេង")),
        );
      } else {
        var result = await UserRepo().createUser(
          firstName: firstnameCtrl.text,
          lastName: lastnameCtrl.text,
          gender: gender,
          phone: phone ?? "",
          email: email ?? "",
          password: pwdCtrl.text,
          role: selectedRole,

        );
        if (result > 0) {
          Navigator.pushNamed(
            context, 
            AppRoutes.otpScreen,
            arguments: selectedRole
          );
        } 
        
        // Navigator.pushNamed(
        //   context, 
        //   AppRoutes.otpScreen,
        //   arguments: selectedRole
        // );
        
      }
    }
  }
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
              size: AppNumber.iconMedium,
            )),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              _buildHeader(size),
              SizedBox(
                height: 24,
              ),
              _buildForm(),
              SizedBox(
                height: 24,
              ),
              _buildFooter(),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(Size size) {
    return Column(
      children: [
        SizedBox(
          height: size.height * 0.2,
          child: SvgPicture.asset(
            AppImages.imgSignUp,
            fit: BoxFit.contain,
          ),
        ),
        SizedBox(
          height: 16,
        ),
        Text(
          "បំពេញព័ត៌មានរបស់អ្នក",
          style: AppTextStyle.screenTitle24,
        )
      ],
    );
  }

  Widget _buildForm() {
    return Form(
      key: formKey,
      child: Column(
        children: [
          AuthField(
            hintText: "នាមត្រកូល",
            icon: Icon(
              Icons.person_outline_rounded,
              color: AppColors.secondaryText,
              size: 20,
            ),
            textController: lastnameCtrl,
            validator: Validators.inputData,
          ),
          SizedBox(
            height: 16,
          ),
          AuthField(
            hintText: "នាមខ្លួន",
            icon: Icon(
              Icons.person_outline_rounded,
              color: AppColors.secondaryText,
              size: 20,
            ),
            textController: firstnameCtrl,
            validator: Validators.inputData,
          ),
          SizedBox(
            height: 16,
          ),
          Row(
            children: [
              Expanded(
                child: _buildRadio(label: "ប្រុស", value: "male"),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: _buildRadio(label: "ស្រី", value: "female"),
              ),
            ],
          ),
          SizedBox(
            height: 16,
          ),
          AuthField(
            hintText: "អ៊ីម៉ែល ឬ លេខទូរស័ព្ទ",
            icon: Icon(
              Icons.email_outlined,
              size: 20,
              color: AppColors.secondaryText,
            ),
            textController: identifierCtrl,
            validator: Validators.emailOrPhone,
          ),
          SizedBox(
            height: 16,
          ),
          AuthField(
            hintText: "ពាក្យសម្ងាត់",
            icon: Icon(
              Icons.lock_outline_rounded,
              size: 20,
              color: AppColors.secondaryText,
            ),
            textController: pwdCtrl,
            isPwd: true,
            validator: Validators.password,
          ),
          SizedBox(
            height: 16,
          ),
          AuthField(
            hintText: "បញ្ជាក់ពាក្យសម្ងាត់",
            icon: Icon(
              Icons.lock_outline_rounded,
              size: 20,
              color: AppColors.secondaryText,
            ),
            textController: cfPwdCtrl,
            isPwd: true,
            validator: (value) => Validators.cnfPassword(value, pwdCtrl.text),
          ),
          SizedBox(
            height: 24,
          ),
          PrimaryButton(
            label: "ចុះឈ្មោះ",
            backgroundColor: AppColors.primaryMain,
            foregroundColor: AppColors.white,
            onPressed: () {
              _register();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "មានគណនីហើយមែនទេ?",
              style: AppTextStyle.body,
            ),
            SizedBox(
              width: 10,
            ),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Text(
                "ចូលគណនី",
                style: GoogleFonts.kantumruyPro(
                    fontSize: 16, color: AppColors.primaryMain),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                height: 1,
                decoration: BoxDecoration(color: AppColors.secondaryText),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Text("ឬ", style: AppTextStyle.body),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Container(
                height: 1,
                decoration: BoxDecoration(color: AppColors.secondaryText),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 16,
        ),
        SizedBox(
          width: double.infinity,
          child: ButtonWithIcon(
              onPressed: () {},
              label: "ភ្ចាប់ជាមួយ Telegram",
              icon: Icon(
                Icons.telegram_outlined,
                size: 30,
                color: AppColors.primaryMain,
              )),
        ),
        SizedBox(
          height: 12,
        ),
        SizedBox(
          width: double.infinity,
          child: ButtonWithIcon(
              onPressed: () {},
              label: "ភ្ចាប់ជាមួយ Google",
              icon: SvgPicture.asset(
                AppImages.googleIcon,
                fit: BoxFit.contain,
                width: 30,
              )),
        ),
      ],
    );
  }

  Widget _buildRadio({required String label, required String value}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          gender = value;
        });
      },
      child: Container(
        decoration: BoxDecoration(
            color: AppColors.white, 
            borderRadius: BorderRadius.circular(AppNumber.radiusMedium)
          ),
        padding: EdgeInsets.only(left: 15, top: 4, bottom: 4),
        child: Row(
          children: [
            Text(
              label,
              style: AppTextStyle.hintText,
            ),
            Spacer(),
            Radio(
              value: value,
              groupValue: gender,
              fillColor: MaterialStateProperty.resolveWith<Color?>(
                (Set<MaterialState> states) {
                  if (states.contains(MaterialState.selected)) {
                    return AppColors.primaryMain;
                  }
                  return AppColors.secondaryText;
                },
              ),
              onChanged: (value) {
                setState(() {
                  gender = value!;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
