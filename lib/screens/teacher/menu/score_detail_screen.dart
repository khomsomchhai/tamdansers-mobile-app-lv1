import 'package:flutter/material.dart';
import 'package:tamdansers_app/constants/app_colors.dart';
import 'package:tamdansers_app/constants/app_number.dart';
import 'package:tamdansers_app/constants/text_style.dart';
import 'package:tamdansers_app/repositories/score_repo.dart';

class ScoreDetailScreen extends StatefulWidget {
  final int studentId;
  final int classId;
  const ScoreDetailScreen(
      {super.key, required this.studentId, required this.classId});

  @override
  State<ScoreDetailScreen> createState() => _ScoreDetailScreenState();
}

class _ScoreDetailScreenState extends State<ScoreDetailScreen> {
  List<Map<String, dynamic>> _scores = [];
  int _rank = 0;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadScores();
  }

  Future<void> _loadScores() async {
    final scores =
        await ScoreRepo().getScoresByStudent(widget.studentId);
    final rank =
        await ScoreRepo().getRankInClass(widget.studentId, widget.classId);
    setState(() {
      _scores = scores;
      _rank = rank;
      _loading = false;
    });
  }

  double get _total =>
      _scores.fold(0.0, (sum, s) => sum + (s['score'] as num).toDouble());

  double get _average => _scores.isEmpty ? 0 : _total / _scores.length;

  String _toKhmerDigits(String s) {
    const map = {'0': '០','1': '១','2': '២','3': '៣','4': '៤',
                 '5': '៥','6': '៦','7': '៧','8': '៨','9': '៩'};
    return s.split('').map((c) => map[c] ?? c).join();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: AppColors.primaryText),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text('តារាងពិន្ទុលម្អិត', style: AppTextStyle.screenTitle24),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: _scores.isEmpty
                      ? Center(
                          child: Text('មិនទាន់មានពិន្ទុ',
                              style: AppTextStyle.bodySecondary))
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          itemCount: _scores.length,
                          itemBuilder: (context, index) {
                            final s = _scores[index];
                            final score =
                                (s['score'] as num).toDouble();
                            final label = _gradeLabel(score);
                            final color = _gradeColor(score);
                            return _buildSubjectItem(
                                s['subject'] as String,
                                score.toStringAsFixed(0),
                                label,
                                color);
                          },
                        ),
                ),
                if (_scores.isNotEmpty) _buildSummarySection(),
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

  Widget _buildSummarySection() {
    final totalStr = _toKhmerDigits(_total.toStringAsFixed(0));
    final avgStr = _toKhmerDigits(_average.toStringAsFixed(1));
    final rankStr = _rank > 0 ? _toKhmerDigits(_rank.toString().padLeft(2, '0')) : '—';
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
      decoration: const BoxDecoration(
        color: AppColors.primaryMain,
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(AppNumber.radiusPill)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.bar_chart_rounded,
                  color: AppColors.white, size: 20),
              const SizedBox(width: 8),
              Text('សេចក្តីសង្ខេបប្រចាំខែ',
                  style: AppTextStyle.bodyWhite
                      .copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _summaryItem('ពិន្ទុសរុប', totalStr),
              _summaryItem('មធ្យមភាគ', avgStr),
              _summaryItem('ចំណាត់ថ្នាក់', rankStr),
            ],
          ),
        ],
      ),
    );
  }

  Widget _summaryItem(String label, String value) {
    return Container(
      width: 105,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(AppNumber.radiusRounded),
        border: Border.all(color: AppColors.white.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Text(label,
              style:
                  AppTextStyle.caption12White.copyWith(color: AppColors.white)),
          const SizedBox(height: 4),
          Text(value,
              style: AppTextStyle.subtitle18.copyWith(color: AppColors.white)),
        ],
      ),
    );
  }
}
