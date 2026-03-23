import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tamdansers_app/constants/app_colors.dart';
import 'package:tamdansers_app/constants/app_icon.dart';
import 'package:tamdansers_app/constants/app_number.dart';
import 'package:tamdansers_app/constants/text_style.dart';
import 'package:tamdansers_app/repositories/activity_repo.dart';
import 'package:tamdansers_app/repositories/attendance_repo.dart';
import 'package:tamdansers_app/repositories/class_repo.dart';
import 'package:tamdansers_app/repositories/parent_student_repo.dart';
import 'package:tamdansers_app/repositories/student_class_repo.dart';
import 'package:tamdansers_app/repositories/student_stat_repo.dart';
import 'package:tamdansers_app/repositories/user_repo.dart';
import 'package:tamdansers_app/routes/app_routes.dart';
import 'package:tamdansers_app/screens/parents/menu/comment_signature.dart';
import 'package:tamdansers_app/screens/parents/menu/news.dart';
import 'package:tamdansers_app/screens/parents/menu/setting.dart';
import 'package:tamdansers_app/screens/parents/widget/parent_profile_header.dart';

class ParentsDashboard extends StatefulWidget {
  final int? studentClassId;
  final int? classId;

  const ParentsDashboard({super.key, this.studentClassId, this.classId});

  @override
  State<ParentsDashboard> createState() => _ParentsDashboardState();
}

