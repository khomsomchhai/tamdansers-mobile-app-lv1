import 'package:flutter/material.dart';
import 'package:tamdansers_app/constants/app_colors.dart';
import 'package:tamdansers_app/constants/app_number.dart';
import 'package:tamdansers_app/constants/text_style.dart';
import 'package:tamdansers_app/screens/teacher/link_parent_bottom_sheet.dart';
import 'package:tamdansers_app/widget/search_field.dart';

class LinkParentScreen extends StatefulWidget {
  const LinkParentScreen({super.key});

  @override
  State<LinkParentScreen> createState() => _LinkParentScreenState();
}

class _LinkParentScreenState extends State<LinkParentScreen> {
  final TextEditingController searchCtrl = TextEditingController();

  Future<void> _showLinkParentSheet() async {
    final result = await showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.transparent,
      isScrollControlled: true,
      builder: (_) => LinkParentBottomSheet(),
    );

    if (!mounted) return;

    if (result != null) {
      Navigator.pop(context, result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new_rounded,
              color: AppColors.primaryText),
        ),
        title: Text(
          "ភ្ជាប់អាណាព្យាបាល",
          style: AppTextStyle.screenTitle24,
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: SearchField(
              hintText: "ស្វែងរកតាមលេខទូរស័ព្ទ ឬ អ៊ីមែល",
              icon: Icon(Icons.search, color: AppColors.secondaryText),
              controller: searchCtrl,
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                Text("លទ្ធផលស្វែងរក", style: AppTextStyle.sectionTitle20),
                const SizedBox(height: 12),
                _parentTile("ចាន់ ដារ៉ា", "012 448 877"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _parentTile(String name, String phone) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppNumber.radiusPill),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: AppColors.orange.withValues(alpha: 0.1),
            child: Icon(Icons.person_outline, color: AppColors.orange),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: AppTextStyle.subtitle16),
                Text(phone, style: AppTextStyle.caption13Secondary),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _showLinkParentSheet();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryMain.withValues(alpha: 0.1),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppNumber.radiusMedium),
              ),
              minimumSize: const Size(60, 36),
            ),
            child: Text(
              "ភ្ជាប់",
              style: AppTextStyle.bodyPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
