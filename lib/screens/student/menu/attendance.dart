import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tamdansers_app/constants/app_colors.dart';
import 'package:tamdansers_app/constants/text_style.dart';
import 'package:tamdansers_app/repositories/attendance_repo.dart';
import 'package:tamdansers_app/repositories/class_repo.dart';
import 'package:tamdansers_app/repositories/student_class_repo.dart';
import 'package:tamdansers_app/repositories/user_repo.dart';
import 'package:tamdansers_app/widget/attendance_db.dart';

const List<String> khmerMonths = [
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
  'ធ្នូ'
];

String _formatDateWithDay(String dateString) {
  try {
    final date = DateTime.parse(dateString);
    return DateFormat('EEEE, dd MMMM yyyy', 'km').format(date);
  } catch (e) {
    return dateString;
  }
}

String _getMonthLabel(int month) {
  if (month >= 1 && month <= 12) {
    return khmerMonths[month - 1];
  }
  return 'មិនបានកំណត់';
}

class Attendance extends StatefulWidget {
  final int? userId;
  final int? classId;
  const Attendance({super.key, this.userId, this.classId});

  @override
  State<Attendance> createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  List<Map<String, dynamic>> attendanceHistory = [];
  Map<String, int>? attendanceSummary;
  bool isLoading = true;
  late int _classId;
  late int _currentMonth;
  String _teacherName = 'មិនបានកំណត់';
  
  @override
  void initState() {
    super.initState();
    _currentMonth = DateTime.now().month;
    _loadAttendanceData();
  }

  Future<void> _loadAttendanceData({int? month}) async {
    if (widget.userId == null) return;
    if (month == null) {
      setState(() => isLoading = true);
    }
    try {
      final user = await UserRepo().getUserById(widget.userId!);
      if (user != null) {
        final email = user['email'] as String?;
        if (email != null && email.isNotEmpty) {
          int? classId = widget.classId;
        
          if (classId == null) {
            final enrolledClasses = await StudentClassRepo().getEnrolledClassesByEmail(email);
            if (enrolledClasses.isNotEmpty) {
              classId = enrolledClasses.first['id'] as int;
            }
          }
          
          if (classId != null) {
            _classId = classId;
            
            final classInfo = await ClassRepo().getClassById(_classId);
            if (classInfo != null) {
              final teacherId = classInfo['teacher_id'] as int?;
              if (teacherId != null) {
                final teacher = await UserRepo().getUserById(teacherId);
                if (teacher != null) {
                  _teacherName = '${teacher['first_name']} ${teacher['last_name']}';
                }
              }
            }
            
            final studentClassRecord = await StudentClassRepo()
                .getStudentClassByUserIdAndClassId(widget.userId!, _classId);
            
            if (studentClassRecord != null) {
              final targetMonth = month ?? _currentMonth;
              final monthString = targetMonth.toString().padLeft(2, '0');
              
              final summary = await AttendanceRepo().getAttendanceSummaryForStudent(
                studentClassRecord['id'],
                _classId,
                '2026-$monthString',
              );
              final history = await AttendanceRepo().getAttendanceHistoryForStudent(
                studentClassRecord['id'],
                _classId,
              );

              final filteredHistory = history.where((entry) {
                try {
                  final date = DateTime.parse(entry['date'] as String? ?? '');
                  return date.month == targetMonth;
                } catch (e) {
                  return false;
                }
              }).toList();

              setState(() {
                attendanceSummary = summary;
                attendanceHistory = filteredHistory;
                _currentMonth = targetMonth;
              });
            }
          }
        }
      }
    } catch (e) {
      debugPrint('Error loading attendance data: $e');
    } finally {
      if (month == null) {
        setState(() => isLoading = false);
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    final summary = attendanceSummary;
    if (summary == null) {
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            'វត្តមាន',
            style: AppTextStyle.sectionTitle20,
          ),
          centerTitle: true,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.calendar_today, size: 60, color: AppColors.primaryMain),
                const SizedBox(height: 16),
                Text(
                  'មិនមានទិន្នន័យ',
                  style: AppTextStyle.subtitle16,
                ),
              ],
            ),
          ),
        ),
      );
    }

    final total = summary['total'] ?? 0;
    final present = summary['present'] ?? 0;
    final absent = summary['absent'] ?? 0;
    final late = summary['late'] ?? 0;
    final presentDays = present + late;
    final attendanceRate = total == 0 ? 0.0 : (presentDays / total) * 100;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'វត្តមាន',
          style: AppTextStyle.sectionTitle20,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildMonthSelector(),
              const SizedBox(height: 20),
              CardAttendance(
                totalDays: total,
                presentDays: presentDays,
                absentDays: absent,
                attendanceRate: attendanceRate,
                monthLabel: _getMonthLabel(_currentMonth),
              ),

              const SizedBox(height: 20),
              Text('វត្តមាន', style: AppTextStyle.subtitle18),
              const SizedBox(height: 10),

              if (attendanceHistory.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      'មិនមានទិន្នន័យវត្តមានសម្រាប់ខែនេះ',
                      style: AppTextStyle.body.copyWith(
                        color: AppColors.secondaryText,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: attendanceHistory.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final entry = attendanceHistory[index];
                    final status = entry['status'] as String? ?? 'absent';
                    final dateString = entry['date'] as String? ?? '';

                    return _buildAttendanceCard(
                      dateString: dateString,
                      teacher: _teacherName,
                      status: status,
                    );
                  },
                )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMonthSelector() {
    List<String> months = [
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
      'ធ្នូ'
    ];
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        separatorBuilder: (context, index) => const SizedBox(width: 10),
        itemCount: 12,
        itemBuilder: (context, index) {
          final month = index + 1;
          final isSelected = month == _currentMonth;
          return GestureDetector(
            onTap: () => _loadAttendanceData(month: month),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOutBack,
              height: 30,
              width: 100,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primaryMain : AppColors.primaryBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  months[index],
                  style: AppTextStyle.subtitle16.copyWith(
                    color: isSelected ? AppColors.white : AppColors.secondaryText,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAttendanceCard({
    required String dateString,
    required String teacher,
    required String status,
  }) {
    Color backgroundColor;
    Color textColor;
    IconData icon;
    String statusLabel;

    switch (status) {
      case 'present':
        backgroundColor = AppColors.successBG;
        textColor = AppColors.success;
        icon = Icons.check_circle;
        statusLabel = 'វត្តមាន';
        break;
      case 'late':
        backgroundColor = const Color(0xFFfff3cd);
        textColor = const Color(0xFFff9800);
        icon = Icons.schedule;
        statusLabel = 'យឺត';
        break;
      case 'absent':
      default:
        backgroundColor = AppColors.errorBG;
        textColor = AppColors.error;
        icon = Icons.cancel;
        statusLabel = 'អវត្តមាន';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: backgroundColor,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: backgroundColor,
            ),
            child: Icon(
              icon,
              color: textColor,
              size: 28,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _formatDateWithDay(dateString),
                  style: AppTextStyle.subtitle16.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'គ្រូបង្រៀន: $teacher',
                  style: AppTextStyle.caption12Secondary,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              statusLabel,
              style: AppTextStyle.caption12Secondary.copyWith(
                color: textColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
