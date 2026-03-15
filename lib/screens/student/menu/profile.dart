// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tamdansers_app/constants/app_colors.dart';
import 'package:tamdansers_app/constants/app_icon.dart';
import 'package:tamdansers_app/constants/app_number.dart';
import 'package:tamdansers_app/constants/text_style.dart';
import 'package:tamdansers_app/repositories/profile_repo.dart';
import 'package:tamdansers_app/repositories/user_repo.dart';
import 'package:tamdansers_app/routes/app_routes.dart';
import 'package:tamdansers_app/state/profile_image_state.dart';

class Profile extends StatefulWidget {
  final int userId;
  const Profile({super.key, required this.userId});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String imagePath = '';
  Map<String, dynamic>? user;
  final UserRepo _userRepo = UserRepo();
  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final fetchedUser = await _userRepo.getUserById(widget.userId);
    setState(() {
      user = fetchedUser;
    });
  }
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
        automaticallyImplyLeading: false,
        title: Text('ប្រវតិ្តរូប', style: AppTextStyle.sectionTitle20),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
            const SizedBox(height: 20),
            ImageProfile(userId: widget.userId),
            const SizedBox(height: 60),
            _buildInfoSection(user),
            const SizedBox(height: 24),
            _buildSettingsSection(context),
            const SizedBox(height: 16),
            _buildLogoutButton(context),
            const SizedBox(height: 24),
              
            ],
          ),
        ),
      ),
    );
  }
}

class ImageProfile extends StatefulWidget {
  final int userId;
  const ImageProfile({super.key, required this.userId});

  @override
  State<ImageProfile> createState() => _ImageProfileState();
}

class _ImageProfileState extends State<ImageProfile> {
  String imagePath = '';
  Map<String, dynamic>? user;
  final ProfileRepo _profileRepo = ProfileRepo();

  @override
  void initState() {
    super.initState();
    _loadImage();
    _loadUser();
  }
  Future<void> _loadImage() async {
    final savedImage = await _profileRepo.getImage(widget.userId);

    if (savedImage != null && savedImage.isNotEmpty) {
      final file = File(savedImage);

      if (await file.exists()) {
        setState(() {
          imagePath = savedImage;
        });
        ProfileImageState.updateImage(widget.userId, savedImage);
      }
    } 
  }

  Future<void> _loadUser() async {
    final fetchedUser = await UserRepo().getUserById(widget.userId);
    setState(() {
      user = fetchedUser;
    });
  }

  Future<void> dataChooseImg(ImageSource source) async {
    final picker = ImagePicker();

    final pickedImg = await picker.pickImage(
      source: source,
      imageQuality: 70,
    );

    if (pickedImg != null) {
      await _profileRepo.saveImage(pickedImg.path, widget.userId);

      setState(() {
        imagePath = pickedImg.path;
      });
    }
  }

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
                title: Text("ថតរូប",style: AppTextStyle.body,),
                onTap: () {
                  Navigator.pop(context);
                  dataChooseImg(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo, color: Colors.green),
                title: Text("ជ្រើសរើសពីថតរូប",style: AppTextStyle.body),
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
                    : null
              ),
              child: imagePath.isEmpty
                  ? Image.asset(
                    AppIcon.maleAvatar
                  )
                  : null,
            ),
            Material(
              color: AppColors.primary300,
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: showImageOptions,
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
        Text(
          (() {
            final first = user?['first_name'] ?? '';
            final last = user?['last_name'] ?? '';
            final full = ('$first $last').trim();
            return full.isNotEmpty ? full : 'រុន​ លីមហុង';
          })(),
          style: AppTextStyle.screenTitle24,
        ),
      ],
    );
  }
}

Widget _buildInfoSection(Map<String, dynamic>? user) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppNumber.cardPadding),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppNumber.radiusLarge),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _infoRow(Icons.email_outlined,user?['email'] ?? "មិនមានទិន្នន័យ"),
          const Divider(height: 24, thickness: 0.5),
          _infoRow(Icons.phone_outlined,user?['phone']??"មិនមានទិន្នន័យ"),
          const Divider(height: 24, thickness: 0.5),
          _infoRow(Icons.location_on_outlined, "ភ្នំពេញ, កម្ពុជា"),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String value) {
    return Row(
      children: [
        Icon(icon, color: AppColors.secondaryText, size: 20),
        const SizedBox(width: 12),
        Expanded(child: Text(value, style: AppTextStyle.body14)),
      ],
    );
  }

  Widget _buildSettingsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 10),
          child: Text("ការកំណត់", style: AppTextStyle.sectionTitle20),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppNumber.radiusLarge),
          ),
          child: Column(
            children: [
              _settingsTile(
                icon: Icons.link_outlined, 
                title: "សំណើភ្ជាប់របស់ឪពុកម្តាយ", 
                onTap: (){
                  Navigator.pushNamed(
                    context, 
                    AppRoutes.connectRequest
                  );
                }, 
                showDivider: true
              ),
              _settingsTile(
                icon: Icons.lock_outline_rounded,
                title: "ផ្លាស់ប្តូរពាក្យសម្ងាត់",
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.changePassword);
                },
                showDivider: true,
              ),
              _settingsTile(
                icon: Icons.settings_outlined,
                title: "ការកំណត់កម្មវិធី",
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.notifications);
                },
                showDivider: true,
              ),
              _settingsTile(
                icon: Icons.help_outline_rounded,
                title: "ជំនួយ & សេវាកម្ម",
                onTap: () {},
                showDivider: false,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _settingsTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required bool showDivider,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppNumber.radiusLarge),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Icon(icon, color: AppColors.secondaryText, size: 22),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(title, style: AppTextStyle.body14),
                ),
                const Icon(Icons.chevron_right,
                    color: AppColors.secondaryText, size: 20),
              ],
            ),
          ),
        ),
        if (showDivider)
          const Divider(height: 1, thickness: 0.5, indent: 52, endIndent: 0),
      ],
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () => _confirmLogout(context),
        icon:
            const Icon(Icons.logout_rounded, color: AppColors.error, size: 20),
        label: Text(
          "ចាកចេញ",
          style: AppTextStyle.subtitle16.copyWith(color: AppColors.error),
        ),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          side: const BorderSide(color: AppColors.error, width: 1.2),
          backgroundColor: AppColors.error.withValues(alpha: 0.05),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppNumber.radiusLarge),
          ),
        ),
      ),
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.backgroundLight,
        title: Text("ចាកចេញ?", style: AppTextStyle.subtitle18),
        content: Text(
          "តើអ្នកពិតជាចង់ចាកចេញពីគណនីនេះមែនទេ?",
          style: AppTextStyle.body14,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text("បោះបង់", style: AppTextStyle.bodyPrimary),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final pref = await SharedPreferences.getInstance();
              await pref.setBool("isLogin", false);
              await pref.remove("role");
              await pref.remove("userId");
              if (context.mounted) {
                Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(
                  AppRoutes.roleSelectionScreen,
                  (route) => false,
                );
              }
            },
            child: Text(
              "ចាកចេញ",
              style: AppTextStyle.subtitle16.copyWith(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

