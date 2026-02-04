import 'package:flutter/material.dart';
import 'package:tamdansers_app/constants/app_colors.dart';
import 'package:tamdansers_app/constants/text_style.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  String _selectedDate = "២៥ មករា, ព្រឹក្ស";
  final List<String> _dates = ["២៥ មករា, ព្រឹក", "២៤ មករា", "២៣ មករា"];

  final List<Map<String, dynamic>> _students = [
    {
      "name": "ច័ន្ថ ធីតា",
      "id": "10245",
      "status": "present",
      "hasNotification": true,
      "image": "assets/images/user_profile.png"
    },
    {
      "name": "ច័ន្ថ ពិសី",
      "id": "10246",
      "status": "absent",
      "hasNotification": true,
      "image": "assets/images/user_profile.png"
    },
    {
      "name": "ឌូមា​ មុី",
      "id": "10247",
      "status": "late",
      "hasNotification": false,
      "image": "assets/images/user_profile.png"
    },
    {
      "name": "ហុង សុភា",
      "id": "10248",
      "status": "absent",
      "hasNotification": false,
      "image": "assets/images/user_profile.png"
    },
    {
      "name": "ហូលី ស្សីត",
      "id": "10249",
      "status": "present",
      "hasNotification": false,
      "image": null
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            padding: EdgeInsets.only(top: 8),
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
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: _students.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 12),
                  child: _buildStudentCard(
                    _students[index]["name"],
                    _students[index]["id"],
                    _students[index]["status"],
                    _students[index]["hasNotification"],
                    _students[index]["image"],
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
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "គណិតវិទ្យា • ថ្នាក់ទី 7-A",
            style: AppTextStyle.sectionTitle20.copyWith(fontSize: 18),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem("24", "សរុប", AppColors.primaryText),
              _buildStatItem("20", "មក", AppColors.success),
              _buildStatItem("3", "អវត្តមាន", AppColors.error),
              _buildStatItem("1", "យឺត", Color(0xFFFFA726)),
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
          style: AppTextStyle.title28.copyWith(
            color: color,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: AppTextStyle.body.copyWith(
            fontSize: 14,
            color: AppColors.secondaryText,
          ),
        ),
      ],
    );
  }

  Widget _buildMarkAllButton() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Color(0xFFE3F2FD),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle, color: AppColors.primaryMain, size: 20),
          SizedBox(width: 8),
          Text(
            "កំណត់សិស្សមកទាំងអស់",
            style: AppTextStyle.body.copyWith(
              color: AppColors.primaryMain,
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
        ],
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
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundImage:
                        imagePath != null ? AssetImage(imagePath) : null,
                    backgroundColor: status == "present"
                        ? Color(0xFFE8F5E9)
                        : status == "absent"
                            ? Color(0xFFFFEBEE)
                            : Color(0xFFFFF3E0),
                    child: imagePath == null
                        ? Text(
                            name.substring(0, 2).toUpperCase(),
                            style: AppTextStyle.fontsize18.copyWith(
                              color: statusColor,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : null,
                  ),
                ],
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name,
                        style: AppTextStyle.fontsize18
                            .copyWith(fontWeight: FontWeight.w600)),
                    SizedBox(height: 2),
                    Text(
                      "ID: $id",
                      style: AppTextStyle.body.copyWith(
                        fontSize: 13,
                        color: AppColors.secondaryText,
                      ),
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
                    padding: EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    "មក",
                    style: AppTextStyle.body.copyWith(
                      fontSize: 14,
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
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: status == "absent"
                        ? AppColors.error
                        : AppColors.backgroundLight,
                    elevation: 0,
                    padding: EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    "អវត្តមាន",
                    style: AppTextStyle.body.copyWith(
                      fontSize: 14,
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
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: status == "late"
                        ? Color(0xFFFFA726)
                        : AppColors.backgroundLight,
                    elevation: 0,
                    padding: EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    "យឺត",
                    style: AppTextStyle.body.copyWith(
                      fontSize: 14,
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
                      "ផ្ញើការជូនដំណឹងទៅឪពុកម្តាយ",
                      style: AppTextStyle.body.copyWith(
                        fontSize: 13,
                        color: AppColors.secondaryText,
                      ),
                    ),
                  ),
                  Switch(
                    value: _students[index]["hasNotification"],
                    onChanged: (value) {
                      setState(() {
                        _students[index]["hasNotification"] = value;
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
            Icon(Icons.save_outlined, color: AppColors.white, size: 22),
            SizedBox(width: 8),
            Text(
              "បញ្ជូនវត្តមាន",
              style: AppTextStyle.fontsize18.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
