import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tamdansers_app/constants/app_colors.dart';
import 'package:tamdansers_app/constants/app_images.dart';
import 'package:tamdansers_app/constants/app_number.dart';
import 'package:tamdansers_app/constants/text_style.dart';
import 'package:tamdansers_app/screens/parents/menu/detailnews.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  int _selectedCategory = 0;
  int _currentFeaturedIndex = 0;
  late final PageController _featuredPageController;
  Timer? _featuredTimer;

  double _fs(double base, BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return base * (width / 390).clamp(0.78, 1.15);
  }

  final List<String> _categories = [
    "ទាំងអស់",
    "សាលា",
    "ថ្នា",
    "ព្រឹត្តិ",
  ];

  final List<Map<String, dynamic>> _newsItems = [
    {
      "category": "សារប្រចាំសារ​​​​​​​​​​​",
      "categoryColor": AppColors.primaryMain,
      "categoryBgColor": AppColors.primaryBg,
      "title": "ការប្បវេសប៍ចេញប្រឡងសណ្ដាប់វិទ្យា",
      "description":
          "សារប្រឡងសណ្ដាប់វិទ្យាដែលថ្ងៃទី៦ខែមករាស្បូទប្បល កោរខឺវ​រពេលវួក្រការអារាស​វ៍ព្រកានៗ។",
      "author": "លោក សុខ",
      "hasImage": false,
      "icon": Icons.campaign,
      "iconColor": AppColors.primaryMain,
      "importantPoints": [
        "កាលបរិច្ឆេទប្រឡងត្រូវបានកំណត់យ៉ាងច្បាស់",
        "សិស្សត្រូវត្រៀមឯកសារសិក្សាឲ្យបានគ្រប់គ្រាន់",
        "សូមតាមដានសេចក្ដីជូនដំណឹងបន្ថែមពីសាលា",
      ],
    },
    {
      "category": "ព្រៃចម្បូទប៍ម៍និទព្រេន",
      "categoryColor": AppColors.pepure,
      "categoryBgColor": AppColors.lightPink,
      "title": "ការប្រកួតពល់ទាត់",
      "description":
          "សារប្រុកាុយែលង​វោតាំមនែសនារីកាុវ៉ៃផ្ដើមនួរនៅ សល្បរះ​ រ សួប្រារម​ទមន​ៃធកៃរីង​ក៍ការ់អណ់ស៍អែល​អ​​។",
      "author": "ថ្នាក់វិទ្យា",
      "hasImage": false,
      "icon": Icons.emoji_events,
      "iconColor": AppColors.pepure,
      "importantPoints": [
        "ការប្រកួតមានគោលបំណងបង្កើនស្មារតីកីឡា",
        "សិស្សគួរចូលរួមតាមកាលវិភាគដែលបានប្រកាស",
        "មានការរៀបចំសុវត្ថិភាព និងការគ្រប់គ្រងពេញលេញ",
      ],
    },
    {
      "category": "តារព៍ន៍",
      "categoryColor": AppColors.success,
      "categoryBgColor": AppColors.successBG,
      "title": "ការប្រជុំមាតាបិត និទក្រូ",
      "description":
          "បារតារពហ៌ចែសស្សួម្រាប់ថៅសៅរីកា​រប្រញា​​ រាប៍ក រាម​ ៦ ម៉ឺក​ នៅសាលា​សួប្រជុំវិទារណ៍​።",
      "author": "ល្បួនការណៃ​",
      "hasImage": false,
      "icon": Icons.groups,
      "iconColor": AppColors.success,
      "importantPoints": [
        "ការប្រជុំផ្តោតលើការសហការរវាងមាតាបិតា និងគ្រូ",
        "នឹងពិភាក្សាអំពីការរីកចម្រើន និងសកម្មភាពសិស្ស",
        "សូមមកទាន់ពេលតាមម៉ោងដែលបានជូនដំណឹង",
      ],
    },
  ];

  final List<Map<String, String>> _featuredSlides = [
    {
      "badge": "ថ្មី ចុង",
      "title": "កិឈវណ៍វិទ្យាសាស្រ្តប្រចាំឆ្នាំ ២០២៥",
      "description":
          "ចូលមួយបើកផ្សញ​បម្រាប់នៃថ្ងៃនាក​វ៍ផូទល់មី​​ នីការម​​​រ របឞ្ញ។",
      "image": AppImages.news1,
    },
    {
      "badge": "ដំណឹង",
      "title": "ការប្រជុំមាតាបិតា និងគ្រូបង្រៀន",
      "description":
          "សូមអញ្ជើញចូលរួមប្រជុំជាមួយថ្នាក់គ្រូនៅសាលាវិទ្យាល័យសប្ដាហ៍នេះ។",
      "image": AppImages.news2,
    },
    {
      "badge": "ពិសេស",
      "title": "ការប្រកួតកីឡាប្រចាំខែ",
      "description":
          "កម្មវិធីប្រកួតកីឡារបស់សិស្សនឹងចាប់ផ្ដើមនៅថ្ងៃសុក្រ ម៉ោង ៨:០០ ព្រឹក។",
      "image": AppImages.news3,
    },
    {
      "badge": "សាលា",
      "title": "ការប្រកួតសិល្បៈប្រចាំខែ",
      "description":
          "កម្មវិធីប្រកួតសិល្បៈរបស់សិស្សនឹងចាប់ផ្ដើមនៅថ្ងៃអាទិត្យ ម៉ោង ៩:០០ ព្រឹក។",
      "image": AppImages.news4,
    },
    {
      "badge": "ព្រឹត្តិការណ៍",
      "title": "ការប្រកួតកីឡាប្រចាំខែ",
      "description":
          "កម្មវិធីប្រកួតកីឡារបស់សិស្សនឹងចាប់ផ្ដើមនៅថ្ងៃសុក្រ ម៉ោង ៨:០០ ព្រឹក។",
      "image": AppImages.news5,
    }
  ];

  @override
  void initState() {
    super.initState();
    _featuredPageController = PageController(viewportFraction: 1);
    _featuredTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!_featuredPageController.hasClients || _featuredSlides.isEmpty) {
        return;
      }
      final next = (_currentFeaturedIndex + 1) % _featuredSlides.length;
      _featuredPageController.animateToPage(
        next,
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeInOutCubic,
      );
    });
  }

  @override
  void dispose() {
    _featuredTimer?.cancel();
    _featuredPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppColors.backgroundLight,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  _buildHeader(),
                  const SizedBox(height: 16),
                  _buildSearchBar(),
                  const SizedBox(height: 14),
                  _buildCategoryChips(),
                  const SizedBox(height: 16),
                  _buildFeaturedSlider(),
                  const SizedBox(height: 20),
                  _buildLatestUpdatesHeader(),
                  const SizedBox(height: 12),
                  _buildNewsList(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ==================== HEADER ====================
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "ព័ត៌មាន",
          style:
              AppTextStyle.sectionTitle20.copyWith(fontSize: _fs(20, context)),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 0),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppNumber.radiusMedium),
        border: Border.all(color: AppColors.lightgrey),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, size: 22, color: AppColors.secondaryText),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: "ស្វែងរកការប្រកាស...",
                hintStyle:
                    AppTextStyle.hint15.copyWith(fontSize: _fs(15, context)),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
              style: AppTextStyle.body.copyWith(fontSize: _fs(14, context)),
            ),
          ),
        ],
      ),
    );
  }

  // ==================== CATEGORY CHIPS ====================
  Widget _buildCategoryChips() {
    return Row(
      children: List.generate(_categories.length, (index) {
        final isSelected = _selectedCategory == index;
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: GestureDetector(
            onTap: () => setState(() => _selectedCategory = index),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primaryMain : AppColors.white,
                borderRadius: BorderRadius.circular(AppNumber.radiusPill),
                border: Border.all(
                  color:
                      isSelected ? AppColors.primaryMain : AppColors.lightgrey,
                ),
              ),
              child: Text(
                _categories[index],
                style: AppTextStyle.body14.copyWith(
                  fontSize: _fs(14, context),
                  fontWeight: FontWeight.w500,
                  color: isSelected ? AppColors.white : AppColors.primaryText,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  // ==================== FEATURED SLIDER ====================
  Widget _buildFeaturedSlider() {
    return Column(
      children: [
        SizedBox(
          height: 180,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppNumber.radiusLarge),
            child: PageView.builder(
              controller: _featuredPageController,
              itemCount: _featuredSlides.length,
              onPageChanged: (index) {
                setState(() => _currentFeaturedIndex = index);
              },
              itemBuilder: (context, index) {
                final slide = _featuredSlides[index];
                return _buildFeaturedSlideCard(slide);
              },
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_featuredSlides.length, (index) {
            final isActive = index == _currentFeaturedIndex;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: isActive ? 18 : 7,
              height: 7,
              decoration: BoxDecoration(
                color: isActive
                    ? AppColors.primaryMain
                    : AppColors.secondaryText.withValues(alpha: 0.35),
                borderRadius: BorderRadius.circular(99),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildFeaturedSlideCard(Map<String, String> slide) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          slide["image"]!,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(color: const Color(0xFF1C1C3A));
          },
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withValues(alpha: 0.12),
                Colors.black.withValues(alpha: 0.78),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.error,
                  borderRadius: BorderRadius.circular(AppNumber.radiusRounded),
                ),
                child: Text(
                  slide["badge"]!,
                  style: AppTextStyle.caption12Secondary.copyWith(
                    fontSize: _fs(11, context),
                    fontWeight: FontWeight.w600,
                    color: AppColors.white,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                slide["title"]!,
                style: AppTextStyle.screenTitle24.copyWith(
                  fontSize: _fs(25, context),
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              Text(
                slide["description"]!,
                style: AppTextStyle.body14.copyWith(
                  fontSize: _fs(13, context),
                  fontWeight: FontWeight.w400,
                  color: Colors.white.withValues(alpha: 0.9),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ==================== LATEST UPDATES HEADER ====================
  Widget _buildLatestUpdatesHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "បច្ចុប្បន្នភាពថ្មីៗ",
          style: AppTextStyle.subtitle18.copyWith(fontSize: _fs(18, context)),
        ),
        Text(
          "សម្ពាល់ពាក្យទាំងអស់",
          style: AppTextStyle.body14.copyWith(
            fontSize: _fs(13, context),
            fontWeight: FontWeight.w500,
            color: AppColors.primaryMain,
          ),
        ),
      ],
    );
  }

  // ==================== NEWS LIST ====================
  Widget _buildNewsList() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _newsItems.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final item = _newsItems[index];
        return _buildNewsCard(item);
      },
    );
  }

  Widget _buildNewsCard(Map<String, dynamic> item) {
    return InkWell(
      borderRadius: BorderRadius.circular(AppNumber.radiusLarge),
      onTap: () {
        final points = (item["importantPoints"] as List<dynamic>? ?? const [])
            .map((e) => e.toString())
            .toList();

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DetailNewsScreen(
              category: item["category"]?.toString() ?? "-",
              title: item["title"]?.toString() ?? "-",
              description: item["description"]?.toString() ?? "-",
              author: item["author"]?.toString() ?? "-",
              icon: item["icon"] as IconData? ?? Icons.article_outlined,
              iconColor: item["iconColor"] as Color? ?? AppColors.primaryMain,
              importantPoints: points,
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppNumber.radiusLarge),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Icon
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: item["categoryBgColor"],
                    borderRadius: BorderRadius.circular(AppNumber.radiusSmall),
                  ),
                  child: Icon(item["icon"], color: item["iconColor"], size: 20),
                ),
                const SizedBox(width: 10),
                // Category + Title
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: item["categoryBgColor"],
                          borderRadius:
                              BorderRadius.circular(AppNumber.radiusRounded),
                        ),
                        child: Text(
                          item["category"],
                          style: AppTextStyle.caption12Secondary.copyWith(
                            fontSize: _fs(11, context),
                            fontWeight: FontWeight.w500,
                            color: item["categoryColor"],
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item["title"],
                        style: AppTextStyle.subtitle16
                            .copyWith(fontSize: _fs(16, context)),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Description
            Padding(
              padding: const EdgeInsets.only(left: 46),
              child: Text(
                item["description"],
                style: AppTextStyle.caption13Secondary
                    .copyWith(fontSize: _fs(13, context)),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 10),
            // Author + Read more
            Padding(
              padding: const EdgeInsets.only(left: 46),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    item["author"],
                    style: AppTextStyle.caption12Secondary
                        .copyWith(fontSize: _fs(12, context)),
                  ),
                  Text(
                    "អានបន្ថែម",
                    style: AppTextStyle.body14.copyWith(
                      fontSize: _fs(13, context),
                      fontWeight: FontWeight.w500,
                      color: AppColors.primaryMain,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
