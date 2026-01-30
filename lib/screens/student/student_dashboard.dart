import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tamdansers_app/constants/app_colors.dart';
import 'package:tamdansers_app/constants/text_style.dart';

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({super.key});

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  var index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(
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
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.white,
        currentIndex: index,
        onTap: (value) {
          setState(() {
            index = value;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primaryMain,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'ទំព័រដើម',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.class_), label: 'កិច្ចការផ្ទះ'),
          BottomNavigationBarItem(
              icon: Icon(Icons.assignment), label: "វត្តមាន"),
          BottomNavigationBarItem(
              icon: Icon(Icons.person), label: 'ប្រវត្តិរូប'),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _titleheader(),
              SizedBox(height: 20),
              _cardAttendance(),
              SizedBox(height: 20),
              _grid_info(),
              SizedBox(height: 20),
              _classes(),
              SizedBox(height: 20),
              _homework()
            ],
          ),
        ),
      ),
    );
  }
}

class _titleheader extends StatelessWidget {
  const _titleheader({
    super.key,
  });

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

class _homework extends StatelessWidget {
  const _homework({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'កិច្ចការផ្ទះ',
          style: AppTextStyle.sectionTitle20,
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

class _classes extends StatelessWidget {
  const _classes({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text('ថ្នាក់បន្ទាប់', style: AppTextStyle.sectionTitle20),
            Spacer(),
            Text('មើលទាំងអស់',
                style: AppTextStyle.fontsize18.copyWith(color: AppColors.link)),
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

class _grid_info extends StatelessWidget {
  const _grid_info({
    super.key,
  });

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
                Text('ស្កេន QR', style: AppTextStyle.fontsize18)
              ],
            ),
          );
        },
      ),
    );
  }
}

class _cardAttendance extends StatelessWidget {
  const _cardAttendance({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryMain,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('វត្តមានប្រចាំខែ មករា 2026',
                  style: AppTextStyle.body.copyWith(color: AppColors.white)),
              Text('94%',
                  style: AppTextStyle.title28.copyWith(
                      color: AppColors.white, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundLight,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text("វត្តមាន​ 26",
                        style: AppTextStyle.body.copyWith(
                            color: AppColors.success,
                            fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(width: 10),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundLight,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text("អវត្តមាន​ 4",
                        style: AppTextStyle.body.copyWith(
                            color: AppColors.error,
                            fontWeight: FontWeight.bold)),
                  )
                ],
              )
            ],
          ),
          Spacer(),
        ],
      ),
    );
  }
}
