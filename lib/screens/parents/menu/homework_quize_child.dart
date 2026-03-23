import 'dart:io' as io;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tamdansers_app/constants/app_colors.dart';
import 'package:tamdansers_app/constants/app_icon.dart';
import 'package:tamdansers_app/constants/app_number.dart';
import 'package:tamdansers_app/constants/text_style.dart';
import 'package:tamdansers_app/repositories/class_repo.dart';
import 'package:tamdansers_app/repositories/homework_repo.dart';
import 'package:tamdansers_app/repositories/student_class_repo.dart';
import 'package:tamdansers_app/routes/app_routes.dart';

enum TaskStatus {
  completed,
  notSubmitted,
  inProgress,
  late,
}

TaskStatus _determineStatus({
  required int submitted,
  required String deadline,
}) {
  if (submitted == 1) {
    return TaskStatus.completed;
  }
  
  try {
    final deadlineDate = DateTime.parse(deadline);
    final now = DateTime.now();
    
    if (now.isAfter(deadlineDate)) {
      return TaskStatus.late;
    }
    return TaskStatus.inProgress;
  } catch (e) {
    return TaskStatus.notSubmitted;
  }
}

String _formatDate(String dateString) {
  try {
    final date = DateTime.parse(dateString);
    return DateFormat('dd MMMM yyyy', 'km').format(date);
  } catch (e) {
    return dateString;
  }
}

Color _statusColor(TaskStatus status) {
  switch (status) {
    case TaskStatus.completed:
      return AppColors.success;
    case TaskStatus.notSubmitted:
      return AppColors.error;
    case TaskStatus.inProgress:
      return AppColors.primaryMain;
    case TaskStatus.late:
      return AppColors.orange;
  }
}

String _statusText(TaskStatus status) {
  switch (status) {
    case TaskStatus.completed:
      return "បានបញ្ចប់";
    case TaskStatus.notSubmitted:
      return "មិនទាន់ផ្ញើរ";
    case TaskStatus.inProgress:
      return "កំពុងរៀបចំ";
    case TaskStatus.late:
      return "យឺតយ៉ាវ";
  }
}

class HomeworkQuizeScreen extends StatefulWidget {
  final int? studentClassId;
  final int? classId;
  
  const HomeworkQuizeScreen({super.key, this.studentClassId, this.classId});
  
  @override
  State<HomeworkQuizeScreen> createState() => _HomeworkQuizeScreenState();
}

class _HomeworkQuizeScreenState extends State<HomeworkQuizeScreen> {
  int _selectedTab = 0;
  bool _isLoading = true;
  Map<String, dynamic> _student = {};
  String? _className;
  List<Map<String, dynamic>> _homeworkData = [];

  @override
  void initState() {
    super.initState();
    _loadStudentData();
  }

