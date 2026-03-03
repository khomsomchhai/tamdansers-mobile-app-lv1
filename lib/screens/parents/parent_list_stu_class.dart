import 'package:flutter/material.dart';
import 'package:tamdansers_app/constants/app_colors.dart';
import 'package:tamdansers_app/constants/app_number.dart';
import 'package:tamdansers_app/constants/text_style.dart';
import 'package:tamdansers_app/screens/parents/widget/parent_profile_header.dart';

class ParentListStuClass extends StatefulWidget {
  const ParentListStuClass({super.key});

  @override
  State<ParentListStuClass> createState() => _ParentListStuClassState();
}

class _ParentListStuClassState extends State<ParentListStuClass> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ParentProfileHeader(
            name: "Piseth",
            gender: "male",
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Row(
              children: [
                Icon(
                  Icons.account_circle_rounded,
                  size: AppNumber.iconLarge,
                  color: AppColors.primaryText,
                ),
                SizedBox(
                  width: 8,
                ),
                Text("គណនីសិស្ស", style: AppTextStyle.subtitle18),
              ],
            ),
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            // child: StudentHasJoinedClass(userId: user['id'],),
          )),
        ],
      ),
    );
  }
}
