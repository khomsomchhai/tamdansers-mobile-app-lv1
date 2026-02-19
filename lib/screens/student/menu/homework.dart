import 'package:flutter/material.dart';
import 'package:tamdansers_app/constants/app_colors.dart';
import 'package:tamdansers_app/constants/text_style.dart';
import 'package:tamdansers_app/routes/app_routes.dart';

enum TaskStatus {
  completed,
  notSubmitted,
  inProgress,
  late,
}
Color _statusColor(TaskStatus status) {
  switch (status) {
    case TaskStatus.completed:
      return Colors.green;
    case TaskStatus.notSubmitted:
      return Colors.red;
    case TaskStatus.inProgress:
      return Colors.blue;
    case TaskStatus.late:
      return Colors.orange;
  }
}

String _statusText(TaskStatus status) {
  switch (status) {
    case TaskStatus.completed:
      return "បានបញ្ចប់";
    case TaskStatus.notSubmitted:
      return "មិនទាន់ផ្ញើរ";
    case TaskStatus.inProgress:
      return "កំពុងរៀបចំ";
    case TaskStatus.late:
      return "យឺតយ៉ាវ";
  }
}

class Homework extends StatefulWidget {
  const Homework({super.key});
  
  @override
  State<Homework> createState() => _HomeworkState();
}

class _HomeworkState extends State<Homework> {
  
