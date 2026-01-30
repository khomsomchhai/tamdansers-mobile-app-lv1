import 'package:flutter/material.dart';
import 'package:tamdansers_app/constants/app_colors.dart';
import 'package:tamdansers_app/constants/text_style.dart';
import 'package:tamdansers_app/widget/class_card.dart';

class ManageAllClass extends StatefulWidget {
  const ManageAllClass({super.key});

  @override
  State<ManageAllClass> createState() => _ManageAllClassState();
}

class _ManageAllClassState extends State<ManageAllClass> {
  String _selectedGrade = "ទាំងអស់";

  final List<String> grades = [
    "ទាំងអស់",
    "ថ្នាក់ទី 12",
    "ថ្នាក់ទី 11",
    "ថ្នាក់ទី 10",
    "ថ្នាក់ទី 9",
    "ថ្នាក់ទី 8",
    "ថ្នាក់ទី 7",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "គ្រប់គ្រងថ្នាក់សិក្សា",
          style: AppTextStyle.sectionTitle20,
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.primaryText),
          onPressed: () {},
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                _buildSearchAndAddSection(),
                SizedBox(height: 12),
                _buildGradeFilters(),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(16),
              children: [
                ClassCard(
                  className: "ថ្នាក់ទី 7A (Grade 7A)",
                  subject: "គ្រូបន្ទុកថ្នាក់",
                  students: "36 នាក់",
                  color: Color(0xFF1976D2),
                ),
                SizedBox(height: 12),
                ClassCard(
                  className: "ថ្នាក់ទី 7A (Grade 7A)",
                  subject: "គ្រូបន្ទុកថ្នាក់",
                  students: "36 នាក់",
                  color: Color(0xFF00897B),
                ),
                SizedBox(height: 12),
                ClassCard(
                  className: "ថ្នាក់ទី 7A (Grade 7A)",
                  subject: "គ្រូបន្ទុកថ្នាក់",
                  students: "36 នាក់",
                  color: Color(0xFF546E7A),
                ),
                SizedBox(height: 12),
                ClassCard(
                  className: "ថ្នាក់ទី 7A (Grade 7A)",
                  subject: "គ្រូបន្ទុកថ្នាក់",
                  students: "36 នាក់",
                  color: Color(0xFF1976D2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndAddSection() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.primaryMain.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.search, color: AppColors.secondaryText, size: 20),
                SizedBox(width: 8),
                Text(
                  "ស្វែងរក...",
                  style: AppTextStyle.hintText.copyWith(fontSize: 15),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: 12),
        ElevatedButton.icon(
          onPressed: () {},
          icon: Icon(Icons.add, color: AppColors.white, size: 20),
          label: Text(
            "បង្កើតថ្នាក់",
            style: AppTextStyle.body.copyWith(
              color: AppColors.white,
              fontSize: 15,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryMain,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGradeFilters() {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: grades.length,
        itemBuilder: (context, index) {
          final grade = grades[index];
          final isSelected = _selectedGrade == grade;
          return Padding(
            padding: EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(grade),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedGrade = grade;
                });
              },
              labelStyle: AppTextStyle.body.copyWith(
                fontSize: 14,
                color: isSelected ? AppColors.white : AppColors.primaryText,
              ),
              backgroundColor: AppColors.white,
              selectedColor: AppColors.primaryMain,
              showCheckmark: false,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: isSelected
                      ? AppColors.primaryMain
                      : AppColors.secondaryText.withOpacity(0.2),
                ),
              ),
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          );
        },
      ),
    );
  }
}
