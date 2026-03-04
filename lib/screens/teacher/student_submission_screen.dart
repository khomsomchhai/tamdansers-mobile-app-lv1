// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:tamdansers_app/constants/app_colors.dart';
import 'package:tamdansers_app/constants/app_number.dart';
import 'package:tamdansers_app/constants/text_style.dart';
import 'package:tamdansers_app/repositories/homework_repo.dart';

class StudentSubmissionScreen extends StatefulWidget {
  const StudentSubmissionScreen({super.key});

  @override
  State<StudentSubmissionScreen> createState() =>
      _StudentSubmissionScreenState();
}

class _StudentSubmissionScreenState extends State<StudentSubmissionScreen> {
  late Map<String, dynamic> _hw;
  bool _initialized = false;

  List<Map<String, dynamic>> _all = [];
  bool _loading = true;

  final TextEditingController _searchCtrl = TextEditingController();
  int _filterIndex = 0;

  static const _filters = [
    'ទាំងអស់',
    'មិនទាន់បញ្ជូន',
    'បានបញ្ជូន',
  ];

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
    if (mounted) setState(() => _loading = true);
    final homeworkId = _hw['id'] as int?;
    final classId = _hw['class_id'] as int?;
    if (homeworkId == null || classId == null) {
      if (mounted) setState(() => _loading = false);
      return;
    }
    final result = await HomeworkRepo().getStudentsWithSubmissionStatus(
      homeworkId: homeworkId,
      classId: classId,
    );
    if (mounted) {
      setState(() {
        _all = result;
        _loading = false;
      });
    }
  }

  Future<void> _toggle(Map<String, dynamic> student) async {
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

  List<Map<String, dynamic>> get _filtered {
    final query = _searchCtrl.text.trim().toLowerCase();
    return _all.where((s) {
      final submitted = (s['submitted'] as int? ?? 0) == 1;
      final matchFilter = _filterIndex == 0 ||
          (_filterIndex == 1 && !submitted) ||
          (_filterIndex == 2 && submitted);
      final name =
          '${s['first_name'] ?? ''} ${s['last_name'] ?? ''}'.toLowerCase();
      final matchSearch = query.isEmpty || name.contains(query);
      return matchFilter && matchSearch;
    }).toList();
  }

  String get _hwTitle => _hw['title'] as String? ?? 'ពិនិត្យកិច្ចការផ្ទះ';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundLight,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          color: AppColors.primaryText,
        ),
        centerTitle: true,
        title: Text('ពិនិត្យកិច្ចការ', style: AppTextStyle.sectionTitle20),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(AppNumber.radiusMedium),
                  ),
                  child: TextField(
                    controller: _searchCtrl,
                    onChanged: (_) => setState(() {}),
                    style: AppTextStyle.body14,
                    decoration: InputDecoration(
                      hintText: 'ស្វែងរកឈ្មោះសិស្ស...',
                      hintStyle: AppTextStyle.body14
                          .copyWith(color: AppColors.secondaryText),
                      prefixIcon: Icon(Icons.search,
                          color: AppColors.secondaryText, size: 20),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: List.generate(
                    _filters.length,
                    (i) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: _FilterChip(
                        label: _filters[i],
                        selected: _filterIndex == i,
                        onTap: () => setState(() => _filterIndex = i),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : filtered.isEmpty
                    ? Center(
                        child: Text('មិនមានទិន្នន័យ',
                            style: AppTextStyle.bodySecondary),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                        itemCount: filtered.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (_, i) {
                          final s = filtered[i];
                          final submitted = (s['submitted'] as int? ?? 0) == 1;
                          final name =
                              '${s['first_name'] ?? ''} ${s['last_name'] ?? ''}'
                                  .trim();
                          final submittedAt =
                              s['submitted_at'] as String? ?? '';
                          return _StudentCard(
                            name: name,
                            submitted: submitted,
                            submittedAt: submittedAt,
                            hwTitle: _hwTitle,
                            onToggle: () => _toggle(s),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _FilterChip(
      {required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryMain : AppColors.white,
          borderRadius: BorderRadius.circular(AppNumber.radiusPill),
          border: selected
              ? null
              : Border.all(color: AppColors.lightgrey, width: 1.2),
        ),
        child: Text(
          label,
          style: AppTextStyle.body14.copyWith(
            color: selected ? AppColors.white : AppColors.secondaryText,
            fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

class _StudentCard extends StatelessWidget {
  final String name;
  final String hwTitle;
  final bool submitted;
  final String submittedAt;
  final VoidCallback onToggle;

  const _StudentCard({
    required this.name,
    required this.hwTitle,
    required this.submitted,
    required this.submittedAt,
    required this.onToggle,
  });

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
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppNumber.radiusLarge),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryText.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: AppColors.primaryMain.withValues(alpha: 0.15),
                child: Icon(Icons.person_outline,
                    color: AppColors.primaryMain, size: 28),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(name, style: AppTextStyle.subtitle16),
              ),
              _statusBadge(),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFF0F0F0)),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hwTitle,
                      style: AppTextStyle.subtitle16
                          .copyWith(color: AppColors.primaryMain),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Icon(Icons.access_time_rounded,
                            size: 13, color: AppColors.secondaryText),
                        const SizedBox(width: 4),
                        Text(
                          submitted && submittedAt.isNotEmpty
                              ? _formatTime(submittedAt)
                              : 'មិនទាន់ដាក់',
                          style: AppTextStyle.caption12Secondary.copyWith(
                            color: submitted
                                ? AppColors.secondaryText
                                : AppColors.error,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              submitted
                  ? OutlinedButton(
                      onPressed: onToggle,
                      style: OutlinedButton.styleFrom(
                        side:
                            BorderSide(color: AppColors.lightgrey, width: 1.2),
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(AppNumber.radiusMedium)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 10),
                        foregroundColor: AppColors.secondaryText,
                      ),
                      child: Text(
                        'មើលឡើងវិញ',
                        style: AppTextStyle.body14
                            .copyWith(color: AppColors.secondaryText),
                      ),
                    )
                  : ElevatedButton.icon(
                      onPressed: onToggle,
                      icon: const Icon(Icons.grading_outlined,
                          size: 15, color: Colors.white),
                      label: Text(
                        'ដាក់ពិន្ទុ',
                        style: AppTextStyle.body14
                            .copyWith(color: AppColors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryMain,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(AppNumber.radiusMedium)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                      ),
                    ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statusBadge() {
    if (submitted) {
      return _badge(
        icon: Icons.check_circle_rounded,
        label: 'ទាន់ពេល',
        color: AppColors.success,
        bg: AppColors.success.withValues(alpha: 0.1),
      );
    }
    return _badge(
      icon: Icons.radio_button_unchecked_rounded,
      label: 'មិនទាន់បញ្ចូន',
      color: AppColors.secondaryText,
      bg: AppColors.lightgrey,
    );
  }

  Widget _badge({
    required IconData icon,
    required String label,
    required Color color,
    required Color bg,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
          color: bg, borderRadius: BorderRadius.circular(AppNumber.radiusPill)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 4),
          Text(label,
              style: AppTextStyle.caption12Secondary
                  .copyWith(color: color, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
