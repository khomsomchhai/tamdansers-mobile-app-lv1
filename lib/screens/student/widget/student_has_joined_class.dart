import 'package:flutter/material.dart';
import 'package:tamdansers_app/repositories/class_repo.dart';
import 'package:tamdansers_app/repositories/user_repo.dart';
import 'package:tamdansers_app/routes/app_routes.dart';
import 'package:tamdansers_app/widget/class_card.dart';

class StudentHasJoinedClass extends StatefulWidget {
  final int userId;
  const StudentHasJoinedClass({super.key, required this.userId});

  @override
  State<StudentHasJoinedClass> createState() => _StudentHasJoinedClassState();
}

class _StudentHasJoinedClassState extends State<StudentHasJoinedClass> {
  Map<String, dynamic>? user;
  Map<String, dynamic>? classData;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final fetchedUser = await UserRepo().getUserById(widget.userId);
    if (fetchedUser != null && fetchedUser['class_id'] != null) {
      final fetchedClass = await ClassRepo().getClassById(fetchedUser['class_id']);
      setState(() {
        user = fetchedUser;
        classData = fetchedClass;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (classData == null) {
      return Center(child: CircularProgressIndicator());
    }
    return Column(
      children: [
        Expanded(
          child: ListView(
            children: [
              ClassCard(
                className: "${classData!['name']} (${classData!['grade']} ${classData!['section']})",
                title: "គ្រូបន្ទុកថ្នាក់",
                students: "36 នាក់", // TODO: get actual count
                color: Color(int.parse(classData!['color_hex'].replaceFirst('#', '0xFF'))),
                onTap: () {
                  Navigator.pushNamed(
                    context, 
                    AppRoutes.studentDashboard
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}