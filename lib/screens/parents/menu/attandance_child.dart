import 'dart:io' as io;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tamdansers_app/constants/app_colors.dart';
import 'package:tamdansers_app/constants/app_icon.dart';
import 'package:tamdansers_app/constants/app_number.dart';
import 'package:tamdansers_app/constants/text_style.dart';
import 'package:tamdansers_app/repositories/attendance_repo.dart';
import 'package:tamdansers_app/repositories/class_repo.dart';
import 'package:tamdansers_app/repositories/student_class_repo.dart';
import 'package:tamdansers_app/repositories/user_repo.dart';

class AttandanceScreen extends StatefulWidget {
  final int? studentClassId;
  final int? classId;
  
  const AttandanceScreen({super.key, this.studentClassId, this.classId});

  @override
  State<AttandanceScreen> createState() => _AttandanceScreenState();
}

class _AttandanceScreenState extends State<AttandanceScreen> {
  int _currentMonthIndex = 0;
  bool _isLoading = true;

  Map<String, dynamic> _student = {};
  String _teacherName = 'គ្រូ';
  int presentDays = 0;
  int lateDays = 0;
  int absentDays = 0;
  List<Map<String, dynamic>> _records = [];

  final List<String> _months = [
    'មករា',
    'កុម្ភៈ',
    'មីនា',
    'មេសា',
    'ឧសភា',
    'មិថុនា',
    'កក្កដា',
    'សីហា',
    'កញ្ញា',
    'តុលា',
    'វិច្ឆិកា',
    'ធ្នូ',
  ];

  @override
  void initState() {
    super.initState();
    _currentMonthIndex = DateTime.now().month - 1;
    _loadAttendanceData();
  }

  String _getYearMonthString(int monthIndex) {
    final now = DateTime.now();
    final year = now.year;
    final month = monthIndex + 1;
    return '$year-${month.toString().padLeft(2, '0')}';
  }

