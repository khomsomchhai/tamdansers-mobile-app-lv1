import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tamdansers_app/constants/app_colors.dart';
import 'package:tamdansers_app/constants/app_images.dart';
import 'package:tamdansers_app/constants/app_number.dart';
import 'package:tamdansers_app/constants/text_style.dart';
import 'package:tamdansers_app/constants/validators.dart';
import 'package:tamdansers_app/widget/auth_field.dart';
import 'package:tamdansers_app/widget/custom_dialog.dart';
import 'package:tamdansers_app/widget/primary_button.dart';

class ParentConnectStudent extends StatefulWidget {
  const ParentConnectStudent({super.key});

  @override
  State<ParentConnectStudent> createState() => _ParentConnectStudentState();
}

class _ParentConnectStudentState extends State<ParentConnectStudent> {
  var formKey = GlobalKey<FormState>();
  var invCodeCtrl = TextEditingController();

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
          "ភ្ជាប់គណនីសិស្ស",
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
                SizedBox(height: 16,),
                _buildForm(),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: 
        Padding(
          padding: const EdgeInsets.all(20),
          child: PrimaryButton(
            label: "ដាក់ស្នើរ",
            backgroundColor: AppColors.primaryMain, 
            foregroundColor: AppColors.white, 
            onPressed: (){
              if(formKey.currentState!.validate()){
                showDialog(
                  context: context, 
                  builder: (context) => 
                  CustomDialog(
                    label: "យល់ព្រម", 
                    title: "សំណើរត្រូវបានដាក់ស្នើរ", 
                    description: "សូមរង់ចាំការទទួលសំណើរពីសិស្ស។ អ្នកនឹងទទួលបានការជូនដំណឹងនៅពេលដែលសំណើរបស់អ្នកត្រូវបានទទួល ឬ បដិសេធ។", 
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                );
              }
              
            }
          ),
        ),
    );
  }

  Widget _buildHeader(){
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height*0.30,
          child: SvgPicture.asset(
            AppImages.connection
          ),
        ),
        SizedBox(height: 20,),
        Text(
          "ភ្ជាប់ទៅកាន់គណនីរបស់សិស្ស",
          style: AppTextStyle.sectionTitle20,
        ),
        SizedBox(height: 16,),
        Center(
          child: Text(
            "សូមបញ្ចូលអ៊ីម៉ែល ឬ លេខទូរស័ព្ទរបស់សិស្សដែលអ្នកចង់ភ្ជាប់។ អ៊ីម៉ែល ឬ លេខទូរស័ព្ទដែលបានចុះឈ្មោះជាមួយគណនីសិស្សរួចហើយ។",
            style: AppTextStyle.body,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  _buildForm(){
    return Column(
      children: [
        AuthField(
          hintText: "អ៊ីម៉ែល ឬ លេខទូរស័ព្ទរបស់សិស្ស", 
          icon: Icon(
            Icons.email_outlined, 
            color: AppColors.secondaryText,
          ), 
          textController: invCodeCtrl,
          validator: Validators.emailOrPhone,
        ),
        SizedBox(height: 10,)
      ],
    );
  }
}