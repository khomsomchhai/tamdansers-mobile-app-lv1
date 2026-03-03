// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:tamdansers_app/constants/app_colors.dart';

class Item {
  final String title;
  final String img;
  final Color imgColor;
  final Color bgColor;
  final String route;
  
  Item({
    required this.title,
    required this.img,
    required this.bgColor,
    required this.imgColor,
    required this.route,
  });
}

final List<Item> items = [
  Item(
      title: 'កាលវិភាគ',
      img: 'assets/icons/schedule.png',
      bgColor: AppColors.primaryBg,
      imgColor: AppColors.primary400,
      route: '/student_scedeul'),
  Item(
      title: 'លទ្ធផល',
      img: 'assets/icons/result.png',
      bgColor: AppColors.errorBG,
      imgColor: AppColors.error,
      route: '/student_result'),
  Item(
      title: 'ដំណឹង',
      img: 'assets/icons/bell.png',
      bgColor: AppColors.lightPink,
      imgColor: AppColors.pepure,
      route: '/notification'),
];
