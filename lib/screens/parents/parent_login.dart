import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tamdansers_app/constants/app_colors.dart';
import 'package:tamdansers_app/constants/app_images.dart';
import 'package:tamdansers_app/constants/text_style.dart';
import 'package:tamdansers_app/routes/app_routes.dart';
import 'package:tamdansers_app/widget/auth_field.dart';
import 'package:tamdansers_app/widget/button_with_icon.dart';
import 'package:tamdansers_app/widget/primary_button.dart';

class ParentLogin extends StatefulWidget {
  const ParentLogin({super.key});

  @override
  State<ParentLogin> createState() => _ParentLoginState();
}

class _ParentLoginState extends State<ParentLogin> {
  final emailCtrl = TextEditingController();
  final pwdCtrl = TextEditingController();
  final formKey = GlobalKey<FormState>();

  bool isCheck = false;
  AutovalidateMode _autoValidate = AutovalidateMode.disabled;

  String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "សូមបញ្ចូលអ៊ីម៉ែល";
    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return "អ៊ីម៉ែលមិនត្រឹមត្រូវ";
    }
    return null;
  }

  String? pwdValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "សូមបញ្ចូលពាក្យសម្ងាត់";
    } else if (!RegExp(
            r'^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*[!@#$%^&*()_+{}\[\]:;<>,.?~\\-])(.{8,})$')
        .hasMatch(value)) {
      return "ពាក្យសម្ងាត់មិនត្រឹមត្រូវ";
    }
    return null;
  }

  @override
  void dispose() {
    emailCtrl.dispose();
    pwdCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: true, // ✅ prevent overflow when keyboard shows
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.primaryText,
          ),
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      _buildHeader(size),
                      const SizedBox(height: 20),
                      _buildForm(),
                      const Spacer(),
                      _buildFooter(),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            );
          },
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
            AppImages.imgParent,
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(height: 15),
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
      autovalidateMode: _autoValidate,
      child: Column(
        children: [
          AuthField(
            validator: emailValidator,
            textController: emailCtrl,
            hintText: "បញ្ចូលអ៊ីម៉ែលរបស់អ្នក",
            icon: Icon(
              Icons.email_outlined,
              size: 20,
              color: AppColors.secondaryText,
            ),
          ),
          const SizedBox(height: 24),
          AuthField(
            validator: pwdValidator,
            textController: pwdCtrl,
            hintText: "បញ្ចូលពាក្យសម្ងាត់របស់អ្នក",
            icon: Icon(
              Icons.lock_outline_rounded,
              size: 20,
              color: AppColors.secondaryText,
            ),
            isPwd: true,
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Checkbox(
                value: isCheck,
                activeColor: AppColors.primaryMain,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                onChanged: (value) {
                  setState(() => isCheck = value ?? false);
                },
              ),
              Text(
                "ចងចាំ",
                style: AppTextStyle.body,
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  // TODO: Forgot password
                },
                child: Text(
                  "ភ្លេចពាក្យសម្ងាត់?",
                  style: GoogleFonts.kantumruyPro(
                    fontSize: 16,
                    color: AppColors.primaryMain,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          PrimaryButton(
            label: "ចូលគណនី",
            backgroundColor: AppColors.primaryMain,
            foregroundColor: AppColors.white,
            onPressed: () {
              final isValid = formKey.currentState?.validate() ?? false;

              // ✅ after first submit, validate as user types
              setState(() {
                _autoValidate = AutovalidateMode.onUserInteraction;
              });

              if (isValid) {
                // TODO: handle login
                Navigator.pushNamed(context, AppRoutes.parentDashboardScreen);
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
            const SizedBox(width: 10),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.signUpTeacherScreen,
                );
              },
              child: Text(
                "banចុះឈ្មោះ",
                style: GoogleFonts.kantumruyPro(
                  fontSize: 16,
                  color: AppColors.primaryMain,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                height: 1,
                decoration: BoxDecoration(
                  color: AppColors.secondaryText,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Text("ឬ", style: AppTextStyle.body),
            const SizedBox(width: 10),
            Expanded(
              child: Container(
                height: 1,
                decoration: BoxDecoration(
                  color: AppColors.secondaryText,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        SizedBox(
          width: double.infinity,
          child: ButtonWithIcon(
            onPressed: () {
              // TODO: connect Telegram
            },
            label: "ភ្ចាប់ជាមួយ Telegram",
            icon: Icon(
              Icons.telegram_outlined,
              size: 30,
              color: AppColors.primaryMain,
            ),
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: ButtonWithIcon(
            onPressed: () {
              // TODO: connect Google
            },
            label: "ភ្ចាប់ជាមួយ Google",
            icon: SvgPicture.asset(
              AppImages.googleIcon,
              fit: BoxFit.contain,
              width: 30,
            ),
          ),
        ),
      ],
    );
  }
}
