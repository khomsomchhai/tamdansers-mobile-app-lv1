// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tamdansers_app/constants/app_colors.dart';
import 'package:tamdansers_app/constants/text_style.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}


class _ProfileState extends State<Profile> {
Future<void> getLostData() async {
  final ImagePicker picker = ImagePicker();
  final LostDataResponse response = await picker.retrieveLostData();

  if (response.isEmpty) {
    return;
  }

  final List<XFile>? files = response.files;

  if (files != null) {
    _handleLostFiles(files);
  } else {
    _handleError(response.exception);
  }
}

void _handleLostFiles(List<XFile> files) {
  print("Recovered files: $files");
}

void _handleError(Object? error) {
  print("Error: $error");
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('គណនីអាខោន', style: AppTextStyle.screenTitle24),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              children: [
                SizedBox(height: 20),
                ImageProfile(onCameraTap: () {
                  getLostData();
                },),
                SizedBox(height: 60),
                ProfileMenu(
                  icon: Icons.person,
                  iconBgColor: AppColors.primaryBg,
                  iconColor: AppColors.primaryMain,
                  title: 'ព័ត៍មានផ្ទាល់ខ្លួន',
                  onTap: () {
                    Navigator.pushNamed(context, '/student_info_personal');
                    
                  },
                ),
                SizedBox(height: 20),
                ProfileMenu(
                  icon: Icons.lock,
                  iconBgColor: AppColors.lightPink,
                  iconColor: AppColors.pepure,
                  title: 'ប្ដូរពាក្យសម្ងាត់',
                  onTap: () {
                    Navigator.pushNamed(context, '/change_password');
                  },
                ),
                SizedBox(height: 20),
                ProfileMenu(
                  icon: Icons.person,
                  iconBgColor: AppColors.primaryBg,
                  iconColor: AppColors.primaryMain,
                  title: 'ព័ត៍មានផ្ទាល់ខ្លួន',
                  onTap: () {},
                ),
                SizedBox(height: 20),
                ProfileMenu(
                  icon: Icons.logout,
                  // iconBgColor: AppColors.lightPink,
                  iconColor: AppColors.error,
                  title: 'ចាកចេញ',
                  showChevron: false,
                  titleColor: AppColors.error,
                  center: true,
                  onTap: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ImageProfile extends StatelessWidget {
  final VoidCallback onCameraTap;
  const ImageProfile({
    super.key,
    required this.onCameraTap
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(alignment: Alignment.bottomRight, children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(width: 4, color: Colors.white),
                image: DecorationImage(
                    image: AssetImage('assets/images/mylove.jpg'),
                    fit: BoxFit.cover)),
          ),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary300,
            ),
            child: IconButton(
              onPressed: () {
                onCameraTap();
              },
              padding: EdgeInsets.zero,
              icon: Icon(Icons.camera_alt_outlined,
                  color: AppColors.white),
            ),
          )
        ]),
        SizedBox(height: 10),
        Text('Run Limhong', style: AppTextStyle.screenTitle24),
        Text('ID: 12345678', style: AppTextStyle.body),
        SizedBox(height: 10),
        Container(
          width: 120,
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.primaryBg,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'ថ្នាក់ទី 8A',
            style: AppTextStyle.body
                .copyWith(color: AppColors.primaryMain),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}

class ProfileMenu extends StatelessWidget {
  final IconData icon;
  final Color? iconBgColor;
  final Color iconColor;
  final String title;
  final VoidCallback onTap;
  final bool showChevron;
  final bool center;
  final Color? titleColor;
  const ProfileMenu(
      {super.key,
      required this.icon,
      this.iconBgColor,
      required this.iconColor,
      required this.title,
      required this.onTap,
      this.showChevron = true,
      this.center = false,
      this.titleColor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment:
              center ? MainAxisAlignment.center : MainAxisAlignment.start,
          children: [
            Container(
              width: 50,
              height: 50,
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconBgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor),
            ),
            SizedBox(width: 16),
            Text(title,
                style: AppTextStyle.sectionTitle20
                    .copyWith(color: titleColor ?? Colors.black)),
            if (!center) const Spacer(),
            if (!center && showChevron)
              Icon(Icons.chevron_right, color: AppColors.secondaryText),
          ],
        ),
      ),
    );
  }
}
