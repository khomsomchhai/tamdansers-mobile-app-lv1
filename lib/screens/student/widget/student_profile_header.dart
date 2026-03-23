import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tamdansers_app/constants/app_colors.dart';
import 'package:tamdansers_app/constants/app_icon.dart';
import 'package:tamdansers_app/constants/app_images.dart';
import 'package:tamdansers_app/constants/app_number.dart';
import 'package:tamdansers_app/constants/text_style.dart';
import 'package:tamdansers_app/repositories/profile_repo.dart';
import 'package:tamdansers_app/routes/app_routes.dart';
import 'package:tamdansers_app/state/profile_image_state.dart';

class StudentProfileHeader extends StatefulWidget {
  final Map<String, dynamic>? user;
  const StudentProfileHeader({super.key, this.user});

  @override
  State<StudentProfileHeader> createState() => _StudentProfileHeaderState();
}

class _StudentProfileHeaderState extends State<StudentProfileHeader> {
  String? imagePath;
  final ProfileRepo _profileRepo = ProfileRepo();

  @override
  void initState() {
    super.initState();
    _loadImage();
    ProfileImageState.notifier.addListener(_onImageChanged);
  }

  @override
  void didUpdateWidget(covariant StudentProfileHeader oldWidget) {
    super.didUpdateWidget(oldWidget);
    final oldId = oldWidget.user?['id'];
    final newId = widget.user?['id'];
    if (newId != null && newId != oldId) {
      _loadImage();
    }
  }

  @override
  void dispose() {
    ProfileImageState.notifier.removeListener(_onImageChanged);
    super.dispose();
  }

  void _onImageChanged() {
    if (widget.user != null && widget.user!['id'] != null) {
      final newImage = ProfileImageState.getImage(widget.user!['id']);
      if (mounted) {
        setState(() {
          imagePath = newImage;
        });
      }
    }
  }

  Future<void> _loadImage() async {
    if (widget.user != null && widget.user!['id'] != null) {
      final savedImage = await _profileRepo.getImage(widget.user!['id']);
      if (mounted) {
        setState(() {
          imagePath = savedImage;
        });
      }
      ProfileImageState.updateImage(widget.user!['id'], savedImage);
    }
  }
  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.backgroundLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppNumber.radiusLarge),
        ),
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
                Navigator.pushNamedAndRemoveUntil(
                  context,
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
  @override
  Widget build(BuildContext context) {
    ImageProvider? backgroundImage;
    if (imagePath != null && imagePath!.isNotEmpty) {
      backgroundImage = FileImage(File(imagePath!));
    } else {
      backgroundImage = AssetImage(
        (() {
          final g = (widget.user?['gender'] ?? '').toString().toLowerCase();
          if (g.contains('f') || g.contains('female')) return AppIcon.femaleAvatar;
          return AppIcon.maleAvatar;
        })(),
      );
    }
    return Row(
      children: [
        GestureDetector(
          onTap: () => _confirmLogout(context),
          child: CircleAvatar(
            radius: AppNumber.avatarSmall,
            backgroundColor: AppColors.white,
            backgroundImage: backgroundImage,
          ),
        ),
        SizedBox(width: 10,),
        Text(
          (() {
            final first = widget.user?['first_name'] ?? '';
            final last = widget.user?['last_name'] ?? '';
            final full = ('$first $last').trim();
            return full.isNotEmpty ? full : 'រុន​ លីមហុង';
          })(),
          style: AppTextStyle.subtitle18
        ),
        Spacer(),
        SvgPicture.asset(
          AppImages.notification,
          height: AppNumber.iconSmall,
        )
      ],
    );
  }
}