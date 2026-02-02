import 'package:flutter/material.dart';
import 'package:tamdansers_app/constants/app_colors.dart';
import 'package:tamdansers_app/constants/text_style.dart';

class ManageClass extends StatefulWidget {
  const ManageClass({super.key});

  @override
  State<ManageClass> createState() => _ManageClassState();
}

class _ManageClassState extends State<ManageClass> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.primaryText),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "ថ្នាក់ទី 7A (Grade 7A)",
          style: AppTextStyle.sectionTitle20,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildClassInfoCard(),
              SizedBox(height: 20),
              _buildManagementOptions(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildClassInfoCard() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primaryMain, AppColors.primary400],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "សិស្សសរុប",
                style: AppTextStyle.body.copyWith(
                  fontSize: 12,
                  color: AppColors.white,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "ឆមាសទី​ ១",
                  style: AppTextStyle.body.copyWith(
                    fontSize: 12,
                    color: AppColors.white,
                  ),
                ),
              ),
            ],
          ),
          Text(
            "៣៦ នាក់",
            style: AppTextStyle.title28.copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Divider(
            color: AppColors.white.withValues(alpha: 0.3),
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(Icons.person, color: AppColors.white, size: 24),
                    SizedBox(width: 6),
                    Text(
                      "ប្រុស: ៦០",
                      style: AppTextStyle.body.copyWith(
                        color: AppColors.white,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 20),
              Expanded(
                child: Row(
                  children: [
                    Icon(Icons.person, color: Colors.pink[200], size: 24),
                    SizedBox(width: 6),
                    Text(
                      "ស្រី: ៩៦",
                      style: AppTextStyle.body.copyWith(
                        color: AppColors.white,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildManagementOptions() {
    return Column(
      children: [
        _buildOptionTile(
          icon: Icons.groups,
          iconColor: AppColors.primaryMain,
          iconBgColor: Color(0xFFE3F2FD),
          title: "គ្រប់គ្រងសិស្ស",
          subtitle: "Student Management",
          onTap: () {},
        ),
        SizedBox(height: 12),
        _buildOptionTile(
          icon: Icons.event_note,
          iconColor: Color(0xFFFFA726),
          iconBgColor: Color(0xFFFFF3E0),
          title: "គ្រប់គ្រងវត្តមាន",
          subtitle: "Attendance Management",
          onTap: () {},
        ),
        SizedBox(height: 12),
        _buildOptionTile(
          icon: Icons.assignment,
          iconColor: Color(0xFF9C27B0),
          iconBgColor: Color(0xFFF3E5F5),
          title: "គ្រប់គ្រងកិច្ចការផ្ទះ",
          subtitle: "Homework Management",
          onTap: () {},
        ),
        SizedBox(height: 12),
        _buildOptionTile(
          icon: Icons.bar_chart,
          iconColor: Color(0xFFEF5350),
          iconBgColor: Color(0xFFFFEBEE),
          title: "លទ្ធផល និងចំណាត់ថ្នាក់",
          subtitle: "Result & Ranking",
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildOptionTile({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyle.fontsize18.copyWith(fontSize: 16),
                  ),
                  SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: AppTextStyle.body.copyWith(
                      fontSize: 13,
                      color: AppColors.secondaryText,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: AppColors.secondaryText,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}
