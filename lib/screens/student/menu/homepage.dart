import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tamdansers_app/constants/app_colors.dart';
import 'package:tamdansers_app/constants/text_style.dart';
import 'package:tamdansers_app/widget/attendance_db.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Container(
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.primaryMain,
                    width: 2.0,
                  )),
              child: CircleAvatar(
                  child: SvgPicture.asset("assets/images/app_logo_blue.svg"))),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Run Limhong',
              style: AppTextStyle.sectionTitle20,
            ),
            Text(
              'ID: 12345678',
              style: AppTextStyle.body.copyWith(color: AppColors.secondaryText),
            ),
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
      ),
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
}

class _TitleHeader extends StatelessWidget {
  const _TitleHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ថ្ងៃច័ន្ទ ទី 5 ខែ មីនា ឆ្នាំ 2026',
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
        Container(
          height: 80,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.secondaryText, width: 0.5),
          ),
          child: Center(
            child: ListTile(
              leading: CircleAvatar(
                radius: 30,
                child: Icon(Icons.calculate_outlined,
                    size: 40, color: AppColors.primary400),
              ),
              title: Text('គណិតវិទ្យា', style: AppTextStyle.fontsize18),
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
            Spacer(),
            Text('មើលទាំងអស់',
                style: AppTextStyle.hintText.copyWith(color: AppColors.link)),
          ],
        ),
        SizedBox(height: 12),
        Container(
          padding: EdgeInsets.all(12),
          height: 80,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.secondaryText, width: 0.5),
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
                  Text('គណិតវិទ្យា', style: AppTextStyle.fontsize18),
                  Text(
                    'គ្រូបង្រៀន​: លោក សុខា',
                    style: AppTextStyle.body,
                  ),
                ],
              )
            ],
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
        itemCount: 3,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 12,
        ),
        itemBuilder: (context, index) {
          return Container(
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
                      shape: BoxShape.circle, color: AppColors.primaryBg),
                  child: Icon(
                    Icons.qr_code,
                    size: 40,
                    color: AppColors.primary400,
                  ),
                ),
                Text('ស្កេន QR', style: AppTextStyle.body)
              ],
            ),
          );
        },
      ),
    );
  }
}
