import 'package:flutter/material.dart';
import 'package:tamdansers_app/constants/app_colors.dart';
import 'package:tamdansers_app/constants/app_number.dart';
import 'package:tamdansers_app/constants/text_style.dart';
import 'package:tamdansers_app/widget/primary_button.dart';

class AddStudent extends StatefulWidget {
  const AddStudent({super.key});

  @override
  State<AddStudent> createState() => _AddStudentState();
}

class _AddStudentState extends State<AddStudent> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  String? _selectedGender;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _dobController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundLight,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded,
              color: AppColors.primaryText),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'បន្ថែមសិស្ស',
          style: AppTextStyle.subtitle18,
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              // Save action
            },
            child: Text(
              'រក្សាទុក',
              style: AppTextStyle.bodyPrimary,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    // Profile Section
                    Container(
                      width: double.infinity,
                      color: AppColors.backgroundLight,
                      padding: EdgeInsets.only(top: 24),
                      child: Column(
                        children: [
                          // Profile Image
                          SizedBox(
                            width: 120,
                            height: 120,
                            child: Align(
                              alignment: Alignment.center,
                              child: Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.grey.withOpacity(0.3),
                                ),
                                child: Align(
                                  alignment: Alignment.bottomRight,
                                  child: Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryMain,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.camera_alt,
                                      color: AppColors.backgroundLight,
                                      size: 24,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'ផ្ទុតរូបថតសិស្ស',
                            style: AppTextStyle.subtitle18,
                          ),
                          SizedBox(height: 4),
                          Text(
                            'ចុចដើម្បីផ្ទុករូបថតរបស់សិស្ស',
                            style: AppTextStyle.bodySecondary,
                          ),
                          // Photo Buttons
                        ],
                      ),
                    ),
                    SizedBox(height: 12),
                    Divider(),
                    SizedBox(height: 12),
                    Container(
                      color: AppColors.backgroundLight,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.person,
                                  color: AppColors.primaryMain, size: 20),
                              SizedBox(width: 8),
                              Text(
                                'ព័ត៌មានលម្អិតសិស្ស',
                                style: AppTextStyle.subtitle16,
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          // First Name and Last Name
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('នាមខ្លួន', style: AppTextStyle.body),
                                    SizedBox(height: 8),
                                    TextField(
                                      controller: _firstNameController,
                                      decoration: InputDecoration(
                                        hintText: 'ចាន់',
                                        hintStyle: AppTextStyle.hintText,
                                        filled: true,
                                        fillColor: AppColors.white,
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          borderSide: BorderSide.none,
                                        ),
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 12),
                                      ),
                                      style: AppTextStyle.body,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('នាមត្រកូល', style: AppTextStyle.body),
                                    SizedBox(height: 8),
                                    TextField(
                                      controller: _lastNameController,
                                      decoration: InputDecoration(
                                        hintText: 'សុផល',
                                        hintStyle: AppTextStyle.hintText,
                                        filled: true,
                                        fillColor: AppColors.white,
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          borderSide: BorderSide.none,
                                        ),
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 12),
                                      ),
                                      style: AppTextStyle.body,
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
                                    Text('ថ្ងៃខែឆ្នាំកំណើត',
                                        style: AppTextStyle.body),
                                    SizedBox(height: 8),
                                    TextField(
                                      controller: _dobController,
                                      readOnly: true,
                                      decoration: InputDecoration(
                                        hintText: 'mm/dd/yyyy',
                                        hintStyle: AppTextStyle.hintText,
                                        filled: true,
                                        fillColor: AppColors.white,
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          borderSide: BorderSide.none,
                                        ),
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 12),
                                        suffixIcon: Icon(Icons.calendar_today,
                                            size: 20),
                                      ),
                                      style: AppTextStyle.body,
                                      onTap: () async {
                                        // Show date picker
                                        final DateTime? picked =
                                            await showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(1900),
                                          lastDate: DateTime.now(),
                                        );
                                        if (picked != null) {
                                          setState(() {
                                            _dobController.text =
                                                '${picked.month}/${picked.day}/${picked.year}';
                                          });
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('ភេទ', style: AppTextStyle.body),
                                    SizedBox(height: 8),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: AppColors.white,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color:
                                              AppColors.grey.withOpacity(0.3),
                                          width: 1,
                                        ),
                                      ),
                                      child: DropdownButtonFormField<String>(
                                        value: _selectedGender,
                                        decoration: InputDecoration(
                                          hintText: 'ជ្រើសរើសភេទ',
                                          hintStyle: AppTextStyle.hintText,
                                          filled: true,
                                          fillColor: Colors.transparent,
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            borderSide: BorderSide.none,
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            borderSide: BorderSide.none,
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            borderSide: BorderSide.none,
                                          ),
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 12),
                                        ),
                                        icon: Icon(Icons.keyboard_arrow_down,
                                            color: AppColors.primaryText),
                                        dropdownColor: AppColors.white,
                                        style: AppTextStyle.body.copyWith(
                                            color: AppColors.primaryText),
                                        items: ['ស្រី', 'ប្រុស']
                                            .map((String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(
                                              value,
                                              style: AppTextStyle.body.copyWith(
                                                  color: AppColors.primaryText,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          );
                                        }).toList(),
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            _selectedGender = newValue;
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 12),
                    Divider(),
                    SizedBox(height: 12),
                    Container(
                      color: AppColors.backgroundLight,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.email,
                                  color: AppColors.primaryMain, size: 20),
                              SizedBox(width: 8),
                              Text(
                                'ការចូលប្រើប្រាស់',
                                style: AppTextStyle.subtitle16,
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          // Email
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('អ៊ីម៉ែលសិស្ស', style: AppTextStyle.body),
                              SizedBox(height: 8),
                              TextField(
                                controller: _emailController,
                                decoration: InputDecoration(
                                  hintText: 'student@email.com',
                                  hintStyle: AppTextStyle.hintText,
                                  filled: true,
                                  fillColor: AppColors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide.none,
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 12),
                                  prefixIcon:
                                      Icon(Icons.email_outlined, size: 20),
                                ),
                                style: AppTextStyle.body,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Submit Button
                PrimaryButton(
                  label: 'បញ្ចូលព័ត៌មានសិស្ស',
                  backgroundColor: AppColors.primaryMain,
                  foregroundColor: AppColors.backgroundLight,
                  onPressed: () {
                    // Add student action
                  },
                ),
                SizedBox(height: AppNumber.spacingSmall),

                // Link Text
                TextButton(
                  onPressed: () {
                    // Navigate to another screen
                  },
                  child: Text(
                    'បោះបង់ការបញ្ចូល',
                    style: AppTextStyle.bodyPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
