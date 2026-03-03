// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:tamdansers_app/constants/app_colors.dart';
import 'package:tamdansers_app/constants/app_number.dart';
import 'package:tamdansers_app/constants/text_style.dart';
import 'package:tamdansers_app/repositories/homework_repo.dart';
import 'package:tamdansers_app/routes/app_routes.dart';
import 'package:tamdansers_app/screens/teacher/teacher_dashboard.dart';

class HomeworkScreen extends StatefulWidget {
  final int? classId;
  final bool showBackButton;
  const HomeworkScreen({
    super.key,
    this.classId,
    this.showBackButton = true,
  });

  @override
  State<HomeworkScreen> createState() => _HomeworkScreenState();
}

class _HomeworkScreenState extends State<HomeworkScreen> {
  bool _loading = true;
  List<Map<String, dynamic>> _activeHomework = [];
  List<Map<String, dynamic>> _reviewHomework = [];

  @override
  void initState() {
    super.initState();
    _loadHomework();
  }

  Future<void> _loadHomework() async {
    if (mounted) setState(() => _loading = true);
    List<Map<String, dynamic>> all;
    if (widget.classId != null) {
      all = await HomeworkRepo().getHomeworkByClass(widget.classId!);
    } else {
      all = await HomeworkRepo().getAllHomeworkByTeacher(kTeacherId);
    }
    if (mounted) {
      setState(() {
        _activeHomework = all.where((h) => h['status'] == 'active').toList();
        _reviewHomework = all.where((h) => h['status'] != 'active').toList();
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

  Future<void> _setStatus(Map<String, dynamic> hw, String status) async {
    await HomeworkRepo().updateHomeworkStatus(hw['id'] as int, status);
    if (mounted) _loadHomework();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: widget.showBackButton
            ? IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.arrow_back_ios_new_rounded,
                    color: AppColors.primaryText),
              )
            : null,
        automaticallyImplyLeading: widget.showBackButton,
        title: Text('កិច្ចការផ្ទះ', style: AppTextStyle.fontsize18),
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
          : _activeHomework.isEmpty && _reviewHomework.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Text('មិនមានកិច្ចការ', style: AppTextStyle.body),
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          "កិច្ចការផ្ទះ:",
                          style: AppTextStyle.screenTitle24,
                        ),
                      ),
                      if (_activeHomework.isNotEmpty) _buildActiveSection(),
                      if (_activeHomework.isNotEmpty &&
                          _reviewHomework.isNotEmpty)
                        const SizedBox(height: 16),
                      if (_reviewHomework.isNotEmpty) _buildReviewSection(),
                    ],
                  ),
                ),
    );
  }

  Widget _buildActiveSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.success,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                "សកម្ម (ACTIVE)",
                style: AppTextStyle.subtitle16,
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: List.generate(_activeHomework.length, (i) {
              const bgColors = [Color(0xFFE3F2FD), Color(0xFFE8F5E9)];
              const icons = [
                Icons.functions,
                Icons.chat_bubble_outline,
                Icons.assignment,
                Icons.book
              ];
              final hw = _activeHomework[i];
              return Padding(
                padding:
                    i > 0 ? const EdgeInsets.only(top: 12) : EdgeInsets.zero,
                child: _buildHomeworkCard(
                  hw: hw,
                  bgColor: bgColors[i % bgColors.length],
                  icon: icons[i % icons.length],
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildHomeworkCard({
    required Map<String, dynamic> hw,
    required Color bgColor,
    required IconData icon,
  }) {
    final title = hw['title'] as String? ?? '';
    final subject = hw['subject'] as String? ?? '';
    final dueDate = hw['deadline'] as String? ?? '';
    final submitted = (hw['submitted_count'] as int?) ?? 0;
    final total = (hw['total_students'] as int?) ?? 0;
    final progress = total > 0 ? submitted / total : 0.0;
    final isActive = hw['status'] == 'active';

    return Container(
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
                  color: bgColor,
                  borderRadius: BorderRadius.circular(AppNumber.radiusMedium),
                ),
                child: Icon(icon, color: AppColors.primaryMain, size: 24),
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
              // ⋮ popup menu
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert,
                    color: AppColors.secondaryText, size: 20),
                onSelected: (val) {
                  switch (val) {
                    case 'edit':
                      _editHomework(hw);
                      break;
                    case 'publish':
                      _setStatus(hw, 'active');
                      break;
                    case 'unpublish':
                      _setStatus(hw, 'review');
                      break;
                    case 'delete':
                      _confirmDelete(hw);
                      break;
                  }
                },
                itemBuilder: (_) => [
                  PopupMenuItem(
                    value: 'edit',
                    child: Row(children: [
                      const Icon(Icons.edit_outlined, size: 18),
                      const SizedBox(width: 10),
                      Text('កែប្រែ', style: AppTextStyle.subtitle16),
                    ]),
                  ),
                  if (!isActive)
                    PopupMenuItem(
                      value: 'publish',
                      child: Row(children: [
                        const Icon(Icons.publish_rounded,
                            size: 18, color: Colors.green),
                        const SizedBox(width: 10),
                        Text('ផ្សព្វផ្សាយ',
                            style: AppTextStyle.subtitle16
                                .copyWith(color: Colors.green)),
                      ]),
                    ),
                  if (isActive)
                    PopupMenuItem(
                      value: 'unpublish',
                      child: Row(children: [
                        const Icon(Icons.unpublished_outlined,
                            size: 18, color: Colors.orange),
                        const SizedBox(width: 10),
                        Text('មិនសកម្ម',
                            style: AppTextStyle.subtitle16
                                .copyWith(color: Colors.orange)),
                      ]),
                    ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(children: [
                      const Icon(Icons.delete_outline,
                          size: 18, color: Colors.red),
                      const SizedBox(width: 10),
                      Text('លុប',
                          style: AppTextStyle.subtitle16
                              .copyWith(color: Colors.red)),
                    ]),
                  ),
                ],
              ),
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
    );
  }

  Widget _buildReviewSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.orange,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "ពិនិត្យម្តងវិញ (REVIEW)",
                    style: AppTextStyle.subtitle16,
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: List.generate(_reviewHomework.length, (i) {
              const bgColors = [Color(0xFFFFF3E0), Color(0xFFF3E5F5)];
              const icons = [Icons.history, Icons.check_circle_outline];
              final hw = _reviewHomework[i];
              return Padding(
                padding:
                    i > 0 ? const EdgeInsets.only(top: 12) : EdgeInsets.zero,
                child: _buildHomeworkCard(
                  hw: hw,
                  bgColor: bgColors[i % bgColors.length],
                  icon: icons[i % icons.length],
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
