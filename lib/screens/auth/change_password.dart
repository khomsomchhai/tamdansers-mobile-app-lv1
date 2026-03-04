import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tamdansers_app/constants/app_colors.dart';
import 'package:tamdansers_app/constants/app_number.dart';
import 'package:tamdansers_app/constants/text_style.dart';
import 'package:tamdansers_app/constants/validators.dart';
import 'package:tamdansers_app/repositories/user_repo.dart';
import 'package:tamdansers_app/widget/auth_field.dart';
import 'package:tamdansers_app/widget/custom_snackbar.dart';
import 'package:tamdansers_app/widget/primary_button.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {

  late TextEditingController oldPasswordCtrl;
  late TextEditingController newPasswordCtrl;
  late TextEditingController confirmPasswordCtrl;
  late GlobalKey<FormState> formKey;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    oldPasswordCtrl = TextEditingController();
    newPasswordCtrl = TextEditingController();
    confirmPasswordCtrl = TextEditingController();
    formKey = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    oldPasswordCtrl.dispose();
    newPasswordCtrl.dispose();
    confirmPasswordCtrl.dispose();
    super.dispose();
  }

  void _changePassword() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final pref = await SharedPreferences.getInstance();
      final userId = pref.getInt('id');

      if (userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            content: CustomSnackbar(
              title: "កំហុស!",
              message: "មិនបានរកឃើញលម្អិតគណនី សូមចូលប្រើប្រាស់ម្ដងទៀត",
              icon: Icons.close,
              color: AppColors.error,
            ),
          ),
        );
        return;
      }

      final success = await UserRepo().changePassword(
        userId,
        oldPasswordCtrl.text,
        newPasswordCtrl.text,
      );

      if (success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              content: CustomSnackbar(
                title: "ជោគជ័យ!",
                message: "ពាក្យសម្ងាត់ត្រូវបានផ្លាស់ប្តូរដោយជោគជ័យ",
                icon: Icons.check_circle,
                color: AppColors.success,
              ),
            ),
          );
          Navigator.pop(context);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            content: CustomSnackbar(
              title: "មិនត្រឹមត្រូវ!",
              message: "ពាក្យសម្ងាត់ចាស់មិនត្រឹមត្រូវ។ សូមព្យាយាមម្ដងទៀត",
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
        title: Text(
          "ប្ដូរពាក្យសម្ងាត់",
          style: AppTextStyle.sectionTitle20,
        ),
        centerTitle: true,
        elevation: 0,
        surfaceTintColor: AppColors.transparent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 20,
          ),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AuthField(
                  hintText: "ពាក្យសម្ងាត់បច្ចុប្បន្ន",
                  icon: Icon(
                    Icons.lock_outline_rounded,
                    size: 20,
                    color: AppColors.secondaryText,
                  ),
                  isPwd: true,
                  textController: oldPasswordCtrl,
                  validator: Validators.password
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
                SizedBox(height: 12,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        
                      },
                      child: Text(
                        "ភ្លេចពាក្យសម្ងាត់",
                        style: AppTextStyle.bodyPrimary,
                      ),
                    ),
                  ],
                ),
                SizedBox(height:20),
                PrimaryButton(
                  label: isLoading ? "កំពុងដំណើរការ..." : "បន្ទាប់",
                  backgroundColor: AppColors.primaryMain,
                  foregroundColor: AppColors.white,
                  onPressed: isLoading ? () {} : _changePassword,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}