  Future<void> _loadAttendanceData() async {
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
        
        String teacherName = 'គ្រូ';
        if (classData != null && classData['teacher_id'] != null) {
          try {
            final userRepo = UserRepo();
            final teacherData = await userRepo.getUserById(classData['teacher_id'] as int);
            if (teacherData != null) {
              final firstName = teacherData['first_name'] as String? ?? '';
              final lastName = teacherData['last_name'] as String? ?? '';
              teacherName = '$firstName $lastName'.trim();
              if (teacherName.isEmpty) teacherName = 'គ្រូប្រឹក្សា';
            }
          } catch (e) {
            debugPrint('Error loading teacher: $e');
          }
        }
        final student = {
          ...studentData,
          'class_name': classData?['name'] ?? 'មិនបានកំណត់'
        };
        
        setState(() {
          _student = student;
          _teacherName = teacherName;
          _isLoading = false;
        });
        
        await _loadMonthAttendance();
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      debugPrint('Error loading attendance: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loadMonthAttendance() async {
    try {
      if (widget.studentClassId == null || widget.classId == null) return;
      final currentMonth = _getYearMonthString(_currentMonthIndex);
      final attendanceRepo = AttendanceRepo();
      final attendance = await attendanceRepo.getAttendanceByStudentAndMonth(
          widget.studentClassId!, widget.classId!, currentMonth);
      
      int present = 0;
      int late = 0;
      int absent = 0;
      
      for (var record in attendance) {
        final status = record['status'] as String?;
        if (status == 'present') present++;
        else if (status == 'late') late++;
        else if (status == 'absent') absent++;
      }
      
      setState(() {
        presentDays = present;
        lateDays = late;
        absentDays = absent;
        _records = _formatAttendanceRecords(attendance);
      });
    } catch (e) {
      debugPrint('Error loading month attendance: $e');
    }
  }

  List<Map<String, dynamic>> _formatAttendanceRecords(List<Map<String, dynamic>> attendance) {
    return attendance.map((record) {
      final date = record['date'] as String?;
      final status = record['status'] as String?;
      
      String khmerDate = _formatDateToKhmer(date ?? '');
      String statusKhmer = 'វត្តមាន';
      String statusType = 'presents';
      
      if (status == 'late') {
        statusKhmer = 'យឺត';
        statusType = 'late';
      } else if (status == 'absent') {
        statusKhmer = 'អវត្តមាន';
        statusType = 'absent';
      }
      
      return {
        'day': khmerDate,
        'teacher': _teacherName,
        'status': statusKhmer,  
        'type': statusType,
      };
    }).toList();
  }

  String _formatDateToKhmer(String date) {
    if (date.isEmpty) return 'មិនមាន';
    try {
      final parts = date.split('-');
      if (parts.length != 3) return date;
      
      final year = parts[0];
      final month = int.parse(parts[1]);
      final day = int.parse(parts[2]);
      
      final months = [
        'មករា', 'កុម្ភៈ', 'មីនា', 'មេសា', 'ឧសភា', 'មិថុនា',
        'កក្កដា', 'សីហា', 'កញ្ញា', 'តុលា', 'វិច្ឆិកា', 'ធ្នូ'
      ];
      
      final monthKhmer = months[month - 1];
      return 'ថ្ងៃទី$day ខែ$monthKhmer ឆ្នាំ$year';
    } catch (e) {
      return date;
    }
  }

  void _previousMonth() {
    if (_currentMonthIndex > 0) {
      setState(() => _currentMonthIndex--);
      _loadMonthAttendance();
    }
  }

  void _nextMonth() {
    if (_currentMonthIndex < 11) {
      setState(() => _currentMonthIndex++);
      _loadMonthAttendance();
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
          title: Text('វត្តមាន', style: AppTextStyle.sectionTitle20),
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
        title: Text('វត្តមាន', style: AppTextStyle.sectionTitle20),
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child:
                Icon(Icons.notifications_sharp, color: AppColors.primaryText),
          ),
        ],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primaryText),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              _buildProfileHeader(),
              const SizedBox(height: 16),
              _buildMonthSelector(),
              const SizedBox(height: 16),
              _buildStatsRow(),
              const SizedBox(height: 20),
              Text("វត្តមាន", style: AppTextStyle.subtitle18),
              const SizedBox(height: 12),
              _buildAttendanceList(),
            ],
          ),
        ),
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
                student['class_name'] ?? '',
                style: AppTextStyle.caption13Secondary,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMonthSelector() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: _previousMonth,
              child: const Icon(Icons.chevron_left,
                  size: 28, color: AppColors.primaryText),
            ),
            const SizedBox(width: 8),
            Text(
              _months[_currentMonthIndex],
              style: AppTextStyle.subtitle18,
            ),
            const SizedBox(width: 6),
            Icon(Icons.calendar_today,
                size: 18, color: AppColors.secondaryText),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: _nextMonth,
              child: const Icon(Icons.chevron_right,
                  size: 28, color: AppColors.primaryText),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        _buildStatCard(
          icon: Icons.check_circle_outline,
          iconColor: AppColors.success,
          label: "វត្តមាន",
          value: presentDays.toString(),
          unit: "ថ្ងៃ",
          bgColor: AppColors.primaryBg,
          valueBgColor: const Color(0xFFD6E9FF),
          valueColor: AppColors.success,
        ),
        const SizedBox(width: 10),
        _buildStatCard(
          icon: Icons.access_time,
          iconColor: AppColors.orange,
          label: "យឺត",
          value: lateDays.toString(),
          unit: "ថ្ងៃ",
          bgColor: const Color(0xFFFFF3E0),
          valueBgColor: const Color(0xFFFFE0B2),
          valueColor: AppColors.orange,
        ),
        const SizedBox(width: 10),
        _buildStatCard(
          icon: Icons.cancel_outlined,
          iconColor: AppColors.error,
          label: "អវត្តមាន",
          value: absentDays.toString(),
          unit: "ថ្ងៃ",
          bgColor: AppColors.errorBG,
          valueBgColor: const Color(0xFFFFCDD2),
          valueColor: AppColors.error,
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
    required String unit,
    required Color bgColor,
    required Color valueBgColor,
    required Color valueColor,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(AppNumber.radiusMedium),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 16, color: iconColor),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    label,
                    style: GoogleFonts.kantumruyPro(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: iconColor,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: GoogleFonts.kantumruyPro(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: valueColor,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              unit,
              style: GoogleFonts.kantumruyPro(
                fontSize: 13,
                color: valueColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttendanceList() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _records.length,
      separatorBuilder: (_, __) => Divider(
        color: AppColors.lightgrey,
        height: 1,
      ),
      itemBuilder: (context, index) {
        final record = _records[index];
        return _buildAttendanceItem(record);
      },
    );
  }

  Widget _buildAttendanceItem(Map<String, dynamic> record) {
    final type = record["type"] as String;

    Color statusColor;
    Color statusBgColor;
    Color dotColor;

    switch (type) {
      case "presents":
      case "present":
        statusColor = AppColors.success;
        statusBgColor = AppColors.primaryBg;
        dotColor = AppColors.success;
        break;
      case "late":
        statusColor = AppColors.orange;
        statusBgColor = const Color(0xFFFFF3E0);
        dotColor = AppColors.orange;
        break;
      case "absent":
        statusColor = AppColors.error;
        statusBgColor = AppColors.errorBG;
        dotColor = AppColors.error;
        break;
      default:
        statusColor = AppColors.secondaryText;
        statusBgColor = AppColors.backgroundLight;
        dotColor = AppColors.secondaryText;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: dotColor,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  record["day"],
                  style: AppTextStyle.subtitle16,
                ),
                const SizedBox(height: 2),
                Text(
                  "គ្រូបន្ទុកថ្នាក់: ${record["teacher"]}",
                  style: AppTextStyle.caption13Secondary,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: statusBgColor,
              borderRadius: BorderRadius.circular(AppNumber.radiusRounded),
            ),
            child: Text(
              record["status"],
              style: GoogleFonts.kantumruyPro(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: statusColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

}
