import 'package:flutter/material.dart';
import 'package:tamdansers_app/constants/text_style.dart';
import 'package:tamdansers_app/repositories/user_repo.dart';
import 'package:tamdansers_app/routes/app_routes.dart';
import 'package:tamdansers_app/widget/class_card.dart';

class StudentHasJoinedClass extends StatelessWidget {
  final int userId;
  final List<Map<String, dynamic>> classes;

  const StudentHasJoinedClass({
    super.key,
    required this.userId,
    required this.classes,
  });

  @override
  Widget build(BuildContext context) {
    if (classes.isEmpty) {
      return Center(child: Text('មិនមានថ្នាក់ដែលបានចូលទេ', style: AppTextStyle.body));
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: classes.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final cls = classes[index];
        final className = "${cls['name']} (${cls['grade']} ${cls['section']})";
        final color = Color(int.parse(cls['color_hex'].replaceFirst('#', '0xFF')));

        return ClassCard(
          className: className,
          title: "គ្រូបន្ទុកថ្នាក់",
          students: "? នាក់",
          color: color,
          onTap: () async {
            await UserRepo().joinClass(userId, cls['id']);
            Navigator.pushNamed(
              context,
              AppRoutes.studentDashboard,
              arguments: userId,
            );
          },
        );
      },
    );
  }
}
