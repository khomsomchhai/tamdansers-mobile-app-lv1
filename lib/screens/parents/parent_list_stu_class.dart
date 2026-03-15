import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tamdansers_app/constants/app_colors.dart';
import 'package:tamdansers_app/constants/app_number.dart';
import 'package:tamdansers_app/constants/text_style.dart';
import 'package:tamdansers_app/repositories/user_repo.dart';
import 'package:tamdansers_app/routes/app_routes.dart';
import 'package:tamdansers_app/screens/parents/widget/parent_profile_header.dart';
import 'package:tamdansers_app/screens/student/widget/student_has_joined_class.dart';

class ParentListStuClass extends StatefulWidget {
  final Map<String, dynamic>? student;

  const ParentListStuClass({super.key, this.student});

  @override
  State<ParentListStuClass> createState() => _ParentListStuClassState();
}

class _ParentListStuClassState extends State<ParentListStuClass> {
  List<int> joinedClassIds = [];
  bool _loading = true;
  Map<String, dynamic>? _currentParent;

  @override
  void initState() {
    super.initState();
    _loadParentUser();
    _loadJoinedClasses();
  }

  Future<void> _loadParentUser() async {
    try {
      final pref = await SharedPreferences.getInstance();
      final userId = pref.getInt("userId");
      if (userId != null) {
        _currentParent = await UserRepo().getUserById(userId);
        setState(() {});
      }
    } catch (e) {
      debugPrint("Error loading parent user: $e");
    }
  }

  Future<void> _loadJoinedClasses() async {
    if (widget.student != null) {
      final studentId = widget.student!['id'] as int?;
      if (studentId != null) {
        final classIds = await UserRepo().getJoinedClassIds(studentId);
        setState(() {
          joinedClassIds = classIds;
          _loading = false;
        });
      } else {
        setState(() {
          _loading = false;
        });
      }
    } else {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ParentProfileHeader(
            name: _currentParent?["first_name"] ?? "Parent",
            gender: _currentParent?["gender"] ?? "male",
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Row(
              children: [
                Icon(
                  Icons.account_circle_rounded,
                  size: AppNumber.iconLarge,
                  color: AppColors.primaryText,
                ),
                SizedBox(
                  width: 8,
                ),
                Text("គណនីសិស្ស", style: AppTextStyle.subtitle18),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : joinedClassIds.isNotEmpty
                      ? StudentHasJoinedClass(
                          userId: widget.student?['id'] ?? 0,
                          classIds: joinedClassIds,
                          onClassTap: () {
                            Navigator.pushNamed(context, AppRoutes.ParentsDashboard);
                          },
                        )
                      : const Center(child: Text("No classes joined")),
            ),
          ),
        ],
      ),
    );
  }
}
