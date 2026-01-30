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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.chevron_left,size: 40, color: AppColors.secondaryText),
        title: Text('កាលវិភាគ', style: AppTextStyle.sectionTitle20),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return Dialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    
                    child: Container(
                      height: 400,
                      child: TableCalendar(
                        firstDay: DateTime.utc(2025, 1, 1),
                        lastDay: DateTime.utc(2030, 12, 31),
                        focusedDay: DateTime.now(),
                      ),
                    ),
                  );
                },
              );
            },
            icon: Icon(Icons.calendar_month,  color: AppColors.secondaryText)
          )
        ],
      
      ),
    );
  }
}
