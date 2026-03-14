// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:tamdansers_app/constants/app_colors.dart';
enum Session { morning, evening }

enum SubjectType {
  math,
  khmer,
  geography,
  biology,
  physics,
  chemistry,
  history,
  english,
}

class SubjectModel {
  final SubjectType type;
  final String name;
  final IconData icon;
  final Color iconColor;
  final Color bgIconColor;

  const SubjectModel({
    required this.type,
    required this.name,
    required this.icon,
    required this.iconColor,
    required this.bgIconColor,
  });

  static const math = SubjectModel(
    type: SubjectType.math,
    name: 'គណិតវិទ្យា',
    icon: Icons.calculate_rounded,
    iconColor: AppColors.primary300,  
    bgIconColor: AppColors.primaryBg,
  );

  static const khmer = SubjectModel(
    type: SubjectType.khmer,
    name: 'ភាសាខ្មែរ',
    icon: Icons.menu_book_rounded,
    iconColor: AppColors.orange,    
    bgIconColor: AppColors.teacomment,
  );

  static const geography = SubjectModel(
    type: SubjectType.geography,
    name: 'ភូមិវិទ្យា',
    icon: Icons.public_rounded,
    iconColor: AppColors.success,      
    bgIconColor: AppColors.successBG,
  );

  static const biology = SubjectModel(
    type: SubjectType.biology,
    name: 'ជីវវិទ្យា',
    icon: Icons.biotech_rounded,
    iconColor: AppColors.pepure,     
    bgIconColor: AppColors.purple,
  );

  static const physics = SubjectModel(
    type: SubjectType.physics,
    name: 'រូបវិទ្យា',
    icon: Icons.bolt_rounded,
    iconColor: AppColors.error,    
    bgIconColor: AppColors.errorBG,
  );

  static const chemistry = SubjectModel(
    type: SubjectType.chemistry,
    name: 'គីមីវិទ្យា',
    icon: Icons.science_rounded,
    iconColor: AppColors.grey,      
    bgIconColor: AppColors.lightgrey,
  );

  static const history = SubjectModel(
    type: SubjectType.history,
    name: 'ប្រវត្តិវិទ្យា',
    icon: Icons.account_balance_rounded,
    iconColor: Color(0xFFCA8A04),      
    bgIconColor: AppColors.teacomment,
  );

  static const english = SubjectModel(
    type: SubjectType.english,
    name: 'ភាសាអង់គ្លេស',
    icon: Icons.language_rounded,
    iconColor: Color(0xFF0D9488),     
    bgIconColor: AppColors.successBG,
  );
}

class TeacherModel {
  final String name;
  final String? avatarUrl;

  const TeacherModel({required this.name, this.avatarUrl});
}

class TimeSlotModel {
  final String start;
  final String end;

  const TimeSlotModel({required this.start, required this.end});

  static const m1 = TimeSlotModel(start: '7:00 AM',  end: '8:00 AM');
  static const m2 = TimeSlotModel(start: '8:10 AM',  end: '9:00 AM');
  static const m3 = TimeSlotModel(start: '9:10 AM',  end: '10:00 AM');
  static const m4 = TimeSlotModel(start: '10:10 AM', end: '11:00 AM');

  static const e1 = TimeSlotModel(start: '1:00 PM', end: '1:50 PM');
  static const e2 = TimeSlotModel(start: '2:00 PM', end: '2:50 PM');
  static const e3 = TimeSlotModel(start: '3:00 PM', end: '3:50 PM');
  static const e4 = TimeSlotModel(start: '4:00 PM', end: '5:00 PM');

  String get display      => '$start - $end';
  String get shortDisplay => start;
}
class ScheduleEntryModel {
  final SubjectModel subject;
  final TeacherModel teacher;
  final TimeSlotModel timeSlot;
  final Session session;

  const ScheduleEntryModel({
    required this.subject,
    required this.teacher,
    required this.timeSlot,
    required this.session,
  });
}

class DayScheduleModel {
  final String dayName;
  final int date;
  final List<ScheduleEntryModel> morning;
  final List<ScheduleEntryModel> evening;

  const DayScheduleModel({
    required this.dayName,
    required this.date,
    required this.morning,
    required this.evening,
  });

