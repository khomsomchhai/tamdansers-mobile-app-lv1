import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tamdansers_app/constants/app_colors.dart';
import 'package:tamdansers_app/constants/app_icon.dart';
import 'package:tamdansers_app/constants/text_style.dart';
import 'package:tamdansers_app/repositories/class_repo.dart';
import 'package:tamdansers_app/repositories/score_repo.dart';
import 'package:tamdansers_app/repositories/student_class_repo.dart';

class Result extends StatefulWidget {
  final int? studentClassId;
  final int? classId;
  const Result({super.key, this.studentClassId, this.classId});

  @override
  State<Result> createState() => _ResultState();
}

class _ResultState extends State<Result> {
  int selectIndex = 2;
  bool _loading = true;

  Map<String, dynamic> _student = {};
  String? _className;
  String? _photoPath;
  
  List<Map<String, dynamic>> _scores = [];
  int _rank = 0;

  final ScoreRepo _scoreRepo = ScoreRepo();
  final StudentClassRepo _studentClassRepo = StudentClassRepo();
  final ClassRepo _classRepo = ClassRepo();

  @override
  void initState() {
    super.initState();
    _loadScoreData();
  }

  Future<void> _loadScoreData() async {
    try {
      setState(() => _loading = true);
      
      if (widget.studentClassId == null || widget.classId == null) {
        setState(() => _loading = false);
        return;
      }
      final studentData = await _studentClassRepo.getStudentById(widget.studentClassId!);
      
      if (studentData != null) {
        final classData = await _classRepo.getClassById(widget.classId!);
        
        setState(() {
          _student = studentData;
          _className = classData?['name'] ?? 'មិនបានកំណត់';
          _photoPath = studentData['photo_path'] as String?;
          _loading = false;
        });
        
        await _loadScores();
      } else {
        setState(() => _loading = false);
      }
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  Future<void> _loadScores() async {
    try {
      if (widget.studentClassId == null || widget.classId == null) return;

      final scores = await _scoreRepo.getScoresByStudent(widget.studentClassId!);
      final rank = await _scoreRepo.getRankInClass(widget.studentClassId!, widget.classId!);
      
      if (mounted) {
        setState(() {
          _scores = scores;
          _rank = rank;
        });
      }
    } catch (e) {
      debugPrint("Error loading scores: $e");
    }
  }



  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        appBar: AppBar(
          title: Text('លទ្ធផល', style: AppTextStyle.sectionTitle20),
          centerTitle: true,
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final filteredScores = _filterScoresByMonth(_scores, selectIndex + 1);
    final total = filteredScores.isEmpty ? 0.0 : filteredScores.fold(0.0, (sum, s) => sum + ((s['score'] as num).toDouble()));
    final average = filteredScores.isEmpty ? 0.0 : total / filteredScores.length;
    return Scaffold(
        appBar: AppBar(
          title: Text('លទ្ធផល', style: AppTextStyle.sectionTitle20),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                _buildMonthTabBar(),
                SizedBox(height: 20),
                _buildSummaryCard(total, average),
                SizedBox(height: 20),
                if (filteredScores.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        'មិនមានទិន្នន័យពិន្ទុ',
                        style: AppTextStyle.body.copyWith(
                          color: AppColors.secondaryText,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                else
                  ListView.separated(
                    separatorBuilder: (context, index) => SizedBox(height: 10),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: filteredScores.length,
                    itemBuilder: (context, index) {
                      final score = filteredScores[index];
                      return _buildScoreItem(score);
                    },
                  )
              ],
            ),
          ),
        ));
  }

  Widget _buildMonthTabBar() {
    List<String> months = [
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
    
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        separatorBuilder: (context, index) => SizedBox(width: 10),
        itemCount: 12,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                selectIndex = index;
              });
            },
            child: Container(
              height: 30,
              width: 100,
              decoration: BoxDecoration(
                color: index == selectIndex
                    ? AppColors.primaryMain
                    : AppColors.primaryBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  months[index],
                  style: AppTextStyle.subtitle16.copyWith(
                    color: index == selectIndex
                        ? AppColors.white
                        : AppColors.secondaryText,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSummaryCard(double total, double average) {
    return Container(
      padding: EdgeInsets.all(20),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.primaryMain,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Container(
            height: 80,
            width: 80,
            decoration: BoxDecoration(shape: BoxShape.circle),
            clipBehavior: Clip.antiAlias,
            child: _photoPath != null && _photoPath!.isNotEmpty
                ? Image.file(File(_photoPath!), fit: BoxFit.cover)
                : Image.asset(AppIcon.maleAvatar, fit: BoxFit.cover),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Text('ពិន្ទុសរុប',
                      style: AppTextStyle.subtitle16.copyWith(color: AppColors.white)),
                  SizedBox(height: 10),
                  Text(total.toStringAsFixed(1),
                      style: AppTextStyle.sectionTitle20.copyWith(color: AppColors.white, fontWeight: FontWeight.w600)),
                ],
              ),
              Container(height: 60, width: 2, color: AppColors.white),
              Column(
                children: [
                  Text('ចំណាត់ថ្នាក់',
                      style: AppTextStyle.subtitle16.copyWith(color: AppColors.white)),
                  SizedBox(height: 10),
                  Text('#$_rank',
                      style: AppTextStyle.sectionTitle20.copyWith(color: AppColors.white, fontWeight: FontWeight.w600)),
                ],
              ),
              Container(height: 60, width: 2, color: AppColors.white),
              Column(
                children: [
                  Text('មធ្យមភាគ',
                      style: AppTextStyle.subtitle16.copyWith(color: AppColors.white)),
                  SizedBox(height: 10),
                  Text(average.toStringAsFixed(2),
                      style: AppTextStyle.sectionTitle20.copyWith(color: AppColors.white, fontWeight: FontWeight.w600)),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildScoreItem(Map<String, dynamic> scoreData) {
    final subject = scoreData['subject'] as String;
    final scoreValue = (scoreData['score'] as num).toDouble();
    final color = _getScoreColor(scoreValue);
    
    return Container(
      padding: EdgeInsets.all(18),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color, width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10),
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
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(subject, style: AppTextStyle.subtitle16),
                SizedBox(height: 5),
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
          SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(scoreValue.toStringAsFixed(0),
                  style: AppTextStyle.sectionTitle20.copyWith(
                      color: color, fontWeight: FontWeight.bold)),
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
    if (score >= 80) return Color(0xFF8BC34A);
    if (score >= 70) return Color(0xFFFFC107);
    if (score >= 60) return Color(0xFFFF9800);
    return Color(0xFFF44336);
  }

  String _getScoreGrade(double score) {
    if (score >= 90) return 'ល្អណាស់';
    if (score >= 80) return 'ល្អ';
    if (score >= 70) return 'ល្អ';
    if (score >= 60) return 'មធ្យម';
    return 'ខ្សោយ';
  }

  List<Map<String, dynamic>> _filterScoresByMonth(
      List<Map<String, dynamic>> scores, int month) {
    return scores.where((score) {
      final createdAt = score['created_at'] as String?;
      if (createdAt == null) return false;
      try {
        final date = DateTime.parse(createdAt);
        return date.month == month;
      } catch (e) {
        return false;
      }
    }).toList();
  }
}

