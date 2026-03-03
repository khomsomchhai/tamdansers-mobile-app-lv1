import 'package:flutter/material.dart';
import 'package:tamdansers_app/constants/app_colors.dart';
import 'package:tamdansers_app/constants/app_images.dart';
import 'package:tamdansers_app/constants/app_number.dart';
import 'package:tamdansers_app/constants/text_style.dart';
import 'package:tamdansers_app/repositories/activity_repo.dart';
import 'package:tamdansers_app/repositories/class_repo.dart';
import 'package:tamdansers_app/repositories/student_class_repo.dart';
import 'package:tamdansers_app/routes/app_routes.dart';

// Temporary teacher ID — replace with session value once auth is complete
const int kTeacherId = 1;

class TeacherDashboard extends StatefulWidget {
  const TeacherDashboard({super.key});

  @override
  State<TeacherDashboard> createState() => _TeacherDashboardState();
}

class _TeacherDashboardState extends State<TeacherDashboard> {
  int _classCount = 0;
  int _studentCount = 0;
  List<Map<String, dynamic>> _activities = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final classCount = await ClassRepo().getClassCountByTeacher(kTeacherId);
    final studentCount =
        await StudentClassRepo().getTotalStudentsByTeacher(kTeacherId);
    final activities =
        await ActivityRepo().getRecentActivities(kTeacherId, limit: 5);
    if (mounted) {
      setState(() {
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
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage(AppImages.userProfile),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        title: Text(
          "ទេព ធីតា",
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
                  text: "សួស្តី អ្នកគ្រូ ",
                  style: AppTextStyle.screenTitle24,
                  children: [
                    TextSpan(
                      text: "ទេព ធីតា",
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

  // ─── Create Class Dialog ──────────────────────────────────────────────────

  Future<void> _showCreateClassDialog() async {
    final saved = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const _DashboardCreateClassDialog(),
    );
    if (saved == true && mounted) _loadData();
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
            label: Text("ត្រូវត្រាថ្នាក់", style: AppTextStyle.bodyPrimary),
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
          onTap: () {},
        ),
        _buildQuickActionItem(
          Icons.campaign_outlined,
          "ផ្ញើរសេចក្តីជូនដំណឹង",
          Color(0xFFFFF3E0),
          Color(0xFFFF9800),
          onTap: () {},
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

  // ─── Recent Activity ────────────────────────────────────────────────────────

  _ActivityMeta _resolveActivityMeta(String type) {
    switch (type) {
      case "attendance":
        return _ActivityMeta(Icons.how_to_reg_rounded, AppColors.primaryMain);
      case "homework":
        return _ActivityMeta(
            Icons.assignment_turned_in_rounded, const Color(0xFF4CAF50));
      case "score":
        return _ActivityMeta(Icons.star_rounded, const Color(0xFFFF9800));
      case "notification":
        return _ActivityMeta(Icons.campaign_rounded, const Color(0xFF9C27B0));
      default:
        return _ActivityMeta(Icons.event_note_rounded, AppColors.secondaryText);
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
        Text("សកម្មភាពថ្មីៗ", style: AppTextStyle.sectionTitle20),
        const SizedBox(height: 12),
        if (_activities.isEmpty)
          Container(
            padding: const EdgeInsets.all(AppNumber.cardPadding),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppNumber.radiusLarge),
            ),
            child: Center(
              child: Text(
                "មិនមានសកម្មភាពថ្មីៗ",
                style: AppTextStyle.bodySecondary,
              ),
            ),
          )
        else
          ..._activities.map((a) {
            final meta = _resolveActivityMeta(a["activity_type"] as String);
            return _buildActivityCard(_ActivityItem(
              icon: meta.icon,
              accentColor: meta.color,
              title: a["title"] as String,
              subtitle: a["subtitle"] as String,
              time: _formatActivityTime(a["created_at"] as String),
            ));
          }),
        const SizedBox(height: 80),
      ],
    );
  }

  Widget _buildActivityCard(_ActivityItem a) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppNumber.radiusLarge),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppNumber.radiusLarge),
        child: IntrinsicHeight(
          child: Row(
            children: [
              Container(width: 4, color: a.accentColor),
              const SizedBox(width: 14),
              Container(
                width: 42,
                height: 42,
                margin: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: a.accentColor.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(a.icon, color: a.accentColor, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        a.title,
                        style: AppTextStyle.body14
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 3),
                      Text(a.subtitle, style: AppTextStyle.caption12Secondary),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 14),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: a.accentColor.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(AppNumber.radiusPill),
                  ),
                  child: Text(
                    a.time,
                    style: AppTextStyle.caption12Secondary.copyWith(
                      color: a.accentColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
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

// ─── Dashboard Create Class Dialog ────────────────────────────────────────

class _DashboardCreateClassDialog extends StatefulWidget {
  const _DashboardCreateClassDialog();

  @override
  State<_DashboardCreateClassDialog> createState() =>
      _DashboardCreateClassDialogState();
}

class _DashboardCreateClassDialogState
    extends State<_DashboardCreateClassDialog> {
  final _nameCtrl = TextEditingController();
  final _sectionCtrl = TextEditingController();
  final _schoolYearCtrl = TextEditingController(text: "2024-2025");

  String? _grade;
  String _semester = "ឆមាសទី ១";
  String _color = "#1976D2";
  bool _saving = false;

  static const _grades = [
    "ថ្នាក់ទី 7",
    "ថ្នាក់ទី 8",
    "ថ្នាក់ទី 9",
    "ថ្នាក់ទី 10",
    "ថ្នាក់ទី 11",
    "ថ្នាក់ទី 12",
  ];

  static const _classColors = [
    "#1976D2",
    "#00897B",
    "#546E7A",
    "#7B1FA2",
    "#C62828",
    "#E65100",
    "#558B2F",
    "#283593",
  ];

  @override
  void dispose() {
    _nameCtrl.dispose();
    _sectionCtrl.dispose();
    _schoolYearCtrl.dispose();
    super.dispose();
  }

  Color _hexToColor(String hex) =>
      Color(int.parse(hex.replaceFirst('#', '0xFF')));

  Future<void> _save() async {
    if (_nameCtrl.text.trim().isEmpty ||
        _grade == null ||
        _sectionCtrl.text.trim().isEmpty) return;
    setState(() => _saving = true);
    await ClassRepo().createClass(
      name: _nameCtrl.text.trim(),
      grade: _grade!,
      section: _sectionCtrl.text.trim().toUpperCase(),
      teacherId: kTeacherId,
      colorHex: _color,
      semester: _semester,
      schoolYear: _schoolYearCtrl.text.trim(),
    );
    await ActivityRepo().logActivity(
      teacherId: kTeacherId,
      activityType: "class",
      title: "ថ្នាក់ត្រូវបានបង្កើត",
      subtitle:
          "${_nameCtrl.text.trim()} — $_grade ${_sectionCtrl.text.trim().toUpperCase()}",
    );
    if (mounted) Navigator.pop(context, true);
  }

  InputDecoration _fieldDeco({String? hint}) => InputDecoration(
        hintText: hint,
        hintStyle: AppTextStyle.bodySecondary,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppNumber.radiusMedium),
            borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppNumber.radiusMedium),
            borderSide:
                const BorderSide(color: AppColors.primaryMain, width: 1.5)),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      );

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFFF0ECF8),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppNumber.radiusLarge)),
      title: Text("បង្កើតថ្នាក់ថ្មី", style: AppTextStyle.sectionTitle20),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("ឈ្មោះថ្នាក់", style: AppTextStyle.bodySecondary),
            const SizedBox(height: 6),
            TextField(
              controller: _nameCtrl,
              decoration: _fieldDeco(hint: "ឧ. 7A, Grade 7A"),
            ),
            const SizedBox(height: 14),
            Text("ថ្នាក់ទី", style: AppTextStyle.bodySecondary),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              value: _grade,
              hint: Text("ជ្រើសថ្នាក់ទី", style: AppTextStyle.bodySecondary),
              decoration: _fieldDeco(),
              items: _grades
                  .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                  .toList(),
              onChanged: (v) => setState(() => _grade = v),
            ),
            const SizedBox(height: 14),
            Text("ផ្នែក (A, B, C…)", style: AppTextStyle.bodySecondary),
            const SizedBox(height: 6),
            TextField(
              controller: _sectionCtrl,
              decoration: _fieldDeco(hint: "A"),
            ),
            const SizedBox(height: 14),
            Text("ឆមាស", style: AppTextStyle.bodySecondary),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              value: _semester,
              decoration: _fieldDeco(),
              items: ["ឆមាសទី ១", "ឆមាសទី ២"]
                  .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                  .toList(),
              onChanged: (v) => setState(() => _semester = v!),
            ),
            const SizedBox(height: 14),
            Text("ពណ៌", style: AppTextStyle.bodySecondary),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _classColors.map((hex) {
                final color = _hexToColor(hex);
                return GestureDetector(
                  onTap: () => setState(() => _color = hex),
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: _color == hex
                          ? Border.all(color: AppColors.primaryText, width: 2.5)
                          : null,
                    ),
                    child: _color == hex
                        ? const Icon(Icons.check, size: 18, color: Colors.white)
                        : null,
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("បោះបង់", style: AppTextStyle.bodySecondary),
        ),
        ElevatedButton(
          onPressed: _saving ? null : _save,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF42A5F5),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppNumber.radiusMedium)),
          ),
          child: _saving
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: Colors.white))
              : Text("រក្សាទុក", style: AppTextStyle.bodyWhite),
        ),
      ],
    );
  }
}
