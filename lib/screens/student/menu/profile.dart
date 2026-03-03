// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tamdansers_app/constants/app_colors.dart';
import 'package:tamdansers_app/constants/text_style.dart';
import 'package:tamdansers_app/routes/app_routes.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String imagePath = '';

  // ✅ Pick Image (Safe)
  Future<void> dataChooseImg(ImageSource source) async {
    final picker = ImagePicker();
    final pickedImg = await picker.pickImage(
      source: source,
      imageQuality: 70,
    );

    if (pickedImg != null) {
      setState(() {
        imagePath = pickedImg.path;
      });
    }
  }

  // ✅ BottomSheet 2 Option
  void showImageOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Colors.blue),
                title: const Text("Take Photo"),
                onTap: () {
                  Navigator.pop(context);
                  dataChooseImg(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo, color: Colors.green),
                title: const Text("Choose from Gallery"),
                onTap: () {
                  Navigator.pop(context);
                  dataChooseImg(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
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
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(height: 20),
              ImageProfile(),
              const SizedBox(height: 60),
              ProfileMenu(
                icon: Icons.person,
                iconBgColor: AppColors.primaryBg,
                iconColor: AppColors.primaryMain,
                title: 'ព័ត៍មានផ្ទាល់ខ្លួន',
                onTap: () {
                  Navigator.pushNamed(context, '/student_info_personal');
                },
              ),
              const SizedBox(height: 20),
              ProfileMenu(
                icon: Icons.lock,
                iconBgColor: AppColors.lightPink,
                iconColor: AppColors.pepure,
                title: 'ប្ដូរពាក្យសម្ងាត់',
                onTap: () {
                  Navigator.pushNamed(context, '/change_password');
                },
              ),
              const SizedBox(height: 20),
              ProfileMenu(
                icon: Icons.notifications,
                iconColor: AppColors.orange,
                iconBgColor: const Color.fromARGB(37, 252, 170, 88),
                title: 'ការជូនដំណឹង',
                onTap: () {
                  Navigator.pushNamed(context, '/notifications');
                },
              ),
              const SizedBox(height: 20),
              ProfileMenu(
                icon: Icons.logout,
                iconColor: AppColors.error,
                title: 'ចាកចេញ',
                showChevron: false,
                titleColor: AppColors.error,
                center: true,
                BgColor: AppColors.errorBG,
                onTap: () async {
                  final ok = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('ចាកចេញ?'),
                      content:
                          const Text('តើអ្នកពិតជាចង់ចាកចេញពីគណនីនេះមែនទេ?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, false),
                          child: const Text('បោះបង់'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, true),
                          child: Text('ចាកចេញ',
                              style: const TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                  );
                  if (ok == true && context.mounted) {
                    final pref = await SharedPreferences.getInstance();
                    await pref.setBool('isLogin', false);
                    await pref.remove('role');
                    if (context.mounted) {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        AppRoutes.roleSelectionScreen,
                        (route) => false,
                      );
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ImageProfile extends StatefulWidget {
  const ImageProfile({super.key});

  @override
  State<ImageProfile> createState() => _ImageProfileState();
}

class _ImageProfileState extends State<ImageProfile> {
  String imagePath = '';

  // ✅ Pick Image
  Future<void> dataChooseImg(ImageSource source) async {
    final picker = ImagePicker();
    final pickedImg = await picker.pickImage(
      source: source,
      imageQuality: 70,
    );

    if (pickedImg != null) {
      setState(() {
        imagePath = pickedImg.path;
      });
    }
  }

  // ✅ BottomSheet Options
  void showImageOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Colors.blue),
                title: const Text("Take Photo"),
                onTap: () {
                  Navigator.pop(context);
                  dataChooseImg(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo, color: Colors.green),
                title: const Text("Choose from Gallery"),
                onTap: () {
                  Navigator.pop(context);
                  dataChooseImg(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(width: 4, color: Colors.white),
                image: imagePath.isNotEmpty
                    ? DecorationImage(
                        image: FileImage(File(imagePath)),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: imagePath.isEmpty
                  ? const Icon(Icons.person, size: 60, color: Colors.grey)
                  : null,
            ),
            Material(
              color: AppColors.primary300,
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: showImageOptions, // 👈 call inside class
                child: const SizedBox(
                  width: 40,
                  height: 40,
                  child: Icon(
                    Icons.camera_alt_outlined,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text('Run Limhong', style: AppTextStyle.screenTitle24),
        Text('ID: 12345678', style: AppTextStyle.body),
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
  final Color? BgColor;
  const ProfileMenu(
      {super.key,
      required this.icon,
      this.iconBgColor,
      required this.iconColor,
      required this.title,
      required this.onTap,
      this.showChevron = true,
      this.center = false,
      this.titleColor,
      this.BgColor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: BgColor ?? AppColors.white,
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