  List<ScheduleEntryModel> get allEntries => [...morning, ...evening];
}

class WeeklyScheduleModel {
  final List<DayScheduleModel> days;

  const WeeklyScheduleModel({required this.days});

  DayScheduleModel dayAt(int index) => days[index];
  DayScheduleModel? dayByName(String name) =>
      days.where((d) => d.dayName == name).firstOrNull;

  int get totalDays => days.length;
}

class Teachers {
  static const sokha  = TeacherModel(name: 'លោក សុខា');
  static const chan   = TeacherModel(name: 'លោក ចន្ទ');
  static const rith   = TeacherModel(name: 'លោក រ័ត្ន');
  static const chanda = TeacherModel(name: 'លោក ចន្ទ្រា');
  static const virak  = TeacherModel(name: 'លោក វីរៈ');
  static const lina   = TeacherModel(name: 'លោក លីណា');
  static const sophal = TeacherModel(name: 'លោក សុផល');
  static const bopha  = TeacherModel(name: 'លោក បូផា');
  static const pich   = TeacherModel(name: 'លោក ពេជ្រ');
}


final WeeklyScheduleModel weeklySchedule = WeeklyScheduleModel(
  days: [
    DayScheduleModel(
      dayName: 'ចន្ទ', date: 9,
      morning: [
        ScheduleEntryModel(subject: SubjectModel.math,      teacher: Teachers.sokha,  timeSlot: TimeSlotModel.m1, session: Session.morning),
        ScheduleEntryModel(subject: SubjectModel.khmer,     teacher: Teachers.chan,    timeSlot: TimeSlotModel.m2, session: Session.morning),
        ScheduleEntryModel(subject: SubjectModel.geography, teacher: Teachers.rith,   timeSlot: TimeSlotModel.m3, session: Session.morning),
        ScheduleEntryModel(subject: SubjectModel.biology,   teacher: Teachers.chanda, timeSlot: TimeSlotModel.m4, session: Session.morning),
      ],
      evening: [
        ScheduleEntryModel(subject: SubjectModel.physics,   teacher: Teachers.virak,  timeSlot: TimeSlotModel.e1, session: Session.evening),
        ScheduleEntryModel(subject: SubjectModel.chemistry, teacher: Teachers.lina,   timeSlot: TimeSlotModel.e2, session: Session.evening),
        ScheduleEntryModel(subject: SubjectModel.history,   teacher: Teachers.sophal, timeSlot: TimeSlotModel.e3, session: Session.evening),
        ScheduleEntryModel(subject: SubjectModel.english,   teacher: Teachers.bopha,  timeSlot: TimeSlotModel.e4, session: Session.evening),
      ],
    ),
    DayScheduleModel(
      dayName: 'អង្គារ', date: 10,
      morning: [
        ScheduleEntryModel(subject: SubjectModel.english,   teacher: Teachers.pich,   timeSlot: TimeSlotModel.m1, session: Session.morning),
        ScheduleEntryModel(subject: SubjectModel.math,      teacher: Teachers.sokha,  timeSlot: TimeSlotModel.m2, session: Session.morning),
        ScheduleEntryModel(subject: SubjectModel.physics,   teacher: Teachers.virak,  timeSlot: TimeSlotModel.m3, session: Session.morning),
        ScheduleEntryModel(subject: SubjectModel.biology,   teacher: Teachers.chanda, timeSlot: TimeSlotModel.m4, session: Session.morning),
      ],
      evening: [
        ScheduleEntryModel(subject: SubjectModel.chemistry, teacher: Teachers.lina,   timeSlot: TimeSlotModel.e1, session: Session.evening),
        ScheduleEntryModel(subject: SubjectModel.geography, teacher: Teachers.rith,   timeSlot: TimeSlotModel.e2, session: Session.evening),
        ScheduleEntryModel(subject: SubjectModel.khmer,     teacher: Teachers.chan,    timeSlot: TimeSlotModel.e3, session: Session.evening),
        ScheduleEntryModel(subject: SubjectModel.history,   teacher: Teachers.sophal, timeSlot: TimeSlotModel.e4, session: Session.evening),
      ],
    ),

    DayScheduleModel(
      dayName: 'ពុធ', date: 11,
      morning: [
        ScheduleEntryModel(subject: SubjectModel.history,   teacher: Teachers.sophal, timeSlot: TimeSlotModel.m1, session: Session.morning),
        ScheduleEntryModel(subject: SubjectModel.english,   teacher: Teachers.pich,   timeSlot: TimeSlotModel.m2, session: Session.morning),
        ScheduleEntryModel(subject: SubjectModel.math,      teacher: Teachers.sokha,  timeSlot: TimeSlotModel.m3, session: Session.morning),
        ScheduleEntryModel(subject: SubjectModel.geography, teacher: Teachers.rith,   timeSlot: TimeSlotModel.m4, session: Session.morning),
      ],
      evening: [
        ScheduleEntryModel(subject: SubjectModel.biology,   teacher: Teachers.chanda, timeSlot: TimeSlotModel.e1, session: Session.evening),
        ScheduleEntryModel(subject: SubjectModel.physics,   teacher: Teachers.virak,  timeSlot: TimeSlotModel.e2, session: Session.evening),
        ScheduleEntryModel(subject: SubjectModel.khmer,     teacher: Teachers.chan,    timeSlot: TimeSlotModel.e3, session: Session.evening),
        ScheduleEntryModel(subject: SubjectModel.chemistry, teacher: Teachers.lina,   timeSlot: TimeSlotModel.e4, session: Session.evening),
      ],
    ),

    DayScheduleModel(
      dayName: 'ព្រហ', date: 12,
      morning: [
        ScheduleEntryModel(subject: SubjectModel.khmer,     teacher: Teachers.chan,    timeSlot: TimeSlotModel.m1, session: Session.morning),
        ScheduleEntryModel(subject: SubjectModel.biology,   teacher: Teachers.chanda, timeSlot: TimeSlotModel.m2, session: Session.morning),
        ScheduleEntryModel(subject: SubjectModel.history,   teacher: Teachers.sophal, timeSlot: TimeSlotModel.m3, session: Session.morning),
        ScheduleEntryModel(subject: SubjectModel.chemistry, teacher: Teachers.lina,   timeSlot: TimeSlotModel.m4, session: Session.morning),
      ],
      evening: [
        ScheduleEntryModel(subject: SubjectModel.english,   teacher: Teachers.pich,   timeSlot: TimeSlotModel.e1, session: Session.evening),
        ScheduleEntryModel(subject: SubjectModel.math,      teacher: Teachers.sokha,  timeSlot: TimeSlotModel.e2, session: Session.evening),
        ScheduleEntryModel(subject: SubjectModel.physics,   teacher: Teachers.virak,  timeSlot: TimeSlotModel.e3, session: Session.evening),
        ScheduleEntryModel(subject: SubjectModel.geography, teacher: Teachers.rith,   timeSlot: TimeSlotModel.e4, session: Session.evening),
      ],
    ),

    DayScheduleModel(
      dayName: 'សុក្រ', date: 13,
      morning: [
        ScheduleEntryModel(subject: SubjectModel.physics,   teacher: Teachers.virak,  timeSlot: TimeSlotModel.m1, session: Session.morning),
        ScheduleEntryModel(subject: SubjectModel.geography, teacher: Teachers.rith,   timeSlot: TimeSlotModel.m2, session: Session.morning),
        ScheduleEntryModel(subject: SubjectModel.english,   teacher: Teachers.pich,   timeSlot: TimeSlotModel.m3, session: Session.morning),
        ScheduleEntryModel(subject: SubjectModel.khmer,     teacher: Teachers.chan,    timeSlot: TimeSlotModel.m4, session: Session.morning),
      ],
      evening: [
        ScheduleEntryModel(subject: SubjectModel.math,      teacher: Teachers.sokha,  timeSlot: TimeSlotModel.e1, session: Session.evening),
        ScheduleEntryModel(subject: SubjectModel.history,   teacher: Teachers.sophal, timeSlot: TimeSlotModel.e2, session: Session.evening),
        ScheduleEntryModel(subject: SubjectModel.biology,   teacher: Teachers.chanda, timeSlot: TimeSlotModel.e3, session: Session.evening),
        ScheduleEntryModel(subject: SubjectModel.chemistry, teacher: Teachers.lina,   timeSlot: TimeSlotModel.e4, session: Session.evening),
      ],
    ),

  ],
);