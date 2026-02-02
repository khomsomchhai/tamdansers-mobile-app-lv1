import 'package:flutter/material.dart';
import 'package:tamdansers_app/constants/app_colors.dart';
import 'package:tamdansers_app/constants/app_images.dart';
import 'package:tamdansers_app/constants/text_style.dart';
import 'package:tamdansers_app/routes/app_routes.dart';
import 'package:tamdansers_app/widget/class_card.dart';

class TeacherDashboard extends StatefulWidget {
  const TeacherDashboard({super.key});

  @override
  State<TeacherDashboard> createState() => _TeacherDashboardState();
}

class _TeacherDashboardState extends State<TeacherDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage(AppImages.userProfile),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        title: Text(
          "ទេព ធីតា",
          style: AppTextStyle.fontsize18,
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.notifications_outlined,
                    color: AppColors.primaryText),
                onPressed: () {},
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: AppColors.error,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  text: "សួស្តី អ្នកគ្រូ ",
                  style: AppTextStyle.screenTitle24
                      .copyWith(color: AppColors.primaryText),
                  children: [
                    TextSpan(
                      text: "ទេព ធីតា",
                      style: AppTextStyle.screenTitle24
                          .copyWith(color: AppColors.primaryMain),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              _buildStatsCards(),
              SizedBox(height: 16),
              _buildActionButtons(),
              SizedBox(height: 24),
              _buildQuickActions(),
              SizedBox(height: 24),
              _buildClassesSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsCards() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Color(0xFFE3F2FD),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.class_outlined,
                      color: AppColors.primaryMain, size: 24),
                ),
                SizedBox(height: 12),
                Text("ថ្នាក់សរុប",
                    style: AppTextStyle.body
                        .copyWith(color: AppColors.secondaryText)),
                SizedBox(height: 4),
                Text("4", style: AppTextStyle.title28),
              ],
            ),
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Color(0xFFF3E5F5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.groups_outlined,
                      color: Color(0xFF9C27B0), size: 24),
                ),
                SizedBox(height: 12),
                Text("សិស្សសរុប",
                    style: AppTextStyle.body
                        .copyWith(color: AppColors.secondaryText)),
                SizedBox(height: 4),
                Text("120", style: AppTextStyle.title28),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {},
            icon: Icon(Icons.add, color: AppColors.white),
            label: Text("បង្កើតថ្នាក់",
                style: AppTextStyle.body.copyWith(color: AppColors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryMain,
              padding: EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {},
            icon: Icon(Icons.event_note_outlined, color: AppColors.primaryMain),
            label: Text("ត្រូវត្រាថ្នាក់",
                style:
                    AppTextStyle.body.copyWith(color: AppColors.primaryMain)),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: AppColors.primaryMain),
              padding: EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildQuickActionItem(Icons.person_outline, "កត់ត្រាវត្តមាន",
            Color(0xFFE3F2FD), AppColors.primaryMain),
        _buildQuickActionItem(Icons.assignment_outlined, "កិច្ចការផ្ទះ",
            Color(0xFFF3E5F5), Color(0xFF9C27B0)),
        _buildQuickActionItem(Icons.check_circle_outline, "បញ្ជូលពិន្ទុ",
            Color(0xFFE8F5E9), Color(0xFF4CAF50)),
        _buildQuickActionItem(Icons.campaign_outlined, "ផ្ញើរសេចក្តីជូនដំណឹង",
            Color(0xFFFFF3E0), Color(0xFFFF9800)),
      ],
    );
  }

  Widget _buildQuickActionItem(
      IconData icon, String label, Color bgColor, Color iconColor) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icon, color: iconColor, size: 28),
        ),
        SizedBox(height: 8),
        Text(
          label,
          style: AppTextStyle.body
              .copyWith(fontSize: 12, color: AppColors.primaryText),
          textAlign: TextAlign.center,
          maxLines: 2,
        ),
      ],
    );
  }

  Widget _buildClassesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("ថ្នាក់ទាំងអស់", style: AppTextStyle.sectionTitle20),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.manageAllClass);
              },
              child: Text("មើលទាំងអស់",
                  style:
                      AppTextStyle.body.copyWith(color: AppColors.primaryMain)),
            ),
          ],
        ),
        SizedBox(height: 12),
        ClassCard(
          className: "ថ្នាក់ទី 7A (Grade 7A)",
          title: "គ្រូបន្ទុកថ្នាក់",
          students: "36 នាក់",
          color: Color(0xFF1976D2),
          onTap: () {
            Navigator.pushNamed(context, AppRoutes.manageClass);
          },
        ),
        SizedBox(height: 12),
        ClassCard(
          className: "ថ្នាក់ទី 7A (Grade 7A)",
          title: "គ្រូបន្ទុកថ្នាក់",
          students: "36 នាក់",
          color: Color(0xFF00897B),
          onTap: () {
            Navigator.pushNamed(context, AppRoutes.manageClass);
          },
        ),
        SizedBox(height: 12),
        ClassCard(
          className: "ថ្នាក់ទី 7A (Grade 7A)",
          title: "គ្រូបន្ទុកថ្នាក់",
          students: "36 នាក់",
          color: Color(0xFF546E7A),
          onTap: () {
            Navigator.pushNamed(context, AppRoutes.manageClass);
          },
        ),
      ],
    );
  }
}
