import 'package:flutter/material.dart';
import 'package:tamdansers_app/constants/app_colors.dart';
import 'package:tamdansers_app/constants/app_icon.dart';
import 'package:tamdansers_app/constants/app_number.dart';
import 'package:tamdansers_app/constants/text_style.dart';
import 'package:tamdansers_app/routes/app_routes.dart';

class ParentHasData extends StatefulWidget {
  const ParentHasData({super.key});

  @override
  State<ParentHasData> createState() => _ParentHasDataState();
}

class _ParentHasDataState extends State<ParentHasData> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 30,),
        Row(
          children: [
            Icon(
              Icons.account_circle_rounded,
              size: AppNumber.iconLarge,
              color: AppColors.primaryMain,
            ),
            Text(
              "គណនីសិស្ស",
              style: AppTextStyle.sectionTitle20
            ),
          ],
        ),
        // SizedBox(height: 8,),
        Expanded(
          child: ListView.separated(
            padding: EdgeInsets.all(16),
            itemCount: 3,
            separatorBuilder: (context, index){
              return SizedBox(height: 12,);
            },
            itemBuilder: (context, index){
              return GestureDetector(
                onTap: (){
                  Navigator.pushNamed(
                    context,
                    AppRoutes.parentListStuClass
                  );
                },
                child: _studentCard()
              );
            },
            
          ),
        ),
      ],
    );
  }

  Widget _studentCard() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppNumber.radiusMedium),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryText.withValues(alpha: 0.1),
            blurRadius: 8,
          )
        ]
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.primaryMain.withValues(alpha: 0.2),
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage(AppIcon.maleAvatar),
                fit: BoxFit.cover
              )
            ),
          ),
          SizedBox(width: 16,),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "រុន​ លីមហុង",
                  style: AppTextStyle.subtitle16
                ),
                SizedBox(height: 4,),
                Text(
                  "ID: stu300343",
                  style: AppTextStyle.caption14Secondary
                ),
                SizedBox(height: 4,),
                Text(
                  "limhong@gmail.com",
                  style: AppTextStyle.caption14Secondary
                )
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios_rounded, 
            size: AppNumber.iconSmall, 
            color: AppColors.secondaryText, 
          )
        ],
      ),
    );
  }
}