import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tamdansers_app/constants/app_colors.dart';
import 'package:tamdansers_app/constants/app_images.dart';
import 'package:tamdansers_app/constants/app_number.dart';
import 'package:tamdansers_app/constants/text_style.dart';
import 'package:tamdansers_app/constants/validators.dart';
import 'package:tamdansers_app/repositories/user_repo.dart';
import 'package:tamdansers_app/routes/app_routes.dart';
import 'package:tamdansers_app/widget/auth_field.dart';
import 'package:tamdansers_app/widget/custom_snackbar.dart';
import 'package:tamdansers_app/widget/primary_button.dart';

class ResetPasswordScreen extends StatefulWidget {
  final int userId;
  const ResetPasswordScreen({super.key, required this.userId});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  late TextEditingController newPasswordCtrl;
  late TextEditingController confirmPasswordCtrl;
  late GlobalKey<FormState> formKey;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    newPasswordCtrl = TextEditingController();
    confirmPasswordCtrl = TextEditingController();
    formKey = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    newPasswordCtrl.dispose();
    confirmPasswordCtrl.dispose();
    super.dispose();
  }

  void _resetPassword() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final success = await UserRepo().resetPassword(
        widget.userId,
        newPasswordCtrl.text,
      );

      if (success) {
        String? role = await UserRepo().getRoleById(widget.userId);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              content: CustomSnackbar(
                title: "ជោគជ័យ!",
                message: "ពាក្យសម្ងាត់ត្រូវបានកំណត់ឡើងវិញដោយជោគជ័យ។ សូមចូលប្រើប្រាស់។",
                icon: Icons.check_circle,
                color: AppColors.success,
              ),
            ),
          );
          await Future.delayed(const Duration(seconds: 2)); // Wait for snackbar to show
          if (mounted) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.loginScreen,
              (route) => false,
              arguments: role,
            );
          }
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            content: CustomSnackbar(
              title: "កំហុស!",
              message: "មានកំហុសកើតឡើង សូមព្យាយាមម្ដងទៀត",
              icon: Icons.close,
              color: AppColors.error,
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          content: CustomSnackbar(
            title: "កំហុស!",
            message: "មានកំហុសកើតឡើង សូមព្យាយាមម្ដងទៀត",
            icon: Icons.close,
            color: AppColors.error,
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
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
          ),
        ),
        elevation: 0,
        surfaceTintColor: AppColors.transparent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.2,
                  child: SvgPicture.asset(
                    AppImages.appLogoblue,
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: 30),
                Center(
                  child: Text(
                    "បង្កើតពាក្យសម្ងាត់ថ្មី",
                    style: AppTextStyle.sectionTitle20,
                  ),
                ),
                SizedBox(height: 20),
                AuthField(
                  hintText: "ពាក្យសម្ងាត់ថ្មី",
                  icon: Icon(
                    Icons.lock_outline_rounded,
                    size: 20,
                    color: AppColors.secondaryText,
                  ),
                  isPwd: true,
                  textController: newPasswordCtrl,
                  validator: Validators.password,
                ),
                SizedBox(height: 20),
                AuthField(
                  hintText: "បញ្ចាក់ពាក្យសម្ងាត់ថ្មី",
                  icon: Icon(
                    Icons.lock_outline_rounded,
                    size: 20,
                    color: AppColors.secondaryText,
                  ),
                  isPwd: true,
                  textController: confirmPasswordCtrl,
                  validator: (value) {
                    return Validators.cnfPassword(value, newPasswordCtrl.text);
                  },
                ),
                SizedBox(height: 20),
                PrimaryButton(
                  label: isLoading ? "កំពុងដំណើរការ..." : "កំណត់ពាក្យសម្ងាត់",
                  backgroundColor: AppColors.primaryMain,
                  foregroundColor: AppColors.white,
                  onPressed: isLoading ? () {} : _resetPassword,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}