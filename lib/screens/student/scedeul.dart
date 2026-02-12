import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tamdansers_app/constants/app_colors.dart';
import 'package:tamdansers_app/constants/text_style.dart';

class Scedeul extends StatefulWidget {
  const Scedeul({super.key});

  @override
  State<Scedeul> createState() => _ScedeulState();
}

class _ScedeulState extends State<Scedeul> {
  int? selectedDay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(
          Icons.chevron_left,
          size: 40,
          color: AppColors.secondaryText,
        ),
        title: Text('កាលវិភាគ', style: AppTextStyle.sectionTitle20),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_month,
                color: AppColors.secondaryText),
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
              height: 100,
              child: GridView.builder(
                itemCount: 5,
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  crossAxisSpacing: 10,
                  childAspectRatio: 0.7,
                ),
                itemBuilder: (context, index) {
                  final isSelected = selectedDay == index;
                  return GestureDetector(
                    onTap: () {
                      setState(() => selectedDay = index);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: isSelected
                            ? AppColors.primaryMain
                            : AppColors.primaryBg,
                      ),
                      child: Column(
                        children: [
                          Text(
                            'ចន្ទ',
                            style: AppTextStyle.fontsize18.copyWith(
                              color: isSelected
                                  ? AppColors.white
                                  : AppColors.primaryText,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            '11',
                            style: AppTextStyle.fontsize18.copyWith(
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

                  ...List.generate(3, (_) => _scheduleItem()),

                  const SizedBox(height: 30),

                  /// ===== AFTERNOON =====
                  Text('វេនរសៀល', style: AppTextStyle.sectionTitle20),
                  const SizedBox(height: 10),

                  ...List.generate(3, (_) => _scheduleItem()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ===== REUSABLE SCHEDULE ITEM =====
  Widget _scheduleItem() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Text(
              '8:00 - 9:00',
              style: AppTextStyle.hintText
                  .copyWith(color: AppColors.secondaryText),
            ),
            const SizedBox(height: 5),
            Container(
              height: 80,
              width: 3,
              color: AppColors.secondaryText,
            ),
          ],
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppColors.primaryBg,
                    ),
                    child: Icon(
                      Icons.book,
                      size: 40,
                      color: AppColors.primaryMain,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('ប្រវត្តិវិទ្យា',
                          style: AppTextStyle.sectionTitle20),
                      const SizedBox(height: 5),
                      Text(
                        'គ្រូ: សុខ សុភា',
                        style: AppTextStyle.body.copyWith(
                          color: AppColors.secondaryText,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.watch,
                              size: 16,
                              color: AppColors.secondaryText),
                          const SizedBox(width: 5),
                          Text(
                            '8:00 AM - 9:00 AM',
                            style: AppTextStyle.body.copyWith(
                              color: AppColors.secondaryText,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
