import 'dart:io' as io;

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tamdansers_app/constants/app_colors.dart';
import 'package:tamdansers_app/constants/app_icon.dart';
import 'package:tamdansers_app/constants/app_number.dart';
import 'package:tamdansers_app/constants/text_style.dart';
import 'package:tamdansers_app/repositories/activity_repo.dart';
import 'package:tamdansers_app/repositories/parent_student_repo.dart';
import 'package:tamdansers_app/widget/custom_snackbar.dart';

class CommentSignature extends StatefulWidget {
  const CommentSignature({super.key});

  @override
  State<CommentSignature> createState() => _CommentSignatureState();
}

class _CommentSignatureState extends State<CommentSignature> {
  Map<String, dynamic>? _student;
  bool _isLoading = true;
  final TextEditingController _messageController = TextEditingController();
  bool _isSending = false;
  final String _teacherRecommendation = '';

  @override
  void initState() {
    super.initState();
    _loadStudent();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _loadStudent() async {
    setState(() => _isLoading = true);
    final pref = await SharedPreferences.getInstance();
    final parentId = pref.getInt("userId");
    if (parentId != null) {
      final students = await ParentStudentRepo().getStudentsByParent(parentId);
      if (students.isNotEmpty) {
        _student = students.first;
      }
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "សារ",
          style: AppTextStyle.sectionTitle20
              .copyWith(color: AppColors.primaryText),
        ),
        centerTitle: true,
        backgroundColor: AppColors.backgroundLight,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _studentCard(),
              SizedBox(height: 20),
              _teacherRecommendationCard(),
              SizedBox(height: 20),
              _messageCard(),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _studentCard() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    final student = _student;
    if (student == null) {
      return Center(
        child: Text(
          "មិនមានសិស្សភ្ជាប់ទេ",
          style: AppTextStyle.body.copyWith(color: AppColors.secondaryText),
        ),
      );
    }
    final photoPath = student['photo_path'] as String?;
    return Row(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primaryBg,
            border: Border.all(color: AppColors.primaryMain, width: 2),
          ),
          child: ClipOval(
            child: (photoPath != null && photoPath.isNotEmpty)
                ? Image.file(
                    io.File(photoPath),
                    fit: BoxFit.cover,
                  )
                : Image.asset(
                    student['gender'] == 'ប្រុស' || student['gender'] == 'male'
                        ? AppIcon.maleAvatar
                        : AppIcon.femaleAvatar,
                    fit: BoxFit.cover,
                  ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    '${student['first_name'] ?? ''} ${student['last_name'] ?? ''}',
                    style: AppTextStyle.subtitle18,
                  ),
                  const SizedBox(width: 4),
                  Icon(Icons.keyboard_arrow_down,
                      size: 20, color: AppColors.secondaryText),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                student['class_name'] ?? '',
                style: AppTextStyle.caption13Secondary,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _teacherRecommendationCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.comment, color: AppColors.primaryMain),
              const SizedBox(width: 10),
              Text(
                'មតិយោបល់របស់គ្រូ',
                style: AppTextStyle.subtitle18,
              ),
            ],
          ),
          const SizedBox(height: 15),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF1C2),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFFDAD00)),
            ),
            child: Text(
              _teacherRecommendation.isNotEmpty
                  ? _teacherRecommendation
                  : 'ខិតខំប្រឹងប្រែងបន្តទៀត ការសិក្សាខែធ្វើបានល្អច្រើនហើយ សូមបន្តធ្វើអោយបានល្អបន្ថែមទៀតនៅខែក្រោយ',
              style: AppTextStyle.body,
            ),
          ),
        ],
      ),
    );
  }

  Widget _messageCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'ផ្ញើសារ',
          style: AppTextStyle.subtitle18,
        ),
        const SizedBox(height: 15),
        Container(
          decoration: BoxDecoration(
            color: AppColors.uploadFile,
            border: Border.all(color: AppColors.uploadFile),
            borderRadius: BorderRadius.circular(20),
          ),
          child: TextField(
            controller: _messageController,
            maxLines: 6,
            decoration: InputDecoration(
              hintText: 'សរសេរសារ',
              hintStyle: AppTextStyle.subtitle16.copyWith(color: Colors.grey),
              contentPadding: EdgeInsets.all(15),
              border: InputBorder.none,
            ),
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _isSending ? null : _sendMessage,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryMain,
              disabledBackgroundColor: AppColors.grey,
              padding: const EdgeInsets.symmetric(vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppNumber.radiusMedium),
              ),
            ),
            child: Text(
              _isSending ? 'កំពុងផ្ញើ...' : 'ផ្ញើសារ',
              style: AppTextStyle.size18.copyWith(color: AppColors.uploadFile),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          content: CustomSnackbar(
            title: "មិនត្រឹមត្រូវ!",
            message: 'សូមបញ្ចូលសារ',
            icon: Icons.close,
            color: AppColors.error,
          ),
        ),
      );
      return;
    }

    setState(() => _isSending = true);
    try {
      // TODO: Implement actual message sending logic
      await Future.delayed(Duration(milliseconds: 500));

      // Log activity
      final pref = await SharedPreferences.getInstance();
      final parentId = pref.getInt("userId");
      if (parentId != null) {
        final studentName =
            '${_student?['first_name'] ?? ''} ${_student?['last_name'] ?? ''}'
                .trim();
        final studentClassId = _student?['student_id'] as int?;
        await ActivityRepo().logParentActivity(
          parentId: parentId,
          activityType: 'message',
          title: 'ផ្ញើសារ',
          subtitle: 'ផ្ញើសារឱ្យ $studentName',
          studentClassId: studentClassId,
        );
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          content: CustomSnackbar(
            title: "ជោគជ័យ!",
            message: 'សារត្រូវបានផ្ញើដោយជោគជ័យ',
            icon: Icons.check_circle,
            color: AppColors.success,
          ),
        ),
      );
      _messageController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          content: CustomSnackbar(
            title: "មានបញ្ហា!",
            message: 'មានកំហុសក្នុងការផ្ញើសារ',
            icon: Icons.error,
            color: AppColors.error,
          ),
        ),
      );
    } finally {
      setState(() => _isSending = false);
    }
  }
}
