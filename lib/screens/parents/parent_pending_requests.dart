import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tamdansers_app/constants/app_colors.dart';
import 'package:tamdansers_app/constants/app_number.dart';
import 'package:tamdansers_app/constants/text_style.dart';
import 'package:tamdansers_app/repositories/parent_student_repo.dart';

class ParentPendingRequests extends StatefulWidget {
  const ParentPendingRequests({super.key});

  @override
  State<ParentPendingRequests> createState() => _ParentPendingRequestsState();
}

class _ParentPendingRequestsState extends State<ParentPendingRequests> {
  List<Map<String, dynamic>> _pendingRequests = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPendingRequests();
  }

  Future<void> _loadPendingRequests() async {
    try {
      final pref = await SharedPreferences.getInstance();
      final parentId = pref.getInt("userId");
      if (parentId == null) return;

      final parentStudentRepo = ParentStudentRepo();
      final requests = await parentStudentRepo.getPendingRequestsByParent(parentId);
      setState(() {
        _pendingRequests = requests;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('សំណើភ្ជាប់ដែលបានផ្ញើ', style: AppTextStyle.sectionTitle20),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _pendingRequests.isEmpty
              ? Center(
                  child: Text(
                    'មិនមានសំណើភ្ជាប់ដែលកំពុងរង់ចាំទេ',
                    style: AppTextStyle.body,
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _pendingRequests.length,
                  itemBuilder: (context, index) {
                    final request = _pendingRequests[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(AppNumber.radiusSmall),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'អ៊ីម៉ែល: ${request['student_email']}',
                                  style: AppTextStyle.body,
                                ),
                                Text(
                                  'សំណើររង់ចាំ',
                                  style: AppTextStyle.body.copyWith(color: Colors.orange),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}