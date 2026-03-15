import 'package:flutter/material.dart';
import 'package:tamdansers_app/constants/app_colors.dart';
import 'package:tamdansers_app/constants/text_style.dart';
import 'package:tamdansers_app/screens/student/menu/data_attendance.dart';
import 'package:tamdansers_app/widget/attendance_db.dart';

class Attendance extends StatefulWidget {
  const Attendance({super.key});

  @override
  State<Attendance> createState() => _AttendanceState();
}

final summary = attendanceSummary;

class _AttendanceState extends State<Attendance> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'វត្តមាន',
          style: AppTextStyle.sectionTitle20,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CardAttendance(
                totalDays: summary.totalDays,
                presentDays: summary.presentDays,
                absentDays: summary.absentDays,
                attendanceRate: summary.attendanceRate,
                monthLabel: 'មករា',
              ),
              SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ប្រវត្តិវត្តមាន', style: AppTextStyle.subtitle18),
                  SizedBox(height: 10),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: AttendanceEntryModel.attendanceHistory.length,
                    itemBuilder: (context, index) {
                      final entry =
                          AttendanceEntryModel.attendanceHistory[index];
                      final isPresent = entry.isPresent;
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: AppColors.primaryBg),
                          child: Icon(
                            Icons.calendar_month_outlined,
                            color: AppColors.primaryMain,
                            size: 30,
                          ),
                        ),
                        title: Text(entry.date, style: AppTextStyle.subtitle16),
                        subtitle: Text(entry.time, style: AppTextStyle.body),
                        trailing: Container(
                          width: 100,
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                              color: isPresent
                                  ? AppColors.successBG
                                  : AppColors.errorBG,
                              borderRadius: BorderRadius.circular(20)),
                          child: Text(
                            isPresent ? 'វត្តមាន' : 'អវត្តមាន',
                            style: AppTextStyle.subtitle16.copyWith(
                                color: isPresent
                                    ? AppColors.success
                                    : AppColors.error),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    },
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
