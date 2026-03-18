import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'
    show SharedPreferences;
import 'package:tamdansers_app/constants/app_icon.dart';

import '../../../constants/app_colors.dart' show AppColors;
import '../../../constants/app_number.dart' show AppNumber;
import '../../../constants/class_child.dart' show ChildCard;
import '../../../constants/text_style.dart' show AppTextStyle;
import '../../../routes/app_routes.dart' show AppRoutes;

class ParentSetting extends StatefulWidget {
  const ParentSetting({super.key});

  @override
  State<ParentSetting> createState() => _ParentSettingState();
}

class _ParentSettingState extends State<ParentSetting> {
  double _fs(double base, BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return base * (width / 390).clamp(0.78, 1.15);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppColors.backgroundLight,
        appBar: AppBar(
          backgroundColor: AppColors.backgroundLight,
          elevation: 0,
          title: Text(
            "ប្រវត្តិរូប",
            style: AppTextStyle.sectionTitle20
                .copyWith(fontSize: _fs(20, context)),
          ),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(AppNumber.screenPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfileHeader(),
              const SizedBox(height: 24),
              _rowIconText("កូនៗរបស់អ្នក"),
              const SizedBox(height: 15),
              _buildChildrenRow(),
              const SizedBox(height: 24),
              _buildInfoSection(),
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

  Widget _buildProfileHeader() {
    return Center(
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primaryMain, width: 3),
                  image: DecorationImage(
                    image: AssetImage(AppIcon.profileParent),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.primaryMain,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Icon(
                    Icons.edit,
                    size: 14,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            "Lay Heng",
            style: AppTextStyle.sectionTitle20.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: AppNumber.sectionPadding,
                vertical: AppNumber.spacingSmall),
            decoration: BoxDecoration(
              color: AppColors.primaryMain.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppNumber.radiusRounded),
            ),
            child: Text("Parent / July",
                style: AppTextStyle.caption14Secondary
                    .copyWith(color: AppColors.link)),
          ),
        ],
      ),
    );
  }

  Widget _rowIconText(String text) {
    return Text(
      text,
      style: AppTextStyle.fontsize18.copyWith(
        fontWeight: FontWeight.w600,
        fontSize: _fs(18, context),
      ),
    );
  }

  Widget _buildChildrenRow() {
    return SizedBox(
      height: 205,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          const ChildCard(
            name: "Leo Jenkins",
            grade: "Grade 5",
            attendance: 98,
            progressColor: Color(0xFF1E88E5),
            imageUrl: "https://cdn-icons-png.flaticon.com/512/4140/4140048.png",
          ),
          const SizedBox(width: 16),
          const ChildCard(
            name: "Mia Jenkins",
            grade: "Grade 2",
            attendance: 92,
            progressColor: Color(0xFF22C55E),
            imageUrl: "https://cdn-icons-png.flaticon.com/512/6997/6997662.png",
          ),
          const SizedBox(width: 16),
          addChildCard(),
        ],
      ),
    );
  }

  Widget addChildCard() {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, AppRoutes.parentConnectStudent);
      },
      child: Container(
        width: 110,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: const Color(0xFFD9D9D9),
          ),
        ),
        child: Center(
          child: Text(
            "Add",
            style: AppTextStyle.subtitle16.copyWith(
              color: const Color(0xFF9CA3AF),
              fontSize: _fs(16, context),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoSection() {
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
          _infoRow(Icons.email_outlined, "Henglay@school.edu.kh"),
          const Divider(height: 24, thickness: 0.5),
          _infoRow(Icons.phone_outlined, "+855 12 345 678"),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String value) {
    return Row(
      children: [
        Icon(icon, color: AppColors.secondaryText, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Text(value, style: AppTextStyle.body14),
        ),
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
                icon: Icons.lock_outline_rounded,
                title: "ប្ដូរពាក្យសម្ងាត់",
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.changePassword);
                },
                showDivider: true,
              ),
              _settingsTile(
                icon: Icons.settings_outlined,
                title: "ការកំណត់ទូទៅ",
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.notifications);
                },
                showDivider: true,
              ),
              _settingsTile(
                icon: Icons.help_outline_rounded,
                title: "ជំនួយ & គាំទ្រ",
                onTap: () {},
                showDivider: true,
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
                const Icon(
                  Icons.chevron_right,
                  color: AppColors.secondaryText,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
        if (showDivider)
          const Divider(
            height: 1,
            thickness: 0.5,
            indent: 52,
            endIndent: 0,
          ),
      ],
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () => _confirmLogout(context),
        icon: const Icon(
          Icons.logout_rounded,
          color: AppColors.error,
          size: 20,
        ),
        label: Text(
          "Logout",
          style: AppTextStyle.subtitle16.copyWith(color: AppColors.error),
        ),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          side: const BorderSide(color: AppColors.error, width: 1.2),
          backgroundColor: AppColors.error.withOpacity(0.05),
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppNumber.radiusLarge),
        ),
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
                Navigator.of(context, rootNavigator: true)
                    .pushNamedAndRemoveUntil(
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

  // void showPartnerDialog(BuildContext context) {
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return Dialog(
  //         backgroundColor: AppColors.backgroundLight,
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(20),
  //         ),
  //         child: Padding(
  //           padding: const EdgeInsets.all(20),
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               const Text(
  //                 "តំណរភ្ជាប់សិស្ស",
  //                 style: TextStyle(
  //                   fontSize: 18,
  //                   fontWeight: FontWeight.bold,
  //                 ),
  //               ),
  //               const SizedBox(height: 20),
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: [
  //                   Column(
  //                     children: [
  //                       Container(
  //                         width: 60,
  //                         height: 60,
  //                         decoration: BoxDecoration(
  //                           color: Colors.green.shade100,
  //                           borderRadius: BorderRadius.circular(15),
  //                         ),
  //                         child: const Icon(Icons.person, size: 35),
  //                       ),
  //                       const SizedBox(height: 5),
  //                       const Text("អ្នក"),
  //                     ],
  //                   ),
  //                   const SizedBox(width: 10),
  //                   const Icon(Icons.link, color: Colors.blue),
  //                   const SizedBox(width: 10),
  //                   Column(
  //                     children: [
  //                       Container(
  //                         width: 60,
  //                         height: 60,
  //                         decoration: BoxDecoration(
  //                           color: Colors.green.shade100,
  //                           borderRadius: BorderRadius.circular(30),
  //                         ),
  //                         child: const Center(
  //                           child: Text(
  //                             "S for\nParent",
  //                             textAlign: TextAlign.center,
  //                             style: TextStyle(fontSize: 10),
  //                           ),
  //                         ),
  //                       ),
  //                       const SizedBox(height: 5),
  //                       const Text("ដៃគូ"),
  //                     ],
  //                   ),
  //                 ],
  //               ),
  //               const SizedBox(height: 25),
  //               SizedBox(
  //                 width: double.infinity,
  //                 child: ElevatedButton(
  //                   onPressed: () {},
  //                   style: ElevatedButton.styleFrom(
  //                     backgroundColor: AppColors.error,
  //                     shape: RoundedRectangleBorder(
  //                       borderRadius: BorderRadius.circular(12),
  //                     ),
  //                   ),
  //                   child: Text(
  //                     "ចាកចេញ",
  //                     style: AppTextStyle.body18White,
  //                   ),
  //                 ),
  //               ),
  //               const SizedBox(height: 10),
  //               SizedBox(
  //                 width: double.infinity,
  //                 child: TextButton(
  //                   style: TextButton.styleFrom(
  //                     backgroundColor: AppColors.link,
  //                     shape: RoundedRectangleBorder(
  //                       borderRadius: BorderRadius.circular(12),
  //                     ),
  //                   ),
  //                   onPressed: () {
  //                     Navigator.pop(context);
  //                   },
  //                   child: Text(
  //                     "បោះបង់",
  //                     style: AppTextStyle.body18White,
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }
}
