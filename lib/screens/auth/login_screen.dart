import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tamdansers_app/constants/app_colors.dart';
import 'package:tamdansers_app/constants/app_images.dart';
import 'package:tamdansers_app/constants/app_number.dart';
import 'package:tamdansers_app/constants/text_style.dart';
import 'package:tamdansers_app/constants/validators.dart';
import 'package:tamdansers_app/repositories/user_repo.dart';
import 'package:tamdansers_app/routes/app_routes.dart';
import 'package:tamdansers_app/widget/auth_field.dart';
import 'package:tamdansers_app/widget/button_with_icon.dart';
import 'package:tamdansers_app/widget/custom_snackbar.dart';
import 'package:tamdansers_app/widget/primary_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var identifierCtrl = TextEditingController();
  var pwdCtrl = TextEditingController();
  var formKey = GlobalKey<FormState>();
  bool isCheck = false;
  var selectedRole = "";
  void login() async {
    var user = await UserRepo().login(identifierCtrl.text, pwdCtrl.text);
    if(user == null){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 16), // 👈 smaller horizontal margin
          content: CustomSnackbar(
            title: "មិនត្រឹមត្រូវ!", 
            message: "អ៊ីម៉ែល ឬ លេខទូរស័ព្ទ និងពាក្យសម្ងាត់មិនត្រឺមត្រូវ។ សូមព្យាយាមម្ដងទៀត", 
            icon: Icons.close, 
            color: AppColors.error
          )
        ),
      );
      return;
    }
    var pref = await SharedPreferences.getInstance();
    pref.setString("role", user["role"]);
    pref.setBool("isLogin", true);
    if(user["role"] == "teacher"){
      Navigator.pushReplacementNamed(
        context, 
        AppRoutes.teacherDashboard,
      );
    } else if(user["role"] == "student"){
      Navigator.pushReplacementNamed(
        context, 
        AppRoutes.studentFirstScreen,
      );
    } else if(user["role"] == "parent"){
      Navigator.pushReplacementNamed(
        context, 
        AppRoutes.parentFirstScreen,
      );
    }

  }
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    final role = ModalRoute.of(context)!.settings.arguments as String?;
    if(role != null){
      setState(() {
        selectedRole = role;
      });
    }
    
    }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: Navigator.canPop(context)
            ? IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: AppColors.primaryText,
                  size: AppNumber.iconMedium,
                ),
              )
            : null,
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
        SizedBox(
          height: 16,
        ),
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
            textController: identifierCtrl,
            hintText: "បញ្ចូលអ៊ីម៉ែល ឬ លេខទូរស័ព្ទរបស់អ្នក",
            icon: Icon(
              Icons.email_outlined,
              size: 20,
              color: AppColors.secondaryText,
            ),
          ),
          SizedBox(
            height: 16,
          ),
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
          SizedBox(
            height: 8,
          ),
          PrimaryButton(
            label: "ចូលគណនី",
            backgroundColor: AppColors.primaryMain,
            foregroundColor: AppColors.white,
            onPressed: () {
              if (formKey.currentState!.validate()) {
                login();
              }
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
              "មិនទាន់មានគណនីមែនទេ?",
              style: AppTextStyle.body,
            ),
            SizedBox(
              width: 10,
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                  context, 
                  AppRoutes.signUpScreen,
                  arguments: selectedRole
                );
              },
              child: Text(
                "ចុះឈ្មោះ",
                style: GoogleFonts.kantumruyPro(
                    fontSize: 16, color: AppColors.primaryMain),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 8,
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
          height: 15,
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
}
