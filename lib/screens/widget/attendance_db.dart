// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:tamdansers_app/constants/app_colors.dart';
import 'package:tamdansers_app/constants/text_style.dart';

class CardAttendance extends StatelessWidget {
  final int totalDays;
  final int presentDays;
  final int absentDays;
  final double attendanceRate;
  final String? monthLabel; // ✅ បន្ថែម

  const CardAttendance({
    super.key,
    required this.totalDays,
    required this.presentDays,
    required this.absentDays,
    required this.attendanceRate,
     this.monthLabel, // ✅ required
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryMain,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded( // ✅ ការពារ overflow
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'វត្តមានប្រចាំខែ $monthLabel',
                  style: AppTextStyle.body.copyWith(
                    color: AppColors.white,
                  ),
                ),
                Text(
                  '${attendanceRate.toStringAsFixed(0)}%',
                  style: AppTextStyle.title28.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildBadge(
                      'វត្តមាន $presentDays',
                      AppColors.success,
                    ),
                    const SizedBox(width: 10),
                    _buildBadge(
                      'អវត្តមាន $absentDays',
                      AppColors.error,
                    ),
                  ],
                ),
              ],
            ),
          ),
          _buildProgress(),
        ],
      ),
    );
  }

  Widget _buildBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: AppTextStyle.body.copyWith(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildProgress() {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          height: 60,
          width: 60,
          child: CircularProgressIndicator(
            value: attendanceRate / 100,
            strokeWidth: 8,
            color: AppColors.white,
            backgroundColor:
                AppColors.white.withValues(alpha: 0.2),
            strokeCap: StrokeCap.round,
          ),
        ),
        Icon(
          attendanceRate >= 70
              ? Icons.check_circle
              : Icons.warning_amber_rounded,
          size: 20,
          color: AppColors.white,
        ),
      ],
    );
  }
}