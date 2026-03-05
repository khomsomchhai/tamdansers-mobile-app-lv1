import 'package:flutter/material.dart';
import 'package:tamdansers_app/constants/app_colors.dart';
import 'package:tamdansers_app/constants/app_number.dart';
import 'package:tamdansers_app/repositories/user_repo.dart';
import 'package:tamdansers_app/routes/app_routes.dart';
import 'package:tamdansers_app/screens/student/widget/student_empty_class.dart';
import 'package:tamdansers_app/screens/student/widget/student_has_joined_class.dart';
import 'package:tamdansers_app/screens/student/widget/student_profile_header.dart';

class StudentFirstScreen extends StatefulWidget {
  final int userId;
  const StudentFirstScreen({super.key, required this.userId});

  @override
  State<StudentFirstScreen> createState() => _StudentFirstScreenState();
}
class _StudentFirstScreenState extends State<StudentFirstScreen> {

  bool hasJoinedClass = true;
  Map<String, dynamic>? user;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final fetched = await UserRepo().getUserById(widget.userId);
    final joined = _determineHasJoined(fetched);
    setState((){
      user = fetched;
      hasJoinedClass = joined;
    });
  }

  bool _determineHasJoined(Map<String, dynamic>? u) {
    if (u == null) return false;
    final keys = [
      'class_id',
      'class',
      'classCode',
      'class_code',
      'joined_class',
      'has_joined',
    ];
    for (var k in keys) {
      if (u.containsKey(k)) {
        final v = u[k];
        if (v is int && v != 0) return true;
        if (v is String && v.isNotEmpty) return true;
        if (v is bool && v) return true;
      }
    }
    return false;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            children: [
              StudentProfileHeader(user: user),
              SizedBox(height: 20,),
              Expanded(
                child: hasJoinedClass
                    ? StudentHasJoinedClass(userId: widget.userId)
                    : StudentEmptyClass(),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryMain,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppNumber.radiusMedium),
        ),
        onPressed: () {
          Navigator.push(
            context, 
            MaterialPageRoute(
              builder: (context) => JoinClassScreen(userId: widget.userId),
            ),
          );
        },
        child: Icon(
          Icons.add,
          color: AppColors.white,
          size: AppNumber.iconLarge,
        ),
      )
    );
  }
}