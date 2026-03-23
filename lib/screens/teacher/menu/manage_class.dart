import 'package:flutter/material.dart';
import 'package:tamdansers_app/constants/app_colors.dart';
import 'package:tamdansers_app/constants/app_number.dart';
import 'package:tamdansers_app/constants/text_style.dart';
import 'package:tamdansers_app/repositories/class_repo.dart';
import 'package:tamdansers_app/repositories/student_class_repo.dart';
import 'package:tamdansers_app/screens/teacher/menu/attendance_screen.dart';
import 'package:tamdansers_app/screens/teacher/menu/homework_screen.dart';
import 'package:tamdansers_app/screens/teacher/menu/manage_student_screen.dart';

class ManageClass extends StatefulWidget {
  const ManageClass({super.key});

  @override
  State<ManageClass> createState() => _ManageClassState();
}

class _ManageClassState extends State<ManageClass> {
  int? _classId;
  Map<String, dynamic>? _classData;
  int _studentCount = 0;
  int _maleCount = 0;
  int _femaleCount = 0;
  bool _loading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_classId != null) return;
    final arg = ModalRoute.of(context)?.settings.arguments;
    _classId =
        arg is int ? arg : (arg != null ? int.tryParse(arg.toString()) : null);
    if (_classId != null) {
      _loadClass(_classId!);
    } else {
      setState(() => _loading = false);
    }
  }

  Future<void> _loadClass(int id) async {
    final cls = await ClassRepo().getClassById(id);
    final total = await StudentClassRepo().getStudentCountByClass(id);
    final male = await StudentClassRepo().getMaleCountByClass(id);
    final female = await StudentClassRepo().getFemaleCountByClass(id);
    if (mounted) {
      setState(() {
        _classData = cls;
        _studentCount = total;
        _maleCount = male;
        _femaleCount = female;
        _loading = false;
      });
    }
  }

  Color _hexToColor(String hex) =>
      Color(int.parse(hex.replaceFirst('#', '0xFF')));

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final cls = _classData;
    final title = cls != null
        ? "${cls["name"]} (${cls["grade"]} ${cls["section"]})"
        : "ថ្នាក់";
    final cardColor = cls != null
        ? _hexToColor(cls["color_hex"] as String)
        : AppColors.primaryMain;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new_rounded,
              color: AppColors.primaryText),
        ),
        title: Text(title, style: AppTextStyle.sectionTitle20),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildClassInfoCard(cls, cardColor),
              const SizedBox(height: 20),
              _buildManagementOptions(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildClassInfoCard(Map<String, dynamic>? cls, Color cardColor) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [cardColor, cardColor.withValues(alpha: 0.75)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppNumber.radiusRounded),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("សិស្សសរុប", style: AppTextStyle.caption12White),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(AppNumber.radiusSmall),
                ),
                child: Text(
                  cls?["semester"] as String? ?? "ឆមាសទី ១",
                  style: AppTextStyle.caption12White,
                ),
              ),
            ],
          ),
          Text("$_studentCount នាក់", style: AppTextStyle.title28White),
          const SizedBox(height: 8),
          Divider(color: AppColors.white.withValues(alpha: 0.3)),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(Icons.person, color: AppColors.white, size: 24),
                    const SizedBox(width: 6),
                    Text("ប្រុស: $_maleCount", style: AppTextStyle.body18White),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Row(
                  children: [
                    Icon(Icons.person, color: Colors.pink[200], size: 24),
                    const SizedBox(width: 6),
                    Text("ស្រី: $_femaleCount",
                        style: AppTextStyle.body18White),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildManagementOptions() {
    return Column(
      children: [
        _buildOptionTile(
          icon: Icons.groups,
          iconColor: AppColors.primaryMain,
          iconBgColor: const Color(0xFFE3F2FD),
          title: "គ្រប់គ្រងសិស្ស",
          subtitle: "Student Management",
          onTap: _classId == null
              ? null
              : () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ManageStudentScreen(classId: _classId!),
                    ),
                  ).then((_) => _loadClass(_classId!));
                },
        ),
        const SizedBox(height: 12),
        _buildOptionTile(
          icon: Icons.event_note,
          iconColor: const Color(0xFFFFA726),
          iconBgColor: const Color(0xFFFFF3E0),
          title: "គ្រប់គ្រងវត្តមាន",
          subtitle: "Attendance Management",
          onTap: _classId == null
              ? null
              : () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AttendanceScreen(classId: _classId!),
                    ),
                  );
                },
        ),
        const SizedBox(height: 12),
        _buildOptionTile(
          icon: Icons.assignment,
          iconColor: const Color(0xFF9C27B0),
          iconBgColor: const Color(0xFFF3E5F5),
          title: "គ្រប់គ្រងកិច្ចការផ្ទះ",
          subtitle: "Homework Management",
          onTap: _classId == null
              ? null
              : () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => HomeworkScreen(classId: _classId!),
                    ),
                  );
                },
        ),
        const SizedBox(height: 12),
        _buildOptionTile(
          icon: Icons.bar_chart,
          iconColor: const Color(0xFFEF5350),
          iconBgColor: const Color(0xFFFFEBEE),
          title: "លទ្ធផល និងចំណាត់ថ្នាក់",
          subtitle: "Result & Ranking",
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildOptionTile({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Opacity(
        opacity: onTap == null ? 0.5 : 1.0,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppNumber.radiusLarge),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(AppNumber.radiusMedium),
                ),
                child: Icon(icon, color: iconColor, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTextStyle.subtitle16),
                    const SizedBox(height: 2),
                    Text(subtitle, style: AppTextStyle.caption13Secondary),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right,
                  color: AppColors.secondaryText, size: 24),
            ],
          ),
        ),
      ),
    );
  }
}
