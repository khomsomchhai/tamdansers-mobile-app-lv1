import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tamdansers_app/constants/app_colors.dart';
import 'package:tamdansers_app/constants/app_icon.dart';
import 'package:tamdansers_app/constants/app_number.dart';
import 'package:tamdansers_app/constants/text_style.dart';
import 'package:tamdansers_app/repositories/parent_student_repo.dart';
import 'package:tamdansers_app/repositories/student_class_repo.dart';
import 'package:tamdansers_app/widget/custom_snackbar.dart';

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
      final userId = pref.getInt("userId");
      if (userId == null) return;
      final studentClassRepo = StudentClassRepo();
      var studentRow = await studentClassRepo.getStudentByLinkedUserId(userId);

      if (studentRow == null) {
        setState(() {
          _isLoading = false;
        });
        return;
      }

      final studentClassId = studentRow["id"] as int;

      final parentStudentRepo = ParentStudentRepo();
      final requests =
          await parentStudentRepo.getPendingRequestsForStudent(studentClassId);
      setState(() {
        _pendingRequests = requests;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error requests: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _respondToRequest(int connectionId, bool accept) async {
    try {
      final parentStudentRepo = ParentStudentRepo();
      int result = 0;
      if (accept) { 
        result = await parentStudentRepo.approveConnection(connectionId);
      } else {
        result = await parentStudentRepo.rejectConnection(connectionId);
        debugPrint('result: $result');
      }
      _loadPendingRequests();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            content: CustomSnackbar(
              title: accept ? "ទទួលយក!" : "បដិសេធ!",
              message: accept ? 'សំណើត្រូវបានទទួលយក' : 'សំណើត្រូវបានបដិសេធ',
              icon: accept ? Icons.check_circle : Icons.cancel,
              color: accept ? AppColors.success : AppColors.error,
            ),
          ),
        );
      }
    } catch (e) {
      debugPrint('Error responding: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            content: CustomSnackbar(
              title: "មានបញ្ហា!",
              message: 'មានបញ្ហាបច្ចេកទេស',
              icon: Icons.error,
              color: AppColors.error,
            ),
          ),
        );
      }
    }
  }

  Widget _contactRow(IconData icon, String label, String? value) {
    return Row(
      children: [
        Icon(icon, color: AppColors.secondaryText, size: 20),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: AppTextStyle.body14.copyWith(color: AppColors.secondaryText),
        ),
        Expanded(
          child: Text(
            value ?? 'មិនមានទិន្នន័យ',
            style: AppTextStyle.body14,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text('សំណើភ្ជាប់ពីឪពុកម្តាយ', style: AppTextStyle.sectionTitle20),
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
                  padding: const EdgeInsets.all(20),
                  itemCount: _pendingRequests.length,
                  itemBuilder: (context, index) {
                    final request = _pendingRequests[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius:
                            BorderRadius.circular(AppNumber.radiusLarge),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryText.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: AppColors.primaryMain
                                          .withOpacity(0.2),
                                      width: 2,
                                    ),
                                  ),
                                  child: ClipOval(
                                    child: Image.asset(
                                      AppIcon.profileParent,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${request['parent_first_name']} ${request['parent_last_name']}',
                                        style: AppTextStyle.subtitle18,
                                      ),
                                      const SizedBox(height: 4),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: AppColors.comment
                                              .withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          'សំណើភ្ជាប់ពីឪពុកម្តាយ',
                                          style: AppTextStyle.caption12Secondary
                                              .copyWith(
                                            color: AppColors.comment,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppColors.backgroundLight,
                                borderRadius: BorderRadius.circular(
                                    AppNumber.radiusMedium),
                              ),
                              child: Column(
                                children: [
                                  _contactRow(Icons.email_outlined, 'អ៊ីម៉ែល',
                                      request['parent_email']),
                                  const SizedBox(height: 8),
                                  _contactRow(Icons.phone_outlined,
                                      'លេខទូរស័ព្ទ', request['parent_phone']),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: () =>
                                        _respondToRequest(request['id'], false),
                                    style: OutlinedButton.styleFrom(
                                      side: const BorderSide(
                                          color: AppColors.error),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            AppNumber.radiusMedium),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.close,
                                            color: AppColors.error, size: 20),
                                        const SizedBox(width: 8),
                                        Text(
                                          'បដិសេធ',
                                          style: AppTextStyle
                                              .buttonText15Primary
                                              .copyWith(color: AppColors.error),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () =>
                                        _respondToRequest(request['id'], true),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primaryMain,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            AppNumber.radiusMedium),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.check,
                                            color: AppColors.white, size: 20),
                                        const SizedBox(width: 8),
                                        Text(
                                          'ទទួលយក',
                                          style: AppTextStyle.buttonText16White,
                                        ),
                                      ],
                                    ),
                                  ),
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
