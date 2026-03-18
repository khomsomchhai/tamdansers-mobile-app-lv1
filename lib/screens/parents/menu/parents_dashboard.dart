import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tamdansers_app/constants/app_colors.dart';
import 'package:tamdansers_app/constants/app_images.dart';
import 'package:tamdansers_app/constants/app_number.dart';
import 'package:tamdansers_app/constants/text_style.dart';
import 'package:tamdansers_app/repositories/parent_student_repo.dart';
import 'package:tamdansers_app/repositories/score_repo.dart';
import 'package:tamdansers_app/repositories/user_repo.dart';
import 'package:tamdansers_app/routes/app_routes.dart';
import 'package:tamdansers_app/screens/parents/menu/Comment_signature .dart';
import 'package:tamdansers_app/screens/parents/menu/attendance_student_data.dart';
import 'package:tamdansers_app/screens/parents/menu/detail.dart';
import 'package:tamdansers_app/screens/parents/menu/news.dart';
import 'package:tamdansers_app/screens/parents/menu/setting.dart';
import 'package:tamdansers_app/screens/parents/widget/parent_profile_header.dart';

class ParentsDashboard extends StatefulWidget {
  const ParentsDashboard({super.key});

  @override
  State<ParentsDashboard> createState() => _ParentsDashboardState();
}

