import 'package:flutter/material.dart';
import 'package:tamdansers_app/constants/app_colors.dart';
import 'package:tamdansers_app/constants/text_style.dart';
import 'package:tamdansers_app/repositories/attendance_repo.dart';
import 'package:tamdansers_app/repositories/class_repo.dart';
import 'package:tamdansers_app/repositories/homework_repo.dart';
import 'package:tamdansers_app/repositories/student_class_repo.dart';
import 'package:tamdansers_app/repositories/user_repo.dart';
import 'package:tamdansers_app/routes/app_routes.dart';
import 'package:tamdansers_app/screens/student/menu/data_list_homepage.dart';
import 'package:tamdansers_app/screens/student/widget/student_profile_header.dart';
import 'package:tamdansers_app/widget/attendance_db.dart';

class Homepage extends StatefulWidget {
  final int userId;
  final int? selectedClassId;
  const Homepage({super.key, required this.userId, this.selectedClassId});

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

  int? _totalDays;
  int? _presentDays;
  int? _absentDays;
  double? _attendanceRate;

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
        enrolledClasses =
            await StudentClassRepo().getEnrolledClassesByEmail(email);
      }
    }
    if (enrolledClasses.isEmpty &&
        fetchedUser != null &&
        fetchedUser['class_id'] != null) {
      final fetchedClass =
          await ClassRepo().getClassById(fetchedUser['class_id']);
      if (fetchedClass != null) {
        enrolledClasses = [fetchedClass];
      }
    }

    Map<String, dynamic>? fetchedClass;
    List<Map<String, dynamic>> fetchedHomework = [];
    
    if (widget.selectedClassId != null) {
      fetchedClass = enrolledClasses.firstWhere(
        (cls) => cls['id'] == widget.selectedClassId,
        orElse: () => enrolledClasses.isNotEmpty ? enrolledClasses.first : {},
      );
      if (fetchedClass.isEmpty) {
        fetchedClass = null;
      }
    } else if (enrolledClasses.isNotEmpty) {
      fetchedClass = enrolledClasses.first;
    }
    
    if (fetchedClass != null) {
      fetchedHomework =
          await HomeworkRepo().getHomeworkByClass(fetchedClass['id']);
      
      final studentClassRecord = await StudentClassRepo()
          .getStudentClassByUserIdAndClassId(widget.userId, fetchedClass['id']);
      
      if (studentClassRecord != null) {
        final attendanceRepo = AttendanceRepo();
        final summary = await attendanceRepo.getAttendanceSummaryForStudent(
            studentClassRecord['id'], fetchedClass['id'], DateTime.now().toIso8601String().substring(0, 7));
        final total = summary['total'] ?? 0;
        final present = summary['present'] ?? 0;
        final late = summary['late'] ?? 0;
        final absent = summary['absent'] ?? 0;
        final presentDays = present + late;
        setState(() {
          _totalDays = total;
          _presentDays = presentDays;
          _absentDays = absent;
          _attendanceRate = total == 0 ? 0 : (presentDays / total) * 100;
        });
      }
    }
    setState(() {
      user = fetchedUser;
      classData = fetchedClass;
      homeworkData = fetchedHomework;
      availableClasses = enrolledClasses;
    });
  }

  String _currentKhmerMonth() {
    const months = [
      'មករា',
      'កុម្ភៈ',
      'មីនា',
      'មេសា',
      'ឧសភា',
      'មិថុនា',
      'កក្កដា',
      'សីហា',
      'កញ្ញា',
      'តុលា',
      'វិច្ឆិកា',
      'ធ្នូ',
    ];
    return months[DateTime.now().month - 1];
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
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StudentProfileHeader(user: user!),
                SizedBox(height: 20),
                _TitleHeader(
                  user: user,
                  classData: classData,
                ),
                SizedBox(height: 20),
                CardAttendance(
                  totalDays: _totalDays ?? 0,
                  presentDays: _presentDays ?? 0,
                  absentDays: _absentDays ?? 0,
                  attendanceRate: _attendanceRate ?? 0,
                  monthLabel: _currentKhmerMonth(),
                ),
                SizedBox(height: 20),
                _GridInfo(userId: widget.userId, selectedClassId: widget.selectedClassId),
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
String getGreeting() {
  final hour = DateTime.now().hour;
  if (hour < 12) {
    return "អរុណសួស្តី";
  } else if (hour < 17) {
    return "ទិវាសួស្ដី";
  } else if (hour < 21){
    return "សាយណ្ហសួស្ដី";
  } else {
    return "រាត្រីសួស្ដី";
  }
}
class _TitleHeader extends StatefulWidget {
  final Map<String, dynamic>? user;
  final Map<String, dynamic>? classData;

  const _TitleHeader({
    this.user,
    this.classData,
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
    final greeting = fullName.isNotEmpty ? '${getGreeting()} $firstName ' : 'សួស្តី! ';

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
        Text(
          className,
          style: AppTextStyle.subtitle18
              .copyWith(color: AppColors.secondaryText),
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
                  child: Icon(Icons.assignment_outlined,
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
    final teacherName = classData?['teacher_name'] ?? 'Somchhai Khom';
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
                      'គ្រូបង្រៀន​: ${teacherName?? "Somchhai Khom"}',
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
  final int userId;
  final int? selectedClassId;
  const _GridInfo({required this.userId, this.selectedClassId});

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
          onTap: () async {
            if (item.route == AppRoutes.result && selectedClassId != null) {
              final studentClassRecord = await StudentClassRepo()
                  .getStudentClassByUserIdAndClassId(userId, selectedClassId!);
              if (studentClassRecord != null) {
                Navigator.pushNamed(
                  context,
                  item.route,
                  arguments: {
                    'studentClassId': studentClassRecord['id'] as int,
                    'classId': selectedClassId,
                  },
                );
              }
            } else {
              Navigator.pushNamed(context, item.route);
            }
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
                Text(item.title,
                    style:
                        AppTextStyle.body.copyWith(fontWeight: FontWeight.bold))
              ],
            ),
          ),
        );
      },
    );
  }
}
