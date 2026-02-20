import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:tamdansers_app/constants/app_colors.dart';
import 'package:tamdansers_app/constants/app_images.dart';
import 'package:tamdansers_app/constants/text_style.dart';
import 'package:tamdansers_app/routes/app_routes.dart';
import 'package:tamdansers_app/widget/primary_button.dart';

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  var sliderIndex = 0;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            _buildCarousel(size),
            const Spacer(),
            Text(
              "សូមជ្រើសរើសមុខងារ",
              style: AppTextStyle.title28,
            ),
            Text(
              "ចូលប្រើប្រាស់",
              style: AppTextStyle.title28,
            ),
            const Spacer(),
            //custom widget
            PrimaryButton(
                label: "គ្រូបង្រៀន",
                backgroundColor: AppColors.primaryMain,
                foregroundColor: AppColors.white,
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.loginTeacherScreen);
                }),
            const SizedBox(height: 16,),
            PrimaryButton(
                label: "សិស្ស",
                backgroundColor: AppColors.primaryMain,
                foregroundColor: AppColors.white,
                onPressed: () {}),
            const SizedBox(height: 16,),
            PrimaryButton(
                label: "អាណាព្យាបាលសិស្ស",
                backgroundColor: AppColors.primaryMain,
                foregroundColor: AppColors.white,
                onPressed: () {}),
            const SizedBox(height: 32,)
          ],
        ),
      ),
    );
  }

  Widget _buildCarousel(Size size) {
    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            onPageChanged: (index, reason) {
              setState(() {
                sliderIndex = index;
              });
            },
            height: size.height * 0.35,
            viewportFraction: 1,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 3),
          ),
          items: [AppImages.slider1, AppImages.slider2, AppImages.slider3].map((i){
            return Builder(
              builder: (BuildContext context) {
                return SvgPicture.asset( 
                  i,
                  fit: BoxFit.contain,
                );
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 15,),
        AnimatedSmoothIndicator(    
          activeIndex: sliderIndex,
          count: 3,    
          effect: JumpingDotEffect(
            dotHeight: 10,
            dotWidth: 10,
            activeDotColor: AppColors.primaryMain,
            dotColor: AppColors.secondaryText,
          ), 
        )    
      ],
    );
  }
}
