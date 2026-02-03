import 'package:flutter/material.dart';
import 'package:tamdansers_app/constants/app_colors.dart';
import 'package:tamdansers_app/constants/text_style.dart';

class CreateStudentScreen extends StatefulWidget {
  const CreateStudentScreen({super.key});

  @override
  State<CreateStudentScreen> createState() => _CreateStudentScreenState();
}

class _CreateStudentScreenState extends State<CreateStudentScreen> {
  bool _isParent = false;

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
        title: Text("បន្ថែមសិស្ស", style: AppTextStyle.fontsize18),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {},
            child: Text(
              "រក្សាទុក",
              style: AppTextStyle.body.copyWith(color: AppColors.primaryMain),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 24),
            _buildProfileSection(),
            SizedBox(height: 24),
            _buildPersonalInfoSection(),
            SizedBox(height: 24),
            _buildSchoolInfoSection(),
            SizedBox(height: 24),
            _buildContactSection(),
            SizedBox(height: 32),
            _buildSubmitButton(),
            SizedBox(height: 16),
            TextButton(
              onPressed: () {},
              child: Text(
                "សូត្រគណនេះគ្រោះគ្រាន",
                style: AppTextStyle.body.copyWith(
                  color: AppColors.primaryMain,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection() {
    return Column(
      children: [
        Stack(
          children: [
            CircleAvatar(
              radius: 60,
              backgroundColor: AppColors.secondaryText.withValues(alpha: 0.2),
              backgroundImage: AssetImage("assets/images/user_profile.png"),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primaryMain,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.camera_alt, color: AppColors.white, size: 20),
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        Text(
          "អ្នកប្រើប្រាស់",
          style: AppTextStyle.sectionTitle20,
        ),
        Text(
          "ថតរូបដើម្បីបញ្ជូលក្នុងប្រព័ន្ធ",
          style: AppTextStyle.body
              .copyWith(fontSize: 13, color: AppColors.secondaryText),
        ),
        SizedBox(height: 16),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _isParent = false;
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: !_isParent
                        ? AppColors.primaryMain.withValues(alpha: 0.1)
                        : AppColors.white,
                    side: BorderSide(
                      color: !_isParent
                          ? AppColors.primaryMain
                          : AppColors.secondaryText.withValues(alpha: 0.3),
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    padding: EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(
                    "គិតមានសិស្ស",
                    style: AppTextStyle.body.copyWith(
                      color: !_isParent
                          ? AppColors.primaryMain
                          : AppColors.primaryText,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _isParent = true;
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: _isParent
                        ? AppColors.primaryMain.withValues(alpha: 0.1)
                        : AppColors.white,
                    side: BorderSide(
                      color: _isParent
                          ? AppColors.primaryMain
                          : AppColors.secondaryText.withValues(alpha: 0.3),
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    padding: EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(
                    "គិតមានអាណាព្យាបាល",
                    style: AppTextStyle.body.copyWith(
                      color: _isParent
                          ? AppColors.primaryMain
                          : AppColors.primaryText,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPersonalInfoSection() {
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
              Icon(Icons.person, color: AppColors.primaryMain, size: 20),
              SizedBox(width: 8),
              Text(
                "គិតមានប្រវត្តិសិស្ស",
                style: AppTextStyle.sectionTitle20.copyWith(fontSize: 16),
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
                    Text("នាមខ្លួន",
                        style: AppTextStyle.body.copyWith(fontSize: 14)),
                    SizedBox(height: 8),
                    TextField(
                      decoration: InputDecoration(
                        hintText: "ចាន់",
                        hintStyle: AppTextStyle.hintText.copyWith(fontSize: 14),
                        filled: true,
                        fillColor: AppColors.backgroundLight,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("នាមត្រកូល",
                        style: AppTextStyle.body.copyWith(fontSize: 14)),
                    SizedBox(height: 8),
                    TextField(
                      decoration: InputDecoration(
                        hintText: "សុផន",
                        hintStyle: AppTextStyle.hintText.copyWith(fontSize: 14),
                        filled: true,
                        fillColor: AppColors.backgroundLight,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                    ),
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
                    Text("ថ្ងៃខែឆ្នាំកំណើត",
                        style: AppTextStyle.body.copyWith(fontSize: 14)),
                    SizedBox(height: 8),
                    TextField(
                      decoration: InputDecoration(
                        hintText: "mm/dd/yyyy",
                        hintStyle: AppTextStyle.hintText.copyWith(fontSize: 14),
                        filled: true,
                        fillColor: AppColors.backgroundLight,
                        suffixIcon: Icon(Icons.calendar_today,
                            color: AppColors.secondaryText),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("ភេទ",
                        style: AppTextStyle.body.copyWith(fontSize: 14)),
                    SizedBox(height: 8),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: AppColors.backgroundLight,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("ប្រុសប្រភេទ",
                              style: AppTextStyle.body.copyWith(fontSize: 14)),
                          Icon(Icons.arrow_drop_down,
                              color: AppColors.secondaryText),
                        ],
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

  Widget _buildSchoolInfoSection() {
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
              Icon(Icons.school, color: AppColors.primaryMain, size: 20),
              SizedBox(width: 8),
              Text(
                "ប្រើសប្រភេទក្នុង",
                style: AppTextStyle.sectionTitle20.copyWith(fontSize: 16),
              ),
            ],
          ),
          SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("សាលារៀន", style: AppTextStyle.body.copyWith(fontSize: 14)),
              SizedBox(height: 8),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.backgroundLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("ប្រើសប្រភេទក្នុង",
                        style: AppTextStyle.body.copyWith(fontSize: 14)),
                    Icon(Icons.arrow_drop_down, color: AppColors.secondaryText),
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
                    Text("ថ្នាក់",
                        style: AppTextStyle.body.copyWith(fontSize: 14)),
                    SizedBox(height: 8),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: AppColors.backgroundLight,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("A",
                              style: AppTextStyle.body.copyWith(fontSize: 14)),
                          Icon(Icons.arrow_drop_down,
                              color: AppColors.secondaryText),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("លេខរៀង",
                        style: AppTextStyle.body.copyWith(fontSize: 14)),
                    SizedBox(height: 8),
                    TextField(
                      decoration: InputDecoration(
                        hintText: "001",
                        hintStyle: AppTextStyle.hintText.copyWith(fontSize: 14),
                        filled: true,
                        fillColor: AppColors.backgroundLight,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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

  Widget _buildContactSection() {
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
              Icon(Icons.email, color: AppColors.primaryMain, size: 20),
              SizedBox(width: 8),
              Text(
                "ការទាក់ទងប្រជាដង",
                style: AppTextStyle.sectionTitle20.copyWith(fontSize: 16),
              ),
            ],
          ),
          SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("អ៊ីមែលសិស្ស",
                  style: AppTextStyle.body.copyWith(fontSize: 14)),
              SizedBox(height: 8),
              TextField(
                decoration: InputDecoration(
                  hintText: "student@school.edu",
                  hintStyle: AppTextStyle.hintText.copyWith(fontSize: 14),
                  filled: true,
                  fillColor: AppColors.backgroundLight,
                  prefixIcon: Icon(Icons.email_outlined,
                      color: AppColors.secondaryText),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryMain,
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          minimumSize: Size(double.infinity, 50),
        ),
        child: Text(
          "បន្ថែមសិស្ស",
          style: AppTextStyle.fontsize18.copyWith(color: AppColors.white),
        ),
      ),
    );
  }
}
