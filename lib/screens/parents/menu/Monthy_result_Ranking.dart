import 'dart:io' as io;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tamdansers_app/constants/app_colors.dart';
import 'package:tamdansers_app/constants/app_icon.dart';
import 'package:tamdansers_app/constants/app_number.dart';
import 'package:tamdansers_app/constants/text_style.dart';
import 'package:tamdansers_app/repositories/class_repo.dart';
import 'package:tamdansers_app/repositories/score_repo.dart';
import 'package:tamdansers_app/repositories/student_class_repo.dart';

class CustomScreen extends StatefulWidget {
  final int? studentClassId;
  final int? classId;
  
  const CustomScreen({super.key, this.studentClassId, this.classId});

  @override
  State<CustomScreen> createState() => _CustomScreenState();
}

class _CustomScreenState extends State<CustomScreen> {
  int _currentMonthIndex = 0;
  bool _isLoading = true;

  Map<String, dynamic> _student = {};
  String? _className;
  String? _photoPath;
  double _totalScore = 0;
  double _average = 0;
  int _rank = 0;
  List<Map<String, dynamic>> _records = [];

  final List<String> _months = [
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
    'ធ្នូ',
  ];

  final ScoreRepo _scoreRepo = ScoreRepo();
  final StudentClassRepo _studentClassRepo = StudentClassRepo();
  final ClassRepo _classRepo = ClassRepo();

  @override
  void initState() {
    super.initState();
    _currentMonthIndex = DateTime.now().month - 1;
    _loadScoreData();
  }

