import 'package:flutter/material.dart';
import 'package:tamdansers_app/constants/app_colors.dart';
import 'package:tamdansers_app/constants/app_number.dart';
import 'package:tamdansers_app/constants/text_style.dart';
import 'package:tamdansers_app/repositories/activity_repo.dart';
import 'package:tamdansers_app/repositories/class_repo.dart';
import 'package:tamdansers_app/repositories/student_class_repo.dart';
import 'package:tamdansers_app/routes/app_routes.dart';
import 'package:tamdansers_app/screens/teacher/teacher_dashboard.dart';
import 'package:tamdansers_app/widget/class_card.dart';

class ManageAllClass extends StatefulWidget {
  final bool showBackButton;
  const ManageAllClass({super.key, this.showBackButton = true});

  @override
  State<ManageAllClass> createState() => _ManageAllClassState();
}

class _ManageAllClassState extends State<ManageAllClass> {
  String _selectedGrade = "ទាំងអស់";
  String _searchQuery = "";
  List<Map<String, dynamic>> _classes = [];
  bool _loading = true;

  final TextEditingController _searchCtrl = TextEditingController();

  final List<String> grades = [
    "ទាំងអស់",
    "ថ្នាក់ទី 12",
    "ថ្នាក់ទី 11",
    "ថ្នាក់ទី 10",
    "ថ្នាក់ទី 9",
    "ថ្នាក់ទី 8",
    "ថ្នាក់ទី 7",
  ];

  @override
  void initState() {
    super.initState();
    _loadClasses();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadClasses() async {
    final classes = await ClassRepo().getClassesByTeacher(kTeacherId);
    if (mounted) {
      setState(() {
        _classes = classes;
        _loading = false;
      });
    }
  }

  List<Map<String, dynamic>> get _filteredClasses {
    return _classes.where((c) {
      final matchGrade =
          _selectedGrade == "ទាំងអស់" || c["grade"] == _selectedGrade;
      final matchSearch = _searchQuery.isEmpty ||
          (c["name"] as String)
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          (c["grade"] as String)
              .toLowerCase()
              .contains(_searchQuery.toLowerCase());
      return matchGrade && matchSearch;
    }).toList();
  }

  Color _hexToColor(String hex) =>
      Color(int.parse(hex.replaceFirst('#', '0xFF')));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "គ្រប់គ្រងថ្នាក់សិក្សា",
          style: AppTextStyle.sectionTitle20,
        ),
        leading: widget.showBackButton
            ? IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.arrow_back_ios_new_rounded,
                    color: AppColors.primaryText),
              )
            : null,
        automaticallyImplyLeading: widget.showBackButton,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildSearchAndAddSection(),
                const SizedBox(height: 12),
                _buildGradeFilters(),
              ],
            ),
          ),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _filteredClasses.isEmpty
                    ? Center(
                        child: Text("មិនមានថ្នាក់",
                            style: AppTextStyle.bodySecondary),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                        itemCount: _filteredClasses.length,
                        itemBuilder: (context, i) {
                          final cls = _filteredClasses[i];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: FutureBuilder<int>(
                              future: StudentClassRepo()
                                  .getStudentCountByClass(cls["id"] as int),
                              builder: (context, snap) {
                                final count = snap.data ?? 0;
                                return ClassCard(
                                  className:
                                      "${cls["name"]} (${cls["grade"]} ${cls["section"]})",
                                  title: cls["semester"] as String,
                                  students: "$count នាក់",
                                  color:
                                      _hexToColor(cls["color_hex"] as String),
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      AppRoutes.manageClass,
                                      arguments: cls["id"] as int,
                                    ).then((_) => _loadClasses());
                                  },
                                );
                              },
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndAddSection() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.primaryMain.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppNumber.radiusMedium),
            ),
            child: TextField(
              controller: _searchCtrl,
              onChanged: (v) => setState(() => _searchQuery = v),
              style: AppTextStyle.body14,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "ស្វែងរក...",
                hintStyle: AppTextStyle.bodySecondary,
                icon: Icon(Icons.search,
                    color: AppColors.secondaryText, size: 20),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        ElevatedButton.icon(
          onPressed: () => _showCreateClassDialog(),
          icon: const Icon(Icons.add, color: AppColors.white, size: 20),
          label: Text("បង្កើតថ្នាក់", style: AppTextStyle.body15White),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryMain,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppNumber.radiusMedium),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGradeFilters() {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: grades.length,
        itemBuilder: (context, index) {
          final grade = grades[index];
          final isSelected = _selectedGrade == grade;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(grade),
              selected: isSelected,
              onSelected: (_) => setState(() => _selectedGrade = grade),
              labelStyle: AppTextStyle.body14.copyWith(
                color: isSelected ? AppColors.white : AppColors.primaryText,
              ),
              backgroundColor: AppColors.white,
              selectedColor: AppColors.primaryMain,
              showCheckmark: false,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppNumber.radiusRounded),
                side: BorderSide(
                  color: isSelected
                      ? AppColors.primaryMain
                      : AppColors.secondaryText.withValues(alpha: 0.2),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          );
        },
      ),
    );
  }

  // ─── Create Class Dialog ─────────────────────────────────────────────────

  Future<void> _showCreateClassDialog() async {
    final gradeList = grades.where((g) => g != "ទាំងអស់").toList();
    final saved = await showDialog<bool>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.45),
      builder: (_) => _CreateClassDialog(
        grades: gradeList,
        hexToColor: _hexToColor,
      ),
    );
    if (saved == true && mounted) _loadClasses();
  }
}

