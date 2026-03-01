import 'package:flutter/material.dart';
import 'package:tamdansers_app/constants/app_colors.dart';
import 'package:tamdansers_app/constants/text_style.dart';
import 'package:tamdansers_app/routes/app_routes.dart';

class HomeworkScreen extends StatefulWidget {
  const HomeworkScreen({super.key});

  @override
  State<HomeworkScreen> createState() => _HomeworkScreenState();
}

class _HomeworkScreenState extends State<HomeworkScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new_rounded,
              color: AppColors.primaryText),
        ),
        title: Column(
          children: [
            Text(
              "ថ្នាក់ទី 7-A",
              style: AppTextStyle.fontsize18,
            ),
            Text(
              "គណិតវិទ្យា (Mathematics)",
              style: AppTextStyle.body.copyWith(
                fontSize: 13,
                color: AppColors.secondaryText,
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon:
                Icon(Icons.add_circle, color: AppColors.primaryMain, size: 28),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.addTaskScreen),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                "កិច្ចការផ្ទះ:",
                style: AppTextStyle.screenTitle24,
              ),
            ),
            _buildActiveSection(),
            SizedBox(height: 16),
            _buildReviewSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: AppColors.success,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 8),
              Text(
                "សកម្ម (ACTIVE)",
                style: AppTextStyle.subtitle16,
              ),
            ],
          ),
        ),
        SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              _buildHomeworkCard(
                "Algebra Chapter 4",
                "ប្រធានបទ​៖ សមីការ​ ដឺក្រេទី២",
                "២០ កុម្ភៈ ២០២៥",
                "២៥ / ៣៦ នាក់",
                0.7,
                Color(0xFFE3F2FD),
                Icons.functions,
              ),
              SizedBox(height: 12),
              _buildHomeworkCard(
                "Geometry Quiz Prep",
                "ប្រធានបទ​៖ រង្វង់​ និង មុំ",
                "២៥ កុម្ភៈ ២០២៥",
                "១៦ / ៣៦ នាក់",
                0.45,
                Color(0xFFE8F5E9),
                Icons.chat_bubble_outline,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHomeworkCard(String title, String description, String dueDate,
      String submissions, double progress, Color bgColor, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: AppColors.primaryMain, size: 24),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTextStyle.fontsize18),
                    Text(description, style: AppTextStyle.caption13Secondary),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "ថ្ងៃផុតកំណត់ (Due Date)",
                      style: AppTextStyle.caption12Secondary,
                    ),
                    SizedBox(height: 4),
                    Text(dueDate, style: AppTextStyle.fontsize18),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "ការបញ្ជូន (Submissions)",
                      style: AppTextStyle.caption12Secondary,
                    ),
                    SizedBox(height: 4),
                    Text(submissions, style: AppTextStyle.fontsize18),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: AppColors.backgroundLight,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryMain),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    "ពិនិត្យឡើងវិញ (REVIEW)",
                    style: AppTextStyle.subtitle16,
                  ),
                ],
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  "មើលទាំងអស់",
                  style: AppTextStyle.bodyPrimary,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              _buildReviewCard(
                "ចាន់​ ដារ៉ា",
                "Algebra Chapter 4 •",
                "១០​ នាទីមុន",
                "assets/images/user_profile.png",
              ),
              SizedBox(height: 12),
              _buildReviewCard(
                "លី​ សុភាព",
                "Algebra Chapter 4 •",
                "២៥ នាទីមុន",
                "assets/images/user_profile.png",
              ),
              SizedBox(height: 12),
              _buildReviewCard(
                "ហុង សុភា",
                "Algebra Chapter 4 •",
                "៥៥ នាទីមុន",
                null,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReviewCard(
      String name, String assignment, String submitTime, String? imagePath) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundImage: imagePath != null ? AssetImage(imagePath) : null,
            backgroundColor: AppColors.backgroundLight,
            child: imagePath == null
                ? Icon(Icons.person, color: AppColors.secondaryText)
                : null,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: AppTextStyle.fontsize18),
                Text(
                  "$assignment $submitTime",
                  style: AppTextStyle.caption13Secondary,
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryMain,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            child: Text(
              "ដាក់ពិន្ទុ",
              style: AppTextStyle.caption13White,
            ),
          ),
        ],
      ),
    );
  }
}