  Future<void> _loadScoreData() async {
    try {
      setState(() => _isLoading = true);
      
      if (widget.studentClassId == null || widget.classId == null) {
        setState(() => _isLoading = false);
        return;
      }

      final studentData = await _studentClassRepo.getStudentById(widget.studentClassId!);
      
      if (studentData != null) {
        final classData = await _classRepo.getClassById(widget.classId!);
        
        setState(() {
          _student = studentData;
          _className = classData?['name'] ?? 'មិនបានកំណត់';
          _photoPath = studentData['photo_path'] as String?;
          _isLoading = false;
        });
        
        await _loadMonthScores();
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loadMonthScores() async {
    try {
      if (widget.studentClassId == null || widget.classId == null) return;

      final scores = await _scoreRepo.getScoresByStudent(widget.studentClassId!);
      final rank = await _scoreRepo.getRankInClass(widget.studentClassId!, widget.classId!);

      final monthScores = scores.where((score) {
        final createdAt = score['created_at'] as String?;
        if (createdAt == null || createdAt.isEmpty) return false;
        try {
          final date = DateTime.parse(createdAt);
          return date.month == _currentMonthIndex + 1;
        } catch (e) {
          return false;
        }
      }).toList();

      double total = 0;
      for (var score in monthScores) {
        total += double.tryParse(score['score'].toString()) ?? 0;
      }

      double avg = monthScores.isEmpty ? 0 : total / monthScores.length;

      setState(() {
        _records = monthScores;
        _rank = rank;
        _totalScore = total;
        _average = avg;
      });
    } catch (e) {
      debugPrint('Error loading scores: $e');
    }
  }

  void _previousMonth() {
    if (_currentMonthIndex > 0) {
      setState(() => _currentMonthIndex--);
      _loadMonthScores();
    }
  }

  void _nextMonth() {
    if (_currentMonthIndex < 11) {
      setState(() => _currentMonthIndex++);
      _loadMonthScores();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppColors.backgroundLight,
        appBar: AppBar(
          backgroundColor: AppColors.backgroundLight,
          elevation: 0,
          scrolledUnderElevation: 0,
          title: Text('លទ្ធផល', style: AppTextStyle.sectionTitle20),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.primaryText),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundLight,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text('លទ្ធផល', style: AppTextStyle.sectionTitle20),
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Icon(Icons.notifications_sharp, color: AppColors.primaryText),
          ),
        ],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primaryText),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              _buildProfileHeader(),
              const SizedBox(height: 16),
              _buildMonthSelector(),
              const SizedBox(height: 16),
              _buildStatsRow(),
              const SizedBox(height: 20),
              Text("ពិន្ទុតាមមុខវិជ្ជា", style: AppTextStyle.subtitle18),
              const SizedBox(height: 12),
              _buildScoreList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    final student = _student;
    final photoPath = _photoPath;
    return Row(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primaryBg,
            border: Border.all(color: AppColors.primaryMain, width: 2),
          ),
          child: ClipOval(
            child: (photoPath != null && photoPath.isNotEmpty)
                ? Image.file(
                    io.File(photoPath),
                    fit: BoxFit.cover,
                  )
                : Image.asset(
                    student['gender'] == 'ប្រុស' || student['gender'] == 'male'
                        ? AppIcon.maleAvatar
                        : AppIcon.femaleAvatar,
                    fit: BoxFit.cover,
                  ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    '${student['first_name'] ?? ''} ${student['last_name'] ?? ''}',
                    style: AppTextStyle.subtitle18,
                  ),
                  const SizedBox(width: 4),
                  Icon(Icons.keyboard_arrow_down,
                      size: 20, color: AppColors.secondaryText),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                _className ?? '',
                style: AppTextStyle.caption13Secondary,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMonthSelector() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: _previousMonth,
              child: const Icon(Icons.chevron_left,
                  size: 28, color: AppColors.primaryText),
            ),
            const SizedBox(width: 8),
            Text(
              _months[_currentMonthIndex],
              style: AppTextStyle.subtitle18,
            ),
            const SizedBox(width: 6),
            Icon(Icons.calendar_today,
                size: 18, color: AppColors.secondaryText),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: _nextMonth,
              child: const Icon(Icons.chevron_right,
                  size: 28, color: AppColors.primaryText),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        _buildStatCard(
          icon: Icons.score,
          iconColor: AppColors.primaryMain,
          label: "សរុប",
          value: _totalScore.toStringAsFixed(0),
          unit: "ពិន្ទុ",
          bgColor: AppColors.primaryBg,
          valueBgColor: const Color(0xFFD6E9FF),
          valueColor: AppColors.primaryMain,
        ),
        const SizedBox(width: 10),
        _buildStatCard(
          icon: Icons.emoji_events,
          iconColor: const Color(0xFFFFB700),
          label: "ឋាន",
          value: _rank.toString(),
          unit: "ក្នុងក្រុម",
          bgColor: const Color(0xFFFFF3E0),
          valueBgColor: const Color(0xFFFFE0B2),
          valueColor: const Color(0xFFFFB700),
        ),
        const SizedBox(width: 10),
        _buildStatCard(
          icon: Icons.trending_up,
          iconColor: AppColors.success,
          label: "មធ្យម",
          value: _average.toStringAsFixed(1),
          unit: "ពិន្ទុ",
          bgColor: const Color(0xFFE8F5E9),
          valueBgColor: const Color(0xFFC8E6C9),
          valueColor: AppColors.success,
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
    required String unit,
    required Color bgColor,
    required Color valueBgColor,
    required Color valueColor,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(AppNumber.radiusMedium),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 16, color: iconColor),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    label,
                    style: GoogleFonts.kantumruyPro(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: iconColor,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: GoogleFonts.kantumruyPro(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: valueColor,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              unit,
              style: GoogleFonts.kantumruyPro(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: iconColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreList() {
    if (_records.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Center(
          child: Text(
            "គ្មានលទ្ធផលក្នុងខែនេះ",
            style: AppTextStyle.bodySecondary,
          ),
        ),
      );
    }

    return Column(
      children: List.generate(
        _records.length,
        (index) {
          if (index > 0) {
            return Column(
              children: [
                const SizedBox(height: 10),
                _buildScoreItem(_records[index]),
              ],
            );
          }
          return _buildScoreItem(_records[index]);
        },
      ),
    );
  }

  Widget _buildScoreItem(Map<String, dynamic> scoreData) {
    final subject = scoreData['subject'] as String? ?? 'មិនបានកំណត់';
    final scoreValue = double.tryParse(scoreData['score'].toString()) ?? 0;
    final color = _getScoreColor(scoreValue);
    
    return Container(
      padding: const EdgeInsets.all(18),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color, width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                subject.isNotEmpty ? subject[0] : '?',
                style: AppTextStyle.sectionTitle20.copyWith(color: color),
              ),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(subject, style: AppTextStyle.subtitle16),
                const SizedBox(height: 5),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    minHeight: 6,
                    value: scoreValue / 100,
                    backgroundColor: AppColors.primaryBg,
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                scoreValue.toStringAsFixed(0),
                style: AppTextStyle.sectionTitle20.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                _getScoreGrade(scoreValue),
                style: AppTextStyle.body.copyWith(color: color),
              )
            ],
          )
        ],
      ),
    );
  }

  Color _getScoreColor(double score) {
    if (score >= 90) return AppColors.primaryMain;
    if (score >= 80) return const Color(0xFF8BC34A);
    if (score >= 70) return const Color(0xFFFFC107);
    if (score >= 60) return const Color(0xFFFF9800);
    return const Color(0xFFF44336);
  }

  String _getScoreGrade(double score) {
    if (score >= 90) return 'ល្អណាស់';
    if (score >= 80) return 'ល្អ';
    if (score >= 70) return 'ល្អ';
    if (score >= 60) return 'មធ្យម';
    return 'ខ្សោយ';
  }
}