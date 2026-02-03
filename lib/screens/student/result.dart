import 'package:flutter/material.dart';
import 'package:tamdansers_app/constants/app_colors.dart';
import 'package:tamdansers_app/constants/text_style.dart';

class Result extends StatefulWidget {
  const Result({super.key});

  @override
  State<Result> createState() => _ResultState();
}

class _ResultState extends State<Result> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 7,
      child: Scaffold(
          appBar: AppBar(
            leading: Icon(
              Icons.chevron_left,
              size: 40,
              color: AppColors.secondaryText,
            ),
            title: Text('លទ្ធផល', style: AppTextStyle.sectionTitle20),
            centerTitle: true,
          ),
          body: Column(
            children: [
              Row(
                children: [
                  TabBar(
                    indicatorColor: AppColors.primaryMain,
                    labelColor: AppColors.primaryMain,
                    unselectedLabelColor: AppColors.secondaryText,
                    tabs: const [
                      Tab(text: 'ឈ្មោះ'),
                      Tab(text: 'ឈ្មោះ'),
                      Tab(text: 'ឈ្មោះ'),
                      Tab(text: 'ឈ្មោះ'),
                    ])
                ],
              )
            ],
          )
        ),
    );
  }
}
