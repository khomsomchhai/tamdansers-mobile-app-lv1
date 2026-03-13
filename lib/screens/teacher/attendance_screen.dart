// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tamdansers_app/constants/app_animation.dart';
import 'package:tamdansers_app/constants/app_colors.dart';
import 'package:tamdansers_app/constants/app_number.dart';
import 'package:tamdansers_app/constants/text_style.dart';
import 'package:tamdansers_app/repositories/activity_repo.dart';
import 'package:tamdansers_app/repositories/attendance_repo.dart';
import 'package:tamdansers_app/repositories/class_repo.dart';

class AttendanceScreen extends StatefulWidget {
  final int? classId;
  const AttendanceScreen({super.key, this.classId});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  int? _classId;
  bool _loading = true;
  String _selectedDate = '';
  List<String> _dates = [];
  List<Map<String, dynamic>> _students = [];
  List<Map<String, dynamic>> _allClasses = [];
  Map<String, int> _summary = {
    'present': 0,
    'absent': 0,
    'late': 0,
    'total': 0,
  };
  String _className = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_classId == null && _allClasses.isEmpty) {
      final arg =
          widget.classId ?? ModalRoute.of(context)?.settings.arguments as int?;
      if (arg != null) {
        _classId = arg;
        _initDateAndLoad();
      } else {
        // No classId provided — load class list for picker
        _loadAllClasses();
      }
    }
  }

  Future<void> _loadAllClasses() async {
    final classes = await ClassRepo().getClassesByTeacher((await SharedPreferences.getInstance()).getInt('userId') ?? 1);
    if (mounted) {
      setState(() {
        _allClasses = classes;
        _loading = false;
      });
    }
  }

  Future<void> _initDateAndLoad() async {
    final today = DateTime.now();
    final todayStr =
        '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
    final pastDates = await AttendanceRepo().getDistinctDates(_classId!);
    final dateSet = <String>{todayStr, ...pastDates};
    final sortedDates = dateSet.toList()..sort((a, b) => b.compareTo(a));
    final cls = await ClassRepo().getClassById(_classId!);
    if (mounted) {
      setState(() {
        _dates = sortedDates;
        _selectedDate = todayStr;
        _className = cls != null
            ? '${cls["name"]} • ថ្នាក់ ${cls["grade"]}-${cls["section"]}'
            : '';
      });
    }
    await _loadData();
  }

  Future<void> _loadData() async {
    if (_classId == null || _selectedDate.isEmpty) return;
    if (mounted) setState(() => _loading = true);
    final students = await AttendanceRepo()
        .getAttendanceWithStudents(_classId!, _selectedDate);
    final summary =
        await AttendanceRepo().getAttendanceSummary(_classId!, _selectedDate);
    if (mounted) {
      setState(() {
        _students = students.map((s) => Map<String, dynamic>.from(s)).toList();
        _summary = summary;
        _loading = false;
      });
    }
  }

  void _markAllPresent() {
    if (_students.isEmpty) return;
    setState(() {
      for (final s in _students) {
        s['status'] = 'present';
      }
      _summary = {
        'present': _students.length,
        'absent': 0,
        'late': 0,
        'total': _students.length,
      };
    });
  }

  Future<void> _submitAttendance() async {
    if (_classId == null || _selectedDate.isEmpty || _students.isEmpty) return;

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: AppColors.backgroundLight,
            borderRadius: BorderRadius.circular(AppNumber.radiusLarge),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset(
                AppAnimations.loading,
                width: 100,
                height: 100,
              ),
              const SizedBox(height: 12),
              Text('កំពុងរក្សាទុក...', style: AppTextStyle.subtitle16),
            ],
          ),
        ),
      ),
    );

    // Save records
    final repo = AttendanceRepo();
    for (final s in _students) {
      await repo.saveAttendance(
        classId: _classId!,
        studentId: s['student_id'] as int,
        date: _selectedDate,
        status: s['status'] as String,
      );
    }
    await ActivityRepo().logActivity(
      teacherId: (await SharedPreferences.getInstance()).getInt('userId') ?? 1,
      activityType: 'attendance',
      title: 'វត្តមានត្រូវបានកត់ត្រា',
      subtitle: '$_className · $_selectedDate',
    );

    if (!mounted) return;

    // Close loading dialog
    Navigator.of(context, rootNavigator: true).pop();

    // Show success dialog
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: AppColors.backgroundLight,
            borderRadius: BorderRadius.circular(AppNumber.radiusLarge),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset(
                AppAnimations.successful,
                width: 140,
                height: 140,
                repeat: false,
              ),
              const SizedBox(height: 8),
              Text(
                'រៀបរាល់!',
                style: AppTextStyle.sectionTitle20
                    .copyWith(color: AppColors.success),
              ),
              const SizedBox(height: 8),
              Text(
                'វត្តមានត្រូវបានរក្សាទុក។',
                style: AppTextStyle.body14,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryMain,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppNumber.radiusMedium),
                    ),
                  ),
                  child: Text(
                    'ត្រលប់',
                    style: AppTextStyle.buttonText18White,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    // Navigate back after dialog is dismissed
    if (mounted) Navigator.of(context).pop();
  }

  void _recalcSummary() {
    int present = 0, absent = 0, late = 0;
    for (final s in _students) {
      switch (s['status']) {
        case 'present':
          present++;
          break;
        case 'absent':
          absent++;
          break;
        case 'late':
          late++;
          break;
      }
    }
    _summary = {
      'present': present,
      'absent': absent,
      'late': late,
      'total': _students.length,
    };
  }

  String _formatDateLabel(String isoDate) {
    final now = DateTime.now();
    final todayStr =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    if (isoDate == todayStr) return 'ថ្ងៃនេះ';
    final parts = isoDate.split('-');
    if (parts.length == 3) return '${parts[2]}/${parts[1]}';
    return isoDate;
  }

  @override
  Widget build(BuildContext context) {
    final bool inClassPicker = _classId == null && widget.classId == null;
    final bool pickedFromDashboard = _classId != null && widget.classId == null;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            if (pickedFromDashboard) {
              // Go back to class picker
              setState(() {
                _classId = null;
                _students = [];
                _dates = [];
                _selectedDate = '';
                _loading = false;
              });
            } else {
              Navigator.pop(context);
            }
          },
          icon: Icon(Icons.arrow_back_ios_new_rounded,
              color: AppColors.primaryText),
        ),
        title: Text(
          inClassPicker ? 'វត្តមាន' : 'វត្តមាន',
          style: AppTextStyle.fontsize18,
        ),
        centerTitle: true,
        actions: [
          if (!inClassPicker)
            IconButton(
              icon: Icon(Icons.calendar_today, color: AppColors.primaryText),
              onPressed: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                );
                if (picked != null && mounted) {
                  final ds =
                      '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
                  setState(() {
                    if (!_dates.contains(ds)) _dates.insert(0, ds);
                    _selectedDate = ds;
                  });
                  await _loadData();
                }
              },
            ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _classId == null
              ? _buildClassPicker()
              : Column(
                  children: [
                    Container(
                      color: AppColors.white,
                      padding: const EdgeInsets.only(top: 8),
                      child: Column(
                        children: [
                          _buildDateFilter(),
                          SizedBox(height: 16),
                          _buildStatsCard(),
                          SizedBox(height: 12),
                          _buildMarkAllButton(),
                          SizedBox(height: 12),
                        ],
                      ),
                    ),
                    Expanded(
                      child: _students.isEmpty
                          ? Center(
                              child: Text('មិនមានសិស្សក្នុងថ្នាក់',
                                  style: AppTextStyle.body),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.all(16),
                              itemCount: _students.length,
                              itemBuilder: (context, index) {
                                final s = _students[index];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: _buildStudentCard(
                                    '${s["first_name"]} ${s["last_name"]}',
                                    s['student_id'].toString(),
                                    s['status'] as String,
                                    s['status'] == 'absent' ||
                                        s['status'] == 'late',
                                    s['photo_path'] as String?,
                                    index,
                                  ),
                                );
                              },
                            ),
                    ),
                    _buildSubmitButton(),
                  ],
                ),
    );
  }

  Widget _buildClassPicker() {
    // rotating accent colors for class cards
    final cardColors = [
      AppColors.primaryMain,
      AppColors.purple,
      AppColors.orange,
      AppColors.success,
      const Color(0xFF00BCD4),
      const Color(0xFFE91E63),
    ];

    final now = DateTime.now();
    final months = [
      'មករា',
      'កុម្ភៈ',
      'មីនា',
      'មេសា',
      'ឧសភា',
      'មិថុនា',
      'កក្កដា',
      'សីហា',
      'កញ្ញា',
      'តុលា',
      'វិច្ឆិកា',
      'ធ្នូ'
    ];
    final dateStr = '${now.day} ${months[now.month - 1]} ${now.year}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Hero header ─────────────────────────────────────────
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 52),
              decoration: const BoxDecoration(
                color: AppColors.primaryMain,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.how_to_reg_rounded,
                            color: Colors.white, size: 28),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('ជ្រើសរើសថ្នាក់',
                              style: AppTextStyle.sectionTitle20
                                  .copyWith(color: Colors.white)),
                          const SizedBox(height: 2),
                          Text(dateStr,
                              style: AppTextStyle.body14.copyWith(
                                  color: Colors.white.withValues(alpha: 0.8))),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // wave clip at bottom
            Positioned(
              bottom: -1,
              left: 0,
              right: 0,
              child: Container(
                height: 32,
                decoration: const BoxDecoration(
                  color: AppColors.backgroundLight,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                ),
              ),
            ),
          ],
        ),
        // ── Class count label ────────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
          child: Row(
            children: [
              Text('ថ្នាក់ទាំងអស់', style: AppTextStyle.sectionTitle20),
              const SizedBox(width: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.primaryBg,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text('${_allClasses.length}',
                    style: AppTextStyle.subtitle16
                        .copyWith(color: AppColors.primaryMain)),
              ),
            ],
          ),
        ),
        // ── Class cards ──────────────────────────────────────────
        if (_allClasses.isEmpty)
          Expanded(
            child: Center(
              child: Text('មិនមានថ្នាក់', style: AppTextStyle.bodySecondary),
            ),
          ),
        if (_allClasses.isNotEmpty)
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              itemCount: _allClasses.length,
              itemBuilder: (context, i) {
                final cls = _allClasses[i];
                final accent = cardColors[i % cardColors.length];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _classId = cls['id'] as int;
                      _loading = true;
                    });
                    _initDateAndLoad();
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 14),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius:
                          BorderRadius.circular(AppNumber.radiusLarge),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryText.withValues(alpha: 0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // colored left accent bar
                        Container(
                          width: 6,
                          height: 76,
                          decoration: BoxDecoration(
                            color: accent,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(AppNumber.radiusLarge),
                              bottomLeft:
                                  Radius.circular(AppNumber.radiusLarge),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        // icon box
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: accent.withValues(alpha: 0.12),
                            borderRadius:
                                BorderRadius.circular(AppNumber.radiusMedium),
                          ),
                          child: Icon(Icons.menu_book_rounded,
                              color: accent, size: 24),
                        ),
                        const SizedBox(width: 14),
                        // text
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(cls['name'] as String? ?? '',
                                  style: AppTextStyle.subtitle16),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: accent.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      '${cls['grade']}-${cls['section']}',
                                      style: AppTextStyle.body14
                                          .copyWith(color: accent),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: Icon(Icons.arrow_forward_ios_rounded,
                              size: 14, color: AppColors.secondaryText),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildDateFilter() {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _dates.length,
        itemBuilder: (context, index) {
          final date = _dates[index];
          final isSelected = _selectedDate == date;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(_formatDateLabel(date)),
              selected: isSelected,
              onSelected: (selected) async {
                setState(() => _selectedDate = date);
                await _loadData();
              },
              labelStyle: AppTextStyle.body14.copyWith(
                color: isSelected ? AppColors.white : AppColors.primaryText,
              ),
              backgroundColor: AppColors.backgroundLight,
              selectedColor: AppColors.primaryMain,
              showCheckmark: false,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppNumber.radiusRounded),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatsCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(AppNumber.radiusMedium),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _className.isEmpty ? 'ថ្នាក់' : _className,
            style: AppTextStyle.subtitle18,
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                  '${_summary["total"] ?? 0}', 'សរុប', AppColors.primaryText),
              _buildStatItem(
                  '${_summary["present"] ?? 0}', 'មក', AppColors.success),
              _buildStatItem(
                  '${_summary["absent"] ?? 0}', 'អវត្តមាន', AppColors.error),
              _buildStatItem(
                  '${_summary["late"] ?? 0}', 'យឺត', Color(0xFFFFA726)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: AppTextStyle.stat32Bold.copyWith(
            color: color,
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: AppTextStyle.caption14Secondary,
        ),
      ],
    );
  }

  Widget _buildMarkAllButton() {
    return GestureDetector(
      onTap: _markAllPresent,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Color(0xFFE3F2FD),
          borderRadius: BorderRadius.circular(AppNumber.radiusSmall),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle, color: AppColors.primaryMain, size: 20),
            SizedBox(width: 8),
            Text(
              "កំណត់សិស្សមកទាំងអស់",
              style: AppTextStyle.buttonText15Primary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStudentCard(String name, String id, String status,
      bool hasNotification, String? imagePath, int index) {
    Color statusColor;
    Color statusBgColor;

    switch (status) {
      case "present":
        statusColor = AppColors.success;
        statusBgColor = Color(0xFFE8F5E9);
        break;
      case "absent":
        statusColor = AppColors.error;
        statusBgColor = Color(0xFFFFEBEE);
        break;
      case "late":
        statusColor = Color(0xFFFFA726);
        statusBgColor = Color(0xFFFFF3E0);
        break;
      default:
        statusColor = AppColors.secondaryText;
        statusBgColor = AppColors.backgroundLight;
    }

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppNumber.radiusMedium),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundImage: imagePath != null && File(imagePath).existsSync()
                    ? FileImage(File(imagePath))
                    : null,
                backgroundColor: status == "present"
                    ? Color(0xFFE8F5E9)
                    : status == "absent"
                        ? Color(0xFFFFEBEE)
                        : Color(0xFFFFF3E0),
                child: imagePath == null || !File(imagePath).existsSync()
                    ? Text(
                        name.isNotEmpty
                            ? name.substring(0, 1).toUpperCase()
                            : '?',
                        style: AppTextStyle.fontsize18.copyWith(
                          color: statusColor,
                        ),
                      )
                    : null,
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: AppTextStyle.fontsize18),
                    SizedBox(height: 2),
                    Text(
                      "ID: $id",
                      style: AppTextStyle.caption13Secondary,
                    ),
                  ],
                ),
              ),
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: statusBgColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  status == "absent"
                      ? Icons.close
                      : status == "late"
                          ? Icons.access_time
                          : Icons.check,
                  color: statusColor,
                  size: 20,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _students[index]["status"] = "present";
                      _students[index]["notify_parent"] = false;
                      _recalcSummary();
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: status == "present"
                          ? AppColors.primaryMain
                          : AppColors.secondaryText.withValues(alpha: 0.3),
                    ),
                    backgroundColor:
                        status == "present" ? Color(0xFFE3F2FD) : null,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppNumber.radiusSmall),
                    ),
                  ),
                  child: Text(
                    "មក",
                    style: AppTextStyle.body14.copyWith(
                      color: status == "present"
                          ? AppColors.primaryMain
                          : AppColors.primaryText,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _students[index]["status"] = "absent";
                      if (_students[index]["notify_parent"] == null) {
                        _students[index]["notify_parent"] = true;
                      }
                      _recalcSummary();
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: status == "absent"
                        ? AppColors.error
                        : AppColors.backgroundLight,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppNumber.radiusSmall),
                    ),
                  ),
                  child: Text(
                    "អវត្តមាន",
                    style: AppTextStyle.body14.copyWith(
                      color: status == "absent"
                          ? AppColors.white
                          : AppColors.primaryText,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _students[index]["status"] = "late";
                      if (_students[index]["notify_parent"] == null) {
                        _students[index]["notify_parent"] = true;
                      }
                      _recalcSummary();
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: status == "late"
                        ? Color(0xFFFFA726)
                        : AppColors.backgroundLight,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppNumber.radiusSmall),
                    ),
                  ),
                  child: Text(
                    "យឺត",
                    style: AppTextStyle.body14.copyWith(
                      color: status == "late"
                          ? AppColors.white
                          : AppColors.primaryText,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (hasNotification)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Row(
                children: [
                  Icon(Icons.notifications_none,
                      color: AppColors.secondaryText, size: 20),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "ជូនដំណឹងដល់មាតាបិតា",
                      style: AppTextStyle.caption13Secondary,
                    ),
                  ),
                  Switch(
                    value: _students[index]["notify_parent"] as bool? ?? true,
                    onChanged: (value) {
                      setState(() {
                        _students[index]["notify_parent"] = value;
                      });
                    },
                    activeColor: AppColors.primaryMain,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _submitAttendance,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryMain,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppNumber.radiusMedium),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.save_outlined, color: AppColors.white, size: 22),
            SizedBox(width: 8),
            Text(
              "បញ្ជូនវត្តមាន",
              style: AppTextStyle.buttonText18White,
            ),
          ],
        ),
      ),
    );
  }
}
