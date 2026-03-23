import 'package:flutter/material.dart';
import 'package:tamdansers_app/repositories/class_repo.dart';
import 'package:tamdansers_app/repositories/student_class_repo.dart';
import 'package:tamdansers_app/repositories/user_repo.dart';
import 'package:tamdansers_app/routes/app_routes.dart';
import 'package:tamdansers_app/widget/class_card.dart';

class StudentHasJoinedClass extends StatefulWidget {
  final int userId;
  final List<int> classIds;
  final Function(int)? onClassTap; // Now receives classId
  const StudentHasJoinedClass(
      {super.key, required this.userId, required this.classIds, this.onClassTap});

  @override
  State<StudentHasJoinedClass> createState() => _StudentHasJoinedClassState();
}

class _StudentHasJoinedClassState extends State<StudentHasJoinedClass> {
  List<Map<String, dynamic>> _classes = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void didUpdateWidget(StudentHasJoinedClass oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.classIds.length != widget.classIds.length ||
        !_listEquals(oldWidget.classIds, widget.classIds)) {
      _loadData();
    }
  }

  bool _listEquals(List<int> a, List<int> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  Future<void> _loadData() async {
    print('DEBUG StudentHasJoinedClass: Loading classes, classIds: ${widget.classIds}');
    if (widget.classIds.isEmpty) {
      if (mounted)
        setState(() {
          _classes = [];
          _loading = false;
        });
      return;
    }
    setState(() => _loading = true);
    final results = await Future.wait(widget.classIds.map((id) async {
      print('DEBUG StudentHasJoinedClass: Loading class $id');
      final cls = await ClassRepo().getClassById(id);
      print('DEBUG StudentHasJoinedClass: Class $id data: $cls');
      final count = await StudentClassRepo().getStudentCountByClass(id);
      if (cls == null) {
        print('DEBUG StudentHasJoinedClass: Class $id is null, skipping');
        return null;
      }
      
      final teacher = await UserRepo().getUserById(cls['teacher_id'] as int);
      final teacherName = teacher != null 
          ? '${teacher['first_name']} ${teacher['last_name']}'
          : 'Unknown';
      
      return {...cls, '_studentCount': count, '_teacherName': teacherName};
    }));
    print('DEBUG StudentHasJoinedClass: Results: $results');
    if (mounted) {
      setState(() {
        _classes = results.whereType<Map<String, dynamic>>().toList();
        print('DEBUG StudentHasJoinedClass: Filtered classes count: ${_classes.length}');
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print('DEBUG StudentHasJoinedClass build: _loading=$_loading, _classes.length=${_classes.length}');
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    return ListView.builder(
      itemCount: _classes.length,
      itemBuilder: (context, i) {
        final cls = _classes[i];
        final count = cls['_studentCount'] as int;
        final teacherName = cls['_teacherName'] as String? ?? 'Unknown';
        final classId = cls['id'] as int;
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: ClassCard(
            className: "${cls['name']} (${cls['grade']} ${cls['section']})",
            title: cls['semester'] as String? ?? '',
            students: "$count នាក់",
            color: Color(int.parse(
                (cls['color_hex'] as String).replaceFirst('#', '0xFF'))),
            classCode:'គ្រូបន្ទុកថ្នាក់: $teacherName',
            onTap: widget.onClassTap != null
                ? () => widget.onClassTap!(classId)
                : () {
                    Navigator.pushNamed(context, AppRoutes.studentDashboard, arguments: {'userId': widget.userId, 'classId': classId});
                  },
            teacherName: '',
          ),
        );
      },
    );
  }
}