class _ParentsDashboardState extends State<ParentsDashboard>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  int _currentIndex = 0;
  Map<String, dynamic>? _currentParent;
  Map<String, dynamic>? _selectedStudent;
  List<Map<String, dynamic>> _students = [];
  bool _isLoading = true;
  List<Map<String, dynamic>> _activities = [];
  double? _attendancePercent;
  String? _latestScore;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadParentUser();
    _loadStudents();
    _loadActivities(studentClassId: widget.studentClassId);
    if (widget.studentClassId != null && widget.classId != null) {
      _loadSelectedStudentStats(widget.studentClassId!, widget.classId!);
    } else {
      _loadStudentStats();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _currentIndex == 0) {
      _loadActivities(studentClassId: widget.studentClassId);
    }
  }

  Future<void> _loadParentUser() async {
    try {
      final pref = await SharedPreferences.getInstance();
      final userId = pref.getInt("userId");
      if (userId != null) {
        _currentParent = await UserRepo().getUserById(userId);
        setState(() {});
      }
    } catch (e) {
      debugPrint("Error loading parent user: $e");
    }
  }

  Future<void> _loadStudents() async {
    try {
      final pref = await SharedPreferences.getInstance();
      final userId = pref.getInt("userId");
      if (userId != null) {
        final students = await ParentStudentRepo().getStudentsByParent(userId);
        setState(() {
          _students = students;
        });
        await _loadStudentStats();
      }
    } catch (e) {
      debugPrint("Error loading students: $e");
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loadActivities({int? studentClassId}) async {
    try {
      final pref = await SharedPreferences.getInstance();
      final parentId = pref.getInt("userId");
      if (parentId != null) {
        List<Map<String, dynamic>> activities;
        if (studentClassId != null) {
          activities = await ActivityRepo()
              .getActivitiesByStudent(parentId, studentClassId, limit: 10);
        } else {
          activities =
              await ActivityRepo().getRecentActivities(parentId, limit: 10);
        }
        setState(() {
          _activities = activities;
        });
      }
    } catch (e) {
      debugPrint("Error loading activities: $e");
      setState(() {
        _activities = [];
      });
    }
  }

  Future<void> _loadSelectedStudentStats(
      int studentClassId, int classId) async {
    try {
      final studentClassRepo = StudentClassRepo();
      _selectedStudent = await studentClassRepo.getStudentById(studentClassId);

      if (_selectedStudent != null) {
        final attendanceRepo = AttendanceRepo();
        final currentMonth =
            DateTime.now().toIso8601String().substring(0, 7);
        final summary = await attendanceRepo.getAttendanceSummaryForStudent(
            studentClassId, classId, currentMonth);
        final total = summary['total'] ?? 0;
        final present = summary['present'] ?? 0;
        final late = summary['late'] ?? 0;
        final presentDays = present + late;
        final attendancePercent =
            total == 0 ? 0.0 : (presentDays / total) * 100;

        final score = await StudentStatRepo().getLatestScore(studentClassId, classId);
        final classRepo = ClassRepo();
        final classData = await classRepo.getClassById(classId);
        if (classData != null && _selectedStudent != null) {
          _selectedStudent = {
            ..._selectedStudent!,
            'class_name': classData['name'] ?? 'មិនបានកំណត់'
          };
        }

        setState(() {
          _selectedStudent = _selectedStudent;
          _attendancePercent = attendancePercent;
          _latestScore = score;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loadStudentStats() async {
    if (_students.isNotEmpty) {
      final student = _students.first;
      final studentClassId = student['student_id'] as int?;
      final classId = student['class_id'] as int?;
      if (studentClassId != null && classId != null) {
        final statRepo = StudentStatRepo();
        final percent =
            await statRepo.getAttendancePercent(studentClassId, classId);
        final score = await statRepo.getLatestScore(studentClassId, classId);
        setState(() {
          _attendancePercent = percent;
          _latestScore = score;
        });
      }
    }
  }

  double _fs(double base, BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return base * (width / 390).clamp(0.78, 1.15);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: _buildTabBody(context),
      bottomNavigationBar: _bottomNav(context),
    );
  }

  Widget _buildTabBody(BuildContext context) {
    switch (_currentIndex) {
      case 1:
        return const CommentSignature();
      case 2:
        return const NewsScreen();
      case 3:
        return const ParentSetting();
      default:
        return _buildHomeTab(context);
    }
  }

  Widget _buildHomeTab(BuildContext context) {
    const double cardBottomOffset = -125;
    const double contentTopSpacing = 135;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              ParentProfileHeader(
                firstName: _currentParent?["first_name"] ?? "Parent",
                lastName: _currentParent?["last_name"] ?? "",
                gender: _currentParent?["gender"] ?? "male",
              ),
              Positioned(
                left: 24,
                right: 24,
                bottom: cardBottomOffset,
                child: _studentCard(context),
              ),
            ],
          ),
          const SizedBox(height: contentTopSpacing),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("មុខងារ",
                    style: AppTextStyle.sectionTitle20
                        .copyWith(fontSize: _fs(16, context))),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _quickActionTile(
                    "វត្តមាន", Icons.date_range, AppColors.primaryMain, context,
                    onTap: () {
                  if (widget.studentClassId != null && widget.classId != null) {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.attandanceScreen,
                      arguments: {
                        'studentClassId': widget.studentClassId,
                        'classId': widget.classId,
                      },
                    );
                  }
                }),
                const SizedBox(width: 8),
                _quickActionTile(
                    "លទ្ធផល", Icons.assessment, AppColors.success, context,
                    onTap: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.customScreen,
                    arguments: {
                      'studentClassId': widget.studentClassId,
                      'classId': widget.classId,
                    },
                  );
                }),
                const SizedBox(width: 8),
                _quickActionTile(
                    "កិច្ចការផ្ទះ", Icons.home_work, AppColors.pepure, context,
                    onTap: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.homeworkQuizeScreen,
                    arguments: {
                      'studentClassId': widget.studentClassId,
                      'classId': widget.classId,
                    },
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text("សកម្មភាពថ្មីៗ",
                style: AppTextStyle.sectionTitle20
                    .copyWith(fontSize: _fs(16, context))),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _recentActivity(context),
          ),
        ],
      ),
    );
  }

  Widget _studentCard(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_students.isEmpty && _selectedStudent == null) {
      return Center(
        child: Text(
          "មិនមានសិស្សភ្ជាប់ទេ",
          style: AppTextStyle.body.copyWith(color: AppColors.secondaryText),
        ),
      );
    }
    final student = _selectedStudent ?? _students.first;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primaryBg,
                    ),
                    child: ClipOval(
                      child: (student['photo_path'] != null &&
                              student['photo_path'].toString().isNotEmpty)
                          ? Image.file(
                              File(student['photo_path']),
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            )
                          : (student['gender'] == 'ប្រុស' ||
                                  student['gender'] == 'male'
                              ? Image.asset(AppIcon.maleAvatar,
                                  width: 60, height: 60, fit: BoxFit.cover)
                              : Image.asset(AppIcon.femaleAvatar,
                                  width: 60, height: 60, fit: BoxFit.cover)),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      (student['first_name'] ?? '') +
                          ' ' +
                          (student['last_name'] ?? ''),
                      style: AppTextStyle.subtitle16.copyWith(
                        fontSize: _fs(16, context),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "ថ្នាក់រៀន: ${student['class_name'] ?? 'មិនបានកំណត់'}",
                      style: AppTextStyle.buttonText15Primary.copyWith(
                        fontSize: _fs(13, context),
                        color: AppColors.secondaryText,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _statItem(
                _attendancePercent != null
                    ? ("${_attendancePercent!.toStringAsFixed(0)}%")
                    : "-",
                "វត្តមាន",
                AppColors.success,
                AppTextStyle.caption12Primary,
                context,
                valueFontSize: 30,
                labelFontSize: 16,
              ),
              Container(
                  width: 1,
                  height: 30,
                  color: AppColors.neutral500.withOpacity(0.3)),
              _statItem(
                _latestScore ?? "-",
                "និទ្ទេស",
                AppColors.success,
                AppTextStyle.caption12Primary,
                context,
                valueFontSize: 30,
                labelFontSize: 16,
              ),
              Container(
                  width: 1,
                  height: 30,
                  color: AppColors.neutral500.withOpacity(0.3)),
              _statItem("ល្អ", "អត្តចរិត", AppColors.success,
                  AppTextStyle.caption12Primary, context,
                  valueFontSize: 30, labelFontSize: 16),
            ],
          ),
        ],
      ),
    );
  }

  Widget _quickActionTile(
      String title, IconData icon, Color color, BuildContext context,
      {VoidCallback? onTap}) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 106,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(14),
            border:
                Border.all(color: AppColors.lightgrey.withValues(alpha: 0.7)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: AppTextStyle.body.copyWith(
                  fontSize: _fs(12, context),
                  fontWeight: FontWeight.w500,
                  color: AppColors.primaryText,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _recentActivity(BuildContext context) {
    if (_activities.isEmpty) {
      return Center(
        child: Text(
          "មិនមានសកម្មភាពថ្មីៗ",
          style: AppTextStyle.body.copyWith(color: AppColors.secondaryText),
        ),
      );
    }
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: List.generate(_activities.length, (i) {
          final activity = _activities[i];
          return Column(
            children: [
              _activityItem(
                icon: Icons.notifications,
                title: activity['title'] ?? 'សកម្មភាព',
                subtitle: activity['subtitle'] ?? '',
                time: activity['created_at']?.toString() ?? '',
                iconColor: AppColors.primaryMain,
                context: context,
              ),
              if (i < _activities.length - 1)
                Divider(height: 1, color: AppColors.lightgrey),
            ],
          );
        }),
      ),
    );
  }

  Widget _activityItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required String time,
    required Color iconColor,
    required BuildContext context,
  }) {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: AppTextStyle.subtitle16
                        .copyWith(fontSize: _fs(14, context))),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: AppTextStyle.body.copyWith(
                    fontSize: _fs(12, context),
                    color: AppColors.secondaryText,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(time,
              style: AppTextStyle.body.copyWith(
                fontSize: _fs(11, context),
                color: AppColors.secondaryText,
              )),
        ],
      ),
    );
  }

  Widget _statItem(String value, String label, Color color,
      TextStyle? labelStyle, BuildContext context,
      {double valueFontSize = 18, double labelFontSize = 11}) {
    return Column(
      children: [
        Text(value,
            style: AppTextStyle.stat32Bold.copyWith(
              fontSize: _fs(valueFontSize, context),
              color: color,
            )),
        const SizedBox(height: 2),
        Text(label,
            style: (labelStyle ?? AppTextStyle.caption12Secondary).copyWith(
              fontSize: _fs(labelFontSize, context),
            )),
      ],
    );
  }

  Widget _bottomNav(BuildContext context) {
    const tabs = [
      _NavItem(
        icon: Icons.home_outlined,
        activeIcon: Icons.home_rounded,
        label: 'ទំព័រដើម',
      ),
      _NavItem(
        icon: Icons.mail_outline,
        activeIcon: Icons.mail_rounded,
        label: 'សារ',
      ),
      _NavItem(
        icon: Icons.newspaper_outlined,
        activeIcon: Icons.newspaper,
        label: 'ពត៌មាន',
      ),
      _NavItem(
        icon: Icons.person_outline,
        activeIcon: Icons.person,
        label: 'ប្រវត្តិរូប',
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppNumber.radiusRounded),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryMain.withValues(alpha: 0.12),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppNumber.screenPadding,
            vertical: 10,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(
              tabs.length,
              (i) => _NavTabItem(
                item: tabs[i],
                isActive: _currentIndex == i,
                onTap: () {
                  setState(() => _currentIndex = i);
                  if (i == 0) {
                    _loadActivities(studentClassId: widget.studentClassId);
                  }
                },
                fs: _fs,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}

class _NavTabItem extends StatelessWidget {
  final _NavItem item;
  final bool isActive;
  final VoidCallback onTap;
  final double Function(double, BuildContext) fs;

  const _NavTabItem({
    required this.item,
    required this.isActive,
    required this.onTap,
    required this.fs,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 72,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              width: isActive ? 52 : 40,
              height: 36,
              decoration: BoxDecoration(
                color: isActive
                    ? AppColors.primaryMain.withValues(alpha: 0.12)
                    : AppColors.transparent,
                borderRadius: BorderRadius.circular(AppNumber.radiusPill),
              ),
              child: Icon(
                isActive ? item.activeIcon : item.icon,
                size: 24,
                color:
                    isActive ? AppColors.primaryMain : AppColors.secondaryText,
              ),
            ),
            const SizedBox(height: 4),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: isActive
                  ? AppTextStyle.caption12Secondary.copyWith(
                      color: AppColors.primaryMain,
                      fontWeight: FontWeight.w700,
                      fontSize: fs(12, context),
                    )
                  : AppTextStyle.caption12Secondary.copyWith(
                      fontSize: fs(12, context),
                    ),
              child: Text(item.label, maxLines: 1),
            ),
          ],
        ),
      ),
    );
  }
}
