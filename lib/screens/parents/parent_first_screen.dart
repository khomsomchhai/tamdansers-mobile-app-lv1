import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tamdansers_app/constants/app_colors.dart';
import 'package:tamdansers_app/constants/app_number.dart';
import 'package:tamdansers_app/repositories/parent_student_repo.dart';
import 'package:tamdansers_app/repositories/user_repo.dart';
import 'package:tamdansers_app/routes/app_routes.dart';
import 'package:tamdansers_app/screens/parents/widget/parent_empty_data.dart';
import 'package:tamdansers_app/screens/parents/widget/parent_has_data.dart';
import 'package:tamdansers_app/screens/parents/widget/parent_profile_header.dart';

class ParentFirstScreen extends StatefulWidget {
  const ParentFirstScreen({super.key});

  @override
  State<ParentFirstScreen> createState() => _ParentFirstScreenState();
}

class _ParentFirstScreenState extends State<ParentFirstScreen> {
  Map<String, dynamic>? _currentUser;
  List<Map<String, dynamic>> _students = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final pref = await SharedPreferences.getInstance();
      final userId = pref.getInt("userId");

      if (userId != null) {
        // Fetch current user data
        final userRepo = UserRepo();
        _currentUser = await userRepo.getUserById(userId);

        // Fetch connected students
        final parentStudentRepo = ParentStudentRepo();
        _students = await parentStudentRepo.getStudentsByParent(userId);
      }
    } catch (e) {
      print("Error loading data: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      body: Column(
        children: [
          ParentProfileHeader(
            name: _currentUser?["first_name"] ?? "Parent",
            gender: _currentUser?["gender"] ?? "male",
          ),
          Expanded(
              child: _students.isNotEmpty
                  ? ParentHasData(students: _students)
                  : ParentEmptyData())
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.parentConnectStudent);
        },
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppNumber.radiusMedium)),
        backgroundColor: AppColors.primaryMain,
        child: Icon(
          Icons.add,
          color: AppColors.white,
          size: AppNumber.iconLarge,
        ),
      ),
    );
  }
}
