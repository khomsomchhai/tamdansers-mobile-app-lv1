import 'package:flutter/material.dart';
import 'package:tamdansers_app/constants/app_colors.dart';
import 'package:tamdansers_app/constants/app_number.dart';
import 'package:tamdansers_app/constants/text_style.dart';
import 'package:tamdansers_app/screens/widget/custom_snackbar.dart';

class TeacherNotificationScreen extends StatefulWidget {
  const TeacherNotificationScreen({super.key});

  @override
  State<TeacherNotificationScreen> createState() => _TeacherNotificationScreenState();
}

class _TeacherNotificationScreenState extends State<TeacherNotificationScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  String _selectedRecipient = 'all_students';

  @override
  void dispose() {
    _titleController.dispose();
    _messageController.dispose();
    super.dispose();
  }
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        content: CustomSnackbar(
          title: "កំហុស!",
          message: message,
          icon: Icons.close,
          color: AppColors.error,
        ),
      ),
    );
  }
  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        content: CustomSnackbar(
          title: "ជោកជ័យ!",
          message: message,
          icon: Icons.close,
          color: AppColors.success,
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ផ្ញើរសេចក្តីជូនដំណឹង', style: AppTextStyle.sectionTitle20),
        centerTitle: true,
        backgroundColor: AppColors.backgroundLight,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppNumber.sectionPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ជ្រើសរើសអ្នកទទួល', style: AppTextStyle.subtitle18),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppNumber.radiusLarge),
              ),
              child: DropdownButton<String>(
                value: _selectedRecipient,
                isExpanded: true,
                underline: const SizedBox(),
                items: [
                  DropdownMenuItem(
                    value: 'all_students',
                    child: Text('សិស្សទាំងអស់',style: AppTextStyle.body,),
                  ),
                  DropdownMenuItem(
                    value: 'specific_class',
                    child: Text('ថ្នាក់ទាំងអស់', style: AppTextStyle.body,),
                  ),
                  DropdownMenuItem(
                    value: 'parents',
                    child: Text('ឪពុកម្តាយ', style: AppTextStyle.body),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedRecipient = value!;
                  });
                },
              ),
            ),
            const SizedBox(height: 24),
            Text('ចំណងជើង', style: AppTextStyle.subtitle18),
            const SizedBox(height: 12),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: 'បញ្ចូលចំណងជើងសេចក្តីជូនដំណឹង',
                hintStyle: AppTextStyle.hintText,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppNumber.radiusLarge),
                ),
                filled: true,
                fillColor: AppColors.white,
              ),
            ),
            const SizedBox(height: 24),
            Text('សារសេចក្តីជូនដំណឹង', style: AppTextStyle.subtitle18),
            const SizedBox(height: 12),
            TextField(
              controller: _messageController,
              maxLines: 5,
              
              decoration: InputDecoration(
                hintText: 'បញ្ចូលសារសេចក្តីជូនដំណឹង',
                hintStyle: AppTextStyle.hintText,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppNumber.radiusLarge),
                ),
                filled: true,
                fillColor: AppColors.white,
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _sendNotification,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryMain,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppNumber.radiusLarge),
                  ),
                ),
                child: Text(
                  'ផ្ញើសេចក្តីជូនដំណឹង',
                  style: AppTextStyle.buttonText16White,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _sendNotification() {
    final title = _titleController.text.trim();
    final message = _messageController.text.trim();

    if (title.isEmpty || message.isEmpty) {
      _showError("សូមបំពេញចំណងជើង និងសារសេចក្តីជូនដំណឹង");
      return;
    }

    // TODO: Implement actual notification sending logic
    _showSuccess("សេចក្តីជូនដំណឹងត្រូវបានផ្ញើរដោយជោគជ័យ");

    // Clear fields
    _titleController.clear();
    _messageController.clear();
  }
}