import 'package:flutter/material.dart';
import 'package:tamdansers_app/constants/app_colors.dart';
import 'package:tamdansers_app/constants/text_style.dart';

class StudentGradeScreen extends StatefulWidget {
  const StudentGradeScreen({super.key});

  @override
  State<StudentGradeScreen> createState() => _StudentGradeScreenState();
}

class _StudentGradeScreenState extends State<StudentGradeScreen> {
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
        title: Text("លទ្ធផល និង ចំណាត់ថ្នាក់", style: AppTextStyle.fontsize18),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 16),
            _buildAssignmentDropdown(),
            SizedBox(height: 16),
            _buildStudentProfiles(),
            SizedBox(height: 16),
            _buildSubjectCard(),
            SizedBox(height: 16),
            _buildClassAverageCard(),
            SizedBox(height: 16),
            _buildNotesSection(),
            SizedBox(height: 16),
            _buildActionButtons(),
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildAssignmentDropdown() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border:
            Border.all(color: AppColors.secondaryText.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "ការយោគក្នុងត្រូវការមាន • កុម្ភ ២០២៥",
            style: AppTextStyle.body.copyWith(fontSize: 14),
          ),
          Icon(Icons.arrow_drop_down, color: AppColors.secondaryText),
        ],
      ),
    );
  }

  Widget _buildStudentProfiles() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "ប្រវត្តិសិស្ស",
            style: AppTextStyle.body.copyWith(
              fontSize: 13,
              color: AppColors.primaryMain,
            ),
          ),
          SizedBox(height: 12),
          SizedBox(
            height: 80,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildStudentAvatar(
                    "Alex", true, "assets/images/user_profile.png"),
                SizedBox(width: 12),
                _buildStudentAvatar(
                    "Ben", false, "assets/images/user_profile.png"),
                SizedBox(width: 12),
                _buildStudentAvatar(
                    "Chloe", false, "assets/images/user_profile.png"),
                SizedBox(width: 12),
                _buildStudentAvatar(
                    "David", false, "assets/images/user_profile.png"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentAvatar(String name, bool isSelected, String imagePath) {
    return Column(
      children: [
        Stack(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundImage: AssetImage(imagePath),
              backgroundColor: AppColors.secondaryText.withValues(alpha: 0.2),
            ),
            if (isSelected)
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.primaryMain,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      "x1.0",
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
        SizedBox(height: 4),
        Text(
          name,
          style: AppTextStyle.body.copyWith(
            fontSize: 13,
            color: isSelected ? AppColors.primaryMain : AppColors.primaryText,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildSubjectCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.all(20),
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
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Color(0xFFE3F2FD),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.calculate,
                    color: AppColors.primaryMain, size: 20),
              ),
              SizedBox(width: 12),
              Text(
                "គណិតវិទ្យា (Mathematics)",
                style: AppTextStyle.sectionTitle20.copyWith(fontSize: 16),
              ),
            ],
          ),
          SizedBox(height: 4),
          Text(
            "បញ្ចូលពិន្ទុលម្អិត",
            style: AppTextStyle.body.copyWith(
              fontSize: 13,
              color: AppColors.secondaryText,
            ),
          ),
          SizedBox(height: 20),
          _buildScoreRow("ការប្រជាផ្ទះ (Quiz)", "18", "/ 20", "យូគាត ១០០%"),
          SizedBox(height: 12),
          _buildScoreRow("កិច្ចការផ្ទះ (Homework)", "9", "/ 10", "យូគាត ៩០%"),
          SizedBox(height: 12),
          _buildScoreRow(
              "ប្រជាទីកន្លែងតាមប្រា (Midterm)", "42", "/ 50", "យូគាត ៨០%"),
          Divider(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "កិច្ចសរុប (Total Score)",
                style: AppTextStyle.sectionTitle20.copyWith(
                  fontSize: 16,
                  color: AppColors.primaryMain,
                ),
              ),
              Row(
                children: [
                  Text(
                    "69",
                    style: AppTextStyle.title28.copyWith(fontSize: 32),
                  ),
                  Text(
                    " / 80",
                    style: AppTextStyle.sectionTitle20.copyWith(
                      fontSize: 20,
                      color: AppColors.secondaryText,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildScoreRow(
      String label, String score, String total, String percentage) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Text(label, style: AppTextStyle.body.copyWith(fontSize: 14)),
        ),
        Expanded(
          child: Row(
            children: [
              Text(
                percentage,
                style: AppTextStyle.body.copyWith(
                  fontSize: 12,
                  color: AppColors.primaryMain,
                ),
              ),
            ],
          ),
        ),
        Container(
          width: 100,
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.backgroundLight,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                score,
                style: AppTextStyle.sectionTitle20.copyWith(fontSize: 18),
              ),
              Text(
                total,
                style: AppTextStyle.body.copyWith(
                  fontSize: 16,
                  color: AppColors.secondaryText,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildClassAverageCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "លើគុណនេះយុម្មតាក់",
            style: AppTextStyle.sectionTitle20.copyWith(
              fontSize: 16,
              color: AppColors.white,
            ),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatColumn("កិច្ចសរុប", "255", "លើ ៣០០"),
              _buildStatColumn("យូគាត", "85%", "+២% ប្រៀបប្រា"),
              _buildStatColumn("ចំណាត់ថ្នាក់", "4 /៣៥", "ល្អជាង ១០%"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String label, String value, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyle.body.copyWith(
            fontSize: 13,
            color: AppColors.secondaryText,
          ),
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: AppTextStyle.title28.copyWith(
            fontSize: 24,
            color: label == "យូគាត" ? AppColors.primaryMain : AppColors.white,
          ),
        ),
        SizedBox(height: 2),
        Text(
          subtitle,
          style: AppTextStyle.body.copyWith(
            fontSize: 11,
            color: AppColors.secondaryText,
          ),
        ),
      ],
    );
  }

  Widget _buildNotesSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.comment, color: AppColors.primaryMain, size: 20),
              SizedBox(width: 8),
              Text(
                "មតិលើហានប្រាស",
                style: AppTextStyle.sectionTitle20.copyWith(fontSize: 16),
              ),
            ],
          ),
          SizedBox(height: 12),
          TextField(
            maxLines: 4,
            decoration: InputDecoration(
              hintText: "សូមបញ្ចូលមតិលើហានប្រាស់ការសិក្សាសិស្ស...",
              hintStyle: AppTextStyle.hintText.copyWith(fontSize: 14),
              filled: true,
              fillColor: AppColors.backgroundLight,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.all(16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: AppColors.primaryMain),
                padding: EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                "សូត្រគណក្រោម",
                style: AppTextStyle.body.copyWith(color: AppColors.primaryMain),
              ),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryMain,
                padding: EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.arrow_upward, color: AppColors.white, size: 20),
                  SizedBox(width: 8),
                  Text(
                    "លេខអត្ថប្រយោជន៍លទ្ធផល",
                    style: AppTextStyle.body.copyWith(color: AppColors.white),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