// ─── Isolated StatefulWidget dialog — avoids _dependents.isEmpty error ───────

class _CreateClassDialog extends StatefulWidget {
  final List<String> grades;
  final Color Function(String) hexToColor;

  const _CreateClassDialog({
    required this.grades,
    required this.hexToColor,
  });

  @override
  State<_CreateClassDialog> createState() => _CreateClassDialogState();
}

class _CreateClassDialogState extends State<_CreateClassDialog> {
  final _nameCtrl = TextEditingController();
  final _sectionCtrl = TextEditingController();
  final _schoolYearCtrl = TextEditingController(text: "2024-2025");

  String? _grade;
  String _semester = "ឆមាសទី ១";
  bool _saving = false;

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
  String _color = _classColors[0];

  @override
  void dispose() {
    _nameCtrl.dispose();
    _sectionCtrl.dispose();
    _schoolYearCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_nameCtrl.text.trim().isEmpty ||
        _grade == null ||
        _sectionCtrl.text.trim().isEmpty) return;
    setState(() => _saving = true);
    try {
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
        subtitle: "${_nameCtrl.text.trim()} — $_grade",
      );
      if (mounted) Navigator.pop(context, true);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  InputDecoration _fieldDecoration({String? hint}) => InputDecoration(
        hintText: hint,
        hintStyle: AppTextStyle.bodySecondary,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppNumber.radiusMedium),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppNumber.radiusMedium),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppNumber.radiusMedium),
          borderSide:
              const BorderSide(color: AppColors.primaryMain, width: 1.5),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      );

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFFF0ECF8),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppNumber.radiusLarge)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Title ──
            Text("បង្កើតថ្នាក់ថ្មី",
                style: AppTextStyle.sectionTitle20
                    .copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),

            // ── Class name ──
            Text("ឈ្មោះថ្នាក់", style: AppTextStyle.bodySecondary),
            const SizedBox(height: 6),
            TextField(
              controller: _nameCtrl,
              style: AppTextStyle.body14,
              decoration: _fieldDecoration(hint: "ឧ. 7A, Grade 7A"),
            ),
            const SizedBox(height: 16),

            // ── Grade ──
            Text("ថ្នាក់ទី", style: AppTextStyle.bodySecondary),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              value: _grade,
              hint: Text("ជ្រើសថ្នាក់ទី", style: AppTextStyle.bodySecondary),
              dropdownColor: Colors.white,
              style: AppTextStyle.body14,
              decoration: _fieldDecoration(),
              items: widget.grades
                  .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                  .toList(),
              onChanged: (v) => setState(() => _grade = v),
            ),
            const SizedBox(height: 16),

            // ── Section ──
            Text("ផ្នែក (A, B, C…)", style: AppTextStyle.bodySecondary),
            const SizedBox(height: 6),
            TextField(
              controller: _sectionCtrl,
              style: AppTextStyle.body14,
              decoration: _fieldDecoration(hint: "A"),
            ),
            const SizedBox(height: 16),

            // ── Semester ──
            Text("ឆមាស", style: AppTextStyle.bodySecondary),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              value: _semester,
              dropdownColor: Colors.white,
              style: AppTextStyle.body14,
              decoration: _fieldDecoration(),
              items: ["ឆមាសទី ១", "ឆមាសទី ២"]
                  .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                  .toList(),
              onChanged: (v) => setState(() => _semester = v!),
            ),
            const SizedBox(height: 16),

            // ── Color ──
            Text("ពណ៌", style: AppTextStyle.bodySecondary),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _classColors.map((hex) {
                final col = widget.hexToColor(hex);
                final selected = _color == hex;
                return GestureDetector(
                  onTap: () => setState(() => _color = hex),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: col,
                      shape: BoxShape.circle,
                      border: selected
                          ? Border.all(color: Colors.black87, width: 2.5)
                          : null,
                      boxShadow: selected
                          ? [
                              BoxShadow(
                                  color: col.withValues(alpha: 0.5),
                                  blurRadius: 6,
                                  spreadRadius: 1)
                            ]
                          : null,
                    ),
                    child: selected
                        ? const Icon(Icons.check, size: 20, color: Colors.white)
                        : null,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // ── Actions ──
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed:
                      _saving ? null : () => Navigator.pop(context, false),
                  child: Text("បោះបង់", style: AppTextStyle.bodySecondary),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _saving ? null : _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF42A5F5),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppNumber.radiusMedium),
                    ),
                    elevation: 0,
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
            ),
          ],
        ),
      ),
    );
  }
}
