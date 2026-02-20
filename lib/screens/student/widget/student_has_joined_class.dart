import 'package:flutter/material.dart';
import 'package:tamdansers_app/routes/app_routes.dart';
import 'package:tamdansers_app/widget/class_card.dart';

class StudentHasJoinedClass extends StatelessWidget {
  const StudentHasJoinedClass({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            children: [
              ClassCard(
                className: "ថ្នាក់ទី 7A (Grade 7A)",
                title: "គ្រូបន្ទុកថ្នាក់",
                students: "36 នាក់",
                color: Color(0xFF1976D2),
                onTap: () {
                  Navigator.pushNamed(
                    context, 
                    AppRoutes.studentDashboard
                  );
                },
              ),
              SizedBox(height: 12),
              ClassCard(
                className: "ថ្នាក់ទី 7A (Grade 7A)",
                title: "គ្រូបន្ទុកថ្នាក់",
                students: "36 នាក់",
                color: Color(0xFF00897B),
                onTap: () {
                  Navigator.pushNamed(
                    context, 
                    AppRoutes.studentDashboard
                  );
                },
              ),
              SizedBox(height: 12),
              ClassCard(
                className: "ថ្នាក់ទី 7A (Grade 7A)",
                title: "គ្រូបន្ទុកថ្នាក់",
                students: "36 នាក់",
                color: Color(0xFF546E7A),
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