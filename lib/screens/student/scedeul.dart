// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tamdansers_app/constants/app_colors.dart';
import 'package:tamdansers_app/constants/text_style.dart';
import 'package:tamdansers_app/screens/student/data_schedule.dart'; 

class Scedeul extends StatefulWidget {
  const Scedeul({super.key});

  @override
  State<Scedeul> createState() => _ScedeulState();
}

class _ScedeulState extends State<Scedeul> {
  int selectedDay = 0;

  // ✅ get current day from model
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
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ===== DAYS =====
            SizedBox(
              height: 110,
              child: GridView.builder(
                physics:
                    const NeverScrollableScrollPhysics(), // ✅ fix scroll conflict
                itemCount: weeklySchedule.totalDays, // ✅ from model
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  crossAxisSpacing: 10,
                  childAspectRatio: 0.7,
                ),
                itemBuilder: (context, index) {
                  final isSelected = selectedDay == index;
                  final day = weeklySchedule.dayAt(index); // ✅ from model

                  return GestureDetector(
                    onTap: () => setState(() => selectedDay = index),
                    child: AnimatedContainer(
                      // ✅ smooth animation
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
                            day.dayName, // ✅ from model
                            style: AppTextStyle.fontsize18.copyWith(
                              fontSize: 13,
                              color: isSelected
                                  ? AppColors.white
                                  : AppColors.primaryText,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${day.date}', // ✅ from model
                            style: AppTextStyle.fontsize18.copyWith(
                              fontWeight: FontWeight.bold,
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

            /// ===== SCHEDULE LIST =====
            Expanded(
              child: ListView(
                children: [
                  /// ===== MORNING =====
                  Text('វេនព្រឹក', style: AppTextStyle.sectionTitle20),
                  const SizedBox(height: 10),

                  // ✅ loop real morning data
                  ...currentDay.morning.map((e) => _scheduleItem(e)),

                  const SizedBox(height: 30),

                  /// ===== EVENING =====
                  Text('វេនរសៀល', style: AppTextStyle.sectionTitle20),
                  const SizedBox(height: 10),

                  // ✅ loop real evening data
                  ...currentDay.evening.map((e) => _scheduleItem(e)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ===== REUSABLE SCHEDULE ITEM =====
  Widget _scheduleItem(ScheduleEntryModel entry) {
    // ✅ takes entry param
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Time + Line ──────────────────────────────────
          Column(
            children: [
              Text(
                entry.timeSlot.shortDisplay, // ✅ e.g. "7:00 AM"
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
                      .withOpacity(0.4), // ✅ subject color
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),

          const SizedBox(width: 20),

          // ── Card ─────────────────────────────────────────
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  // ✅ colored border
                  color: entry.subject.iconColor.withOpacity(0.3),
                  width: 1,
                ),
              ),
              elevation: 1.5,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    // ── Subject Icon ────────────────────────
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: entry.subject.bgIconColor, // ✅ bgIconColor
                      ),
                      child: Icon(
                        entry.subject.icon, // ✅ subject icon
                        size: 32,
                        color: entry.subject.iconColor, // ✅ iconColor
                      ),
                    ),
                    const SizedBox(width: 10),

                    // ── Subject Info ────────────────────────
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            entry.subject.name, // ✅ subject name
                            style: AppTextStyle.sectionTitle20
                                .copyWith(fontSize: 15),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'គ្រូ: ${entry.teacher.name}', // ✅ teacher name
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
                                  entry.timeSlot.display, // ✅ full time range
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