  int selectedIndex = 1;
  
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text('កិច្ចការផ្ទះ',style: AppTextStyle.screenTitle24,),
        actions: [
          Icon(Icons.notifications_sharp,color: AppColors.primaryText,)
        ],
        
      ),
      body: Column(
        children: [
          const SizedBox(height: 12),
          tabWidget(),
          const SizedBox(height: 12),

          Expanded(
            child: selectedIndex == 0
                ? oldTaskListWidget()
                : newTaskListWidget(),
          ),
        ], 
      )
    );
  }
  Widget tabWidget() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 18),
    child: Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF2F6),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Expanded(
            child: tabButton(
              "បានបញ្ចប់",
              selectedIndex == 0,
              () => setState(() => selectedIndex = 0),
            ),
          ),
          Expanded(
            child: tabButton(
              "កំពុងបន្ត",
              selectedIndex == 1,
              () => setState(() => selectedIndex = 1),
            ),
          ),
        ],
      ),
    ),
  );
}
 Widget tabButton(String text, bool active, VoidCallback onPressed) {
  return ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      elevation: 0,
      backgroundColor: active ? Colors.white : Colors.transparent,
      foregroundColor: active ? Colors.blue : Colors.grey,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
    ),
    child: Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

  Widget taskCard({
  required String title,
  required String subtitle,
  required String date,
  IconData? icon,            // ✅ optional
  String? imagePath,         // ✅ optional
  required Color color,
  required TaskStatus status,
  required bool isClosed,
}) {
  return Container(
    padding: const EdgeInsets.all(14),
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
      children: [
        Row(
          children: [
            Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(14),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: imagePath != null
                    ? Image.asset(
                        imagePath,
                        fit: BoxFit.cover,
                      )
                    : icon != null
                        ? Icon(icon, color: color)
                        : const SizedBox(),
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.detailTeach,
                        arguments: title,
                      );
                    },
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: _statusColor(status).withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                _statusText(status),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: _statusColor(status),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        Row(
          children: [
            const Icon(Icons.calendar_month, size: 16, color: Colors.grey),
            const SizedBox(width: 6),
            Text(
              isClosed ? "ឈប់ទទួល $date" : "បានផ្ញើរ $date",
              style: TextStyle(
                color: isClosed ? Colors.red : Colors.grey,
                fontWeight:
                    isClosed ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            const Spacer(),
          ],
        )
      ],
    ),
  );
}

Widget taskListWidget() {
  return ListView(
    padding: const EdgeInsets.all(18),
    children: [
      GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, AppRoutes.detail,);
        },
        child: taskCard(
          title: "គណិតវិទ្យា",
          subtitle: "ពិនិត្យឯកសារ ម្តងទៀត",
          date: "08-01-2026",
          icon: Icons.grid_view,
          color: Colors.blue,
          status: TaskStatus.completed,
          isClosed: false
        ),
      ),
      const SizedBox(height: 15),
      GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, AppRoutes.detail,);
        },
        child: taskCard(
          title: "រូបវិទ្យា",
          subtitle: "បញ្ចូលទិន្នន័យ តាមឯកសារ",
          date: "05-01-2026",
          icon: Icons.science,
          color: Colors.green,
          status: TaskStatus.completed,
          isClosed: false
        ),
      ),
      const SizedBox(height: 15),
      GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, AppRoutes.detail,);
        },
        child: taskCard(
          title: "ភូមវិទ្យា",
          subtitle: "ពិនិត្យព័ត៌មាន ស្រុក សង្កាត់",
          date: "03-01-2026",
          icon: Icons.public,
          color: Colors.orange,
          status: TaskStatus.completed,
          isClosed: false
        ),
      ),
      const SizedBox(height: 15),
      GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, AppRoutes.detail,);
        },
        child: taskCard(
          title: "ផែនដី",
          subtitle: "ពិនិត្យព័ត៌មាន ស្រុក សង្កាត់",
          date: "03-01-2026",
          icon: Icons.public,
          color: AppColors.primaryBg,
          status: TaskStatus.completed,
          isClosed: false
        ),
      ),
      const SizedBox(height: 15),
      GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, AppRoutes.detail,);
        },
        child: taskCard(
          title: "គិំមីវិទ្យា",
          subtitle: "ពិនិត្យព័ត៌មាន ស្រុក សង្កាត់",
          date: "03-01-2026",
          icon: Icons.science_sharp,
          color: AppColors.secondaryText,
          status: TaskStatus.completed,
          isClosed: false
        ),
      ),
      const SizedBox(height: 15),
      GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, AppRoutes.detail,);
        },
        child: taskCard(
          title: "ប្រវត្តិវិទ្យា",
          subtitle: "ពិនិត្យព័ត៌មាន ស្រុក សង្កាត់",
          date: "03-01-2026",
          imagePath: "assets/icons/history.jpg",
          color: Colors.orange,
          status: TaskStatus.completed,
          isClosed: false
        ),
      ),
      const SizedBox(height: 15),
      GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, AppRoutes.detail,);
        },
        child: taskCard(
          title: "ភាសាខ្មែរ",
          subtitle: "ពិនិត្យព័ត៌មាន ស្រុក សង្កាត់",
          date: "03-01-2026",
          imagePath: 'assets/icons/khmer.jpg',
          color: Colors.orange,
          status: TaskStatus.completed,
          isClosed: false
        ),
      ),
      const SizedBox(height: 15),
      GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, AppRoutes.detail,);
        },
        child: taskCard(
          title: "ជីវះវិទ្យា",
          subtitle: "ពិនិត្យព័ត៌មាន ស្រុក សង្កាត់",
          date: "03-01-2026",
          imagePath: 'assets/icons/biology.jpg',
          color: Colors.orange,
          status: TaskStatus.completed,
          isClosed: false
        ),
      ),
      const SizedBox(height: 15),
      GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, AppRoutes.detail,);
        },
        child: taskCard(
          title: "អង់គ្លេស",
          subtitle: "ពិនិត្យព័ត៌មាន ស្រុក សង្កាត់",
          date: "03-01-2026",
          imagePath: 'assets/icons/english.jpg',
          color: Colors.orange,
          status: TaskStatus.completed,
          isClosed: false
        ),
      ),
    ],
  );
}
Widget oldTaskListWidget() {
  return taskListWidget(); // reuse your existing
}

