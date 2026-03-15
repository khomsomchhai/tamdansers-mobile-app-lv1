import 'package:flutter/material.dart';
import 'package:tamdansers_app/repositories/class_repo.dart';
import 'package:tamdansers_app/repositories/student_class_repo.dart';
import 'package:tamdansers_app/routes/app_routes.dart';
import 'package:tamdansers_app/widget/class_card.dart';

class StudentHasJoinedClass extends StatefulWidget {
  final int userId;
  final List<int> classIds;
  final VoidCallback? onClassTap;
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
      final cls = await ClassRepo().getClassById(id);
      final count = await StudentClassRepo().getStudentCountByClass(id);
      if (cls == null) return null;
      return {...cls, '_studentCount': count};
    }));
    if (mounted) {
      setState(() {
        _classes = results.whereType<Map<String, dynamic>>().toList();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    return ListView.builder(
      itemCount: _classes.length,
      itemBuilder: (context, i) {
        final cls = _classes[i];
        final count = cls['_studentCount'] as int;
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: ClassCard(
            className: "${cls['name']} (${cls['grade']} ${cls['section']})",
            title: cls['semester'] as String? ?? '',
            students: "$count នាក់",
            color: Color(int.parse(
                (cls['color_hex'] as String).replaceFirst('#', '0xFF'))),
            classCode: cls['class_code'] as String? ?? '',
            onTap: widget.onClassTap ?? () {
              Navigator.pushNamed(context, AppRoutes.studentDashboard);
            },
            teacherName: '',
          ),
        );
      },
    );
  }
}
