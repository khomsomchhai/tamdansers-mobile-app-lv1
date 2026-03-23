import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tamdansers_app/constants/app_colors.dart';
import 'package:tamdansers_app/constants/app_number.dart';
import 'package:tamdansers_app/constants/text_style.dart';
import 'package:tamdansers_app/repositories/class_repo.dart';
import 'package:tamdansers_app/repositories/student_class_repo.dart';
import 'package:tamdansers_app/routes/app_routes.dart';
import 'package:tamdansers_app/widget/class_card.dart';
import 'package:tamdansers_app/widget/create_class_dialog.dart';

class ManageAllClass extends StatefulWidget {
  final bool showBackButton;
  final ValueNotifier<int>? dashboardRefresh;
  final int? teacherId;
  const ManageAllClass({
    super.key,
    this.showBackButton = true,
    this.dashboardRefresh,
    this.teacherId,
  });

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
    widget.dashboardRefresh?.addListener(_loadClasses);
  }

  @override
  void dispose() {
    widget.dashboardRefresh?.removeListener(_loadClasses);
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<int> _getTeacherId() async {
    if (widget.teacherId != null) return widget.teacherId!;
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userId') ?? 1;
  }

  Future<void> _loadClasses() async {
    final teacherId = await _getTeacherId();
    final classes = await ClassRepo().getClassesByTeacher(teacherId);
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
                                  classCode: cls["class_code"] as String? ?? '',
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      AppRoutes.manageClass,
                                      arguments: cls["id"] as int,
                                    ).then((_) => _loadClasses());
                                  },
                                  teacherName: '',
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

  Future<void> _showCreateClassDialog() async {
    final gradeList = grades.where((g) => g != "ទាំងអស់").toList();
    await showDialog<bool>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.45),
      builder: (_) => CreateClassDialog(grades: gradeList),
    );
    if (mounted) {
      _loadClasses();
      widget.dashboardRefresh?.value++;
    }
  }
}
