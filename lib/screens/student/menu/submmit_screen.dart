import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:tamdansers_app/constants/app_colors.dart';
import 'package:tamdansers_app/constants/text_style.dart';

class SubmmitScreen extends StatefulWidget {
  const SubmmitScreen({super.key});

  @override
  State<SubmmitScreen> createState() => _SubmmitScreenState();
}

class _SubmmitScreenState extends State<SubmmitScreen> {
  final noteController = TextEditingController();
  @override
  void dispose() {
    noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("បញ្ចូនកិច្ចការ"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              dashBoard(),
              SizedBox(height: 15,),
              Text("មតិ ឬចំណាំ",style: AppTextStyle.sectionTitle20,),
              SizedBox(height: 15,),
              noteCard(
                controller: noteController,
                hintText: "បញ្ចូលព័តមាននៅទីនេះ...",
                borderColor: AppColors.backgroundLight,
              ),
              SizedBox(height: 15,),
              uploadHomeworkWidget(
                files: [
                  {"name": "Homework01.png", "size": "850 KB"},
                  {"name": "Homework02.png", "size": "850 KB"},
                ],
                onUploadTap: () {},
                onSubmit: () {},
                onRemoveFile: (index) {},
                fileItemBuilder: ({
                  required String fileName,
                  required String sizeText,
                  required VoidCallback onRemove,
                }) {
                  return fileItemWidget(
                    fileName: fileName,
                    sizeText: sizeText,
                    onRemove: onRemove,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget dashBoard(){
    return Container(
      padding: EdgeInsets.all(25),
      decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 12,
            ),
          ]
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.picture_as_pdf,color: AppColors.primaryMain,),
                SizedBox(width: 15,),
                Text("ព័តមានការងារ",style: AppTextStyle.til16)
              ],
            ),
            SizedBox(height: 10,),
            Text("គណិតវិទ្យា​ ថ្នាក់ទី៨",style: AppTextStyle.fontsize18,),
            SizedBox(height: 10,),
            Text("មេរៀនទី១ ចំនួនសនិទាន",style: AppTextStyle.body,),
            SizedBox(height: 10,),
            Row(
              children: [
                Icon(Icons.calendar_month,color: Colors.red,),
                SizedBox(width: 15,),
                Text("កាលបរិច្ឆេទឈប់ទទួល៖ ០៩​ កុម្ភះ ២០២៦",style: AppTextStyle.tiltle16,)
              ],
            ),
          ],
        ),
    );
  }
  Widget noteCard({
  required TextEditingController controller,
  String? hintText,
  Color hintColor = Colors.black,
  Color textColor = Colors.black,
  Color borderColor = const Color.fromARGB(80, 158, 158, 158),
  Color backgroundColor = const Color.fromARGB(79, 158, 158, 158),
}) {
  return TextFormField(
    controller: controller,
    style: TextStyle(
      color: textColor
    ),
    decoration: InputDecoration(
      hintStyle: TextStyle(
        color: hintColor
      ),
      filled: true,
      fillColor: backgroundColor,
      hintText: hintText,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: borderColor)
      )
    ),
  );
}
Widget fileItemWidget({
  required String fileName,
  required String sizeText,
  required VoidCallback onRemove,
}) {
  return Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.black87),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: const Color(0xFFEAF1FF),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.image_outlined,
            color: Color(0xFF2E6BFF),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                fileName,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                sizeText,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: onRemove,
        ),
      ],
    ),
  );
}
Widget uploadHomeworkWidget({
  required List<Map<String, String>> files,
  required VoidCallback onUploadTap,
  required VoidCallback onSubmit,
  required Function(int index) onRemoveFile,

  // ✅ pass widget builder from outside
  required Widget Function({
    required String fileName,
    required String sizeText,
    required VoidCallback onRemove,
  }) fileItemBuilder,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        "បញ្ចូលរូបភាពការងារ",
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
      const SizedBox(height: 10),

      GestureDetector(
        onTap: onUploadTap,
        child: DottedBorder(
          dashPattern: const [6, 4],
          color: const Color(0xFF7AA7FF),
          strokeWidth: 1.5,
          borderType: BorderType.RRect,
          radius: const Radius.circular(16),
          child: Container(
            height: 150,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 22),
            decoration: BoxDecoration(
              color: const Color(0xFFEAF1FF),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: const [
                Text(
                  "Upload រូបភាព",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 12),
                Icon(
                  Icons.cloud_upload_outlined,
                  size: 36,
                  color: Color(0xFF2E6BFF),
                ),
              ],
            ),
          ),
        ),
      ),

      const SizedBox(height: 18),
      Text(
        "បញ្ជីឯកសារដែលបានជ្រើសរើស (${files.length})",
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      ),
      const SizedBox(height: 10),

      ...List.generate(files.length, (index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: fileItemBuilder(
            fileName: files[index]['name'] ?? '',
            sizeText: files[index]['size'] ?? '',
            onRemove: () => onRemoveFile(index),
          ),
        );
      }),

      const SizedBox(height: 16),

      SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton.icon(
          onPressed: onSubmit,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryMain,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
          ),
          icon: const Icon(Icons.send, color: Colors.white),
          label: const Text(
            "បញ្ជូន",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    ],
  );
}

}