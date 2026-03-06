import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tamdansers_app/constants/app_colors.dart';
import 'package:tamdansers_app/constants/app_images.dart';
import 'package:tamdansers_app/constants/app_number.dart';
import 'package:tamdansers_app/constants/text_style.dart';
import 'package:tamdansers_app/constants/validators.dart';
import 'package:tamdansers_app/repositories/class_repo.dart';
import 'package:tamdansers_app/repositories/user_repo.dart';
import 'package:tamdansers_app/widget/auth_field.dart';
import 'package:tamdansers_app/widget/primary_button.dart';

class JoinClassScreen extends StatefulWidget {
  final int userId;
  const JoinClassScreen({super.key, required this.userId});

  @override
  State<JoinClassScreen> createState() => _JoinClassScreenState();
}

class _JoinClassScreenState extends State<JoinClassScreen> {
  var classCodeCtrl = TextEditingController();
  var formKey = GlobalKey<FormState>();

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
          "ចូលថ្នាក់រៀន",
          style: AppTextStyle.sectionTitle20,
        ),
        centerTitle: true,
        elevation: 0,
        surfaceTintColor: AppColors.transparent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                _buildHeader(),
                SizedBox(
                  height: 30,
                ),
                _buildForm(),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: PrimaryButton(
            label: "ចូល",
            backgroundColor: AppColors.primaryMain,
            foregroundColor: AppColors.white,
            onPressed: () async {
              try {
                if (formKey.currentState!.validate()) {
                  // Join class
                  final classData = await ClassRepo().getClassByCode(classCodeCtrl.text.trim());
                  if (classData != null) {
                    final success = await UserRepo().joinClass(widget.userId, classData['id']);
                    if (success) {
                      Navigator.pop(context, true); // Go back to first screen with success
                    } else {
                      // Show error
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to join class')),
                      );
                    }
                  } else {
                    // Invalid code
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Invalid class code')),
                    );
                  }
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: $e')),
                );
              }
            }),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.30,
          child: SvgPicture.asset(AppImages.joinClass),
        ),
        SizedBox(
          height: 40,
        ),
        Text(
          "ចូលរួមថ្នាក់ថ្មី",
          style: AppTextStyle.sectionTitle20,
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          "សូមបញ្ចូលលេខកូដដែលគ្រូបន្ទុកថ្នាក់បានផ្ដល់ឱ្យ",
          style: AppTextStyle.body,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  _buildForm() {
    return Column(
      children: [
        AuthField(
          hintText: "លេខកូដថ្នាក់",
          icon: Icon(
            Icons.key_outlined,
            color: AppColors.secondaryText,
          ),
          textController: classCodeCtrl,
          validator: Validators.classCode,
        ),
        SizedBox(
          height: 10,
        )
      ],
    );
  }
}
