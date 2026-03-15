import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tamdansers_app/constants/app_colors.dart';
import 'package:tamdansers_app/constants/app_number.dart';
import 'package:tamdansers_app/constants/text_style.dart';
import 'package:tamdansers_app/repositories/activity_repo.dart';
import 'package:tamdansers_app/repositories/class_repo.dart';
import 'package:tamdansers_app/repositories/score_repo.dart';
import 'package:tamdansers_app/repositories/student_class_repo.dart';

class GradeResult extends StatefulWidget {
  const GradeResult({super.key});

  @override
  State<GradeResult> createState() => _GradeResultState();
}

class _GradeResultState extends State<GradeResult> {
  List<Map<String, dynamic>> _classes = [];
  Map<String, dynamic>? _selectedClass;
  String? _selectedSubject;
  List<Map<String, dynamic>> _students = [];
  Map<int, TextEditingController> _scoreControllers = {};
  Map<int, double?> _existingScores = {};
  bool _loadingClasses = true;
  bool _loadingStudents = false;
  bool _saving = false;
  int? _teacherId;

  final List<String> _subjects = [
    'គណិតវិទ្យា',
    'ភាសាខ្មែរ',
    'ភាសាអង់គ្លេស',
    'វិទ្យាសាស្ត្រ',
    'សង្គមវិទ្យា',
  ];

  @override
  void initState() {
    super.initState();
    _loadClasses();
  }

  @override
  void dispose() {
    for (final c in _scoreControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _loadClasses() async {
    final pref = await SharedPreferences.getInstance();
    _teacherId = pref.getInt('userId');
    if (_teacherId == null) return;
    final classes = await ClassRepo().getClassesByTeacher(_teacherId!);
    if (mounted) {
      setState(() {
        _classes = classes;
        _loadingClasses = false;
      });
    }
  }

  Future<void> _loadStudentsAndScores() async {
    if (_selectedClass == null || _selectedSubject == null) return;
    setState(() => _loadingStudents = true);

    final classId = _selectedClass!['id'] as int;
    final students = await StudentClassRepo().getStudentsByClass(classId);

    // Dispose old controllers
    for (final c in _scoreControllers.values) {
      c.dispose();
    }

    final Map<int, TextEditingController> controllers = {};
    final Map<int, double?> existing = {};

    for (final s in students) {
      final sid = s['id'] as int;
      final scoreRow =
          await ScoreRepo().findScore(sid, classId, _selectedSubject!);
      final score =
          scoreRow != null ? (scoreRow['score'] as num).toDouble() : null;
      existing[sid] = score;
      controllers[sid] = TextEditingController(
        text: score != null ? score.toStringAsFixed(0) : '',
      );
    }

    if (mounted) {
      setState(() {
        _students = students;
        _scoreControllers = controllers;
        _existingScores = existing;
        _loadingStudents = false;
      });
    }
  }

  Future<void> _saveAllScores() async {
    final classId = _selectedClass!['id'] as int;
    setState(() => _saving = true);

    int saved = 0;
    for (final s in _students) {
      final sid = s['id'] as int;
      final text = _scoreControllers[sid]?.text.trim() ?? '';
      if (text.isEmpty) continue;
      final score = double.tryParse(text);
      if (score == null || score < 0 || score > 100) continue;
      await ScoreRepo().upsertScore(
        studentId: sid,
        classId: classId,
        subject: _selectedSubject!,
        score: score,
      );
      saved++;
    }

    // Log activity
    if (saved > 0 && _teacherId != null) {
      final className =
          _selectedClass!['name'] as String? ?? '${_selectedClass!['grade']} ${_selectedClass!['section']}';
      await ActivityRepo().logActivity(
        teacherId: _teacherId!,
        activityType: 'score',
        title: 'ពិន្ទុត្រូវបានបញ្ចូល',
        subtitle: '$_selectedSubject — $className ($saved នាក់)',
      );
    }

    if (mounted) {
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('រក្សាទុកពិន្ទុបានជោគជ័យ ($saved នាក់)'),
          backgroundColor: AppColors.success,
        ),
      );
      // Reload to reflect saved state
      _loadStudentsAndScores();
    }
  }

  String _gradeLabel(double score) {
    if (score >= 90) return 'ល្អណាស់';
    if (score >= 70) return 'ល្អ';
    if (score >= 50) return 'មធ្យម';
    return 'ខ្សោយ';
  }

