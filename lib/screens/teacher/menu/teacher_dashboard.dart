import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tamdansers_app/constants/app_colors.dart';
import 'package:tamdansers_app/constants/app_icon.dart';
import 'package:tamdansers_app/constants/app_number.dart';
import 'package:tamdansers_app/constants/text_style.dart';
import 'package:tamdansers_app/repositories/activity_repo.dart';
import 'package:tamdansers_app/repositories/class_repo.dart';
import 'package:tamdansers_app/repositories/profile_repo.dart';
import 'package:tamdansers_app/repositories/student_class_repo.dart';
import 'package:tamdansers_app/repositories/user_repo.dart';
import 'package:tamdansers_app/routes/app_routes.dart';
import 'package:tamdansers_app/state/profile_image_state.dart';
import 'package:tamdansers_app/widget/create_class_dialog.dart';

class TeacherDashboard extends StatefulWidget {
  final ValueNotifier<int>? refreshTrigger;
  final int teacherId;
  const TeacherDashboard(
      {super.key, this.refreshTrigger, required this.teacherId});

  @override
  State<TeacherDashboard> createState() => _TeacherDashboardState();
}

class _TeacherDashboardState extends State<TeacherDashboard> {
  int _classCount = 0;
  int _studentCount = 0;
  List<Map<String, dynamic>> _activities = [];
  bool _loading = true;
  String _teacherName = "Teacher";
  String _teacherGender = "";
  String _firstName = "";

  @override
  void initState() {
    super.initState();
    _loadData();
    _loadProfileImage();
    widget.refreshTrigger?.addListener(_loadData);
  }

  Future<void> _loadProfileImage() async {
    final saved = await ProfileRepo().getImage(widget.teacherId);
    if (saved != null && saved.isNotEmpty) {
      final file = File(saved);
      if (await file.exists()) {
        ProfileImageState.updateImage(widget.teacherId, saved);
      }
    }
  }

  @override
  void dispose() {
    widget.refreshTrigger?.removeListener(_loadData);
    super.dispose();
  }

  Future<void> _loadData() async {
    final teacherData = await UserRepo().getUserById(widget.teacherId);
    final classCount =
        await ClassRepo().getClassCountByTeacher(widget.teacherId);
    final studentCount =
        await StudentClassRepo().getTotalStudentsByTeacher(widget.teacherId);
    final activities =
        await ActivityRepo().getRecentActivities(widget.teacherId, limit: 5);
    if (mounted) {
      setState(() {
        _teacherName = teacherData != null
            ? "${teacherData['first_name']} ${teacherData['last_name']}"
            : "Teacher";
        _firstName = teacherData?['first_name'] as String? ?? "";
        _teacherGender = teacherData?['gender'] as String? ?? "";
        _classCount = classCount;
        _studentCount = studentCount;
        _activities = activities;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: ValueListenableBuilder<Map<int, String?>>(
            valueListenable: ProfileImageState.notifier,
            builder: (_, imageMap, __) {
              final path = imageMap[widget.teacherId];
              final hasImage =
                  path != null && path.isNotEmpty && File(path).existsSync();
              final defaultAvatar =
                  (_teacherGender == 'female' || _teacherGender == 'ស្រី')
                      ? AppIcon.femaleAvatar
                      : AppIcon.maleAvatar;
              return CircleAvatar(
                radius: 20,
                backgroundImage: hasImage
                    ? FileImage(File(path)) as ImageProvider
                    : AssetImage(defaultAvatar),
              );
            },
          ),
        ),
        title: Text(
          _teacherName,
          style: AppTextStyle.fontsize18,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  text: _teacherGender.toLowerCase() == 'male' ||
                          _teacherGender == 'ប្រុស'
                      ? "សួស្តី លោកគ្រូ "
                      : "សួស្តី អ្នកគ្រូ ",
                  style: AppTextStyle.screenTitle24,
                  children: [
                    TextSpan(
                      text: _firstName,
                      style: AppTextStyle.screenTitle24Main,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              _buildStatsCards(),
              SizedBox(height: 16),
              _buildActionButtons(),
              SizedBox(height: 24),
              _buildQuickActions(),
              SizedBox(height: 24),
              _buildRecentActivity(),
            ],
          ),
        ),
      ),
    );
  }

