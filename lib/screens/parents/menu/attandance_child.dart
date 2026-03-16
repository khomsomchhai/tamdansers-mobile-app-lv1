import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tamdansers_app/constants/app_colors.dart';
import 'package:tamdansers_app/constants/app_images.dart';
import 'package:tamdansers_app/constants/app_number.dart';
import 'package:tamdansers_app/constants/text_style.dart';
import 'package:tamdansers_app/database/db_helper.dart';
import 'package:tamdansers_app/repositories/parent_student_repo.dart';
import 'package:tamdansers_app/repositories/user_repo.dart';
import 'package:tamdansers_app/screens/parents/menu/attendance_student_data.dart';

class AttandanceScreen extends StatefulWidget {
  const AttandanceScreen({super.key});

  @override
  State<AttandanceScreen> createState() => _AttandanceScreenState();
}

class _AttandanceScreenState extends State<AttandanceScreen> {
  final AttendanceStudentData _attendanceRepo = AttendanceStudentData();
  final ParentStudentRepo _parentStudentRepo = ParentStudentRepo();

  bool _isLoading = true;
  String? _errorMessage;

  List<Map<String, dynamic>> _students = [];
  Map<String, dynamic>? _selectedStudent;

  int _currentMonthIndex = 0;
  List<String> _monthKeys = [];

  int presentDays = 0;
  int lateDays = 0;
  int absentDays = 0;

  List<Map<String, dynamic>> _records = [];

  @override
  void initState() {
    super.initState();
    _loadRoleBasedAttendance();
  }

