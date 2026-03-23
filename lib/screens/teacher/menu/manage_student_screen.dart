import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tamdansers_app/constants/app_colors.dart';
import 'package:tamdansers_app/constants/app_icon.dart';
import 'package:tamdansers_app/constants/app_number.dart';
import 'package:tamdansers_app/constants/text_style.dart';
import 'package:tamdansers_app/database/db_helper.dart';
import 'package:tamdansers_app/repositories/student_class_repo.dart';
import 'package:tamdansers_app/routes/app_routes.dart';
import 'package:tamdansers_app/widget/custom_snackbar.dart';
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
  List<Map<String, dynamic>> _globalMatches = [];
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
    List<Map<String, dynamic>> globalResult = [];
    if (query.isEmpty) {
      result = await StudentClassRepo().getStudentsByClass(widget.classId);
    } else {
      result = await StudentClassRepo().searchStudents(widget.classId, query);
      globalResult = await StudentClassRepo()
          .searchStudentsInOtherClasses(widget.classId, query);
    }

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
        _globalMatches = globalResult;
        _attendanceMap = attMap;
        _loading = false;
      });
    }
  }

  Future<void> _addGlobalStudentToClass(Map<String, dynamic> s) async {
    final phone = s['phone'] as String?;
    final email = s['email'] as String?;
    final isDuplicate = await StudentClassRepo()
        .isDuplicateInClass(widget.classId, phone: phone, email: email);
    if (isDuplicate) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: CustomSnackbar(
              title: 'Error',
              message: 'សិស្សនេះមានក្នុងថ្នាក់នេះរួចហើយ',
              icon: Icons.error,
              color: Colors.red,
            ),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      return;
    }
    await StudentClassRepo().addStudent(
      firstName: s['first_name'] as String,
      lastName: s['last_name'] as String,
      gender: s['gender'] as String,
      classId: widget.classId,
      dob: s['dob'] as String?,
      email: s['email'] as String?,
      phone: s['phone'] as String?,
      photoPath: s['photo_path'] as String?,
      linkedUserId: s['linked_user_id'] as int?,
    );
    final linkedUserId = s['linked_user_id'] as int?;
    if (linkedUserId != null) {
      final db = await DbHelper().initDatabase();
      await db.insert(
        'tbl_user_class',
        {
          'user_id': linkedUserId,
          'class_id': widget.classId,
          'joined_at': DateTime.now().toIso8601String(),
        },
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    }
    searchCtrl.clear();
    _loadStudents();
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
      await _deleteStudentFully(student);
      _loadStudents();
    }
  }

  Future<void> _deleteStudentFully(Map<String, dynamic> student) async {
    final db = await DbHelper().initDatabase();
    await StudentClassRepo().deleteStudent(student['id'] as int);
    final linkedUserId = student['linked_user_id'] as int?;
    if (linkedUserId != null) {
      await db.delete(
        'tbl_user_class',
        where: 'user_id = ? AND class_id = ?',
        whereArgs: [linkedUserId, widget.classId],
      );
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
                  onTap: _globalMatches.isNotEmpty
                      ? null
                      : () {
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
                      color: _globalMatches.isNotEmpty
                          ? AppColors.grey.withValues(alpha: 0.5)
                          : AppColors.primaryMain,
                      borderRadius:
                          BorderRadius.circular(AppNumber.radiusMedium),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _globalMatches.isNotEmpty
                                ? AppColors.white.withValues(alpha: 0.5)
                                : AppColors.white,
                          ),
                          child: Icon(Icons.add_rounded,
                              size: 18,
                              color: _globalMatches.isNotEmpty
                                  ? AppColors.secondaryText
                                  : AppColors.primaryMain),
                        ),
                        const SizedBox(width: 8),
                        Text('បញ្ចូលសិស្ស',
                            style: AppTextStyle.bodyWhite.copyWith(
                                color: _globalMatches.isNotEmpty
                                    ? AppColors.secondaryText
                                    : AppColors.white)),
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
                : (_students.isEmpty && _globalMatches.isEmpty)
                    ? Center(
                        child: Text("មិនមានសិស្ស",
                            style: AppTextStyle.bodySecondary),
                      )
                    : ListView(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                        children: [
                          ..._students.map((s) => Dismissible(
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
                                                  style:
                                                      AppTextStyle.bodyPrimary),
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
                                  await _deleteStudentFully(s);
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
                                  child: _studentCard(
                                    student: s,
                                    onEdit: () => _editStudent(s),
                                    onDelete: () => _confirmDeleteStudent(s),
                                  ),
                                ),
                              )),
                          // ── Students found in other classes ─────────────
                          if (_globalMatches.isNotEmpty) ...[
                            if (_students.isNotEmpty) const SizedBox(height: 8),
                            Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: AppColors.primaryMain
                                    .withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(
                                    AppNumber.radiusMedium),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.info_outline_rounded,
                                      size: 16, color: AppColors.primaryMain),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'រកឃើញក្នុងប្រព័ន្ធ — ចុច "បន្ថែម" ដើម្បីដាក់ចូលថ្នាក់នេះ',
                                      style: AppTextStyle.caption12Secondary
                                          .copyWith(
                                              color: AppColors.primaryMain),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            ..._globalMatches.map((s) => _globalStudentCard(s)),
                          ],
                        ],
                      ),
          ),
        ],
      ),
    );
  }

  Widget _globalStudentCard(Map<String, dynamic> s) {
    final name = '${s['first_name']} ${s['last_name']}';
    final gender = s['gender'] as String? ?? 'ប្រុស';
    final photoPath = s['photo_path'] as String?;
    final hasPhoto = photoPath != null && File(photoPath).existsSync();
    final phone = s['phone'] as String?;
    final email = s['email'] as String?;
    final classGrade = s['class_grade'] as String?;
    final classSection = s['class_section'] as String?;
    final classLabel = (classGrade != null && classSection != null)
        ? '$classGrade $classSection'
        : null;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppNumber.radiusLarge),
        border: Border.all(
            color: AppColors.primaryMain.withValues(alpha: 0.35), width: 1),
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
            radius: 26,
            backgroundColor: AppColors.primaryMain.withValues(alpha: 0.15),
            backgroundImage: hasPhoto ? FileImage(File(photoPath)) : null,
            child: hasPhoto
                ? null
                : Image.asset(
                    gender == 'ស្រី'
                        ? AppIcon.femaleAvatar
                        : AppIcon.maleAvatar,
                    width: 36,
                    fit: BoxFit.cover,
                  ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: AppTextStyle.subtitle16),
                if (classLabel != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Row(
                      children: [
                        Icon(Icons.class_rounded,
                            size: 13, color: AppColors.primaryMain),
                        const SizedBox(width: 4),
                        Text(classLabel,
                            style: AppTextStyle.caption12Secondary
                                .copyWith(color: AppColors.primaryMain)),
                      ],
                    ),
                  ),
                if (phone != null && phone.isNotEmpty)
                  Text(phone, style: AppTextStyle.caption12Secondary),
                if (email != null && email.isNotEmpty)
                  Text(email, style: AppTextStyle.caption12Secondary),
              ],
            ),
          ),
          TextButton(
            onPressed: () => _addGlobalStudentToClass(s),
            style: TextButton.styleFrom(
              backgroundColor: AppColors.primaryMain,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppNumber.radiusMedium)),
            ),
            child: Text('បន្ថែម', style: AppTextStyle.bodyWhite),
          ),
        ],
      ),
    );
  }

  Widget _studentCard({
    required Map<String, dynamic> student,
    VoidCallback? onEdit,
    VoidCallback? onDelete,
  }) {
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
                        ? AppIcon.femaleAvatar
                        : AppIcon.maleAvatar,
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
          const SizedBox(width: 4),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert_rounded,
                color: AppColors.secondaryText, size: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppNumber.radiusMedium),
            ),
            onSelected: (value) {
              if (value == 'edit') onEdit?.call();
              if (value == 'delete') onDelete?.call();
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    const Icon(Icons.edit_outlined,
                        size: 18, color: AppColors.primaryMain),
                    const SizedBox(width: 10),
                    Text('កែប្រែ', style: AppTextStyle.body14),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    const Icon(Icons.delete_outline_rounded,
                        size: 18, color: AppColors.error),
                    const SizedBox(width: 10),
                    Text('លុប',
                        style: AppTextStyle.body14
                            .copyWith(color: AppColors.error)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
