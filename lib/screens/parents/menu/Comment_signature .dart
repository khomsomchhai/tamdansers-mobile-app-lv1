import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:tamdansers_app/constants/app_colors.dart';
import 'package:tamdansers_app/constants/text_style.dart';

class CommentSignature extends StatefulWidget {
  const CommentSignature({super.key});

  @override
  State<CommentSignature> createState() => _CommentSignatureState();
}

class _CommentSignatureState extends State<CommentSignature> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "ការបញ្ជាក់ទទួល",
          style: AppTextStyle.screenTitle24Main
              .copyWith(color: AppColors.primaryText),
        ),
        centerTitle: true,
        backgroundColor: AppColors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              _studentCard(),
              SizedBox(height: 20),
              _commentCard(),
              SizedBox(height: 50),
              _signatureCard(),
              SizedBox(height: 20),
              _submitButton()
            ],
          ),
        ),
      ),
    );
  }

  Widget _studentCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
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
              children:  [
                Text(
                  "ប៊ិន​ សុវណ្ណវង្ស",
                  style: AppTextStyle.subtitle16,
                ),
                SizedBox(height: 4),
                Text(
                  "ID: STU-2023-89. ថ្នាក់ទី ១២ ក",  
                  style: AppTextStyle.subtitle16.copyWith(color: AppColors.grey)
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _commentCard() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: AppColors.lightgrey,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header Link/Text
          Text(
            'មតិយោបល់មាតាបិតា (ជម្រើស)',
            style: AppTextStyle.sectionTitle20,
          ),
          const SizedBox(height: 15),
          Container(
            decoration: BoxDecoration(
              color: AppColors.uploadFile,
              border: Border.all(color: AppColors.uploadFile),
              borderRadius: BorderRadius.circular(20),
            ),
            child: TextField(
              maxLines: 6,
              decoration: InputDecoration(
                  hintText: 'សរសេរការឆ្លើយតប ឬសំណួរ',
                  hintStyle:
                      AppTextStyle.subtitle16.copyWith(color: Colors.grey),
                  contentPadding: EdgeInsets.all(15),
                  border: InputBorder.none),
            ),
          ),
        ],
      ),
    );
  }

  Widget _signatureCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
         Text(
          'ស៊ីញ៉េអាណាព្យាបាល',
          style: AppTextStyle.sectionTitle20
        ),
        const SizedBox(height: 8),
         Text(
          'សូមចុះឈ្មោះក្នុងប្រអប់ខាងក្រោម ដើម្បីទទួលស្គាល់បង្កាន់ដៃ។',
          style: AppTextStyle.subtitle16.copyWith(color: AppColors.grey)
        ),
        const SizedBox(height: 20),
        DottedBorder(
          color: AppColors.secondaryText,
          strokeWidth: 1,
          dashPattern: const [8, 4],
          borderType: BorderType.RRect,
          radius: const Radius.circular(25),
          child: Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.uploadFile,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Stack(
              children: [
                 Center(
                  child: Text(
                    'Sign Here',
                    style: AppTextStyle.screenTitle24
                  ),
                ),
                Positioned(
                  top: 15,
                  right: 15,
                  child: Icon(
                    Icons.delete_outline,
                    color: AppColors.secondaryText,
                    size: 30,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _submitButton() {
    return ElevatedButton(
      onPressed: () {
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryMain,
        padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      child: Text(
        'Submit',
        style: AppTextStyle.size18.copyWith(color: AppColors.uploadFile),
      ),
    );
  }
}