class _ParentsDashboardState extends State<ParentsDashboard>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  Map<String, dynamic>? _currentParent;

  final ParentStudentRepo _parentStudentRepo = ParentStudentRepo();
  final AttendanceStudentData _attendanceRepo = AttendanceStudentData();
  final ScoreRepo _scoreRepo = ScoreRepo();

  Map<String, dynamic>? _selectedStudent;
  double _attendancePercent = 0;
  String _scoreGrade = '-';
  String _behaviorLabel = '-';
  int _presentDays = 0;

  @override
  void initState() {
    super.initState();
    _loadParentUser();
  }

  Future<void> _loadParentUser() async {
    try {
      final pref = await SharedPreferences.getInstance();
      final userId = pref.getInt("userId");
      if (userId != null) {
        _currentParent = await UserRepo().getUserById(userId);
        final students = await _parentStudentRepo.getStudentsByParent(userId);
        if (students.isNotEmpty) {
          _selectedStudent = students.first;
          await _loadStudentSummary();
        }
        setState(() {});
      }
    } catch (e) {
      debugPrint("Error loading parent user: $e");
    }
  }

  Future<void> _loadStudentSummary() async {
    final studentId = _selectedStudent?['student_id'] as int?;
    if (studentId == null) return;

    final attendance =
        await _attendanceRepo.getAttendanceSummaryByStudent(studentId);
    final present = attendance['present'] ?? 0;
    final late = attendance['late'] ?? 0;
    final absent = attendance['absent'] ?? 0;
    final total = present + late + absent;

    final double attendancePercent =
        total == 0 ? 0.0 : (present.toDouble() / total.toDouble()) * 100;

    final scores = await _scoreRepo.getScoresByStudent(studentId);
    double avgScore = 0;
    if (scores.isNotEmpty) {
      final sum = scores.fold<double>(
          0, (prev, e) => prev + ((e['score'] as num?)?.toDouble() ?? 0));
      avgScore = sum / scores.length;
    }

    if (!mounted) return;
    setState(() {
      _presentDays = present;
      _attendancePercent = attendancePercent;
      _scoreGrade = _gradeFromAverage(avgScore);
      _behaviorLabel = _behaviorFromAttendance(attendancePercent);
    });
  }

  String _gradeFromAverage(double avg) {
    if (avg >= 90) return 'A';
    if (avg >= 80) return 'B';
    if (avg >= 70) return 'C';
    if (avg >= 60) return 'D';
    return '-';
  }

  String _behaviorFromAttendance(double attendancePercent) {
    if (attendancePercent >= 95) return 'ល្អណាស់';
    if (attendancePercent >= 85) return 'ល្អ';
    if (attendancePercent >= 70) return 'មធ្យម';
    return 'ត្រូវកែលម្អ';
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
                name: _currentParent?["first_name"] ?? "Parent",
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
                Text("សកម្មភាពលឿន",
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
                _quickActionTile("វត្តមាន", Icons.calendar_month_outlined,
                    AppColors.primaryMain, context, onTap: () {
                  Navigator.pushNamed(context, AppRoutes.AttandanceScreen);
                }),
                const SizedBox(width: 8),
                _quickActionTile("លទ្ធផល", Icons.assignment_outlined,
                    AppColors.success, context, onTap: () {
                  Navigator.pushNamed(context, AppRoutes.CustomScreen);
                }),
                const SizedBox(width: 8),
                _quickActionTile("កិច្ចការផ្ទះ", Icons.menu_book_rounded,
                    AppColors.pepure, context, onTap: () {
                  Navigator.pushNamed(context, AppRoutes.HomeworkQuizeScreen);
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
          const SizedBox(height: 16),
          Center(
            child: Text(
              "មើលការផ្សេងៗដែលពាក់ព័ន្ធ",
              style: AppTextStyle.body.copyWith(
                color: AppColors.primaryText.withValues(alpha: 0.7),
                fontSize: _fs(13, context),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _studentCard(BuildContext context) {
    final firstName = (_selectedStudent?['first_name'] as String?) ?? '';
    final lastName = (_selectedStudent?['last_name'] as String?) ?? '';
    final className = (_selectedStudent?['class_name'] as String?) ?? 'ថ្នាក់';
    final studentId = (_selectedStudent?['student_id'])?.toString() ?? '-';
    final displayName = '$firstName $lastName'.trim();

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
                      child:
                          Image.asset(AppImages.userProfile, fit: BoxFit.cover),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: AppColors.success,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.white, width: 2),
                      ),
                      child: const Icon(Icons.check_rounded,
                          color: AppColors.white, size: 12),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(displayName.isEmpty ? 'Student' : displayName,
                        style: AppTextStyle.subtitle16.copyWith(
                          fontSize: _fs(16, context),
                          fontWeight: FontWeight.w700,
                        )),
                    const SizedBox(height: 2),
                    Text("$className ID: #$studentId",
                        style: AppTextStyle.buttonText15Primary.copyWith(
                          fontSize: _fs(13, context),
                          color: AppColors.secondaryText,
                        )),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.successBG,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.check_circle_outline,
                              color: AppColors.success, size: 14),
                          const SizedBox(width: 4),
                          Text("វត្តមាន $_presentDays ថ្ងៃ",
                              style: AppTextStyle.buttonText15Primary.copyWith(
                                color: AppColors.success,
                                fontSize: _fs(12, context),
                                fontWeight: FontWeight.w600,
                              )),
                        ],
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
              _statItem("${_attendancePercent.toStringAsFixed(0)}%", "វត្តមាន",
                  AppColors.success, AppTextStyle.caption12Primary, context,
                  valueFontSize: 30, labelFontSize: 16),
              Container(
                  width: 1,
                  height: 30,
                  color: AppColors.neutral500.withOpacity(0.3)),
              _statItem(_scoreGrade, "និទ្ទេស", AppColors.success,
                  AppTextStyle.caption12Primary, context,
                  valueFontSize: 30, labelFontSize: 16),
              Container(
                  width: 1,
                  height: 30,
                  color: AppColors.neutral500.withOpacity(0.3)),
              _statItem(_behaviorLabel, "អត្តចរិត", AppColors.success,
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
        children: [
          _activityItem(
            icon: Icons.assignment_outlined,
            title: "សិស្សលទ្ធផលប្រឡងលម្អិត",
            subtitle: "សិស្សលទ្ធផល 18/20 នៅលើការសាកល្បងផ្នែក ៤",
            time: "២ម៉ោង",
            iconColor: AppColors.orange,
            context: context,
            onTap: () {
              _openActivityDetail(
                context,
                title: "សិស្សលទ្ធផលប្រឡងលម្អិត",
                subtitle: "សិស្សលទ្ធផល 18/20 នៅលើការសាកល្បងផ្នែក ៤",
                time: "២ម៉ោង",
                icon: Icons.assignment_outlined,
                iconColor: AppColors.orange,
                importantPoints: const [
                  "លទ្ធផលសរុប៖ 18/20 ពិន្ទុ",
                  "ចំណុចខ្លាំង៖ ឆ្លើយបានត្រឹមត្រូវលើមេរៀនសំខាន់ៗ",
                  "ចំណុចត្រូវពង្រឹង៖ កំហុសតិចតួចនៅផ្នែកសេចក្ដីពន្យល់",
                  "សកម្មភាពណែនាំ៖ ពិនិត្យមេរៀន 10-15 នាទីរៀងរាល់ថ្ងៃ",
                ],
              );
            },
          ),
          Divider(height: 1, color: AppColors.lightgrey),
          _activityItem(
            icon: Icons.notifications_outlined,
            title: "សាលបិទថ្ងៃស័ក្តិ្វ",
            subtitle: "ថ្ងៃឈប់សាធារណៈ",
            time: "ម្សិលមិញ",
            iconColor: AppColors.pepure,
            context: context,
            onTap: () {
              _openActivityDetail(
                context,
                title: "សាលបិទថ្ងៃស័ក្តិ្វ",
                subtitle: "ថ្ងៃឈប់សាធារណៈ",
                time: "ម្សិលមិញ",
                icon: Icons.notifications_outlined,
                iconColor: AppColors.pepure,
                importantPoints: const [
                  "សាលាបិទតាមកាលវិភាគថ្ងៃឈប់សាធារណៈ",
                  "មិនមានថ្នាក់រៀន និងសកម្មភាពក្នុងសាលា",
                  "សូមតាមដានកាលវិភាគថ្មីសម្រាប់ថ្ងៃបើកវិញ",
                  "ពិនិត្យសារ/ការជូនដំណឹងបន្ថែមពីសាលា",
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  void _openActivityDetail(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String time,
    required IconData icon,
    required Color iconColor,
    required List<String> importantPoints,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ParentDetailScreen(
          title: title,
          subtitle: subtitle,
          time: time,
          icon: icon,
          iconColor: iconColor,
          importantPoints: importantPoints,
        ),
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
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
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
                  color: AppColors.primaryMain,
                  fontWeight: FontWeight.w600,
                )),
          ],
        ),
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
        label: 'ផ្ទះ',
      ),
      _NavItem(
        icon: Icons.assignment_outlined,
        activeIcon: Icons.assignment_rounded,
        label: 'សារ',
      ),
      _NavItem(
        icon: Icons.check_circle_outline,
        activeIcon: Icons.check_circle,
        label: 'ពត៌មាន',
      ),
      _NavItem(
        icon: Icons.person_outline_rounded,
        activeIcon: Icons.person_rounded,
        label: 'ប្រវត្តិ',
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
                onTap: () => setState(() => _currentIndex = i),
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
