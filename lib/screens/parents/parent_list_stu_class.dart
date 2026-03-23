import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tamdansers_app/constants/text_style.dart';
import 'package:tamdansers_app/repositories/student_class_repo.dart';
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
      final linkedUserId = widget.student!['linked_user_id'] as int?;
      if (linkedUserId != null) {
        final classIds = await UserRepo().getJoinedClassIds(linkedUserId);
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
            firstName: _currentParent?["first_name"] ?? "Parent",
            lastName: _currentParent?["last_name"] ?? "",
            gender: _currentParent?["gender"] ?? "male",
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : joinedClassIds.isNotEmpty
                      ? StudentHasJoinedClass(
                          userId: widget.student?['linked_user_id'] ?? 0,
                          classIds: joinedClassIds,
                          onClassTap: (classId) async {

                            final linkedUserId =
                                widget.student?['linked_user_id'] as int?;
                            if (linkedUserId != null) {
                              final studentClassRecord =
                                  await StudentClassRepo()
                                      .getStudentClassByUserIdAndClassId(
                                          linkedUserId, classId);
                              if (studentClassRecord != null) {
                                if (mounted) {
                                  Navigator.pushNamed(
                                    context,
                                    AppRoutes.parentsDashboard,
                                    arguments: {
                                      'studentClassId':
                                          studentClassRecord['id'],
                                      'classId': classId,
                                    },
                                  );
                                }
                              }
                            }
                          },
                        )
                      : Center(
                          child: Text("មិនមានថ្នាក់រៀន",
                              style: AppTextStyle.body)),
            ),
          ),
        ],
      ),
    );
  }
}