Widget newTaskListWidget() {
  return ListView(
    padding: const EdgeInsets.all(18),
    children: [
      GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, AppRoutes.detail,);
        },
        child: taskCard(
          title: "គណិតវិទ្យា",
          subtitle: "ពិនិត្យឯកសារ ម្តងទៀត",
          date: "08-01-2026",
          icon: Icons.grid_view,
          color: Colors.blue,
          status: TaskStatus.inProgress,
          isClosed: true
        ),
      ),
      const SizedBox(height: 15),
      GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, AppRoutes.detail,);
        },
        child: taskCard(
          title: "រូបវិទ្យា",
          subtitle: "បញ្ចូលទិន្នន័យ តាមឯកសារ",
          date: "05-01-2026",
          icon: Icons.science,
          color: Colors.green,
          status: TaskStatus.late,
          isClosed: true
        ),
      ),
      const SizedBox(height: 15),
      GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, AppRoutes.detail,);
        },
        child: taskCard(
          title: "ភូមវិទ្យា",
          subtitle: "ពិនិត្យព័ត៌មាន ស្រុក សង្កាត់",
          date: "03-01-2026",
          icon: Icons.public,
          color: Colors.orange,
          status: TaskStatus.notSubmitted,
          isClosed: true
        ),
      ),
      const SizedBox(height: 15),
      GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, AppRoutes.detail,);
        },
        child: taskCard(
          title: "ផែនដី",
          subtitle: "ពិនិត្យព័ត៌មាន ស្រុក សង្កាត់",
          date: "03-01-2026",
          icon: Icons.public,
          color: AppColors.primaryBg,
          status: TaskStatus.inProgress,
          isClosed: true
        ),
      ),
      const SizedBox(height: 15),
      GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, AppRoutes.detail,);
        },
        child: taskCard(
          title: "គិំមីវិទ្យា",
          subtitle: "ពិនិត្យព័ត៌មាន ស្រុក សង្កាត់",
          date: "03-01-2026",
          icon: Icons.science_sharp,
          color: AppColors.secondaryText,
          status: TaskStatus.notSubmitted,
          isClosed: true
        ),
      ),
      const SizedBox(height: 15),
      GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, AppRoutes.detail,);
        },
        child: taskCard(
          title: "ប្រវត្តិវិទ្យា",
          subtitle: "ពិនិត្យព័ត៌មាន ស្រុក សង្កាត់",
          date: "03-01-2026",
          imagePath: "assets/icons/history.jpg",
          color: Colors.orange,
          status: TaskStatus.late,
          isClosed: true
        ),
      ),
      const SizedBox(height: 15),
      GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, AppRoutes.detail,);
        },
        child: taskCard(
          title: "ភាសាខ្មែរ",
          subtitle: "ពិនិត្យព័ត៌មាន ស្រុក សង្កាត់",
          date: "03-01-2026",
          imagePath: 'assets/icons/khmer.jpg',
          color: Colors.orange,
          status: TaskStatus.inProgress,
          isClosed: true
        ),
      ),
      const SizedBox(height: 15),
      GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, AppRoutes.detail,);
        },
        child: taskCard(
          title: "ជីវះវិទ្យា",
          subtitle: "ពិនិត្យព័ត៌មាន ស្រុក សង្កាត់",
          date: "03-01-2026",
          imagePath: 'assets/icons/biology.jpg',
          color: Colors.orange,
          status: TaskStatus.notSubmitted,
          isClosed: true
        ),
      ),
      const SizedBox(height: 15),
      GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, AppRoutes.detail,);
        },
        child: taskCard(
          title: "អង់គ្លេស",
          subtitle: "ពិនិត្យព័ត៌មាន ស្រុក សង្កាត់",
          date: "03-01-2026",
          imagePath: 'assets/icons/english.jpg',
          color: Colors.orange,
          status: TaskStatus.inProgress,
          isClosed: true
        ),
      ),
    ],
  );
}
}
