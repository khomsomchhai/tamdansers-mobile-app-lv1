import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:tamdansers_app/constants/app_colors.dart';
import 'package:tamdansers_app/constants/app_images.dart';
import 'package:tamdansers_app/constants/app_number.dart';
import 'package:tamdansers_app/constants/text_style.dart';
import 'package:tamdansers_app/database/db_helper.dart';
import 'package:tamdansers_app/repositories/student_class_repo.dart';
import 'package:tamdansers_app/routes/app_routes.dart';
import 'package:tamdansers_app/widget/search_field.dart';

class ManageStudentScreen extends StatefulWidget {
  final int classId;
  const ManageStudentScreen({super.key, required this.classId});

  @override
  State<ManageStudentScreen> createState() => _ManageStudentScreenState();
}

class _ManageStudentScreenState extends State<ManageStudentScreen> {
  final TextEditingController searchCtrl = TextEditingController();
  List<Map<String, dynamic>> _students = [];
  // studentId -> attendance percent (0.0–1.0)
  Map<int, double> _attendanceMap = {};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadStudents();
  }

  @override
  void dispose() {
    searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadStudents() async {
    final query = searchCtrl.text.trim();
    List<Map<String, dynamic>> result;
    if (query.isEmpty) {
      result = await StudentClassRepo().getStudentsByClass(widget.classId);
    } else {
      result = await StudentClassRepo().searchStudents(widget.classId, query);
    }

    // Load attendance for all students in parallel
    final db = await DbHelper().initDatabase();
    final attendanceRows = await db.query(
      'tbl_attendance',
      where: 'class_id = ?',
      whereArgs: [widget.classId],
    );
    final Map<int, double> attMap = {};
    for (final s in result) {
      final sid = s['id'] as int;
      final rows = attendanceRows.where((r) => r['student_id'] == sid).toList();
      final total = rows.length;
      final present = rows.where((r) => r['status'] == 'present').length;
      attMap[sid] = total == 0 ? 0.0 : present / total;
    }

    if (mounted) {
      setState(() {
        _students = result;
        _attendanceMap = attMap;
        _loading = false;
      });
    }
  }

  void _editStudent(Map<String, dynamic> student) {
    Navigator.pushNamed(
      context,
      AppRoutes.addStudentScreen,
      arguments: student,
    ).then((_) => _loadStudents());
  }

  Future<void> _confirmDeleteStudent(Map<String, dynamic> student) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.backgroundLight,
        title: Text("លុបសិស្ស?", style: AppTextStyle.subtitle18),
        content: Text(
          "តើអ្នកពិតជាចង់លុបសិស្ស ${student["first_name"]} ${student["last_name"]} មែនទេ?",
          style: AppTextStyle.body14,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text("បោះបង់", style: AppTextStyle.bodyPrimary),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text("លុប",
                style: AppTextStyle.subtitle16
                    .copyWith(color: Theme.of(ctx).colorScheme.error)),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await StudentClassRepo().deleteStudent(student["id"] as int);
      _loadStudents();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: AppColors.primaryText),
        ),
        title: Text("គ្រប់គ្រងសិស្ស", style: AppTextStyle.sectionTitle20),
        centerTitle: true,
        elevation: 0,
        surfaceTintColor: AppColors.transparent,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
            child: Row(
              children: [
                Expanded(
                  child: SearchField(
                    controller: searchCtrl,
                    hintText: "ស្វែងរក...",
                    icon: const Icon(Icons.search_outlined,
                        color: AppColors.secondaryText),
                    onChanged: (_) => _loadStudents(),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.addStudentScreen,
                      arguments: widget.classId,
                    ).then((_) => _loadStudents());
                  },
                  child: Container(
                    height: 46,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: AppColors.primaryMain,
                      borderRadius:
                          BorderRadius.circular(AppNumber.radiusMedium),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.white,
                          ),
                          child: const Icon(Icons.add_rounded,
                              size: 18, color: AppColors.primaryMain),
                        ),
                        const SizedBox(width: 8),
                        Text("បញ្ចូលសិស្ស", style: AppTextStyle.bodyWhite),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Text(
                  "បញ្ជីសិស្ស",
                  style: AppTextStyle.sectionTitle20
                      .copyWith(fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                Text(
                  "${_students.length} នាក់",
                  style: AppTextStyle.sectionTitle20.copyWith(
                    color: AppColors.primaryMain,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _students.isEmpty
                    ? Center(
                        child: Text("មិនមានសិស្ស",
                            style: AppTextStyle.bodySecondary),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                        itemCount: _students.length,
                        itemBuilder: (context, index) {
                          final s = _students[index];
                          return Dismissible(
                            key: ValueKey(s['id']),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                color: AppColors.error,
                                borderRadius: BorderRadius.circular(
                                    AppNumber.radiusLarge),
                              ),
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20),
                              child: const Icon(Icons.delete_rounded,
                                  color: AppColors.white, size: 28),
                            ),
                            confirmDismiss: (_) async {
                              return await showDialog<bool>(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      backgroundColor:
                                          AppColors.backgroundLight,
                                      title: Text("លុបសិស្ស?",
                                          style: AppTextStyle.subtitle18),
                                      content: Text(
                                        "តើអ្នកពិតជាចង់លុបសិស្ស ${s["first_name"]} ${s["last_name"]} មែនទេ?",
                                        style: AppTextStyle.body14,
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(ctx, false),
                                          child: Text("បោះបង់",
                                              style: AppTextStyle.bodyPrimary),
                                        ),
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(ctx, true),
                                          child: Text(
                                            "លុប",
                                            style: AppTextStyle.subtitle16
                                                .copyWith(
                                                    color: Theme.of(ctx)
                                                        .colorScheme
                                                        .error),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ) ??
                                  false;
                            },
                            onDismissed: (_) async {
                              final source = s['_source'] as String? ?? 'tbl_student_class';
                              if (source == 'tbl_user') {
                                final db = await DbHelper().initDatabase();
                                await db.delete('tbl_user_class',
                                    where: 'user_id = ? AND class_id = ?',
                                    whereArgs: [s['id'], widget.classId]);
                              } else {
                                await StudentClassRepo()
                                    .deleteStudent(s["id"] as int);
                              }
                              _loadStudents();
                            },
                            child: Bounceable(
                              onTap: () async {
                                final result = await Navigator.pushNamed(
                                  context,
                                  AppRoutes.studentDetailScreen,
                                  arguments: s["id"] as int,
                                );
                                if (result == true) _loadStudents();
                              },
                              child: _studentCard(student: s),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _studentCard({required Map<String, dynamic> student}) {
    final name = "${student["first_name"]} ${student["last_name"]}";
    final gender = student["gender"] as String? ?? "ប្រុស";
    final photoPath = student["photo_path"] as String?;
    final hasPhoto = photoPath != null && File(photoPath).existsSync();
    final sid = student['id'] as int;
    final percent = _attendanceMap[sid] ?? 0.0;
    final percentLabel = '${(percent * 100).round()}%';
    final color = percent >= 0.8
        ? AppColors.success
        : percent >= 0.5
            ? AppColors.orange
            : AppColors.error;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppNumber.radiusLarge),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryText.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: AppColors.primaryMain.withValues(alpha: 0.15),
            backgroundImage: hasPhoto ? FileImage(File(photoPath)) : null,
            child: hasPhoto
                ? null
                : Image.asset(
                    gender == "ស្រី"
                        ? AppImages.userProfile
                        : AppImages.studentMale2,
                    width: 40,
                    fit: BoxFit.cover,
                  ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: AppTextStyle.subtitle16),
                const SizedBox(height: 4),
                Text(gender, style: AppTextStyle.body14),
              ],
            ),
          ),
          CircularPercentIndicator(
            radius: 28,
            lineWidth: 5.0,
            percent: percent.clamp(0.0, 1.0),
            center: Text(percentLabel,
                style: AppTextStyle.caption12Secondary.copyWith(fontSize: 10)),
            progressColor: color,
            backgroundColor: AppColors.secondaryText.withValues(alpha: 0.15),
            animation: true,
            animationDuration: 600,
            circularStrokeCap: CircularStrokeCap.round,
          ),
        ],
      ),
    );
  }
}
