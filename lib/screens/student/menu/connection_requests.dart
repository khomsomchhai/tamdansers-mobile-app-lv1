import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tamdansers_app/constants/app_colors.dart';
import 'package:tamdansers_app/constants/text_style.dart';
import 'package:tamdansers_app/repositories/parent_student_repo.dart';

class ConnectionRequests extends StatefulWidget {
  const ConnectionRequests({super.key});

  @override
  State<ConnectionRequests> createState() => _ConnectionRequestsState();
}

class _ConnectionRequestsState extends State<ConnectionRequests> {
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
      final studentId = pref.getInt("userId");
      if (studentId == null) return;

      final parentStudentRepo = ParentStudentRepo();
      final requests = await parentStudentRepo.getPendingRequestsForStudent(studentId);
      setState(() {
        _pendingRequests = requests;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // Handle error
    }
  }

  Future<void> _respondToRequest(int connectionId, bool accept) async {
    try {
      final parentStudentRepo = ParentStudentRepo();
      if (accept) {
        await parentStudentRepo.approveConnection(connectionId);
      } else {
        await parentStudentRepo.rejectConnection(connectionId);
      }
      _loadPendingRequests();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(accept ? 'សំណើត្រូវបានទទួលយក' : 'សំណើត្រូវបានបដិសេធ'),
            backgroundColor: accept ? AppColors.success : AppColors.error,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('មានបញ្ហាបច្ចេកទេស'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('សំណើភ្ជាប់ពីឪពុកម្តាយ', style: AppTextStyle.sectionTitle20),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _pendingRequests.isEmpty
              ? Center(
                  child: Text(
                    'មិនមានសំណើភ្ជាប់ទេ',
                    style: AppTextStyle.body,
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _pendingRequests.length,
                  itemBuilder: (context, index) {
                    final request = _pendingRequests[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${request['parent_first_name']} ${request['parent_last_name']}',
                              style: AppTextStyle.body
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'អ៊ីម៉ែល: ${request['parent_email']}',
                              style: AppTextStyle.body,
                            ),
                            Text(
                              'លេខទូរស័ព្ទ: ${request['parent_phone']}',
                              style: AppTextStyle.body,
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: () => _respondToRequest(request['id'], false),
                                  child: Text(
                                    'បដិសេធ',
                                    style: AppTextStyle.body.copyWith(color: AppColors.error),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                ElevatedButton(
                                  onPressed: () => _respondToRequest(request['id'], true),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primaryMain,
                                    foregroundColor: AppColors.white,
                                  ),
                                  child: const Text('ទទួលយក'),
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