  Color _gradeColor(double score) {
    if (score >= 90) return const Color(0xFF5B8DEF);
    if (score >= 70) return AppColors.success;
    if (score >= 50) return const Color(0xFFF5A623);
    return AppColors.error;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundLight,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: AppColors.primaryText),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text('បញ្ជូលពិន្ទុ', style: AppTextStyle.sectionTitle20),
      ),
      body: _loadingClasses
          ? const Center(child: CircularProgressIndicator())
          : _classes.isEmpty
              ? _buildEmptyClasses()
              : Column(
                  children: [
                    _buildSelectors(),
                    Expanded(child: _buildStudentList()),
                  ],
                ),
      bottomNavigationBar: (_selectedClass != null &&
              _selectedSubject != null &&
              _students.isNotEmpty)
          ? _buildSaveBar()
          : null,
    );
  }

  Widget _buildEmptyClasses() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.class_outlined,
              size: 48, color: AppColors.grey.withValues(alpha: 0.4)),
          const SizedBox(height: 12),
          Text('មិនទាន់មានថ្នាក់', style: AppTextStyle.bodySecondary),
        ],
      ),
    );
  }

  Widget _buildSelectors() {
    final classLabel = _selectedClass != null
        ? (_selectedClass!['name'] as String? ?? '${_selectedClass!['grade']} ${_selectedClass!['section']}')
        : null;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
      child: Column(
        children: [
          // ── Class selector ──
          _buildSelectorTile(
            icon: Icons.school_rounded,
            iconColor: const Color(0xFF5B8DEF),
            label: 'ឈ្មោះថ្នាក់',
            value: classLabel,
            placeholder: 'ជ្រើសរើសថ្នាក់',
            onTap: () => _showClassPicker(),
          ),
          const SizedBox(height: 10),
          // ── Subject selector ──
          _buildSelectorTile(
            icon: Icons.menu_book_rounded,
            iconColor: const Color(0xFF2ECC71),
            label: 'មុខវិជ្ជា',
            value: _selectedSubject,
            placeholder: 'ជ្រើសរើសមុខវិជ្ជា',
            onTap: () => _showSubjectPicker(),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectorTile({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String? value,
    required String placeholder,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppNumber.radiusLarge),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryText.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: AppTextStyle.caption12Secondary
                          .copyWith(fontSize: 11)),
                  const SizedBox(height: 2),
                  Text(
                    value ?? placeholder,
                    style: value != null
                        ? AppTextStyle.subtitle16
                        : AppTextStyle.bodySecondary,
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded,
                size: 16, color: AppColors.secondaryText),
          ],
        ),
      ),
    );
  }

  void _showClassPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.transparent,
      builder: (ctx) => _buildBottomSheet(
        title: 'ជ្រើសរើសថ្នាក់',
        children: _classes.map((c) {
          final id = c['id'] as int;
          final name = c['name'] as String? ?? '';
          final grade = c['grade'] as String? ?? '';
          final section = c['section'] as String? ?? '';
          final colorHex = c['color_hex'] as String? ?? '#4285F4';
          final color = Color(
              int.parse(colorHex.replaceFirst('#', '0xFF')));
          final isSelected = _selectedClass?['id'] == id;
          return _buildClassOption(
            name: name,
            subtitle: '$grade $section',
            color: color,
            isSelected: isSelected,
            onTap: () {
              Navigator.pop(ctx);
              setState(() {
                _selectedClass = c;
                _students = [];
              });
              if (_selectedSubject != null) _loadStudentsAndScores();
            },
          );
        }).toList(),
      ),
    );
  }

  void _showSubjectPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.transparent,
      builder: (ctx) => _buildBottomSheet(
        title: 'ជ្រើសរើសមុខវិជ្ជា',
        children: _subjects.map((s) {
          final isSelected = _selectedSubject == s;
          return _buildSheetOption(
            label: s,
            isSelected: isSelected,
            onTap: () {
              Navigator.pop(ctx);
              setState(() {
                _selectedSubject = s;
                _students = [];
              });
              if (_selectedClass != null) _loadStudentsAndScores();
            },
          );
        }).toList(),
      ),
    );
  }

  Widget _buildBottomSheet({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.grey.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          Text(title, style: AppTextStyle.subtitle18),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: children,
            ),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
        ],
      ),
    );
  }

  Widget _buildClassOption({
    required String name,
    required String subtitle,
    required Color color,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryMain.withValues(alpha: 0.06)
              : AppColors.backgroundLight,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? AppColors.primaryMain.withValues(alpha: 0.4)
                : AppColors.grey.withValues(alpha: 0.15),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.school_rounded, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: AppTextStyle.subtitle16.copyWith(
                      color: isSelected
                          ? AppColors.primaryMain
                          : AppColors.primaryText,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: AppTextStyle.caption12Secondary,
                  ),
                ],
              ),
            ),
            if (isSelected)
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: AppColors.primaryMain,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_rounded,
                    color: AppColors.white, size: 16),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSheetOption({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryMain.withValues(alpha: 0.06)
              : AppColors.backgroundLight,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? AppColors.primaryMain.withValues(alpha: 0.4)
                : AppColors.grey.withValues(alpha: 0.15),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: AppTextStyle.subtitle16.copyWith(
                  color: isSelected
                      ? AppColors.primaryMain
                      : AppColors.primaryText,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ),
            if (isSelected)
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: AppColors.primaryMain,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_rounded,
                    color: AppColors.white, size: 16),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStudentList() {
    if (_selectedClass == null || _selectedSubject == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.touch_app_rounded,
                  size: 48, color: AppColors.grey.withValues(alpha: 0.35)),
              const SizedBox(height: 12),
              Text('សូមជ្រើសរើសថ្នាក់ និងមុខវិជ្ជា',
                  style: AppTextStyle.bodySecondary,
                  textAlign: TextAlign.center),
            ],
          ),
        ),
      );
    }

    if (_loadingStudents) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_students.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.people_outline_rounded,
                size: 48, color: AppColors.grey.withValues(alpha: 0.4)),
            const SizedBox(height: 12),
            Text('មិនមានសិស្សក្នុងថ្នាក់នេះ',
                style: AppTextStyle.bodySecondary),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
      itemCount: _students.length + 1, // +1 for header
      itemBuilder: (context, index) {
        if (index == 0) return _buildListHeader();
        final student = _students[index - 1];
        return _buildStudentScoreRow(student, index);
      },
    );
  }

  Widget _buildListHeader() {
    final classLabel =
        _selectedClass!['name'] as String? ?? '${_selectedClass!['grade']} ${_selectedClass!['section']}';
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 4),
      child: Row(
        children: [
          Text('បញ្ជីសិស្ស — $classLabel',
              style: AppTextStyle.subtitle16
                  .copyWith(fontWeight: FontWeight.w600)),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primaryMain.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppNumber.radiusPill),
            ),
            child: Text('${_students.length} នាក់',
                style: AppTextStyle.caption12Secondary.copyWith(
                    color: AppColors.primaryMain, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentScoreRow(Map<String, dynamic> student, int number) {
    final sid = student['id'] as int;
    final name =
        '${student['first_name'] ?? ''} ${student['last_name'] ?? ''}'.trim();
    final gender = student['gender'] as String? ?? 'ប្រុស';
    final controller = _scoreControllers[sid]!;
    final existingScore = _existingScores[sid];
    final currentText = controller.text.trim();
    final currentScore = double.tryParse(currentText);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppNumber.radiusLarge),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryText.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Number badge
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.primaryMain.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text('$number',
                  style: AppTextStyle.body14.copyWith(
                      color: AppColors.primaryMain,
                      fontWeight: FontWeight.w700)),
            ),
          ),
          const SizedBox(width: 10),
          // Name + gender
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: AppTextStyle.body14
                        .copyWith(fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                Text(gender, style: AppTextStyle.caption12Secondary),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Grade badge (if score entered)
          if (currentScore != null) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: _gradeColor(currentScore).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                _gradeLabel(currentScore),
                style: AppTextStyle.caption12Secondary.copyWith(
                  color: _gradeColor(currentScore),
                  fontWeight: FontWeight.w600,
                  fontSize: 10,
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
          // Score input
          SizedBox(
            width: 72,
            height: 40,
            child: TextField(
              controller: controller,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                    RegExp(r'^\d{0,3}\.?\d{0,1}')),
              ],
              textAlign: TextAlign.center,
              style: AppTextStyle.subtitle16.copyWith(
                color: existingScore != null
                    ? AppColors.primaryMain
                    : AppColors.primaryText,
                fontWeight: FontWeight.w600,
              ),
              decoration: InputDecoration(
                hintText: '—',
                hintStyle: AppTextStyle.bodySecondary,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                filled: true,
                fillColor: existingScore != null
                    ? AppColors.primaryMain.withValues(alpha: 0.05)
                    : AppColors.backgroundLight,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                      color: AppColors.primaryMain, width: 1.5),
                ),
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveBar() {
    // Count how many have valid scores
    int filledCount = 0;
    for (final s in _students) {
      final text = _scoreControllers[s['id'] as int]?.text.trim() ?? '';
      final val = double.tryParse(text);
      if (val != null && val >= 0 && val <= 100) filledCount++;
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryText.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('$_selectedSubject',
                    style: AppTextStyle.body14
                        .copyWith(fontWeight: FontWeight.w600)),
                Text('$filledCount / ${_students.length} នាក់បានបំពេញ',
                    style: AppTextStyle.caption12Secondary),
              ],
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            height: 46,
            child: ElevatedButton.icon(
              onPressed: _saving ? null : _saveAllScores,
              icon: _saving
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: AppColors.white))
                  : const Icon(Icons.save_rounded, size: 20),
              label: Text(
                _saving ? 'កំពុងរក្សាទុក...' : 'រក្សាទុកពិន្ទុ',
                style: AppTextStyle.bodyWhite,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryMain,
                foregroundColor: AppColors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppNumber.radiusMedium),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
