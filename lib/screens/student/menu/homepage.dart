import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tamdansers_app/constants/app_colors.dart';
import 'package:tamdansers_app/constants/text_style.dart';
import 'package:tamdansers_app/repositories/class_repo.dart';
import 'package:tamdansers_app/repositories/homework_repo.dart';
import 'package:tamdansers_app/repositories/student_class_repo.dart';
import 'package:tamdansers_app/repositories/user_repo.dart';
import 'package:tamdansers_app/screens/student/menu/data_list_homepage.dart';
import 'package:tamdansers_app/screens/student/widget/student_profile_header.dart';
import 'package:tamdansers_app/widget/attendance_db.dart';

class Homepage extends StatefulWidget {
  final int userId;
  const Homepage({super.key, required this.userId});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  bool isExpend = false;
  final totalClass = 10;
  Map<String, dynamic>? user;
  Map<String, dynamic>? classData;
  List<Map<String, dynamic>> homeworkData = [];
  List<Map<String, dynamic>> availableClasses = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final fetchedUser = await UserRepo().getUserById(widget.userId);

    List<Map<String, dynamic>> enrolledClasses = [];
    if (fetchedUser != null) {
      final email = (fetchedUser['email'] ?? '') as String;
      if (email.isNotEmpty) {
        enrolledClasses = await StudentClassRepo().getEnrolledClassesByEmail(email);
      }
    }
    if (enrolledClasses.isEmpty && fetchedUser != null && fetchedUser['class_id'] != null) {
      final fetchedClass = await ClassRepo().getClassById(fetchedUser['class_id']);
      if (fetchedClass != null) {
        enrolledClasses = [fetchedClass];
      }
    }

    Map<String, dynamic>? fetchedClass;
    List<Map<String, dynamic>> fetchedHomework = [];
    if (enrolledClasses.isNotEmpty) {
      fetchedClass = enrolledClasses.first;
      fetchedHomework = await HomeworkRepo().getHomeworkByClass(fetchedClass['id']);
    }

    setState(() {
      user = fetchedUser;
      classData = fetchedClass;
      homeworkData = fetchedHomework;
      availableClasses = enrolledClasses;
    });
  }

  Future<void> _selectClass(Map<String, dynamic> newClass) async {
    final classId = newClass['id'];
    await UserRepo().joinClass(widget.userId, classId);
    final fetchedHomework = await HomeworkRepo().getHomeworkByClass(classId);

    setState(() {
      classData = newClass;
      homeworkData = fetchedHomework;
    });
  }
  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StudentProfileHeader(user: user!),
                SizedBox(height: 20),
                _TitleHeader(
                  user: user,
                  classData: classData,
                  classes: availableClasses,
                  onClassSelected: _selectClass,
                ),
                SizedBox(height: 20),
                CardAttendance(),
                SizedBox(height: 20),
                _GridInfo(),
                SizedBox(height: 20),
                _Classes(classData: classData),
                SizedBox(height: 20),
                _Homework(homeworkData: homeworkData)
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TitleHeader extends StatefulWidget {
  final Map<String, dynamic>? user;
  final Map<String, dynamic>? classData;
  final List<Map<String, dynamic>>? classes;
  final ValueChanged<Map<String, dynamic>>? onClassSelected;

  const _TitleHeader({
    this.user,
    this.classData,
    this.classes,
    this.onClassSelected,
  });

  @override
  State<_TitleHeader> createState() => _TitleHeaderState();
}

class _TitleHeaderState extends State<_TitleHeader> {
  String getKhmerDate() {
    DateTime now = DateTime.now();

    List<String> khmerWeekDays = [
      "ថ្ងៃច័ន្ទ",
      "ថ្ងៃអង្គារ",
      "ថ្ងៃពុធ",
      "ថ្ងៃព្រហស្បតិ៍",
      "ថ្ងៃសុក្រ",
      "ថ្ងៃសៅរ៍",
      "ថ្ងៃអាទិត្យ",
    ];

    List<String> khmerMonths = [
      "មករា",
      "កុម្ភៈ",
      "មីនា",
      "មេសា",
      "ឧសភា",
      "មិថុនា",
      "កក្កដា",
      "សីហា",
      "កញ្ញា",
      "តុលា",
      "វិច្ឆិកា",
      "ធ្នូ",
    ];

    String weekDay = khmerWeekDays[now.weekday - 1];
    String month = khmerMonths[now.month - 1];

    return "$weekDay ទី ${now.day} ខែ $month ឆ្នាំ ${now.year}";
  }

