import 'dart:io';

import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:tamdansers_app/constants/app_colors.dart';
import 'package:tamdansers_app/constants/app_images.dart';
import 'package:tamdansers_app/constants/app_number.dart';
import 'package:tamdansers_app/constants/text_style.dart';
import 'package:tamdansers_app/database/db_helper.dart';
import 'package:tamdansers_app/repositories/student_class_repo.dart';
import 'package:tamdansers_app/routes/app_routes.dart';

class StudentDetailScreen extends StatefulWidget {
  final int studentId;
  const StudentDetailScreen({super.key, required this.studentId});

  @override
  State<StudentDetailScreen> createState() => _StudentDetailScreenState();
}

class _StudentDetailScreenState extends State<StudentDetailScreen> {
  Map<String, dynamic>? _student;
  String? _className;
  List<Map<String, dynamic>> _scores = [];
  int _attendPresent = 0;
  int _attendExcused = 0;
  int _attendAbsent = 0;
  bool _loading = true;
  bool _wasEdited = false;

  @override
  void initState() {
    super.initState();
    _loadStudent();
  }

  Future<void> _loadStudent() async {
    // Run student + scores in parallel — both are independent
    final db = await DbHelper().initDatabase();

    // Try tbl_student_class first, then fall back to tbl_user
    var studentRows = await db.query('tbl_student_class',
        where: 'id = ?', whereArgs: [widget.studentId]);
    Map<String, dynamic>? student;
    if (studentRows.isNotEmpty) {
      student = studentRows.first;
    } else {
      // Self-joined student: load from tbl_user
      final userRows = await db
          .query('tbl_user', where: 'id = ?', whereArgs: [widget.studentId]);
      if (userRows.isNotEmpty) {
        student = userRows.first;
      }
    }

    final results = await Future.wait([
      db.query('tbl_score',
          where: 'student_id = ?',
          whereArgs: [widget.studentId],
          orderBy: 'subject ASC'),
      db.query('tbl_attendance',
          where: 'student_id = ?', whereArgs: [widget.studentId]),
    ]);

    final scoreRows = results[0];
    final attendRows = results[1];

    String? className;
    if (student != null && student['class_id'] != null) {
      final classRows = await db.query('tbl_class',
          where: 'id = ?', whereArgs: [student['class_id']]);
      if (classRows.isNotEmpty) {
        className = "${classRows.first['grade']} ${classRows.first['section']}";
      }
    }

    final present = attendRows.where((r) => r['status'] == 'present').length;
    final excused = attendRows.where((r) => r['status'] == 'excused').length;
    final absent = attendRows.where((r) => r['status'] == 'absent').length;

    setState(() {
      _student = student;
      _className = className;
      _scores = scoreRows;
      _attendPresent = present;
      _attendExcused = excused;
      _attendAbsent = absent;
      _loading = false;
    });
  }

