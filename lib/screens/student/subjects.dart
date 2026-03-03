import 'package:flutter/material.dart';
import 'package:tamdansers_app/constants/app_colors.dart';
import 'package:tamdansers_app/constants/text_style.dart';

class Subjects extends StatefulWidget {
  const Subjects({super.key});

  @override
  State<Subjects> createState() => _SubjectsState();
}

class _SubjectsState extends State<Subjects> {
  bool isExpanded = false;
  final totalLesson = 10;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(
          Icons.chevron_left,
          size: 40,
          color: AppColors.secondaryText,
        ),
        title: Text('គណិតវិទ្យា', style: AppTextStyle.sectionTitle20),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _card_sbj(),
              SizedBox(height: 20),
              _lesson_list(),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _lesson_list() {
    return Column(
      children: [
        Row(
          children: [
            Text('មេរៀន', style: AppTextStyle.fontsize18),
            Spacer(),
            if (totalLesson > 2)
              TextButton(
                onPressed: () {
                  setState(() {
                    isExpanded = !isExpanded;
                  });
                },
                child: Text(
                  isExpanded ? 'បង្ហាញតិច' : 'បង្ហាញទាំងអស់',
                  style: AppTextStyle.body.copyWith(
                      color: AppColors.success, fontWeight: FontWeight.bold),
                ),
              ),
          ],
        ),
        SizedBox(height: 10),
        Column(
          children: [
            ListView.separated(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              separatorBuilder: (context, index) {
                return SizedBox(height: 10);
              },
              itemBuilder: (context, index) {
                return _lesson();
              },
              itemCount: isExpanded ? totalLesson : 2,
            )
          ],
        )
      ],
    );
  }

  Widget _lesson() {
    return Container(
      padding: EdgeInsets.all(14),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: AppColors.white,
      ),
      child: Row(
        children: [
          Container(
            height: 45,
            width: 45,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: AppColors.primaryBg,
            ),
            child: Icon(Icons.book, color: AppColors.primaryMain),
          ),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('មេរៀនទី១ : ចំនួនពិត',
                  style:
                      AppTextStyle.body.copyWith(fontWeight: FontWeight.bold)),
              Text(
                'បញ្ចប់តាំងពី ម្សិលមិញ',
                style: AppTextStyle.body,
              )
            ],
          ),
          Spacer(),
          Icon(
            Icons.chevron_right,
            color: AppColors.success,
          )
        ],
      ),
    );
  }

  Widget _card_sbj() {
    return Container(
      padding: EdgeInsets.all(12),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.secondaryText, width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: AppColors.primaryMain,
            ),
            child: Image.asset('assets/images/user_profile.png'),
          ),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('គណិតវិទ្យា', style: AppTextStyle.fontsize18),
              Text('លោកគ្រូ : រុន លីមហុង',
                  style: AppTextStyle.body
                      .copyWith(color: AppColors.secondaryText)),
              SizedBox(height: 10),
              Row(
                children: [
                  Column(
                    children: [
                      Text('មធ្យមភាគ', style: AppTextStyle.body),
                      Text('43.25',
                          style: AppTextStyle.fontsize18
                              .copyWith(color: AppColors.primary300)),
                    ],
                  ),
                  SizedBox(width: 30),
                  Container(
                    width: 1,
                    height: 35,
                    color: AppColors.secondaryText,
                  ),
                  SizedBox(width: 30),
                  Column(
                    children: [
                      Text('វត្តមាន', style: AppTextStyle.body),
                      Text('80%',
                          style: AppTextStyle.fontsize18
                              .copyWith(color: AppColors.success)),
                    ],
                  ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
