import 'package:flutter/material.dart';
import 'package:tamdansers_app/constants/app_colors.dart';

import '../../../constants/text_style.dart';
import '../../../routes/app_routes.dart';

class CustomScreen extends StatefulWidget {
  const CustomScreen({super.key});

  @override
  State<CustomScreen> createState() => _CustomScreenState();
}

class _CustomScreenState extends State<CustomScreen> {
  String selectedValue = "១២ មករា ២០២៤";

  final List<String> items = [
    "១២ មករា ២០២៤",
    "១៣ មករា ២០២៤",
    "១៤ មករា ២០២៤",
  ];
  final List<Map<String, dynamic>> subjects = [
    {
      "name": "គណិតវិទ្យា",
      "teacher": "លោកគ្រូ. វិបុល",
      "score": "៩០/១០០",
      "grade": "ល្អណាស់",
      "color": AppColors.success,
      "icon": Icons.calculate,
    },
    {
      "name": "ភាសាខ្មែរ",
      "teacher": "អ្នកគ្រូ. ស្រីនាង",
      "score": "៨៥/១០០",
      "grade": "ល្អ",
      "color": Colors.orange,
      "icon": Icons.menu_book,
    },
    {
      "name": "ភាសាអង់គ្លេស",
      "teacher": "Mr. John",
      "score": "៩៥/១០០",
      "grade": "ល្អខ្លាំង",
      "color": AppColors.success,
      "icon": Icons.language,
    },
    {
      "name": "រូបវិទ្យា",
      "teacher": "លោកគ្រូ. ដារ៉ា",
      "score": "៧៥/១០០",
      "grade": "មធ្យម",
      "color": Colors.red,
      "icon": Icons.science,
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          "របាយការណ៍",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _dateDropdown(),
              const SizedBox(height: 20),
              _studentCard(),
              const SizedBox(height: 15),
              _rankDashboard(),
              const SizedBox(height: 20),
              _sectionHeader(),
              const SizedBox(height: 15),
              _subjectList(),
              const SizedBox(height: 15),
              _commentCard(
                  'ដារ៉ាបង្ហាញពីការរីកចម្រើនគួរអោយកត់សម្គាល់លើមុខវិជ្ជាគណិតវិទ្យាក្នុងខែនេះទោះជាយ៉ាងណាក៏ដោយគាត់ត្រូវផ្ដោតអារម្មណ៍បន្ថែមទៀតលើមុខវិជ្ជាប្រវត្តិវិទ្យាជាទូទៅការសិក្សារបស់គាត់មានភាពល្អប្រសើរ!'),
              SizedBox(height: 20),
              _saveCard()
            ],
          ),
        ),
      ),
    );
  }

  Widget _dateDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedValue,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down),
          items: items.map((e) {
            return DropdownMenuItem(
              value: e,
              child: Text(e, style: const TextStyle(fontSize: 14)),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectedValue = value!;
            });
          },
        ),
      ),
    );
  }

  Widget _studentCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            margin: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: NetworkImage(
                    "https://cdn-icons-png.flaticon.com/512/149/149071.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:[
                Text(
                  "ប៊ិន​ សុវណ្ណវង្ស",
                  style: AppTextStyle.subtitle16.copyWith(color: AppColors.grey),
                ),
                SizedBox(height: 4),
                Text(
                  "ID: STU-2023-89. ថ្នាក់ទី ១២ ក",  
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _sectionHeader() {
    return Row(
      children: [
        Text("មុខវិជ្ជា", style: AppTextStyle.fontsize18),
        const Spacer(),
        Text("មើលទាំងអស់", style: AppTextStyle.til16),
      ],
    );
  }

  Widget _subjectList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: subjects.length,
      itemBuilder: (context, index) {
        final subject = subjects[index];

        return Container(
          height: 90,
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue[100],
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  subject["icon"],
                  color: AppColors.primaryMain,
                  size: 35,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(subject["name"], style: AppTextStyle.subtitle18),
                    Text(
                      "គ្រូបង្រៀន: ${subject["teacher"]}",
                      style: AppTextStyle.bodySecondary,
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(subject["score"], style: AppTextStyle.subtitle18),
                  Text(
                    subject["grade"],
                    style: AppTextStyle.bodySecondary
                        .copyWith(color: subject["color"]),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _commentCard(String comment) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("មតិគ្រូបង្រៀន", style: AppTextStyle.subtitle18),
        SizedBox(height: 15),
        Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            comment,
            style: AppTextStyle.bodySecondary,
          ),
        ),
      ],
    );
  }

  Widget _saveCard() {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, AppRoutes.commentScreen);
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.primaryMain,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          "រក្សាទុក",
          style: AppTextStyle.subtitle16.copyWith(color: AppColors.white),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _rankDashboard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.primaryMain,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text("ចំណាត់ថ្នាក់ក្នុងថ្នាក់",
                  style:
                      AppTextStyle.subtitle18.copyWith(color: AppColors.white)),
              Spacer(),
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: AppColors.primary300,
                  shape: BoxShape.circle,
                ),
                child:
                    Icon(Icons.emoji_events, color: AppColors.white, size: 30),
              )
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Text("#៨ / ",
                  style: AppTextStyle.screenTitle24
                      .copyWith(color: AppColors.white)),
              Text("៣២",
                  style:
                      AppTextStyle.subtitle16.copyWith(color: AppColors.white)),
            ],
          ),
          SizedBox(height: 15),
          Divider(
            color: AppColors.white,
            height: 1,
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "មធ្យមភាគ",
                    style: AppTextStyle.subtitle16
                        .copyWith(color: AppColors.white),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text("៨៥.៥",
                      style: AppTextStyle.sectionTitle20
                          .copyWith(color: AppColors.white))
                ],
              ),
              Container(
                height: 55,
                width: 3,
                decoration: BoxDecoration(
                  color: AppColors.white,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "សរុប",
                    style: AppTextStyle.subtitle16
                        .copyWith(color: AppColors.white),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text("៤៥០",
                      style: AppTextStyle.sectionTitle20
                          .copyWith(color: AppColors.white))
                ],
              ),
              Container(
                height: 55,
                width: 3,
                decoration: BoxDecoration(
                  color: AppColors.white,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "និទ្ទេស",
                    style: AppTextStyle.subtitle16
                        .copyWith(color: AppColors.white),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text("B",
                      style: AppTextStyle.sectionTitle20
                          .copyWith(color: AppColors.white))
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