  Future<void> _confirmDelete() async {
    final name =
        '${_student?['first_name'] ?? ''} ${_student?['last_name'] ?? ''}'
            .trim();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppNumber.radiusLarge)),
        title: Text('លុបសិស្ស', style: AppTextStyle.sectionTitle20),
        content: Text(
          'តើអ្នកប្រាកដថាចង់លុប "$name" មែនទេ? សកម្មភាពនេះមិនអាចត្រឡប់វិញបានទេ។',
          style: AppTextStyle.body,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('បោះបង់', style: AppTextStyle.bodyPrimary),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppNumber.radiusPill)),
              elevation: 0,
            ),
            child: Text('លុប', style: AppTextStyle.bodyWhite),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      await StudentClassRepo().deleteStudent(widget.studentId);
      if (mounted) Navigator.pop(context, true);
    }
  }

  String _formatDob(String? dob) {
    if (dob == null || dob.isEmpty) return '—';
    try {
      final d = DateTime.parse(dob);
      return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
    } catch (_) {
      return dob;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.pop(context, _wasEdited),
            icon: Icon(Icons.arrow_back_ios_new_rounded,
                color: AppColors.primaryText),
          ),
          title: Text("ព័ត៌មានលម្អិត", style: AppTextStyle.sectionTitle20),
          centerTitle: true,
          elevation: 0,
          backgroundColor: AppColors.transparent,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context, _wasEdited),
          icon: Icon(Icons.arrow_back_ios_new_rounded,
              color: AppColors.primaryText),
        ),
        title: Text("ព័ត៌មានលម្អិត", style: AppTextStyle.sectionTitle20),
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColors.transparent,
        actions: [
          IconButton(
            icon: Icon(Icons.edit_rounded, color: AppColors.primaryMain),
            onPressed: () async {
              final updated = await Navigator.pushNamed(
                context,
                AppRoutes.addStudentScreen,
                arguments: Map<String, dynamic>.from(_student ?? {}),
              );
              if (updated == true) {
                _wasEdited = true;
                _loadStudent();
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            _buildProfileHeader(),
            const SizedBox(height: 24),
            _buildGeneralInfo(context),
            const SizedBox(height: 20),
            _buildAttendanceCard(),
            const SizedBox(height: 20),
            _buildSubjectList(context),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    final name =
        '${_student?['first_name'] ?? ''} ${_student?['last_name'] ?? ''}'
            .trim();
    final photoPath = _student?['photo_path'] as String?;
    final gender = _student?['gender'] as String? ?? 'ប្រុស';
    final isMale = gender != 'ស្រី';
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: AppColors.primaryMain.withValues(alpha: 0.1),
          backgroundImage: (photoPath != null && File(photoPath).existsSync())
              ? FileImage(File(photoPath))
              : null,
          child: (photoPath == null || !File(photoPath).existsSync())
              ? Image.asset(
                  isMale ? AppImages.studentMale2 : AppImages.studentMale2,
                  width: 70)
              : null,
        ),
        const SizedBox(height: 12),
        Text(name.isEmpty ? '—' : name,
            style: AppTextStyle.sectionTitle20
                .copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_className != null) ...[
              _tag(_className!, AppColors.primaryMain.withValues(alpha: 0.1),
                  AppColors.primaryMain),
              const SizedBox(width: 8),
            ],
            _tag('កំពុងសិក្សា', AppColors.success.withValues(alpha: 0.1),
                AppColors.success),
          ],
        )
      ],
    );
  }

  Widget _buildGeneralInfo(BuildContext context) {
    final gender = _student?['gender'] as String? ?? '—';
    final dob = _formatDob(_student?['dob'] as String?);
    final phone = _student?['phone'] as String? ?? '—';
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionLabel(Icons.info_outline, 'ព័ត៌មានទូទៅ'),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _infoTile('ឆ្នាំកំណើត', dob)),
              Expanded(child: _infoTile('ភេទ', gender)),
            ],
          ),
          const SizedBox(height: 16),
          Text('ទំនាក់ទំនង',
              style:
                  AppTextStyle.body.copyWith(color: AppColors.secondaryText)),
          Row(
            children: [
              Text(phone,
                  style: AppTextStyle.body
                      .copyWith(fontWeight: FontWeight.bold, fontSize: 16)),
              const Spacer(),
              _circleIcon(Icons.phone, AppColors.success),
              const SizedBox(width: 10),
              _circleIcon(Icons.chat_bubble, AppColors.primaryMain),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: () async {
                final result = await Navigator.pushNamed(
                  context,
                  AppRoutes.linkParentScreen,
                );

                if (!context.mounted) return;

                if (result == true) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Center(
                        child: Text(
                          "ភ្ជាប់អាណាព្យាបាលជោគជ័យ",
                          style: AppTextStyle.sectionTitle20,
                        ),
                      ),
                      backgroundColor: AppColors.success,
                    ),
                  );
                }
              },
              icon: const Icon(Icons.person_add_alt_1_rounded,
                  color: AppColors.white, size: 20),
              label: Text("ភ្ជាប់អាណាព្យាបាល", style: AppTextStyle.bodyWhite),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryMain,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppNumber.radiusPill)),
                elevation: 0,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildAttendanceCard() {
    final total = _attendPresent + _attendExcused + _attendAbsent;
    final percent = total == 0 ? 0.0 : _attendPresent / total;
    final percentLabel = total == 0 ? '0%' : '${(percent * 100).round()}%';
    return _card(
      child: Column(
        children: [
          _sectionLabel(Icons.calendar_month, 'វត្តមានសរុប'),
          const SizedBox(height: 20),
          CircularPercentIndicator(
            radius: 60.0,
            lineWidth: 10.0,
            percent: percent.clamp(0.0, 1.0),
            center: Text(percentLabel, style: AppTextStyle.sectionTitle20),
            progressColor: percent >= 0.8
                ? AppColors.success
                : percent >= 0.5
                    ? AppColors.orange
                    : AppColors.error,
            backgroundColor: AppColors.secondaryText,
            circularStrokeCap: CircularStrokeCap.round,
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _statItem('វត្តមាន', '$_attendPresent ថ្ងៃ'),
              _statItem('ច្បាប់', '$_attendExcused ថ្ងៃ'),
              _statItem('អវត្តមាន', '$_attendAbsent ថ្ងៃ'),
            ],
          )
        ],
      ),
    );
  }

  String _gradeLabel(double score) {
    if (score >= 90) return 'ល្អណាស់';
    if (score >= 70) return 'ល្អ';
    if (score >= 50) return 'មធ្យម';
    return 'ខ្សោយ';
  }

  Color _gradeColor(double score) {
    if (score >= 90) return AppColors.primaryMain;
    if (score >= 70) return AppColors.success;
    if (score >= 50) return AppColors.orange;
    return AppColors.error;
  }

  Widget _buildSubjectList(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text("លទ្ធផលសិក្សា", style: AppTextStyle.sectionTitle20),
            const Spacer(),
            TextButton(
                onPressed: () {
                  final classId = _student?['class_id'] as int? ?? 0;
                  Navigator.pushNamed(
                    context,
                    AppRoutes.scoreDetailScreen,
                    arguments: {
                      'studentId': widget.studentId,
                      'classId': classId,
                    },
                  );
                },
                child: Text(
                  "មើលទាំងអស់",
                  style: AppTextStyle.bodyPrimary,
                ))
          ],
        ),
        const SizedBox(height: 12),
        if (_scores.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text('មិនទាន់មានពិន្ទុ', style: AppTextStyle.bodySecondary),
          )
        else
          ..._scores.take(3).map((s) {
            final score = (s['score'] as num).toDouble();
            return _buildSubjectItem(
              s['subject'] as String,
              score.toStringAsFixed(0),
              _gradeLabel(score),
              _gradeColor(score),
            );
          }),
      ],
    );
  }

  // Widget _buildNoteSection() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text("កំណត់ត្រាគ្រូ", style: AppTextStyle.sectionTitle20),
  //       const SizedBox(height: 10),
  //       TextField(
  //         maxLines: 3,
  //         decoration: InputDecoration(
  //           hintText: "បញ្ចូលចំណាំ...",
  //           hintStyle:
  //               AppTextStyle.body.copyWith(color: AppColors.secondaryText),
  //           filled: true,
  //           fillColor: AppColors.white,
  //           border: OutlineInputBorder(
  //               borderRadius: BorderRadius.circular(15),
  //               borderSide: BorderSide.none),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Widget _card({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppNumber.radiusPill),
        boxShadow: [
          BoxShadow(
              color: AppColors.primaryText.withValues(alpha: 0.04),
              blurRadius: 10)
        ],
      ),
      child: child,
    );
  }

  Widget _sectionLabel(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primaryMain, size: 20),
        const SizedBox(width: 8),
        Text(label, style: AppTextStyle.subtitle16),
      ],
    );
  }

  Widget _infoTile(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyle.bodySecondary),
        Text(value, style: AppTextStyle.subtitle16),
      ],
    );
  }

  Widget _statItem(String label, String value) {
    return Column(
      children: [
        Text(label, style: AppTextStyle.caption12Secondary),
        Text(value, style: AppTextStyle.subtitle16),
      ],
    );
  }

  Widget _tag(String text, Color bg, Color textCol) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(AppNumber.radiusSmall)),
      child: Text(text,
          style: AppTextStyle.body.copyWith(
              color: textCol, fontSize: 12, fontWeight: FontWeight.bold)),
    );
  }

  Widget _circleIcon(IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1), shape: BoxShape.circle),
      child: Icon(icon, color: color, size: 20),
    );
  }

  Widget _buildSubjectItem(
      String title, String score, String status, Color themeColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppNumber.radiusPill),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
                color: themeColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppNumber.radiusLarge)),
            child: Center(
              child: Text(title[0],
                  style:
                      AppTextStyle.sectionTitle20.copyWith(color: themeColor)),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyle.subtitle16),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(score,
                  style: AppTextStyle.sectionTitle20.copyWith(
                      color: themeColor, fontWeight: FontWeight.bold)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppNumber.radiusSmall)),
                child: Text(status,
                    style: AppTextStyle.caption12Secondary.copyWith(
                        color: AppColors.success, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
