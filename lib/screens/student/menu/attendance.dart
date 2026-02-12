import 'package:flutter/material.dart';
import 'package:tamdansers_app/constants/app_colors.dart';
import 'package:tamdansers_app/constants/text_style.dart';
import 'package:tamdansers_app/widget/attendance_db.dart';

class Attendance extends StatefulWidget {
  const Attendance({super.key});

  @override
  State<Attendance> createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'វត្តមាន',
          style: AppTextStyle.screenTitle24,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CardAttendance(),
              SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ប្រវត្តិវត្តមាន', style: AppTextStyle.sectionTitle20),
                  SizedBox(height: 10),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: 10,
                    itemBuilder: (context, index) {
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
                        title: Text('17 មករា 2026',
                            style: AppTextStyle.sectionTitle20),
                        subtitle: Text('ថ្ងៃច័ន្ទ', style: AppTextStyle.body),
                        trailing: Container(
                          width: 100,
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                              color: AppColors.successBG,
                              borderRadius: BorderRadius.circular(20)),
                          child: Text(
                            'វត្តមាន',
                            style: AppTextStyle.fontsize18
                                .copyWith(color: AppColors.success),
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
