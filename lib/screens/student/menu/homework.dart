import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:tamdansers_app/constants/app_colors.dart';
import 'package:tamdansers_app/constants/app_images.dart';
import 'package:tamdansers_app/constants/app_number.dart';
import 'package:tamdansers_app/constants/text_style.dart';
import 'package:tamdansers_app/repositories/homework_repo.dart';
import 'package:tamdansers_app/repositories/student_class_repo.dart';
import 'package:tamdansers_app/repositories/user_repo.dart';
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

class Homework extends StatefulWidget {
  final int? userId;
  final int? selectedClassId;
  const Homework({super.key, this.userId, this.selectedClassId});
  
  @override
  State<Homework> createState() => _HomeworkState();
}

class _HomeworkState extends State<Homework> {
  int selectedIndex = 0;
  List<Map<String, dynamic>> homeworkData = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHomework();
  }

  @override
  void didUpdateWidget(Homework oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedClassId != widget.selectedClassId) {
      _loadHomework();
    }
  }

  Future<void> _loadHomework() async {
    if (widget.userId == null) return;
    setState(() => isLoading = true);
    try {
      final user = await UserRepo().getUserById(widget.userId!);
      if (user != null) {
        final email = user['email'] as String?;
        if (email != null && email.isNotEmpty) {
          final enrolledClasses = await StudentClassRepo().getEnrolledClassesByEmail(email);
          if (enrolledClasses.isNotEmpty) {
            // Use selected class if provided, otherwise use first class
            final classData = widget.selectedClassId != null
                ? enrolledClasses.firstWhere(
                    (cls) => cls['id'] == widget.selectedClassId,
                    orElse: () => enrolledClasses.first,
                  )
                : enrolledClasses.first;
            
            final studentClassRecord = await StudentClassRepo()
                .getStudentClassByUserIdAndClassId(widget.userId!, classData['id']);
            
            if (studentClassRecord != null) {
              final homework = await HomeworkRepo().getHomeworkForStudent(studentClassRecord['id'], classData['id']);
              setState(() => homeworkData = homework);
            }
          }
        }
      }
    } catch (e) {
      debugPrint("Error loading homework: $e");
      
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('កិច្ចការផ្ទះ',style: AppTextStyle.sectionTitle20,),
        centerTitle: true,
        actions: [
          SvgPicture.asset(
            AppImages.notification,
            height: AppNumber.iconSmall,
          ),
          SizedBox(width: 20,)
        ],
        
      ),
      body: Column(
        children: [
          const SizedBox(height: 12),
          tabWidget(),
          const SizedBox(height: 12),

          Expanded(
            child: selectedIndex == 0
                ? oldTaskListWidget()
                : newTaskListWidget(),
          ),
        ], 
      )
    );
  }

Widget tabWidget() {
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
            left: selectedIndex == 0 ? 5 : null,
            right: selectedIndex == 1 ? 5 : null,
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
                  isActive: selectedIndex == 0,
                  onTap: () => setState(() => selectedIndex = 0),
                ),
              ),
              Expanded(
                child: _buildTabButton(
                  label: "កំពុងបន្ត",
                  isActive: selectedIndex == 1,
                  onTap: () => setState(() => selectedIndex = 1),
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

  Widget taskCard({
  required String title,
  required String subtitle,
  required String date,
  IconData? icon,            
  String? imagePath,         
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
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: imagePath != null
                    ? Image.asset(
                        imagePath,
                        fit: BoxFit.cover,
                      )
                    : icon != null
                        ? Icon(icon, color: color)
                        : const SizedBox(),
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.detailTeach,
                        arguments: title,
                      );
                    },
                    child: Text(
                      title,
                      style: AppTextStyle.fontsize18,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: AppTextStyle.caption14Secondary
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
                fontWeight:
                    isClosed ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            const Spacer(),
          ],
        )
      ],
    ),
  );
}

Widget taskListWidget() {
  if (isLoading) {
    return const Center(child: CircularProgressIndicator());
  }
  
  if (homeworkData.isEmpty) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.assignment_turned_in, size: 60, color: AppColors.primaryMain),
            const SizedBox(height: 16),
            Text(
              'មិនមានកិច្ចការ',
              style: AppTextStyle.subtitle16,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
  
  final filteredHomework = homeworkData.where((h) => h['submitted'] == 1).toList();
  
  if (filteredHomework.isEmpty) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(
          'មិនមានកិច្ចការដែលបានបញ្ចប់',
          style: AppTextStyle.body,
          textAlign: TextAlign.center,
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
            arguments: {'homework': homework, 'userId': widget.userId},
          );
        },
        child: Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: taskCard(
            title: homework['title'] ?? 'មិនបានកំណត់',
            subtitle: homework['instructions'] ?? '',
            date: _formatDate(deadline),
            icon: Icons.assignment,
            color: AppColors.primaryMain,
            status: status,
            isClosed: false,
          ),
        ),
      );
    },
  );
}

Widget oldTaskListWidget() {
  return taskListWidget(); 
}

Widget newTaskListWidget() {
  if (isLoading) {
    return const Center(child: CircularProgressIndicator());
  }
  
  final filteredHomework = homeworkData.where((h) => h['submitted'] != 1).toList();
  
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
            arguments: {'homework': homework, 'userId': widget.userId},
          );
        },
        child: Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: taskCard(
            title: homework['title'] ?? 'មិនបានកំណត់',
            subtitle: homework['instructions'] ?? '',
            date: _formatDate(deadline),
            icon: Icons.assignment_late,
            color: isDeadlinePassed ? AppColors.error : AppColors.primaryMain,
            status: status,
            isClosed: isDeadlinePassed,
          ),
        ),
      );
    },
  );
}
}