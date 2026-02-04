import 'package:flutter/material.dart';
import 'package:tamdansers_app/constants/app_colors.dart';
import 'package:tamdansers_app/constants/app_images.dart';
import 'package:tamdansers_app/constants/text_style.dart';
import 'package:tamdansers_app/routes/app_routes.dart';
import 'package:tamdansers_app/widget/search_field.dart';

class ManageStudentScreen extends StatefulWidget {
  const ManageStudentScreen({super.key});

  @override
  State<ManageStudentScreen> createState() => _ManageStudentScreenState();
}

class _ManageStudentScreenState extends State<ManageStudentScreen> {
  final TextEditingController searchCtrl = TextEditingController();

  @override
  void dispose() {
    searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.primaryText,
          ),
        ),
        title: Text(
          "គ្រប់គ្រងសិស្ស",
          style: AppTextStyle.screenTitle24,
        ),
        centerTitle: true,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
            child: Row(
              children: [
                Expanded(
                  child: SearchField(
                    controller: searchCtrl,
                    hintText: "ស្វែងរក...",
                    icon: Icon(
                      Icons.search_outlined,
                      color: AppColors.secondaryText,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    height: 46,
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: AppColors.primaryMain,
                      borderRadius: BorderRadius.circular(26),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.white,
                          ),
                          child: Icon(
                            Icons.add_rounded,
                            size: 18,
                            color: AppColors.primaryMain,
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          "បញ្ចូលសិស្ស",
                          style: AppTextStyle.body.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Text(
                  "បញ្ជីសិស្សថ្នាក់ទី 7A",
                  style: AppTextStyle.sectionTitle20.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: 4),
                Text(
                  "32 នាក់",
                  style: AppTextStyle.sectionTitle20.copyWith(
                    color: AppColors.primaryMain,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 16),
              itemCount: 32,
              itemBuilder: (context, index) {
                return _studentCard(
                  name: "សុម តារី",
                  code: "ID: 2023-00$index",
                  gender: "ប្រុស",
                  attendance: 0.68,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _studentCard({
    required String name,
    required String code,
    required String gender,
    required double attendance,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: AppColors.primaryMain.withOpacity(0.15),
                child: Image.asset(
                  AppImages.studentMale2,
                  width: 40,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: AppTextStyle.body.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      code,
                      style: AppTextStyle.body.copyWith(
                        color: AppColors.secondaryText,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(gender, style: AppTextStyle.body),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _progressRow(
            label: "វត្តមាន",
            value: attendance,
            barColor: AppColors.success,
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size(0, 0),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.studentDetailScreen);
              },
              child: Text(
                "ព័ត៌មានលម្អិត >",
                style: AppTextStyle.body.copyWith(
                  color: AppColors.primaryMain,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _progressRow({
    required String label,
    required double value,
    required Color barColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: AppTextStyle.body,
            ),
            Spacer(),
            Text(
              "${(value * 100).toStringAsFixed(0)}%",
              style: AppTextStyle.body,
            ),
          ],
        ),
        SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: value,
            minHeight: 4,
            backgroundColor: AppColors.white,
            valueColor: AlwaysStoppedAnimation<Color>(barColor),
          ),
        ),
      ],
    );
  }
}
