import 'package:flutter/material.dart';
import 'package:tamdansers_app/constants/app_colors.dart';
import 'package:tamdansers_app/constants/app_number.dart';
import 'package:tamdansers_app/routes/app_routes.dart';
import 'package:tamdansers_app/screens/student/widget/student_empty_class.dart';
import 'package:tamdansers_app/screens/student/widget/student_has_joined_class.dart';
import 'package:tamdansers_app/screens/student/widget/student_profile_header.dart';

class StudentFirstScreen extends StatefulWidget {
  const StudentFirstScreen({super.key});

  @override
  State<StudentFirstScreen> createState() => _StudentFirstScreenState();
}

class _StudentFirstScreenState extends State<StudentFirstScreen> {
  bool hasJoinedClass = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            children: [
              StudentProfileHeader(),
              SizedBox(height: 20,),
              Expanded(
                child: hasJoinedClass
                    ? StudentHasJoinedClass()
                    : StudentEmptyClass(),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryMain,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppNumber.radiusMedium),
        ),
        onPressed: () {
          Navigator.pushNamed(
            context, 
            AppRoutes.joinClassSreen
          );
        },
        child: Icon(
          Icons.add,
          color: AppColors.white,
          size: AppNumber.iconMedium,
        ),
      )
    );
  }
}