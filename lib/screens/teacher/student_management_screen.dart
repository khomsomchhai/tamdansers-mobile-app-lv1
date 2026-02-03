import 'package:flutter/material.dart';
import 'package:tamdansers_app/constants/app_colors.dart';
import 'package:tamdansers_app/constants/text_style.dart';
import 'package:tamdansers_app/screens/teacher/create_student_screen.dart';
import 'package:tamdansers_app/screens/teacher/student_grade_screen.dart';

class StudentManagementScreen extends StatefulWidget {
  const StudentManagementScreen({super.key});

  @override
  State<StudentManagementScreen> createState() =>
      _StudentManagementScreenState();
}

class _StudentManagementScreenState extends State<StudentManagementScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.primaryText),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          children: [
            Text("បញ្ជីសិស្ស", style: AppTextStyle.fontsize18),
            Text(
              "ថ្នាក់ទី 90-A (គណិតវិទ្យា)",
              style: AppTextStyle.body
                  .copyWith(fontSize: 13, color: AppColors.secondaryText),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Container(
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.primaryMain,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.person_add, color: AppColors.white, size: 20),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreateStudentScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: AppColors.white,
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                _buildSearchBar(),
                SizedBox(height: 12),
                _buildStatusChips(),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(16),
              children: [
                _buildStudentCard(
                  "សូន ចន្ថាដី",
                  "ID-2024001",
                  true,
                  "assets/images/user_profile.png",
                ),
                SizedBox(height: 12),
                _buildStudentCard(
                  "ល័ យាកុប",
                  "ID-2024002",
                  true,
                  "assets/images/user_profile.png",
                ),
                SizedBox(height: 12),
                _buildStudentCard(
                  "ហេង វិសាល",
                  "ID-2024003 (អត់មក)",
                  false,
                  null,
                ),
                SizedBox(height: 12),
                _buildStudentCard(
                  "និក គុសល",
                  "ID-2024004",
                  true,
                  null,
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateStudentScreen()),
          );
        },
        backgroundColor: AppColors.primaryMain,
        child: Icon(Icons.add, color: AppColors.white, size: 32),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.backgroundLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.search, color: AppColors.secondaryText, size: 20),
                SizedBox(width: 8),
                Text(
                  "ស្វែងរកសិស្ស",
                  style: AppTextStyle.hintText.copyWith(fontSize: 15),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: 12),
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.backgroundLight,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(Icons.tune, color: AppColors.primaryText, size: 24),
        ),
      ],
    );
  }

  Widget _buildStatusChips() {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Color(0xFFE8F5E9),
            borderRadius: BorderRadius.circular(20),
          ),
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
                "វត្តមាននេះ:: ៣០/៣៦",
                style: AppTextStyle.body.copyWith(fontSize: 13),
              ),
            ],
          ),
        ),
        SizedBox(width: 12),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Color(0xFFFFF3E0),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Icon(Icons.warning, color: Colors.orange, size: 16),
              SizedBox(width: 6),
              Text(
                "អត់មក: ២ នាក់",
                style: AppTextStyle.body.copyWith(fontSize: 13),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStudentCard(
      String name, String id, bool isOnline, String? imagePath) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundImage:
                        imagePath != null ? AssetImage(imagePath) : null,
                    backgroundColor:
                        imagePath == null ? AppColors.primaryMain : null,
                    child: imagePath == null
                        ? Text(
                            name.substring(0, 2),
                            style: AppTextStyle.fontsize18
                                .copyWith(color: AppColors.white),
                          )
                        : null,
                  ),
                  if (isOnline)
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          color: AppColors.success,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.white, width: 2),
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: AppTextStyle.fontsize18),
                    Text(
                      id,
                      style: AppTextStyle.body.copyWith(
                          fontSize: 13, color: AppColors.secondaryText),
                    ),
                  ],
                ),
              ),
              Icon(Icons.more_vert, color: AppColors.secondaryText),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => StudentGradeScreen()),
                    );
                  },
                  child: _buildActionButton(
                    Icons.bar_chart,
                    "មើលពិន្ទុ",
                    Color(0xFFE3F2FD),
                    AppColors.primaryMain,
                  ),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: _buildActionButton(
                  Icons.assignment,
                  "កំណត់វត្តមាន",
                  Color(0xFFFFF3E0),
                  Colors.orange,
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: _buildActionButton(
                  Icons.message,
                  "ទាក់ទងអាណាព្យាបាល",
                  Color(0xFFE8F5E9),
                  AppColors.success,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
      IconData icon, String label, Color bgColor, Color iconColor) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: iconColor, size: 24),
          SizedBox(height: 4),
          Text(
            label,
            style: AppTextStyle.body.copyWith(
              fontSize: 11,
              color: iconColor,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
          ),
        ],
      ),
    );
  }
}
