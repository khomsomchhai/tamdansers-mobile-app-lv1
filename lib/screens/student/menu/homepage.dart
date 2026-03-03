import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tamdansers_app/constants/app_colors.dart';
import 'package:tamdansers_app/constants/text_style.dart';
import 'package:tamdansers_app/screens/student/menu/data_list_homepage.dart';
import 'package:tamdansers_app/widget/attendance_db.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  bool isExpend = false;
  final totalClass = 10;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buil_appbar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _TitleHeader(),
              SizedBox(height: 20),
              CardAttendance(),
              SizedBox(height: 20),
              _GridInfo(),
              SizedBox(height: 20),
              _Classes(),
              SizedBox(height: 20),
              _Homework()
            ],
          ),
        ),
      ),
    );
  }

  AppBar _buil_appbar() {
    return AppBar(
      leading: Container(
          margin: EdgeInsets.only(left: 16),
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.primaryMain,
                width: 2.0,
              )),
          child: CircleAvatar(
              child: SvgPicture.asset("assets/images/app_logo_blue.svg"))),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Run Limhong',
            style: AppTextStyle.sectionTitle20,
          ),
          Text('ID: 123456789',
              style: AppTextStyle.body.copyWith(color: AppColors.secondaryText))
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.notifications,
            color: AppColors.primaryText,
          ),
        )
      ],
    );
  }
}

class _TitleHeader extends StatefulWidget {
  const _TitleHeader();

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          getKhmerDate(),
          style: AppTextStyle.body,
        ),
        SizedBox(height: 8),
        Text('សួស្តី Limhong! ', style: AppTextStyle.screenTitle24),
        SizedBox(height: 10),
        Text(
          'ថ្នាក់ទី 8A',
          style: AppTextStyle.sectionTitle20
              .copyWith(color: AppColors.secondaryText),
        ),
      ],
    );
  }
}

class _Homework extends StatefulWidget {
  const _Homework();

  @override
  State<_Homework> createState() => _HomeworkState();
}

class _HomeworkState extends State<_Homework> {
  @override
  Widget build(BuildContext context) {
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
                title: Text('គណិតវិទ្យា',
                    style: AppTextStyle.body
                        .copyWith(fontWeight: FontWeight.bold)),
                subtitle: Text(
                  '11-1-2026',
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
  const _Classes();

  @override
  Widget build(BuildContext context) {
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
                    Text('គណិតវិទ្យា',
                        style: AppTextStyle.body
                            .copyWith(fontWeight: FontWeight.bold)),
                    Text(
                      'គ្រូបង្រៀន​: លោក សុខា',
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
    return Container(
      child: GridView.builder(
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
      ),
    );
  }
}