  Future<void> _loadStudentData() async {
    try {
      setState(() => _isLoading = true);
      
      if (widget.studentClassId == null || widget.classId == null) {
        setState(() => _isLoading = false);
        return;
      }

      final studentClassRepo = StudentClassRepo();
      final studentData = await studentClassRepo.getStudentById(widget.studentClassId!);
      
      if (studentData != null) {
        final classRepo = ClassRepo();
        final classData = await classRepo.getClassById(widget.classId!);
        
        final homeworkData = await HomeworkRepo().getHomeworkForStudent(widget.studentClassId!, widget.classId!);
        
        setState(() {
          _student = studentData;
          _className = classData?['name'] ?? 'មិនបានកំណត់';
          _homeworkData = homeworkData;
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      debugPrint('Error loading student: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppColors.backgroundLight,
        appBar: AppBar(
          backgroundColor: AppColors.backgroundLight,
          elevation: 0,
          scrolledUnderElevation: 0,
          title: Text('កិច្ចការផ្ទះ', style: AppTextStyle.sectionTitle20),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.primaryText),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundLight,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text('កិច្ចការផ្ទះ', style: AppTextStyle.sectionTitle20),
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Icon(Icons.notifications_sharp, color: AppColors.primaryText),
          ),
        ],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primaryText),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _buildProfileHeader(),
          ),
          const SizedBox(height: 16),
          _buildTabSelector(),
          const SizedBox(height: 12),
          Expanded(
            child: _selectedTab == 0
                ? _buildCompletedTaskList()
                : _buildInProgressTaskList(),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    final student = _student;
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
                _className ?? 'មិនបានកំណត់',
                style: AppTextStyle.caption13Secondary,
              ),
            ],
          ),
        ),

      ],
    );
  }

  Widget _buildTabSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Container(
        height: 52,
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: const Color(0xFFEFF2F6),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 320),
              curve: Curves.easeInOutCubicEmphasized,
              left: _selectedTab == 0 ? 5 : null,
              right: _selectedTab == 1 ? 5 : null,
              top: 5,
              bottom: 5,
              width: (MediaQuery.sizeOf(context).width - 36 - 10) / 2,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.07),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: _buildTabButton(
                    label: "បានបញ្ចប់",
                    isActive: _selectedTab == 0,
                    onTap: () => setState(() => _selectedTab = 0),
                  ),
                ),
                Expanded(
                  child: _buildTabButton(
                    label: "កំពុងបន្ត",
                    isActive: _selectedTab == 1,
                    onTap: () => setState(() => _selectedTab = 1),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton({
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Center(
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 280),
          style: AppTextStyle.subtitle18.copyWith(
            color: isActive ? AppColors.primaryMain : AppColors.secondaryText,
          ),
          child: Text(label),
        ),
      ),
    );
  }

  Widget _buildCompletedTaskList() {
    final filteredHomework = _homeworkData.where((h) => h['submitted'] == 1).toList();

    if (filteredHomework.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.assignment_turned_in, size: 60, color: AppColors.primaryMain),
              const SizedBox(height: 16),
              Text(
                'មិនមានកិច្ចការដែលបានបញ្ចប់',
                style: AppTextStyle.subtitle16,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(18),
      itemCount: filteredHomework.length,
      itemBuilder: (context, index) {
        final homework = filteredHomework[index];
        final deadline = homework['deadline'] as String? ?? '';
        final submitted = homework['submitted'] as int? ?? 0;
        final status = _determineStatus(submitted: submitted, deadline: deadline);

        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(
              context,
              AppRoutes.detail,
              arguments: {'homework': homework, 'studentClassId': widget.studentClassId},
            );
          },
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: _buildTaskCard(
              title: homework['title'] ?? 'មិនបានកំណត់',
              subtitle: homework['instructions'] ?? '',
              date: _formatDate(deadline),
              color: AppColors.primaryMain,
              status: status,
              isClosed: false,
            ),
          ),
        );
      },
    );
  }

  Widget _buildInProgressTaskList() {
    final filteredHomework = _homeworkData.where((h) => h['submitted'] != 1).toList();

    if (filteredHomework.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle, size: 60, color: AppColors.success),
              const SizedBox(height: 16),
              Text(
                'អ្នកបានបញ្ចប់កិច្ចការទាំងអស់',
                style: AppTextStyle.subtitle16,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: filteredHomework.length,
      itemBuilder: (context, index) {
        final homework = filteredHomework[index];
        final deadline = homework['deadline'] as String? ?? '';
        final submitted = homework['submitted'] as int? ?? 0;
        final status = _determineStatus(submitted: submitted, deadline: deadline);
        final isDeadlinePassed = status == TaskStatus.late;

        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(
              context,
              AppRoutes.detail,
              arguments: {'homework': homework, 'studentClassId': widget.studentClassId},
            );
          },
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: _buildTaskCard(
              title: homework['title'] ?? 'មិនបានកំណត់',
              subtitle: homework['instructions'] ?? '',
              date: _formatDate(deadline),
              color: isDeadlinePassed ? AppColors.error : AppColors.primaryMain,
              status: status,
              isClosed: isDeadlinePassed,
            ),
          ),
        );
      },
    );
  }

  Widget _buildTaskCard({
    required String title,
    required String subtitle,
    required String date,
    required Color color,
    required TaskStatus status,
    required bool isClosed,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppNumber.radiusMedium),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(Icons.assignment, color: color),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyle.fontsize18,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: AppTextStyle.caption14Secondary,
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: _statusColor(status).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _statusText(status),
                  style: AppTextStyle.caption12Secondary.copyWith(
                    fontWeight: FontWeight.bold,
                    color: _statusColor(status),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.calendar_month, size: 16, color: Colors.grey),
              const SizedBox(width: 6),
              Text(
                isClosed ? "ឈប់ទទួល $date" : "បានផ្ញើរ $date",
                style: AppTextStyle.hintText.copyWith(
                  color: isClosed ? AppColors.error : AppColors.secondaryText,
                  fontWeight: isClosed ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              const Spacer(),
            ],
          )
        ],
      ),
    );
  }
}
