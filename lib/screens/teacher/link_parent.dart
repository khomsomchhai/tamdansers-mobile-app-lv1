import 'package:flutter/material.dart';
import 'package:tamdansers_app/constants/app_colors.dart';
import 'package:tamdansers_app/constants/text_style.dart';
import 'package:tamdansers_app/widget/search_field.dart'; 

class LinkParentScreen extends StatefulWidget {
  const LinkParentScreen({super.key});

  @override
  State<LinkParentScreen> createState() => _LinkParentScreenState();
}

class _LinkParentScreenState extends State<LinkParentScreen> {
  var searchCtrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.primaryText),
        ),
        title: Column(
          children: [
            Text(
              "ភ្ជាប់អាណាព្យាបាល", 
              style: AppTextStyle.sectionTitle20),
            Text(
              "សម្រាប់សិស្ស: សុខា ចាន់",
              style: AppTextStyle.body.copyWith(color: AppColors.primaryMain, fontSize: 12)),
          ],
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // 1. Search Section
          Padding(
            padding: const EdgeInsets.all(20),
            child: SearchField(
              hintText: "ស្វែងរកតាមឈ្មោះ ឬលេខទូរស័ព្ទ",
              icon: Icon(Icons.search, color: AppColors.secondaryText),
              controller: searchCtrl,
            ),
          ),

          // 2. Create New Parent Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _buildCreateNewButton(),
          ),

          const SizedBox(height: 24),

          // 3. Search Results List
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                Text(
                  "លទ្ធផលស្វែងរក", 
                  style: AppTextStyle.body.copyWith(color: AppColors.secondaryText)),
                const SizedBox(height: 12),
                _parentTile("ចាន់ ដារ៉ា", "012 448 877"),
                _parentTile("សោម ម៉ារី", "098 765 432"),
                _parentTile("ហេង វិសាល", "015 555 666"),
                _parentTile("ម៉ី ស្រីម៉ុំ", "010 222 333"),
                
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    "ស្វែងរកមិនឃើញ? សូមសាកល្បងបញ្ចូលលេខទូរស័ព្ទឡើងវិញ",
                    textAlign: TextAlign.center,
                    style: AppTextStyle.body.copyWith(color: AppColors.secondaryText, fontSize: 12)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCreateNewButton() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryMain,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: AppColors.primaryMain.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4))
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
            child: const Icon(Icons.add, color: Colors.white),
          ),
          const Spacer(),
          const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 16),
        ],
      ),
    );
  }

  Widget _parentTile(String name, String phone) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: Colors.orange.shade50,
            child: Icon(Icons.person_outline, color: Colors.orange.shade300),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: AppTextStyle.body.copyWith(fontWeight: FontWeight.bold)),
                Text(phone, style: AppTextStyle.body.copyWith(color: AppColors.secondaryText, fontSize: 12)),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryMain.withOpacity(0.1),
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              minimumSize: const Size(60, 36),
            ),
            child: Text("ភ្ជាប់", style: AppTextStyle.body.copyWith(color: AppColors.primaryMain, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}