  //Create Class Dialog

  static const _grades = [
    "ថ្នាក់ទី 7",
    "ថ្នាក់ទី 8",
    "ថ្នាក់ទី 9",
    "ថ្នាក់ទី 10",
    "ថ្នាក់ទី 11",
    "ថ្នាក់ទី 12",
  ];

  Future<void> _showCreateClassDialog() async {
    final created = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.45),
      builder: (_) => CreateClassDialog(grades: _grades),
    );
    if (mounted) {
      _loadData();
      if (created == true) widget.refreshTrigger?.value++;
    }
  }

  Widget _buildStatsCards() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppNumber.radiusLarge),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Color(0xFFE3F2FD),
                    borderRadius: BorderRadius.circular(AppNumber.radiusMedium),
                  ),
                  child: Icon(Icons.class_outlined,
                      color: AppColors.primaryMain, size: 24),
                ),
                SizedBox(height: 12),
                Text("ថ្នាក់សរុប", style: AppTextStyle.bodySecondary),
                SizedBox(height: 4),
                Text("$_classCount", style: AppTextStyle.title28),
              ],
            ),
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppNumber.radiusLarge),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Color(0xFFF3E5F5),
                    borderRadius: BorderRadius.circular(AppNumber.radiusMedium),
                  ),
                  child: Icon(Icons.groups_outlined,
                      color: Color(0xFF9C27B0), size: 24),
                ),
                SizedBox(height: 12),
                Text("សិស្សសរុប", style: AppTextStyle.bodySecondary),
                SizedBox(height: 4),
                Text("$_studentCount", style: AppTextStyle.title28),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => _showCreateClassDialog(),
            icon: Icon(Icons.add, color: AppColors.white),
            label: Text("បង្កើតថ្នាក់", style: AppTextStyle.bodyWhite),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryMain,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppNumber.radiusMedium)),
            ),
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.manageAllClass)
                  .then((_) => _loadData());
            },
            icon: Icon(Icons.event_note_outlined, color: AppColors.primaryMain),
            label: Text("គ្រប់គ្រងថ្នាក់", style: AppTextStyle.bodyPrimary),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: AppColors.primaryMain),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppNumber.radiusMedium)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildQuickActionItem(
          Icons.person_outline,
          "កត់ត្រាវត្តមាន",
          Color(0xFFE3F2FD),
          AppColors.primaryMain,
          onTap: () {
            Navigator.pushNamed(context, AppRoutes.teacherAttendanceScreen)
                .then((_) => _loadData());
          },
        ),
        _buildQuickActionItem(
          Icons.assignment_outlined,
          "កិច្ចការផ្ទះ",
          Color(0xFFF3E5F5),
          Color(0xFF9C27B0),
          onTap: () {
            Navigator.pushNamed(context, AppRoutes.teacherHomeworkScreen)
                .then((_) => _loadData());
          },
        ),
        _buildQuickActionItem(
          Icons.check_circle_outline,
          "បញ្ជូលពិន្ទុ",
          Color(0xFFE8F5E9),
          Color(0xFF4CAF50),
          onTap: () {
            Navigator.pushNamed(context, AppRoutes.teacherGradeResult)
                .then((_) => _loadData());
          },
        ),
        _buildQuickActionItem(
          Icons.campaign_outlined,
          "សេចក្តីជូនដំណឹង",
          Color(0xFFFFF3E0),
          Color(0xFFFF9800),
          onTap: () {
            Navigator.pushNamed(context, AppRoutes.teacherNotificationScreen)
                .then((_) => _loadData());
          },
        ),
      ],
    );
  }

  Widget _buildQuickActionItem(
      IconData icon, String label, Color bgColor, Color iconColor,
      {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(AppNumber.radiusLarge),
            ),
            child: Icon(icon, color: iconColor, size: 28),
          ),
          SizedBox(height: 8),
          Text(
            label,
            style: AppTextStyle.caption12Secondary.copyWith(
              color: AppColors.primaryText,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
          ),
        ],
      ),
    );
  }


  _ActivityMeta _resolveActivityMeta(String type) {
    switch (type) {
      case "attendance":
        return _ActivityMeta(Icons.how_to_reg_rounded, const Color(0xFF5B8DEF));
      case "homework":
        return _ActivityMeta(
            Icons.assignment_turned_in_rounded, const Color(0xFF2ECC71));
      case "score":
        return _ActivityMeta(Icons.star_rounded, const Color(0xFFF5A623));
      case "notification":
        return _ActivityMeta(Icons.campaign_rounded, const Color(0xFF9B7FE6));
      case "class":
        return _ActivityMeta(Icons.person_add_rounded, const Color(0xFF5BC0DE));
      default:
        return _ActivityMeta(Icons.event_note_rounded, const Color(0xFF8E8E93));
    }
  }

  String _formatActivityTime(String isoString) {
    final dt = DateTime.tryParse(isoString);
    if (dt == null) return "";
    final now = DateTime.now();
    final diff = now.difference(dt);
    final hh = dt.hour.toString().padLeft(2, '0');
    final mm = dt.minute.toString().padLeft(2, '0');
    final timeStr = "$hh:$mm";
    if (diff.inDays == 0) return timeStr;
    if (diff.inDays == 1) return "ម្សិលមិញ $timeStr";
    return "${diff.inDays}ថ្ងៃ";
  }

  Widget _buildRecentActivity() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primaryMain.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.history_rounded,
                  color: AppColors.primaryMain, size: 20),
            ),
            const SizedBox(width: 10),
            Text("សកម្មភាពថ្មីៗ", style: AppTextStyle.sectionTitle20),
          ],
        ),
        const SizedBox(height: 14),
        if (_activities.isEmpty)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 40),
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppNumber.radiusLarge),
            ),
            child: Column(
              children: [
                Icon(Icons.inbox_rounded,
                    size: 40, color: AppColors.grey.withValues(alpha: 0.5)),
                const SizedBox(height: 8),
                Text("មិនមានសកម្មភាពថ្មីៗ", style: AppTextStyle.bodySecondary),
              ],
            ),
          )
        else
          Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppNumber.radiusLarge),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryText.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: List.generate(_activities.length, (i) {
                final a = _activities[i];
                final meta = _resolveActivityMeta(a["activity_type"] as String);
                final item = _ActivityItem(
                  icon: meta.icon,
                  accentColor: meta.color,
                  title: a["title"] as String,
                  subtitle: a["subtitle"] as String,
                  time: _formatActivityTime(a["created_at"] as String),
                );
                return Column(
                  children: [
                    _buildActivityCard(item),
                    if (i < _activities.length - 1)
                      Divider(
                        height: 1,
                        thickness: 0.6,
                        indent: 68,
                        endIndent: 16,
                        color: AppColors.grey.withValues(alpha: 0.2),
                      ),
                  ],
                );
              }),
            ),
          ),
        const SizedBox(height: 80),
      ],
    );
  }

  Widget _buildActivityCard(_ActivityItem a) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  a.accentColor.withValues(alpha: 0.18),
                  a.accentColor.withValues(alpha: 0.06),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(a.icon, color: a.accentColor, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  a.title,
                  style:
                      AppTextStyle.body14.copyWith(fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Text(
                  a.subtitle,
                  style: AppTextStyle.caption12Secondary,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            a.time,
            style: AppTextStyle.caption12Secondary.copyWith(
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActivityMeta {
  final IconData icon;
  final Color color;
  const _ActivityMeta(this.icon, this.color);
}

class _ActivityItem {
  final IconData icon;
  final Color accentColor;
  final String title;
  final String subtitle;
  final String time;

  const _ActivityItem({
    required this.icon,
    required this.accentColor,
    required this.title,
    required this.subtitle,
    required this.time,
  });
}
