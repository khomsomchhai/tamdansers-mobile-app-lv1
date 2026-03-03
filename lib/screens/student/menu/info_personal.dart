// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tamdansers_app/constants/app_colors.dart';
import 'package:tamdansers_app/constants/text_style.dart';
import 'package:tamdansers_app/screens/student/menu/profile.dart';

class InfoPersonal extends StatefulWidget {
  const InfoPersonal({super.key});

  @override
  State<InfoPersonal> createState() => _InfoPersonalState();
}

class _InfoPersonalState extends State<InfoPersonal> {
  String imagePath = '';
  void dataChooseImg(ImageSource source) async {
    var image = ImagePicker();

    var pickedImg = await image.pickImage(source: source);

    setState(() {
      imagePath = pickedImg!.path;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ព័ត៌មានផ្ទាល់ខ្លួន', style: AppTextStyle.screenTitle24),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 20),
              ImageProfile(),
              SizedBox(height: 30),
              Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  color: AppColors.white,
                  child: Column(
                    children: [
                      MenuInfo(
                        subtitle: 'Run Limhong',
                        title: 'ឈ្មោះពេញ',
                        icon: Icons.person,
                        iconBgColor: AppColors.primaryBg,
                        iconColor: AppColors.primaryMain,
                      ),
                      Divider(),
                      MenuInfo(
                        subtitle: '0006042',
                        title: 'អត្តលេខ',
                        icon: Icons.credit_card_outlined,
                        iconBgColor: AppColors.lightPink,
                        iconColor: AppColors.pepure,
                      ),
                      Divider(),
                      MenuInfo(
                        subtitle: 'ប្រុស',
                        title: 'ភេទ',
                        icon: Icons.girl_outlined,
                        iconBgColor: AppColors.errorBG,
                        iconColor: AppColors.error,
                      ),
                      Divider(),
                      MenuInfo(
                        subtitle: '02-12-2004',
                        title: 'ថ្ងៃខែឆ្នាំកំណើត',
                        icon: Icons.calendar_month,
                        iconBgColor: AppColors.successBG,
                        iconColor: AppColors.success,
                      ),
                      Divider(),
                      MenuInfo(
                        subtitle: '098494201',
                        title: 'លេខទូរស័ព្ទ',
                        icon: Icons.phone,
                        iconBgColor: AppColors.primaryBg,
                        iconColor: AppColors.primary400,
                      ),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

class MenuInfo extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color? iconColor;
  final String subtitle;
  final Color? iconBgColor;
  const MenuInfo({
    super.key,
    required this.title,
    required this.icon,
    required this.subtitle,
    this.iconColor,
    this.iconBgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(shape: BoxShape.circle, color: iconBgColor),
          child: Icon(
            icon,
            size: 20,
            color: iconColor,
          ),
        ),
        title: Text(title, style: AppTextStyle.hintText),
        subtitle: Text(subtitle,
            style: AppTextStyle.body.copyWith(fontWeight: FontWeight.bold)),
      ),
    );
  }
}
