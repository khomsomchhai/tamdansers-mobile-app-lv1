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
  Map<String, dynamic>? user;
  List<int> joinedClassIds = [];

  bool get hasJoinedClass => joinedClassIds.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final fetched = await UserRepo().getUserById(widget.userId);
    final classIds = await UserRepo().getJoinedClassIds(widget.userId);
    setState(() {
      user = fetched;
      joinedClassIds = classIds;
    });
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
                SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: hasJoinedClass
                      ? StudentHasJoinedClass(
                          userId: widget.userId,
                          classIds: joinedClassIds,
                        )
                      : StudentEmptyClass(
                          userId: widget.userId, onJoined: _loadUser),
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
          onPressed: () async {
            final result = await Navigator.pushNamed(
                context, AppRoutes.joinClassSreen,
                arguments: widget.userId);
            if (result == true) {
              _loadUser(); // Refresh user data
            }
          },
          child: Icon(
            Icons.add,
            color: AppColors.white,
            size: AppNumber.iconLarge,
          ),
        ));
  }
}
