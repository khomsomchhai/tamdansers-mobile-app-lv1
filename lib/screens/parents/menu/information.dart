import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:tamdansers_app/constants/app_colors.dart';
import 'package:tamdansers_app/constants/text_style.dart';
class Information extends StatefulWidget {
  const Information({super.key});

  @override
  State<Information> createState() => _InformationState();
}

class _InformationState extends State<Information> {
  int selectedIndex = 0;
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "ព៌ត៌មាន",
          style: AppTextStyle.screenTitle24,
        ),
        centerTitle: true,
        backgroundColor: AppColors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: Column(
            children: [
              _tabnoothi(
                names: ["All", "Read", "Unread", "Other"],
              ),
              const SizedBox(height: 15),
              _buildCarousel(),
              const SizedBox(height: 15),
              Row(
                children: [
                  Text(
                    "បច្ចុប្បន្នភាពថ្មីៗ",
                    style: AppTextStyle.fontsize18,
                  ),
                  const Spacer(),
                  Text(
                    "មើលទាំងអស់",
                    style: AppTextStyle.til16,
                  ),
                ],
              ),
              const SizedBox(height: 15),
              _listnothicard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tabnoothi({required List<String> names}) {
    return Row(
      children: List.generate(names.length, (index) {
        bool isSelected = selectedIndex == index;

        return Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                selectedIndex = index;
              });
            },
            child: Container(
              height: 40,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primaryMain
                    : AppColors.link.withOpacity(0.2),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                names[index],
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _nothicard({
    required String name,
    required String hour,
    required String description,
    required IconData icon,
    required Color color,
    IconData? trailingIcon,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: AppTextStyle.subtitle16,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    hour,
                    style: AppTextStyle.body14,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyle.body14,
                  ),
                ],
              ),
            ),
            if (trailingIcon != null) ...[
              const SizedBox(width: 8),
              Icon(
                trailingIcon,
                size: 16,
                color: Colors.black38,
              ),
            ],
          ],
        ),
      ),
    );
  }
  Widget _listnothicard() {
    return Column(
      children: [
        _nothicard(
          name: "ការជូនដំណឺងរបស់សាលា",
          hour: "5 ម៉ោងមុន",
          description:
              "សាលានិងបិទនៅថ្ងៃស្អែកដោយសារមានទិវាឈប់សម្រាកបុណ្យជាតិ",
          icon: Icons.notifications,
          color: AppColors.comment,
          trailingIcon: Icons.arrow_forward_ios,
        ),
        _nothicard(
          name: "ការជូនដំណឺងរបស់សាលា",
          hour: "ម្សិលមិញ",
          description:
              "ការព្រមានរបស់សាលាទៅកាន់កូនរបស់អ្នក ការលេងទូរសព័នៅក្នុងថ្នាក់រៀនណៅពេល",
          icon: Icons.warning,
          color: AppColors.error,
          trailingIcon: Icons.arrow_forward_ios,
        ),
        _nothicard(
          name: "ប្រតិបត្តិពន្ទុថ្មី",
          hour: "2 ម៉ោងមុន",
          description:
              "ព្រឺត្តបត្រពិន្ទុសម្រាប់ឆមាសទី១មានសប្រាប់ទាញយកហើយ ។",
          icon: Icons.bookmark_add_outlined,
          color: AppColors.primaryMain,
          trailingIcon: Icons.arrow_forward_ios,
        ),
        _nothicard(
          name: "ការំលឹកថ្លៃសិក្សា",
          hour: "2 ថ្ងៃមុន",
          description:
              "ការរំលឹកដោយមេត្រីភាពសម្រាប់ការបង់ថ្លៃសិក្សានាពេលខាងមុខ ដែលត្រូវនៅសប្តាហ៍ក្រោយ",
          icon: Icons.money,
          color: AppColors.secondaryText,
          trailingIcon: Icons.arrow_forward_ios,
        ),
        _nothicard(
          name: "កិច្ចប្រជុំមាតាបីតា-គ្រូ",
          hour: "1 ម៉ោងមុន",
          description:
              "ការប្រជុំនាពេលខាងមុខគ្រោងធ្វើនៅថ្ងៃសុក្រនេះវេលាម៉ោង ២:០០ រសៀល នៅបន្ទប់ 3B។",
          icon: Icons.notifications,
          color: AppColors.comment,
          trailingIcon: Icons.arrow_forward_ios,
        ),
      ],
    );
  }
  Widget _buildCarousel() {
  final List<String> images = [
    'assets/images/mylove.jpg',
    'assets/images/mylove.jpg',
    'assets/images/mylove.jpg',
  ];

  return Column(
    children: [
      CarouselSlider(
        options: CarouselOptions(
          height: 200,
          autoPlay: true,
          enlargeCenterPage: true,
          viewportFraction: 0.9,
          autoPlayInterval: const Duration(seconds: 3),
          onPageChanged: (index, reason) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
        items: images.map((item) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              item,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          );
        }).toList(),
      ),
      const SizedBox(height: 8),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: images.asMap().entries.map((entry) {
          return Container(
            width: _currentIndex == entry.key ? 12 : 8,
            height: 8,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: _currentIndex == entry.key
                  ? AppColors.primaryMain
                  : AppColors.secondaryText,
            ),
          );
        }).toList(),
      ),
    ],
  );
}
}