  @override
  Widget build(BuildContext context) {
    final firstName = widget.user?['first_name'] ?? '';
    final lastName = widget.user?['last_name'] ?? '';
    final fullName = ('$firstName $lastName').trim();
    final greeting = fullName.isNotEmpty ? 'សួស្តី $firstName! ' : 'សួស្តី! ';

    final className = widget.classData != null
        ? '${widget.classData!['grade']} ${widget.classData!['section']}'
        : 'ថ្នាក់មិនបានកំណត់';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          getKhmerDate(),
          style: AppTextStyle.body,
        ),
        SizedBox(height: 12),
        Text(greeting, style: AppTextStyle.title28),
        SizedBox(height: 12),
        GestureDetector(
          onTap: () {
            if (widget.classes != null && widget.classes!.isNotEmpty) {
              showModalBottomSheet(
                context: context,
                backgroundColor: AppColors.white,
                showDragHandle: true,
                builder: (context) {
                  return ListView.separated(
                    padding: EdgeInsets.symmetric(vertical: 0),
                    itemCount: widget.classes!.length,
                    separatorBuilder: (context, index) => Divider(height: 1),
                    itemBuilder: (context, index) {
                      final cls = widget.classes![index];
                      final label = '${cls['grade']} ${cls['section']}';
                      final isSelected = widget.classData != null && cls['id'] == widget.classData!['id'];
                      return ListTile(
                        title: Text(label, style: AppTextStyle.body),
                        trailing: isSelected ? Icon(Icons.check, color: AppColors.primaryMain) : null,
                        onTap: () {
                          Navigator.pop(context);
                          widget.onClassSelected?.call(cls);
                        },
                      );
                    },
                  );
                },
              );
            }
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                className,
                style: AppTextStyle.subtitle18
                    .copyWith(color: AppColors.secondaryText),
              ),
              SizedBox(width: 8),
              CircleAvatar(
                radius: 14,
                backgroundColor: AppColors.primaryMain.withOpacity(0.12),
                child: Icon(
                  Icons.keyboard_arrow_down,
                  size: 18,
                  color: AppColors.primaryMain,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Homework extends StatefulWidget {
  final List<Map<String, dynamic>> homeworkData;
  const _Homework({required this.homeworkData});

  @override
  State<_Homework> createState() => _HomeworkState();
}

class _HomeworkState extends State<_Homework> {
  @override
  Widget build(BuildContext context) {
    if (widget.homeworkData.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'កិច្ចការផ្ទះ',
            style: AppTextStyle.fontsize18,
          ),
          SizedBox(height: 10),
          Container(
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.white, width: 0.5),
            ),
            child: Center(
              child: Text(
                'មិនមានកិច្ចការផ្ទះ',
                style: AppTextStyle.body,
              ),
            ),
          ),
        ],
      );
    }

    final homework = widget.homeworkData.first;
    final subject = homework['subject'] ?? 'មិនបានកំណត់';
    final deadline = homework['deadline'] ?? 'មិនបានកំណត់';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'កិច្ចការផ្ទះ',
          style: AppTextStyle.fontsize18,
        ),
        SizedBox(height: 10),
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, '/detailscreen');
          },
          child: Container(
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.white, width: 0.5),
            ),
            child: Center(
              child: ListTile(
                leading: CircleAvatar(
                  radius: 30,
                  child: Icon(Icons.calculate_outlined,
                      size: 40, color: AppColors.primary400),
                ),
                title: Text(subject,
                    style: AppTextStyle.body
                        .copyWith(fontWeight: FontWeight.bold)),
                subtitle: Text(
                  deadline,
                  style: AppTextStyle.body,
                ),
                trailing: Icon(
                  Icons.chevron_right,
                  size: 40,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}

class _Classes extends StatelessWidget {
  final Map<String, dynamic>? classData;
  const _Classes({this.classData});

  @override
  Widget build(BuildContext context) {
    final teacherName = classData?['teacher_name'] ?? 'មិនបានកំណត់';
    final subject = 'គណិតវិទ្យា'; 

    return Column(
      children: [
        Row(
          children: [
            Text('ថ្នាក់បន្ទាប់', style: AppTextStyle.fontsize18),
          ],
        ),
        SizedBox(height: 12),
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, '/detailteascreen');
          },
          child: Container(
            padding: EdgeInsets.all(12),
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.white, width: 0.5),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  child: Icon(Icons.calculate_outlined,
                      size: 40, color: AppColors.primary400),
                ),
                SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(subject,
                        style: AppTextStyle.body
                            .copyWith(fontWeight: FontWeight.bold)),
                    Text(
                      'គ្រូបង្រៀន​: $teacherName',
                      style: AppTextStyle.hint15,
                    ),
                  ],
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}

class _GridInfo extends StatelessWidget {
  const _GridInfo();

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      itemCount: items.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
      ),
      itemBuilder: (context, index) {
        final item = items[index];
        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, item.route);
          },
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: item.bgColor),
                  child: Image.asset(
                    item.img,
                    color: item.imgColor,
                  ),
                ),
                SizedBox(height: 12),
                Text(item.title, style: AppTextStyle.body.copyWith(fontWeight: FontWeight.bold))
              ],
            ),
          ),
        );
      },
    );
  }
}
