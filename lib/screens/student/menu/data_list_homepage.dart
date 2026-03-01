// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:tamdansers_app/constants/app_colors.dart';

class Item {
  final String title;
  final IconData icon;
  final Color iconColor;
  final Color bgColor;
  final String route;
  Item({
    required this.title,
    required this.icon,
    required this.bgColor,
    required this.iconColor,
    required this.route,
  });
}

final List<Item> items = [
  Item(
      title: 'កាលវិភាគ',
      icon: Icons.schedule,
      bgColor: AppColors.primaryBg,
      iconColor: AppColors.primary400,
      route: '/student_scedeul'),
  Item(
      title: 'លទ្ធផល',
      icon: Icons.bar_chart,
      bgColor: AppColors.errorBG,
      iconColor: AppColors.error,
      route: '/student_result'),
  Item(
      title: 'ដំណឹង',
      icon: Icons.bookmark,
      bgColor: AppColors.lightPink,
      iconColor: AppColors.pepure,
      route: '/notifications'),
];