  String _currentMonthKey() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}';
  }

  Future<void> _loadRoleBasedAttendance() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final pref = await SharedPreferences.getInstance();
      final userId = pref.getInt('userId');
      final role = pref.getString('role');

      if (userId == null || role == null) {
        setState(() {
          _errorMessage = 'មិនមានព័ត៌មានអ្នកប្រើប្រាស់';
          _isLoading = false;
        });
        return;
      }

      if (role == 'parent') {
        _students = await _parentStudentRepo.getStudentsByParent(userId);
      } else if (role == 'student') {
        final student = await _resolveStudentFromCurrentUser(userId);
        _students = student != null ? [student] : [];
      } else {
        _students = [];
      }

      if (_students.isEmpty) {
        setState(() {
          _errorMessage = 'មិនមានទិន្នន័យសិស្សសម្រាប់បង្ហាញវត្តមាន';
          _records = [];
          presentDays = 0;
          lateDays = 0;
          absentDays = 0;
          _monthKeys = [_currentMonthKey()];
          _currentMonthIndex = 0;
          _isLoading = false;
        });
        return;
      }

      _selectedStudent = _students.first;
      await _loadAttendanceForSelectedStudent(resetMonth: true);
    } catch (_) {
      setState(() {
        _errorMessage = 'មិនអាចទាញយកទិន្នន័យវត្តមានបានទេ';
        _isLoading = false;
      });
    }
  }

  Future<Map<String, dynamic>?> _resolveStudentFromCurrentUser(
      int userId) async {
    final user = await UserRepo().getUserById(userId);
    if (user == null) return null;

    final db = await DbHelper().initDatabase();

    final email = user['email'] as String?;
    if (email != null && email.trim().isNotEmpty) {
      final byEmail = await db.rawQuery(
        '''SELECT sc.id as student_id, sc.first_name, sc.last_name, sc.class_id, c.name as class_name
           FROM tbl_student_class sc
           LEFT JOIN tbl_class c ON sc.class_id = c.id
           WHERE sc.email = ?
           LIMIT 1''',
        [email.trim()],
      );
      if (byEmail.isNotEmpty) return Map<String, dynamic>.from(byEmail.first);
    }

    final classId = user['class_id'] as int?;
    final byNameAndClass = await db.rawQuery(
      '''SELECT sc.id as student_id, sc.first_name, sc.last_name, sc.class_id, c.name as class_name
         FROM tbl_student_class sc
         LEFT JOIN tbl_class c ON sc.class_id = c.id
         WHERE sc.first_name = ? AND sc.last_name = ?
           AND (? IS NULL OR sc.class_id = ?)
         ORDER BY sc.id DESC
         LIMIT 1''',
      [user['first_name'], user['last_name'], classId, classId],
    );

    if (byNameAndClass.isNotEmpty) {
      return Map<String, dynamic>.from(byNameAndClass.first);
    }

    return null;
  }

  Future<void> _loadAttendanceForSelectedStudent(
      {required bool resetMonth}) async {
    if (_selectedStudent == null) return;

    final studentId =
        (_selectedStudent!['student_id'] ?? _selectedStudent!['id']) as int?;
    if (studentId == null) {
      setState(() {
        _errorMessage = 'រកមិនឃើញលេខសម្គាល់សិស្ស';
        _isLoading = false;
      });
      return;
    }

    final months = await _attendanceRepo.getDistinctMonthsByStudent(studentId);
    final nowMonth = _currentMonthKey();
    if (!months.contains(nowMonth)) {
      months.insert(0, nowMonth);
    }

    if (resetMonth || _monthKeys.isEmpty) {
      _monthKeys = months;
      _currentMonthIndex = 0;
    } else {
      _monthKeys = months;
      if (_currentMonthIndex >= _monthKeys.length) {
        _currentMonthIndex = 0;
      }
    }

    final selectedMonthKey = _monthKeys[_currentMonthIndex];
    final attendanceRows = await _attendanceRepo.getAttendanceByStudent(
      studentId,
      monthPrefix: selectedMonthKey,
    );

    final summary = await _attendanceRepo.getAttendanceSummaryByStudent(
      studentId,
      monthPrefix: selectedMonthKey,
    );

    final mappedRecords = attendanceRows.map((row) {
      final date = (row['date'] as String?) ?? '';
      final status = (row['status'] as String?) ?? 'present';

      final type = switch (status) {
        'late' => 'late',
        'absent' => 'absent',
        _ => 'present',
      };

      final statusKh = switch (status) {
        'late' => 'យឺត',
        'absent' => 'អវត្តមាន',
        _ => 'វត្តមាន',
      };

      final noteText = switch (status) {
        'late' => 'បានចូលរៀនយឺត',
        'absent' => 'អវត្តមាន',
        _ => 'បានចូលរៀន',
      };

      return {
        'day': _formatDayLabel(date),
        'time': noteText,
        'status': statusKh,
        'type': type,
      };
    }).toList();

    if (!mounted) return;
    setState(() {
      _records = mappedRecords;
      presentDays = summary['present'] ?? 0;
      lateDays = summary['late'] ?? 0;
      absentDays = summary['absent'] ?? 0;
      _isLoading = false;
      _errorMessage = null;
    });
  }

  String _formatDayLabel(String isoDate) {
    final date = DateTime.tryParse(isoDate);
    if (date == null) return isoDate;

    const weekdays = [
      'ថ្ងៃចន្ទ',
      'ថ្ងៃអង្គារ',
      'ថ្ងៃពុធ',
      'ថ្ងៃព្រហស្បតិ៍',
      'ថ្ងៃសុក្រ',
      'ថ្ងៃសៅរ៍',
      'ថ្ងៃអាទិត្យ',
    ];

    final weekday = weekdays[date.weekday - 1];
    return '$weekday, ${date.day}-${date.month}-${date.year}';
  }

  String _formatMonthLabel(String monthKey) {
    final parts = monthKey.split('-');
    if (parts.length != 2) return monthKey;
    final year = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    if (year == null || month == null || month < 1 || month > 12) {
      return monthKey;
    }

    const khMonths = [
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

    return '${khMonths[month - 1]} $year';
  }

  Future<void> _pickStudent() async {
    if (_students.length <= 1) return;

    final selected = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      backgroundColor: AppColors.white,
      builder: (context) {
        return SafeArea(
          child: ListView.separated(
            itemCount: _students.length,
            separatorBuilder: (_, __) => Divider(color: AppColors.lightgrey),
            itemBuilder: (context, index) {
              final student = _students[index];
              final name =
                  '${student['first_name'] ?? ''} ${student['last_name'] ?? ''}'
                      .trim();
              final className = (student['class_name'] as String?) ?? '';

              return ListTile(
                title: Text(name.isEmpty ? 'Student' : name,
                    style: AppTextStyle.subtitle16),
                subtitle: className.isEmpty ? null : Text(className),
                onTap: () => Navigator.pop(context, student),
              );
            },
          ),
        );
      },
    );

    if (selected == null) return;

    setState(() {
      _selectedStudent = selected;
      _isLoading = true;
    });

    await _loadAttendanceForSelectedStudent(resetMonth: true);
  }

  void _previousMonth() {
    if (_currentMonthIndex > 0) {
      setState(() {
        _currentMonthIndex--;
        _isLoading = true;
      });
      _loadAttendanceForSelectedStudent(resetMonth: false);
    }
  }

  void _nextMonth() {
    if (_currentMonthIndex < _monthKeys.length - 1) {
      setState(() {
        _currentMonthIndex++;
        _isLoading = true;
      });
      _loadAttendanceForSelectedStudent(resetMonth: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundLight,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text('វត្តមាន', style: AppTextStyle.screenTitle24),
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppNumber.screenPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_errorMessage != null) ...[
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          color: AppColors.errorBG,
                          borderRadius:
                              BorderRadius.circular(AppNumber.radiusSmall),
                        ),
                        child: Text(
                          _errorMessage!,
                          style: AppTextStyle.caption14Secondary
                              .copyWith(color: AppColors.error),
                        ),
                      ),
                    ],
                    const SizedBox(height: 12),
                    _buildProfileHeader(),
                    const SizedBox(height: 16),
                    _buildMonthSelector(),
                    const SizedBox(height: 16),
                    _buildStatsRow(),
                    const SizedBox(height: 20),
                    Text("កំណត់សហេតុប្រចាំថ្ងៃ",
                        style: AppTextStyle.subtitle18),
                    const SizedBox(height: 12),
                    _buildAttendanceList(),
                    const SizedBox(height: 16),
                    _buildRequestLeaveButton(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
    );
  }

  // ==================== PROFILE HEADER ====================
  Widget _buildProfileHeader() {
    final firstName = (_selectedStudent?['first_name'] as String?) ?? '';
    final lastName = (_selectedStudent?['last_name'] as String?) ?? '';
    final className = (_selectedStudent?['class_name'] as String?) ?? '';
    final studentId =
        (_selectedStudent?['student_id'] ?? _selectedStudent?['id'])
                ?.toString() ??
            '-';

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
            child: Image.asset(AppImages.userProfile, fit: BoxFit.cover),
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
                    '$firstName $lastName'.trim().isEmpty
                        ? 'Student'
                        : '$firstName $lastName'.trim(),
                    style: AppTextStyle.subtitle18,
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: _pickStudent,
                    child: Icon(Icons.keyboard_arrow_down,
                        size: 20, color: AppColors.secondaryText),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                '${className.isEmpty ? "ថ្នាក់" : className} ID: #$studentId',
                style: AppTextStyle.caption13Secondary,
              ),
            ],
          ),
        ),
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.backgroundLight,
            border: Border.all(color: AppColors.lightgrey),
          ),
          child: Icon(Icons.person_outline,
              size: 22, color: AppColors.secondaryText),
        ),
      ],
    );
  }

  // ==================== MONTH SELECTOR ====================
  Widget _buildMonthSelector() {
    return Column(
      children: [
        Text(
          "បង្ហាញកិច្ចផ្សរសម្រាប់",
          style: AppTextStyle.caption14Secondary,
        ),
        const SizedBox(height: 6),
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
              _monthKeys.isEmpty
                  ? _formatMonthLabel(_currentMonthKey())
                  : _formatMonthLabel(_monthKeys[_currentMonthIndex]),
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

  // ==================== STATS ROW ====================
  Widget _buildStatsRow() {
    return Row(
      children: [
        _buildStatCard(
          icon: Icons.check_circle_outline,
          iconColor: AppColors.primaryMain,
          label: "វត្តមាន",
          value: presentDays.toString(),
          unit: "ថ្ងៃ",
          bgColor: AppColors.primaryBg,
          valueBgColor: const Color(0xFFD6E9FF),
          valueColor: AppColors.primaryMain,
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

  // ==================== ATTENDANCE LIST ====================
  Widget _buildAttendanceList() {
    if (_records.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 28),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppNumber.radiusMedium),
        ),
        child: Center(
          child: Text(
            'មិនមានកំណត់ត្រាវត្តមាន',
            style: AppTextStyle.caption14Secondary,
          ),
        ),
      );
    }

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
        statusColor = AppColors.primaryMain;
        statusBgColor = AppColors.primaryBg;
        dotColor = AppColors.primaryMain;
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
          // Dot indicator
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: dotColor,
            ),
          ),
          const SizedBox(width: 12),
          // Day + Check-in time
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
                  record["time"],
                  style: AppTextStyle.caption13Secondary,
                ),
              ],
            ),
          ),
          // Status tag
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

  // ==================== REQUEST LEAVE BUTTON ====================
  Widget _buildRequestLeaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.edit_calendar_outlined, size: 20),
        label: Text(
          "Request Leave",
          style: GoogleFonts.kantumruyPro(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryMain,
          foregroundColor: AppColors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppNumber.radiusPill),
          ),
          elevation: 0,
        ),
      ),
    );
  }
}
