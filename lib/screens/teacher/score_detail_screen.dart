import 'package:flutter/material.dart';
import 'package:tamdansers_app/constants/app_colors.dart';
import 'package:tamdansers_app/constants/app_number.dart';
import 'package:tamdansers_app/constants/text_style.dart';

class ScoreDetailScreen extends StatelessWidget {
  const ScoreDetailScreen({super.key});

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
        title: Column(
          children: [
            Text("តារាងពិន្ទុលម្អិត", style: AppTextStyle.screenTitle24),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              children: [
                _buildSubjectItem(
                    "ភាសាខ្មែរ", "95", "ល្អណាស់", AppColors.primaryMain),
                _buildSubjectItem(
                    "គណិតវិទ្យា", "98", "ល្អណាស់", AppColors.primaryMain),
                _buildSubjectItem(
                    "ប្រវត្តិវិទ្យា", "76", "ល្អ", AppColors.purple),
                _buildSubjectItem(
                    "ភាសាអង់គ្លេស", "87", "ល្អ", AppColors.success),
                _buildSubjectItem("រូបវិទ្យា", "86", "ល្អ", AppColors.success),
                _buildSubjectItem("គីមីវិទ្យា", "89", "ល្អ", AppColors.success),
                _buildSubjectItem("ជីវវិទ្យា", "64", "ល្អ", AppColors.orange),
              ],
            ),
          ),
          _buildSummarySection(),
        ],
      ),
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

  Widget _buildSummarySection() {
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
              Text("សេចក្តីសង្ខេបប្រចាំខែ",
                  style: AppTextStyle.bodyWhite
                      .copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _summaryItem("ពិន្ទុសរុប", "៦៣៩"),
              _summaryItem("មធ្យមភាគ", "៩១.២"),
              _summaryItem("ចំណាត់ថ្នាក់", "០២"),
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
