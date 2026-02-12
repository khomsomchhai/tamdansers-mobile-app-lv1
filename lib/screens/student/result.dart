import 'package:flutter/material.dart';
import 'package:tamdansers_app/constants/app_colors.dart';
import 'package:tamdansers_app/constants/text_style.dart';

class Result extends StatefulWidget {
  const Result({super.key});

  @override
  State<Result> createState() => _ResultState();
}

class _ResultState extends State<Result> {
  double score = 42;
  double maxScore = 50;

  late double progress = score / maxScore; // 0.42

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: Icon(
            Icons.chevron_left,
            size: 40,
            color: AppColors.secondaryText,
          ),
          title: Text('លទ្ធផល', style: AppTextStyle.sectionTitle20),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _list_month(),
                SizedBox(height: 20),
                _table_result(),
                SizedBox(height: 20),
                _status(),
                SizedBox(height: 20),
                ListView.separated(
                  separatorBuilder: (context, index) {
                    return SizedBox(
                      height: 10,
                    );
                  },
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: 7,
                  itemBuilder: (context, index) {
                    return _score();
                  },
                )
              ],
            ),
          ),
        ));
  }

  Widget _score() {
    return Container(
                padding: EdgeInsets.all(18),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border:
                      Border.all(color: AppColors.secondaryText, width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(2),
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: AppColors.primaryBg,
                          ),
                          child: Image.asset(
                            'assets/images/user_profile.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('ភូមិវិទ្យា',
                                style: AppTextStyle.fontsize18),
                            Text('លោកគ្រូ​​ : រុន លីមហុង',
                                style: AppTextStyle.body),
                          ],
                        )
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(score.toString(), style: AppTextStyle.sectionTitle20),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: LinearProgressIndicator(
                            minHeight: 8,
                            value: score / maxScore,
                            backgroundColor: AppColors.primaryBg,
                            valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.primaryMain),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              );
  }

  Widget _status() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('វាយតម្លៃពីគ្រូ', style: AppTextStyle.sectionTitle20),
        SizedBox(height: 10),
        Container(
          padding: EdgeInsets.all(20),
          height: 100,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.secondaryText, width: 1),
          ),
          child: Text('Status'),
        )
      ],
    );
  }

  Widget _table_result() {
    return Container(
      padding: EdgeInsets.all(20),
      height: 300,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.primaryMain,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(shape: BoxShape.circle),
            clipBehavior: Clip.antiAlias,
            child: Image.asset('assets/images/user_profile.png',
                fit: BoxFit.cover),
          ),
          SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  children: [
                    Text('ពិន្ទុសរុប',
                        style: AppTextStyle.fontsize18
                            .copyWith(color: AppColors.white)),
                    SizedBox(height: 20),
                    Text('400\nof 500',
                        textAlign: TextAlign.center,
                        style: AppTextStyle.fontsize18
                            .copyWith(color: AppColors.white)),
                  ],
                ),
              ),
              Container(
                height: 100,
                width: 2,
                color: AppColors.white,
              ),
              Expanded(
                child: Column(
                  children: [
                    Text('ចំណាត់ថ្នាក់',
                        style: AppTextStyle.sectionTitle20
                            .copyWith(color: AppColors.white)),
                    SizedBox(height: 10),
                    Text('5',
                        style: AppTextStyle.title28
                            .copyWith(color: AppColors.white)),
                  ],
                ),
              ),
              Container(
                height: 100,
                width: 2,
                color: AppColors.white,
              ),
              Expanded(
                child: Column(
                  children: [
                    Text('មធ្យមភាគ',
                        style: AppTextStyle.fontsize18
                            .copyWith(color: AppColors.white)),
                    SizedBox(height: 20),
                    Text('43.25',
                        style: AppTextStyle.fontsize18
                            .copyWith(color: AppColors.white)),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _list_month() {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        separatorBuilder: (context, index) {
          return SizedBox(
            width: 10,
          );
        },
        itemCount: 12,
        itemBuilder: (context, index) {
          return Container(
            height: 30,
            width: 100,
            decoration: BoxDecoration(
                color: AppColors.primaryMain,
                borderRadius: BorderRadius.circular(12)),
            child: Center(
              child: Text(
                'ខែមករា',
                style: AppTextStyle.fontsize18.copyWith(color: AppColors.white),
              ),
            ),
          );
        },
      ),
    );
  }
}
