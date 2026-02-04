import 'package:flutter/material.dart';
import 'package:tamdansers_app/constants/app_colors.dart';
import 'package:tamdansers_app/constants/text_style.dart';
import 'package:tamdansers_app/widget/search_field.dart'; 

class LinkParentScreen extends StatefulWidget {
  const LinkParentScreen({super.key});

  @override
  State<LinkParentScreen> createState() => _LinkParentScreenState();
}

class _LinkParentScreenState extends State<LinkParentScreen> {
  var searchCtrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.primaryText),
        ),
        title: Column(
          children: [
            Text(
              "ភ្ជាប់អាណាព្យាបាល", 
              style: AppTextStyle.screenTitle24,),
          ],
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // 1. Search Section
          Padding(
            padding: const EdgeInsets.all(20),
            child: SearchField(
              hintText: "ស្វែងរកតាមលេខទូរស័ព្ទ ឬ អ៊ីមែល",
              icon: Icon(Icons.search, color: AppColors.secondaryText),
              controller: searchCtrl,
            ),
          ),

          const SizedBox(height: 24),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                Text(
                  "លទ្ធផលស្វែងរក", 
                  style: AppTextStyle.sectionTitle20),
                const SizedBox(height: 12),
                _parentTile("ចាន់ ដារ៉ា", "012 448 877",
                  onPressed: () {
                    showModalBottomSheet(
                      context: context, 
                      builder: (context) {
                        return Container(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("តើអ្នកប្រាកដជាចង់ភ្ជាប់អាណាព្យាបាលនេះទេ?", style: AppTextStyle.body.copyWith(fontWeight: FontWeight.bold)),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primaryMain.withOpacity(0.1),
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                      minimumSize: const Size(100, 40),
                                    ),
                                    child: Text("យល់ព្រម", style: AppTextStyle.body.copyWith(color: AppColors.primaryMain, fontWeight: FontWeight.bold)),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red.shade100,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                      minimumSize: const Size(100, 40),
                                    ),
                                    child: Text("បោះបង់", style: AppTextStyle.body.copyWith(color: Colors.red.shade700, fontWeight: FontWeight.bold)),
                                  ),
                                  
                                ],
                              )
                            ],
                          ),
                        );
                      }
                    );
                  }),
                
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    "ស្វែងរកមិនឃើញ? សូមសាកល្បងបញ្ចូលលេខទូរស័ព្ទឡើងវិញ",
                    textAlign: TextAlign.center,
                    style: AppTextStyle.body.copyWith(
                      color: AppColors.secondaryText, 
                      fontSize: 12)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _parentTile(String name, String phone,{required VoidCallback onPressed}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: Colors.orange.shade50,
            child: Icon(Icons.person_outline, color: Colors.orange.shade300),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: AppTextStyle.body.copyWith(fontWeight: FontWeight.bold)),
                Text(phone, style: AppTextStyle.body.copyWith(color: AppColors.secondaryText, fontSize: 12)),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              onPressed();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryMain.withOpacity(0.1),
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              minimumSize: const Size(60, 36),
            ),
            child: Text("ភ្ជាប់", style: AppTextStyle.body.copyWith(color: AppColors.primaryMain, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}