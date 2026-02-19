import 'package:flutter/material.dart';
import 'package:tamdansers_app/constants/app_colors.dart';
import 'package:tamdansers_app/constants/text_style.dart';
import 'package:tamdansers_app/routes/app_routes.dart';

class DeatilTeacher extends StatefulWidget {
  const DeatilTeacher({super.key});

  @override
  State<DeatilTeacher> createState() => _DeatilTeacherState();
}

class _DeatilTeacherState extends State<DeatilTeacher> {
  // ✅ Example lessons (replace with API later)
  final List<Map<String, dynamic>> allLessons = [
    {
      "title": "មេរៀន ១៖ ចំនួនគត់",
      "subtitle": "បង្រៀនដោយ គ្រូម៉េង",
      "completed": true,
    },
    {
      "title": "មេរៀន ២៖ ប្រភាគ",
      "subtitle": "បង្រៀនដោយ គ្រូម៉េង",
      "completed": false,
    },
    {
      "title": "មេរៀន ៣៖ អនុគមន៍",
      "subtitle": "បង្រៀនដោយ គ្រូម៉េង",
      "completed": false,
    },
    {
      "title": "មេរៀន ៤៖ សមីការ",
      "subtitle": "បង្រៀនដោយ គ្រូម៉េង",
      "completed": false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    // ✅ accept both String and Map arguments (avoid crash)
    final Object? rawArgs = ModalRoute.of(context)?.settings.arguments;

    String titleAppBar = "មុខវិជ្ជា";
    bool showAll = false;

    if (rawArgs is String) {
      // old style: arguments: "គណិតវិទ្យា"
      titleAppBar = rawArgs;
    } else if (rawArgs is Map) {
      // new style: arguments: {"title": "...", "showAll": true}
      titleAppBar = (rawArgs["title"] ?? "មុខវិជ្ជា").toString();
      showAll = rawArgs["showAll"] == true;
    }

    final lessonsToShow = showAll ? allLessons : allLessons.take(2).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(titleAppBar),
        centerTitle: true,
        actions: const [Icon(Icons.menu)],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              taskCard(),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text("មេរៀន", style: AppTextStyle.sectionTitle20),
                  ),
                  const Spacer(),
                  if (!showAll)
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.detailTeach,
                            arguments: {
                              "title": titleAppBar,
                              "showAll": true,
                            },
                          );
                        },
                        child: Text("មើលទាំងអស់", style: AppTextStyle.til16),
                      ),
                    ),
                ],
              ),

              // ✅ render lessons
              Column(
                children: lessonsToShow.map((l) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: buildLessonCard(
                      title: l["title"].toString(),
                      subtitle: l["subtitle"].toString(),
                      isCompleted: l["completed"] == true,
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 8),

              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text("កិច្ចការផ្ទះ", style: AppTextStyle.sectionTitle20),
              ),
              subMitted(title: "លំហាត់មេរៀនទី២", subtitle: "ផុតកំណត់ថ្ងៃស្អែក"),

              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text("ឯកសារយោង", style: AppTextStyle.sectionTitle20),
              ),
              reFerence(),
            ],
          ),
        ),
      ),
    );
  }

  Widget taskCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              color: const Color(0xFFEAF1FF),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Center(
              child: Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFE6EAF2)),
                ),
                child: const Center(
                  child: Text(
                    "上",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "គណិតវិទ្យា",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0B1220),
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  "សុង ម៉េង (ថ្នាក់ទី៩)",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "មធ្យមភាគ",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.black45,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          "85%",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF2F6BFF),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 14),
                    Container(width: 1, height: 28, color: Color(0xFFE8EDF5)),
                    const SizedBox(width: 14),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "វត្តមាន",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.black45,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          "98%",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF17B26A),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildLessonCard({
    required String title,
    required String subtitle,
    required bool isCompleted,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFEFF2FF),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Center(
              child: Icon(
                Icons.menu_book_rounded,
                color: Color(0xFF5B6CFF),
                size: 22,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0B1220),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.black.withOpacity(0.45),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isCompleted
                    ? const Color(0xFF17B26A)
                    : const Color(0xFFD0D5DD),
                width: 2,
              ),
            ),
            child: Center(
              child: Icon(
                isCompleted ? Icons.check : Icons.lock_outline,
                size: 16,
                color: isCompleted
                    ? const Color(0xFF17B26A)
                    : const Color(0xFF98A2B3),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget subMitted({required String title, required String subtitle}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(24, 244, 67, 54),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Center(
                  child:
                      Icon(Icons.menu_book_rounded, color: Colors.red, size: 22),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0B1220),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.black.withOpacity(0.45),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.submitted);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.link,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text("បញ្ចូនកិច្ចការ", style: AppTextStyle.size18),
            ),
          ),
        ],
      ),
    );
  }

  Widget reFerence() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 150,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: Color.fromARGB(55, 244, 67, 54),
                  child: Icon(Icons.picture_as_pdf, color: Colors.red),
                ),
                SizedBox(height: 8),
                Text("ស្លាយមេរៀន.pdf"),
                SizedBox(height: 8),
                Text("2.8 MB"),
              ],
            ),
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Container(
            height: 150,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: const Color.fromARGB(75, 33, 149, 243),
                  child: Icon(Icons.video_call, color: AppColors.link),
                ),
                const SizedBox(height: 8),
                const Text("ស្លាយមេរៀន.pptx"),
                const SizedBox(height: 8),
                const Text("1.8 MB"),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
