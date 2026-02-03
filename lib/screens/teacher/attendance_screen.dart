import 'package:flutter/material.dart';
import 'package:tamdansers_app/constants/app_colors.dart';
import 'package:tamdansers_app/constants/text_style.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  String _selectedDate = "២៥ មករា, ថ្ងៃនេះ";
  final List<String> _dates = ["២៥ មករា, ថ្ងៃនេះ", "២៣ មករា", "២២ មករា"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.primaryText),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("វត្តមាន", style: AppTextStyle.fontsize18),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_today, color: AppColors.primaryText),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: AppColors.white,
            child: Column(
              children: [
                _buildDateFilter(),
                SizedBox(height: 16),
                _buildStatsCard(),
                SizedBox(height: 16),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(16),
              children: [
                _buildStudentCard(
                  "ចន្ថា ធីតា",
                  "ID: 10245",
                  "present",
                  true,
                  "assets/images/user_profile.png",
                ),
                SizedBox(height: 12),
                _buildStudentCard(
                  "ចន្ថា ប្រើ",
                  "ID: 10246",
                  "absent",
                  true,
                  "assets/images/user_profile.png",
                ),
                SizedBox(height: 12),
                _buildStudentCard(
                  "ចន្ថា ក្រុម",
                  "ID: 10247",
                  "late",
                  false,
                  "assets/images/user_profile.png",
                ),
                SizedBox(height: 12),
                _buildStudentCard(
                  "ហាល ប្រើម្យ",
                  "ID: 10248",
                  "absent",
                  false,
                  "assets/images/user_profile.png",
                ),
                SizedBox(height: 12),
                _buildStudentCard(
                  "ហុល ស៊ីក",
                  "ID: 10249",
                  "present",
                  false,
                  null,
                ),
              ],
            ),
          ),
          _buildSubmitButton(),
        ],
      ),
    );
  }

  Widget _buildDateFilter() {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16),
        itemCount: _dates.length,
        itemBuilder: (context, index) {
          final date = _dates[index];
          final isSelected = _selectedDate == date;
          return Padding(
            padding: EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(date),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedDate = date;
                });
              },
              labelStyle: AppTextStyle.body.copyWith(
                fontSize: 14,
                color: isSelected ? AppColors.white : AppColors.primaryText,
              ),
              backgroundColor: AppColors.backgroundLight,
              selectedColor: AppColors.primaryMain,
              showCheckmark: false,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatsCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "គណិតវិទ្យា • ថ្នាក់ទី 7-A",
            style: AppTextStyle.fontsize18,
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem("24", "សរុប", AppColors.primaryText),
              _buildStatItem("20", "មក", AppColors.success),
              _buildStatItem("3", "អត់មក", AppColors.error),
              _buildStatItem("1", "យឺត", Colors.orange),
            ],
          ),
          SizedBox(height: 16),
          Center(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: Color(0xFFE3F2FD),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle,
                      color: AppColors.primaryMain, size: 20),
                  SizedBox(width: 8),
                  Text(
                    "តាមដានការអត់ត្មាន",
                    style: AppTextStyle.body.copyWith(
                      color: AppColors.primaryMain,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
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
          style: AppTextStyle.title28.copyWith(color: color, fontSize: 24),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: AppTextStyle.body
              .copyWith(fontSize: 13, color: AppColors.secondaryText),
        ),
      ],
    );
  }

  Widget _buildStudentCard(String name, String id, String status,
      bool hasNotification, String? imagePath) {
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
        statusColor = Colors.orange;
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
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundImage:
                        imagePath != null ? AssetImage(imagePath) : null,
                    backgroundColor: AppColors.primaryMain,
                    child: imagePath == null
                        ? Text(
                            name.substring(0, 2).toUpperCase(),
                            style: AppTextStyle.fontsize18
                                .copyWith(color: AppColors.white),
                          )
                        : null,
                  ),
                  if (status == "present")
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: AppColors.success,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.white, width: 2),
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: AppTextStyle.fontsize18),
                    Text(
                      id,
                      style: AppTextStyle.body.copyWith(
                          fontSize: 13, color: AppColors.secondaryText),
                    ),
                  ],
                ),
              ),
              Container(
                width: 32,
                height: 32,
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
                  size: 18,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                        color: AppColors.secondaryText.withValues(alpha: 0.3)),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Text("មក",
                      style: AppTextStyle.body.copyWith(fontSize: 14)),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: status == "absent"
                        ? AppColors.error
                        : AppColors.backgroundLight,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Text(
                    "អត់មក",
                    style: AppTextStyle.body.copyWith(
                      fontSize: 14,
                      color: status == "absent"
                          ? AppColors.white
                          : AppColors.primaryText,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                        color: AppColors.secondaryText.withValues(alpha: 0.3)),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Text("យឺត",
                      style: AppTextStyle.body.copyWith(fontSize: 14)),
                ),
              ),
            ],
          ),
          if (hasNotification)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Row(
                children: [
                  Icon(Icons.notifications,
                      color: AppColors.primaryMain, size: 18),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "ផ្ញើសេចក្តីជូនដំណឹងការពារ",
                      style: AppTextStyle.body.copyWith(fontSize: 13),
                    ),
                  ),
                  Switch(
                    value: hasNotification,
                    onChanged: (value) {},
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
      padding: EdgeInsets.all(16),
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
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryMain,
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.save, color: AppColors.white),
            SizedBox(width: 8),
            Text(
              "បញ្ជូលត្មាន",
              style: AppTextStyle.fontsize18.copyWith(color: AppColors.white),
            ),
          ],
        ),
      ),
    );
  }
}
