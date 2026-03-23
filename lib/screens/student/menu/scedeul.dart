// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tamdansers_app/constants/app_colors.dart';
import 'package:tamdansers_app/constants/text_style.dart';
import 'package:tamdansers_app/screens/student/menu/data_schedule.dart'; 

class Scedeul extends StatefulWidget {
  const Scedeul({super.key});

  @override
  State<Scedeul> createState() => _ScedeulState();
}

class _ScedeulState extends State<Scedeul> {
  int selectedDay = 0;

  DayScheduleModel get currentDay => weeklySchedule.dayAt(selectedDay);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('កាលវិភាគ', style: AppTextStyle.sectionTitle20),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_month, color: AppColors.secondaryText),
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: SizedBox(
                    height: 400,
                    child: TableCalendar(
                      firstDay: DateTime.utc(2025, 1, 1),
                      lastDay: DateTime.utc(2030, 12, 31),
                      focusedDay: DateTime.now(),
                    ),
                  ),
                ),
              );
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 110,
              child: GridView.builder(
                physics:
                    const NeverScrollableScrollPhysics(),
                itemCount: weeklySchedule.totalDays,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  crossAxisSpacing: 10,
                  childAspectRatio: 0.7,
                ),
                itemBuilder: (context, index) {
                  final isSelected = selectedDay == index;
                  final day = weeklySchedule.dayAt(index);

                  return GestureDetector(
                    onTap: () => setState(() => selectedDay = index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: isSelected
                            ? AppColors.primaryMain
                            : AppColors.primaryBg,
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: AppColors.primaryMain.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                )
                              ]
                            : [],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            day.dayName,
                            style: AppTextStyle.fontsize18.copyWith(
                              fontSize: 13,
                              color: isSelected
                                  ? AppColors.white
                                  : AppColors.primaryText,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 15),

            Expanded(
              child: ListView(
                children: [
                  Text('វេនព្រឹក', style: AppTextStyle.sectionTitle20),
                  const SizedBox(height: 10),
                  ...currentDay.morning.map((e) => _scheduleItem(e)),

                  const SizedBox(height: 30),
                  Text('វេនរសៀល', style: AppTextStyle.sectionTitle20),
                  const SizedBox(height: 10),
                  ...currentDay.evening.map((e) => _scheduleItem(e)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _scheduleItem(ScheduleEntryModel entry) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Text(
                entry.timeSlot.shortDisplay, 
                style: AppTextStyle.hintText.copyWith(
                  color: AppColors.secondaryText,
                  fontSize: 11,
                ),
              ),
              const SizedBox(height: 5),
              Container(
                height: 80,
                width: 3,
                decoration: BoxDecoration(
                  color: entry.subject.iconColor
                      .withOpacity(0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),

          const SizedBox(width: 20),
          Expanded(
            child: Card(
              color: AppColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: entry.subject.iconColor.withOpacity(0.3),
                  width: 1,
                ),
              ),
              elevation: 1.5,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: entry.subject.bgIconColor,
                      ),
                      child: Icon(
                        entry.subject.icon,
                        size: 32,
                        color: entry.subject.iconColor,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            entry.subject.name, 
                            style: AppTextStyle.sectionTitle20
                                .copyWith(fontSize: 15),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'គ្រូ: ${entry.teacher.name}',
                            style: AppTextStyle.body.copyWith(
                              color: AppColors.secondaryText,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.watch_later_outlined,
                                  size: 14, color: AppColors.secondaryText),
                              const SizedBox(width: 5),
                              Flexible(
                                child: Text(
                                  entry.timeSlot.display,
                                  style: AppTextStyle.body.copyWith(
                                    color: AppColors.secondaryText,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
