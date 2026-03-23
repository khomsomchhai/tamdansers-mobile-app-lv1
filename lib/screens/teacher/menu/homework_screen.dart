// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tamdansers_app/constants/app_colors.dart';
import 'package:tamdansers_app/constants/app_number.dart';
import 'package:tamdansers_app/constants/text_style.dart';
import 'package:tamdansers_app/repositories/homework_repo.dart';
import 'package:tamdansers_app/routes/app_routes.dart';
import 'package:tamdansers_app/state/app_notifiers.dart';

class HomeworkScreen extends StatefulWidget {
  final int? classId;
  final bool showBackButton;
  final ValueNotifier<int>? refreshTrigger;
  final int? teacherId;
  const HomeworkScreen({
    super.key,
    this.classId,
    this.showBackButton = true,
    this.refreshTrigger,
    this.teacherId,
  });

  @override
  State<HomeworkScreen> createState() => _HomeworkScreenState();
}

class _HomeworkScreenState extends State<HomeworkScreen> {
  bool _loading = true;
  List<Map<String, dynamic>> _allHomework = [];

  @override
  void initState() {
    super.initState();
    _loadHomework();
    widget.refreshTrigger?.addListener(_loadHomework);
    if (widget.classId == null) {
      homeworkChanged.addListener(_loadHomework);
    }
  }

  @override
  void dispose() {
    widget.refreshTrigger?.removeListener(_loadHomework);
    if (widget.classId == null) {
      homeworkChanged.removeListener(_loadHomework);
    }
    super.dispose();
  }

  Future<int> _getTeacherId() async {
    if (widget.teacherId != null) return widget.teacherId!;
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userId') ?? 1;
  }

  Future<void> _loadHomework() async {
    if (mounted) setState(() => _loading = true);
    List<Map<String, dynamic>> all;
    if (widget.classId != null) {
      all = await HomeworkRepo().getHomeworkByClass(widget.classId!);
    } else {
      final teacherId = await _getTeacherId();
      all = await HomeworkRepo().getAllHomeworkByTeacher(teacherId);
    }
    if (mounted) {
      setState(() {
        _allHomework = all;
        _loading = false;
      });
    }
  }

  void _editHomework(Map<String, dynamic> hw) {
    Navigator.pushNamed(context, AppRoutes.addTaskScreen, arguments: hw)
        .then((_) => _loadHomework());
  }

  Future<void> _confirmDelete(Map<String, dynamic> hw) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.backgroundLight,
        title: Text('លុបកិច្ចការ?', style: AppTextStyle.subtitle18),
        content: Text(
          'តើអ្នកចង់លុប "${hw['title']}" មែនទេ?',
          style: AppTextStyle.body14,
        ),
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
      await HomeworkRepo().deleteHomework(hw['id'] as int);
      _loadHomework();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.backgroundLight,
        elevation: 0,
        leading: widget.showBackButton
            ? IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.arrow_back_ios_new_rounded,
                    color: AppColors.primaryText),
              )
            : null,
        automaticallyImplyLeading: widget.showBackButton,
        title: Text('កិច្ចការផ្ទះ', style: AppTextStyle.sectionTitle20),
        centerTitle: true,
        actions: [
          if (widget.classId != null)
            IconButton(
              icon: Icon(Icons.add_circle,
                  color: AppColors.primaryMain, size: 28),
              onPressed: () => Navigator.pushNamed(
                      context, AppRoutes.addTaskScreen,
                      arguments: widget.classId)
                  .then((_) => _loadHomework()),
            ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _allHomework.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Text('មិនមានកិច្ចការ', style: AppTextStyle.body),
                  ),
                )
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    child: Column(
                      children: List.generate(_allHomework.length, (i) {
                        return Padding(
                          padding: i > 0
                              ? const EdgeInsets.only(top: 12)
                              : EdgeInsets.zero,
                          child: _buildHomeworkCard(hw: _allHomework[i]),
                        );
                      }),
                    ),
                  ),
                ),
    );
  }

  Widget _buildHomeworkCard({required Map<String, dynamic> hw}) {
    final title = hw['title'] as String? ?? '';
    final subject = hw['subject'] as String? ?? '';
    final dueDate = hw['deadline'] as String? ?? '';
    final submitted = (hw['submitted_count'] as int?) ?? 0;
    final total = (hw['total_students'] as int?) ?? 0;
    final progress = total > 0 ? submitted / total : 0.0;

    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        AppRoutes.homeworkDetailScreen,
        arguments: hw,
      ).then((_) => _loadHomework()),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppNumber.radiusLarge),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE3F2FD),
                    borderRadius: BorderRadius.circular(AppNumber.radiusMedium),
                  ),
                  child: Icon(Icons.assignment_outlined,
                      color: AppColors.primaryMain, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: AppTextStyle.fontsize18),
                      Text('មុខវិជ្ជា: $subject',
                          style: AppTextStyle.caption13Secondary),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right_rounded,
                    color: AppColors.secondaryText, size: 20),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ថ្ងៃផុតកំណត់ (Due Date)',
                        style: AppTextStyle.caption12Secondary,
                      ),
                      const SizedBox(height: 4),
                      Text(dueDate, style: AppTextStyle.fontsize18),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ការដញ្ជូន (Submissions)',
                        style: AppTextStyle.caption12Secondary,
                      ),
                      const SizedBox(height: 4),
                      Text('$submitted/$total', style: AppTextStyle.fontsize18),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(AppNumber.radiusSmall),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: AppColors.backgroundLight,
                valueColor:
                    const AlwaysStoppedAnimation<Color>(AppColors.primaryMain),
                minHeight: 8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
