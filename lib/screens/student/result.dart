import 'package:flutter/material.dart';
import 'package:tamdansers_app/constants/app_colors.dart';
import 'package:tamdansers_app/constants/text_style.dart';
import 'package:tamdansers_app/screens/student/data_result.dart';
import 'package:tamdansers_app/screens/student/data_schedule.dart';

class Result extends StatefulWidget {
  const Result({super.key});

  @override
  State<Result> createState() => _ResultState();
}

class _ResultState extends State<Result> {
  int selectIndex = 0;

  late List<MonthResult> monthResults;

@override
void initState() {
  super.initState();

  monthResults = List.generate(12, (monthIndex) {
    final subjects = [
      SubjectResult(
        subject: SubjectModel.geography,
        teacher: Teachers.rith,
        score: 70 + monthIndex.toDouble(),
      ),
      SubjectResult(
        subject: SubjectModel.math,
        teacher: Teachers.sokha,
        score: 80 + monthIndex.toDouble(),
      ),
      SubjectResult(
        subject: SubjectModel.physics,
        teacher: Teachers.virak,
        score: 75 + monthIndex.toDouble(),
      ),
      SubjectResult(
        subject: SubjectModel.chemistry,
        teacher: Teachers.lina,
        score: 85 + monthIndex.toDouble(),
      ),
      SubjectResult(
        subject: SubjectModel.biology,
        teacher: Teachers.chanda,
        score: 78 + monthIndex.toDouble(),
      ),
      SubjectResult(
        subject: SubjectModel.history,
        teacher: Teachers.sophal,
        score: 82 + monthIndex.toDouble(),
      ),
      SubjectResult(
        subject: SubjectModel.khmer,
        teacher: Teachers.chan,
        score: 88 + monthIndex.toDouble(),
      ),
    ];

    final total =
        subjects.map((e) => e.score).reduce((a, b) => a + b);

    return MonthResult(
      totalScore: total,
      maxScore: 700,
      rank: monthIndex + 1,
      average: total / subjects.length,
      subjects: subjects,
    );
  });
}
  @override
  Widget build(BuildContext context) {
    final data = monthResults[selectIndex];
    return Scaffold(
        appBar: AppBar(
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
                  itemCount: data.subjects.length,
                  itemBuilder: (context, index) {
                    return _score(data.subjects[index]);
                  },
                )
              ],
            ),
          ),
        ));
  }

  Widget _score(SubjectResult subject) {
    double maxScore = 100;
    return Container(
      padding: EdgeInsets.all(18),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primaryMain, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(5),
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: subject.subject.bgIconColor,
                  borderRadius: BorderRadius.circular(12)
                ),
                child: Icon(
                  subject.subject.icon,
                  color: subject.subject.iconColor,
                )
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(subject.subject.name, style: AppTextStyle.fontsize18),
                  Text('លោកគ្រូ​​ : ${subject.teacher.name}', style: AppTextStyle.body),
                ],
              )
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(subject.score.toString(), style: AppTextStyle.sectionTitle20),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: LinearProgressIndicator(
                  minHeight: 8,
                  value: subject.score / maxScore,
                  backgroundColor: AppColors.primaryBg,
                  valueColor:
                      AlwaysStoppedAnimation<Color>(AppColors.primaryMain),
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
            color: AppColors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.white, width: 1),
          ),
          child: Text('Status'),
        )
      ],
    );
  }

  Widget _table_result() {
    final data = monthResults[selectIndex];
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
                flex: 3,
                child: Column(
                  children: [
                    Text('ពិន្ទុសរុប',
                        style: AppTextStyle.subtitle16
                            .copyWith(color: AppColors.white)),
                    SizedBox(height: 20),
                    Text('${data.totalScore} of ${data.maxScore}',
                        textAlign: TextAlign.center,
                        style:
                            AppTextStyle.body.copyWith(color: AppColors.white,fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              Container(
                height: 100,
                width: 2,
                color: AppColors.white,
              ),
              Expanded(
                flex: 4,
                child: Column(
                  children: [
                    Text('ចំណាត់ថ្នាក់',
                        style: AppTextStyle.fontsize18
                            .copyWith(color: AppColors.white)),
                    SizedBox(height: 10),
                    Text('${data.rank}',
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
                flex: 3,
                child: Column(
                  children: [
                    Text('មធ្យមភាគ',
                        style: AppTextStyle.subtitle16
                            .copyWith(color: AppColors.white)),
                    SizedBox(height: 20),
                    Text(' ${data.calculatedAverage.toStringAsFixed(2)} ',
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
    List<String> months = [
      'ខែមករា',
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
      'ធ្នូ'
    ];
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
          return GestureDetector(
              onTap: () {
                setState(() {
                  selectIndex = index;
                });
              },
              child: Container(
                height: 30,
                width: 100,
                decoration: BoxDecoration(
                    color: index == selectIndex
                        ? AppColors.primary400
                        : AppColors.white,
                    borderRadius: BorderRadius.circular(12)),
                child: Center(
                  child: Text(
                    months[index],
                    style: AppTextStyle.subtitle16.copyWith(
                        color: index == selectIndex
                            ? AppColors.white
                            : AppColors.secondaryText),
                  ),
                ),
              ));
        },
      ),
    );
  }
}
