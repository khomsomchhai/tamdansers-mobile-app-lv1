import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:tamdansers_app/constants/app_colors.dart';
import 'package:tamdansers_app/constants/app_images.dart';
import 'package:tamdansers_app/constants/text_style.dart';
import 'package:tamdansers_app/routes/app_routes.dart';

class StudentDetailScreen extends StatelessWidget {
  const StudentDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.primaryText),
        ),
        title: Text("ព័ត៌មានលម្អិត", style: AppTextStyle.screenTitle24),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            _buildProfileHeader(),
            const SizedBox(height: 24),
            _buildGeneralInfo(context),
            const SizedBox(height: 20),
            _buildAttendanceCard(),
            const SizedBox(height: 20),
            _buildSubjectList(),
            const SizedBox(height: 20),
            _buildNoteSection(),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: AppColors.primaryMain.withOpacity(0.1),
          child: Image.asset(AppImages.studentMale2, width: 70), 
        ),
        const SizedBox(height: 12),
        Text("សុខា ចាន់", style: AppTextStyle.sectionTitle20.copyWith(fontWeight: FontWeight.bold)),
        Text("ID: 2023-001", style: AppTextStyle.body.copyWith(color: AppColors.secondaryText)),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _tag("ថ្នាក់ទី ៥A", AppColors.primaryMain.withOpacity(0.1), AppColors.primaryMain),
            const SizedBox(width: 8),
            _tag("កំពុងសិក្សា", AppColors.success.withOpacity(0.1), AppColors.success),
          ],
        )
      ],
    );
  }

  Widget _buildGeneralInfo(BuildContext context) {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionLabel(Icons.info_outline, "ព័ត៌មានទូទៅ"),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _infoTile("អាយុ", "11 ឆ្នាំ")),
              Expanded(child: _infoTile("ភេទ", "ប្រុស")),
            ],
          ),
          const SizedBox(height: 16),
          Text("ទំនាក់ទំនងអាណាព្យាបាល", style: AppTextStyle.body.copyWith(color: AppColors.secondaryText)),
          Row(
            children: [
              Text("012 345 678", style: AppTextStyle.body.copyWith(fontWeight: FontWeight.bold, fontSize: 16)),
              const Spacer(),
              _circleIcon(Icons.phone, AppColors.success),
              const SizedBox(width: 10),
              _circleIcon(Icons.chat_bubble, AppColors.primaryMain),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(
                  context, 
                  AppRoutes.linkParentScreen
                );
              },
              icon: const Icon(Icons.person_add_alt_1_rounded, color: Colors.white, size: 20),
              label: Text(
                "ភ្ជាប់អាណាព្យាបាល", 
                style: AppTextStyle.body.copyWith(color: Colors.white, fontWeight: FontWeight.bold)
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryMain,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
                elevation: 0,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildAttendanceCard() {
    return _card(
      child: Column(
        children: [
          _sectionLabel(Icons.calendar_month, "វត្តមានសរុប"),
          const SizedBox(height: 20),
          CircularPercentIndicator(
            radius: 60.0,
            lineWidth: 10.0,
            percent: 0.98,
            center: Text("98%", style: AppTextStyle.sectionTitle20),
            progressColor: AppColors.success,
            backgroundColor: Colors.grey.shade100,
            circularStrokeCap: CircularStrokeCap.round,
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _statItem("វត្តមាន", "105 ថ្ងៃ"),
              _statItem("ច្បាប់", "2 ថ្ងៃ"),
              _statItem("អវត្តមាន", "0 ថ្ងៃ"),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildSubjectList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text("លទ្ធផលសិក្សា", style: AppTextStyle.sectionTitle20),
            const Spacer(),
            TextButton(
              onPressed: () {

              }, 
              child: Text(
                "មើលទាំងអស់", 
                style: AppTextStyle.body.copyWith(
                  color: AppColors.primaryMain,
                  fontWeight: FontWeight.bold,
                ),
              )
            )
          ],
        ),
        const SizedBox(height: 12),
        _subjectTile("ភាសាខ្មែរ", "Average: 80", 95, Colors.blue),
        _subjectTile("គណិតវិទ្យា", "Average: 75", 92, Colors.orange),
        _subjectTile("វិទ្យាសាស្ត្រ", "Average: 78", 88, Colors.purple),
      ],
    );
  }

  Widget _buildNoteSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("កំណត់ត្រាគ្រូ", style: AppTextStyle.sectionTitle20),
        const SizedBox(height: 10),
        TextField(
          maxLines: 3,
          decoration: InputDecoration(
            hintText: "បញ្ចូលចំណាំ...",
            hintStyle: AppTextStyle.body.copyWith(color: AppColors.secondaryText),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
          ),
        ),
      ],
    );
  }
  Widget _card({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10)],
      ),
      child: child,
    );
  }

  Widget _sectionLabel(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primaryMain, size: 20),
        const SizedBox(width: 8),
        Text(label, style: AppTextStyle.body.copyWith(fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _infoTile(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyle.body.copyWith(color: AppColors.secondaryText)),
        Text(value, style: AppTextStyle.body.copyWith(fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _statItem(String label, String value) {
    return Column(
      children: [
        Text(label, style: AppTextStyle.body.copyWith(fontSize: 12, color: AppColors.secondaryText)),
        Text(value, style: AppTextStyle.body.copyWith(fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _tag(String text, Color bg, Color textCol) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10)),
      child: Text(text, style: AppTextStyle.body.copyWith(color: textCol, fontSize: 12, fontWeight: FontWeight.bold)),
    );
  }

  Widget _circleIcon(IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
      child: Icon(icon, color: color, size: 20),
    );
  }

  Widget _subjectTile(String title, String sub, int score, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
            child: Icon(Icons.book, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyle.body.copyWith(fontWeight: FontWeight.bold)),
                Text(sub, style: AppTextStyle.body.copyWith(color: AppColors.secondaryText, fontSize: 12)),
              ],
            ),
          ),
          Text("$score", style: AppTextStyle.sectionTitle20.copyWith(color: AppColors.primaryMain)),
        ],
      ),
    );
  }
}