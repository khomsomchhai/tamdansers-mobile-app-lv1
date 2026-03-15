// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tamdansers_app/constants/app_colors.dart';
import 'package:tamdansers_app/constants/app_number.dart';
import 'package:tamdansers_app/constants/text_style.dart';
import 'package:tamdansers_app/repositories/homework_repo.dart';
import 'package:tamdansers_app/routes/app_routes.dart';

class HomeworkDetailScreen extends StatefulWidget {
  const HomeworkDetailScreen({super.key});

  @override
  State<HomeworkDetailScreen> createState() => _HomeworkDetailScreenState();
}

class _HomeworkDetailScreenState extends State<HomeworkDetailScreen> {
  late Map<String, dynamic> _hw;
  bool _initialized = false;
  List<Map<String, dynamic>> _students = [];
  bool _loadingStudents = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;
    final args = ModalRoute.of(context)?.settings.arguments;
    _hw = (args is Map<String, dynamic>) ? Map.from(args) : {};
    _loadStudents();
  }

  Future<void> _loadStudents() async {
    final homeworkId = _hw['id'] as int?;
    final classId = _hw['class_id'] as int?;
    if (homeworkId == null || classId == null) {
      if (mounted) setState(() => _loadingStudents = false);
      return;
    }
    final result = await HomeworkRepo().getStudentsWithSubmissionStatus(
      homeworkId: homeworkId,
      classId: classId,
    );
    if (mounted) {
      setState(() {
        _students = result;
        _loadingStudents = false;
      });
    }
  }

  String get _title => _hw['title'] as String? ?? '';
  String get _subject => _hw['subject'] as String? ?? '';
  String get _dueDate => _hw['deadline'] as String? ?? '';
  int get _submittedCount =>
      _students.where((s) => (s['submitted'] as int? ?? 0) == 1).length;
  int get _total => _students.length;
  double get _progress => _total > 0 ? _submittedCount / _total : 0.0;

  Future<void> _confirmDelete() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.backgroundLight,
        title: Text('លុបកិច្ចការ?', style: AppTextStyle.subtitle18),
        content:
            Text('តើអ្នកចង់លុប "$_title" មែនទេ?', style: AppTextStyle.body14),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('បោះបង់', style: AppTextStyle.bodyPrimary),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('លុប',
                style: AppTextStyle.subtitle16.copyWith(color: Colors.red)),
          ),
        ],
      ),
    );
    if (ok == true && mounted) {
      await HomeworkRepo().deleteHomework(_hw['id'] as int);
      if (mounted) Navigator.pop(context, 'deleted');
    }
  }

  Future<void> _toggleSubmission(Map<String, dynamic> student) async {
    final homeworkId = _hw['id'] as int;
    final studentId = student['id'] as int;
    final alreadySubmitted = (student['submitted'] as int? ?? 0) == 1;
    if (alreadySubmitted) {
      await HomeworkRepo()
          .unsubmitHomework(homeworkId: homeworkId, studentId: studentId);
    } else {
      await HomeworkRepo()
          .submitHomework(homeworkId: homeworkId, studentId: studentId);
    }
    await _loadStudents();
  }

  String _formatTime(String raw) {
    try {
      final dt = DateTime.parse(raw);
      final dd = dt.day.toString().padLeft(2, '0');
      final mm = dt.month.toString().padLeft(2, '0');
      final hh = dt.hour.toString().padLeft(2, '0');
      final min = dt.minute.toString().padLeft(2, '0');
      return '$dd/$mm $hh:$min';
    } catch (_) {
      return raw;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: CustomScrollView(
        slivers: [
          // ── Colored SliverAppBar ──
          SliverAppBar(
            expandedHeight: 148,
            pinned: true,
            backgroundColor: const Color(0xFFE3F2FD),
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: AppColors.primaryText),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.edit_outlined, color: AppColors.primaryMain),
                onPressed: () => Navigator.pushNamed(
                        context, AppRoutes.addTaskScreen,
                        arguments: _hw)
                    .then((_) => Navigator.pop(context, 'edited')),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                onPressed: _confirmDelete,
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: const Color(0xFFE3F2FD),
                padding: const EdgeInsets.fromLTRB(20, 52, 20, 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.6),
                        borderRadius:
                            BorderRadius.circular(AppNumber.radiusMedium),
                      ),
                      child: const Icon(Icons.assignment_outlined,
                          color: AppColors.primaryMain, size: 28),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(_title,
                              style: AppTextStyle.fontsize18
                                  .copyWith(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text('មុខវិជ្ជា: $_subject',
                              style: AppTextStyle.caption13Secondary),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Stats row ──
                  Row(
                    children: [
                      Expanded(
                        child: _statCard(
                          icon: Icons.calendar_today_outlined,
                          label: 'ថ្ងៃផុតកំណត់',
                          value: _dueDate,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _statCard(
                          icon: Icons.assignment_turned_in_outlined,
                          label: 'បានបញ្ជូន',
                          value: '$_submittedCount / $_total',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // ── Progress bar ──
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('កម្រិតការបញ្ជូន',
                          style: AppTextStyle.caption13Secondary),
                      Text(
                        '${(_progress * 100).toStringAsFixed(0)}%',
                        style: AppTextStyle.caption13Secondary.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryMain),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppNumber.radiusSmall),
                    child: LinearProgressIndicator(
                      value: _progress,
                      backgroundColor: AppColors.primaryMain.withOpacity(0.1),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                          AppColors.primaryMain),
                      minHeight: 10,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ── Section header ──
                  Row(
                    children: [
                      Text(
                        'សិស្ស $_submittedCount/${_students.length}',
                        style: AppTextStyle.subtitle16,
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () => Navigator.pushNamed(
                            context, AppRoutes.studentSubmissionScreen,
                            arguments: _hw),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text('មើលទាំងអស់',
                            style: AppTextStyle.caption13Secondary
                                .copyWith(color: AppColors.primaryMain)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),

          // ── Student list ──
          _loadingStudents
              ? const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                )
              : _students.isEmpty
                  ? SliverToBoxAdapter(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32),
                          child: Text('មិនមានសិស្ស',
                              style: AppTextStyle.bodySecondary),
                        ),
                      ),
                    )
                  : SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, i) {
                          final s = _students[i];
                          final submitted = (s['submitted'] as int? ?? 0) == 1;
                          final firstName = s['first_name'] as String? ?? '';
                          final lastName = s['last_name'] as String? ?? '';
                          final submittedAt =
                              s['submitted_at'] as String? ?? '';

                          return Padding(
                            padding:
                                EdgeInsets.fromLTRB(16, i == 0 ? 0 : 10, 16, 0),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 14),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(
                                    AppNumber.radiusLarge),
                              ),
                              child: Row(
                                children: [
                                  // Avatar
                                  CircleAvatar(
                                    radius: 24,
                                    backgroundColor:
                                        AppColors.primaryMain.withOpacity(0.15),
                                    backgroundImage: () {
                                      final p = s['photo_path'] as String?;
                                      if (p != null && File(p).existsSync()) {
                                        return FileImage(File(p)) as ImageProvider;
                                      }
                                      return null;
                                    }(),
                                    child: () {
                                      final p = s['photo_path'] as String?;
                                      if (p != null && File(p).existsSync()) return null;
                                      return Icon(
                                        Icons.person_outline,
                                        color: AppColors.primaryMain,
                                        size: 26,
                                      );
                                    }(),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '$firstName $lastName',
                                          style: AppTextStyle.body14.copyWith(
                                              fontWeight: FontWeight.w600),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          submitted && submittedAt.isNotEmpty
                                              ? '$_subject • ${_formatTime(submittedAt)}'
                                              : _subject,
                                          style:
                                              AppTextStyle.caption12Secondary,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  submitted
                                      ? OutlinedButton.icon(
                                          onPressed: () => _toggleSubmission(s),
                                          icon: const Icon(
                                              Icons.check_circle_outline,
                                              size: 16),
                                          label: Text('បានដាក់',
                                              style: AppTextStyle
                                                  .caption12Secondary
                                                  .copyWith(
                                                      color:
                                                          AppColors.success)),
                                          style: OutlinedButton.styleFrom(
                                            side: BorderSide(
                                                color: AppColors.success,
                                                width: 1.2),
                                            foregroundColor: AppColors.success,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 6),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      AppNumber.radiusMedium),
                                            ),
                                          ),
                                        )
                                      : ElevatedButton.icon(
                                          onPressed: () => _toggleSubmission(s),
                                          icon: const Icon(
                                              Icons.grading_outlined,
                                              size: 16,
                                              color: Colors.white),
                                          label: Text(
                                            'ដាក់ពិន្ទុ (Grade Now)',
                                            style: AppTextStyle
                                                .caption12Secondary
                                                .copyWith(color: Colors.white),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                AppColors.primaryMain,
                                            elevation: 0,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 6),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      AppNumber.radiusMedium),
                                            ),
                                          ),
                                        ),
                                ],
                              ),
                            ),
                          );
                        },
                        childCount: _students.length,
                      ),
                    ),

          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }

  Widget _statCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppNumber.radiusMedium),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: AppColors.secondaryText),
              const SizedBox(width: 5),
              Text(label, style: AppTextStyle.caption12Secondary),
            ],
          ),
          const SizedBox(height: 8),
          Text(value,
              style: AppTextStyle.body14.copyWith(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
