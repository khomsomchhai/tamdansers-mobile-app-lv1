import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tamdansers_app/constants/app_colors.dart';
import 'package:tamdansers_app/constants/text_style.dart';

class SubmmitScreen extends StatefulWidget {
  const SubmmitScreen({super.key});

  @override
  State<SubmmitScreen> createState() => _SubmmitScreenState();
}

class _SubmmitScreenState extends State<SubmmitScreen> {
  final noteController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  // ✅ store real picked images
  final List<XFile> _pickedImages = [];

  @override
  void dispose() {
    noteController.dispose();
    super.dispose();
  }

  // ✅ convert picked images to your files format
  List<Map<String, String>> get files => _pickedImages.map((x) {
        final bytes = File(x.path).lengthSync();
        return {
          "name": x.name,
          "size": _formatBytes(bytes),
          "path": x.path, // ✅ for preview
        };
      }).toList();

  Future<void> _onUploadTap() async {
    final images = await _picker.pickMultiImage(imageQuality: 90);
    if (images.isEmpty) return;

    setState(() {
      _pickedImages.addAll(images); // png1, png2...
    });
  }

  void _onRemoveFile(int index) {
    setState(() => _pickedImages.removeAt(index));
  }

  void _onSubmit() {
    // TODO: upload _pickedImages (paths)
    debugPrint("Submit ${_pickedImages.length} images");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("បញ្ចូនកិច្ចការ")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              dashBoard(),
              const SizedBox(height: 15),
              Text("មតិ ឬចំណាំ", style: AppTextStyle.sectionTitle20),
              const SizedBox(height: 15),
              noteCard(
                controller: noteController,
                hintText: "បញ្ចូលព័តមាននៅទីនេះ......",
                borderColor: AppColors.backgroundLight,
              ),
              const SizedBox(height: 15),

              // ✅ use real files from picker
              uploadHomeworkWidget(
                files: files,
                onUploadTap: _onUploadTap,
                onSubmit: _onSubmit,
                onRemoveFile: _onRemoveFile,
                fileItemBuilder: ({
                  required String fileName,
                  required String sizeText,
                  required VoidCallback onRemove,
                }) {
                  // ✅ find the file path for preview
                  final item = files.firstWhere((e) => e["name"] == fileName);
                  final path = item["path"] ?? "";

                  return fileItemWidget(
                    fileName: fileName,
                    sizeText: sizeText,
                    imagePath: path, // ✅ add preview
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

  String _formatBytes(int bytes) {
    if (bytes < 1024) return "$bytes B";
    final kb = bytes / 1024;
    if (kb < 1024) return "${kb.toStringAsFixed(1)} KB";
    final mb = kb / 1024;
    return "${mb.toStringAsFixed(1)} MB";
  }

  // ---------------- your widgets below (small edits) ----------------

  Widget dashBoard() {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.picture_as_pdf, color: AppColors.primaryMain),
              const SizedBox(width: 15),
              Text("ព័តមានការងារ", style: AppTextStyle.til16),
            ],
          ),
          const SizedBox(height: 10),
          Text("គណិតវិទ្យា​ ថ្នាក់ទី៨", style: AppTextStyle.fontsize18),
          const SizedBox(height: 10),
          Text("មេរៀនទី១ ចំនួនសនិទាន", style: AppTextStyle.body),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.calendar_month, color: Colors.red),
              const SizedBox(width: 15),
              Text("កាលបរិច្ឆេទឈប់ទទួល៖ ០៩​ កុម្ភះ ២០២៦",
                  style: AppTextStyle.tiltle16),
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
      style: TextStyle(color: textColor),
      decoration: InputDecoration(
        hintStyle: TextStyle(color: hintColor),
        filled: true,
        fillColor: backgroundColor,
        hintText: hintText,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: borderColor),
        ),
      ),
    );
  }

  // ✅ edited: add imagePath and show thumbnail
  Widget fileItemWidget({
    required String fileName,
    required String sizeText,
    required String imagePath,
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
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: imagePath.isEmpty
                ? Container(
                    width: 36,
                    height: 36,
                    color: const Color(0xFFEAF1FF),
                    child: const Icon(
                      Icons.image_outlined,
                      color: Color(0xFF2E6BFF),
                    ),
                  )
                : Image.file(
                    File(imagePath),
                    width: 36,
                    height: 36,
                    fit: BoxFit.cover,
                  ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fileName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
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
          behavior: HitTestBehavior.opaque,
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
              child: const Column(
                children: [
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
