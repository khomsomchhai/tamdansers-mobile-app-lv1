import 'package:flutter/material.dart';
import 'package:tamdansers_app/constants/app_colors.dart';
import 'package:tamdansers_app/constants/text_style.dart';

class Nothication extends StatefulWidget {
  const Nothication({super.key});

  @override
  State<Nothication> createState() => _NothicationState();
}

class _NothicationState extends State<Nothication> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ការជូនដំណឹង',
        style: AppTextStyle.screenTitle24,
        ),
        centerTitle: true,
        backgroundColor: AppColors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 15,),
            Padding(
              padding: EdgeInsetsGeometry.all(10),
              child: _tabnoothi(
                names: ["All", "Read", "Unread", "Other"],
              )),
              SizedBox(height: 30,),
              _listnothicard()
              
          ],
        ),
      ),
    );
  }
  Widget _tabnoothi({required List<String> names}) {
    return Row(
      children: List.generate(names.length, (index) {
        return Expanded(
          child: Container(
            height: 40,
            alignment: Alignment.center,
            margin: const EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
              color: AppColors.link,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text(
              names[index],
              style: const TextStyle(color: Colors.white),
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
  required IconData icon, // circular icon
  required Color color,
  IconData? trailingIcon, // optional
}) {
  return Card(
    margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    child: Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Circular icon
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
                  style: AppTextStyle.subtitle16
                ),
                const SizedBox(height: 4),
                Text(
                  hour,
                  style: AppTextStyle.body14
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style:AppTextStyle.body14
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
  Widget _listnothicard(){
    return Column(
      children: [
        _nothicard(
              name: "ការជូនដំណឺងរបស់សាលា",
              hour: "5 ម៉ោងមុន",
              description: "សាលានិងបិទនៅថ្ងៃស្អែកដោយសារមានទិវាឈប់សម្រាកបុណ្យជាតិ",
              icon: Icons.notifications,
              color: AppColors.comment,
              trailingIcon: Icons.arrow_forward_ios,
          ),
        _nothicard(
          name: "ការជូនដំណឺងរបស់សាលា",
          hour: "ម្សិលមិញ",
          description: "ការព្រមានរបស់សាលាទៅកាន់កូនរបស់អ្នក ការលេងទូរសព័នៅក្នុងថ្នាក់រៀនណៅពេល",
          icon: Icons.warning,
          color: AppColors.error,
          trailingIcon: Icons.arrow_forward_ios,
          ) ,
           _nothicard(
              name: "ប្រតិបត្តិពន្ទុថ្មី",
              hour: "2 ម៉ោងមុន",
              description: "ព្រឺត្តបត្រពិន្ទុសម្រាប់ឆមាសទី១មានសប្រាប់ទាញយកហើយ ។",
              icon: Icons.bookmark_add_outlined,
              color: AppColors.primaryMain,
              trailingIcon: Icons.arrow_forward_ios,
          ),
          _nothicard(
            name: "ការំលឹកថ្លៃសិក្សា",
            hour: "2 ថ្ងៃមុន",
            description: "ការរំលឹកដោយមេត្រីភាពសម្រាប់ការបង់ថ្លៃសិក្សានាពេលខាងមុខ ដែលត្រូវនៅសប្តាហ៍ក្រោយ",
            icon: Icons.money,
            color: AppColors.secondaryText,
            trailingIcon: Icons.arrow_forward_ios,
            ) ,
           _nothicard(
              name: "កិច្ចប្រជុំមាតាបីតា-គ្រូ",
              hour: "1 ម៉ោងមុន",
              description: "ការប្រជុំនាពេលខាងមុខគ្រោងធ្វើនៅថ្ងៃសុក្រនេះវេលាម៉ោង ២:០០​ រសៀល​ នៅបន្ទប់ 3B។",
              icon: Icons.notifications,
              color: AppColors.comment,
              trailingIcon: Icons.arrow_forward_ios,
          ),
      ],
    );
  }
}