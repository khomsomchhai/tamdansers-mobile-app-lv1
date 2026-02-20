import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tamdansers_app/constants/app_colors.dart';
import 'package:tamdansers_app/constants/app_number.dart';
import 'package:tamdansers_app/routes/app_routes.dart';
import 'package:tamdansers_app/screens/parents/widget/parent_empty_data.dart';
import 'package:tamdansers_app/screens/parents/widget/parent_has_data.dart';
import 'package:tamdansers_app/screens/parents/widget/parent_profile_header.dart';

class ParentFirstScreen extends StatefulWidget {
  const ParentFirstScreen({super.key});

  @override
  State<ParentFirstScreen> createState() => _ParentFirstScreenState();
}

class _ParentFirstScreenState extends State<ParentFirstScreen> {
  bool hasData = true;
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
    return Scaffold(
      body: Column(
        children: [
          ParentProfileHeader(name: "Piseth", gender: "male",),
          Expanded(
            child: hasData 
            ? ParentHasData() 
            : ParentEmptyData()
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.pushNamed(
            context, 
            AppRoutes.parentConnectStudent
          );
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppNumber.radiusMedium)
        ),
        backgroundColor: AppColors.primaryMain,
        child: Icon(
          Icons.add,
          color: AppColors.white,
          size: AppNumber.iconLarge,
        ),
      ),
    );
  }
}