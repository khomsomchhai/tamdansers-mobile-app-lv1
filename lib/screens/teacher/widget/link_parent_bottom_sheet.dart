import 'package:flutter/material.dart';
import 'package:tamdansers_app/constants/app_colors.dart';
import 'package:tamdansers_app/constants/app_number.dart';
import 'package:tamdansers_app/constants/text_style.dart';
import 'package:tamdansers_app/repositories/parent_student_repo.dart';
import 'package:tamdansers_app/widget/custom_snackbar.dart';

class LinkParentBottomSheet extends StatefulWidget {
  final Map<String, dynamic>? student;
  final Map<String, dynamic> parent;

  const LinkParentBottomSheet({
    super.key,
    required this.student,
    required this.parent,
  });

  @override
  State<LinkParentBottomSheet> createState() => LinkParentBottomSheetState();
}

class LinkParentBottomSheetState extends State<LinkParentBottomSheet> {
  bool _saving = false;

  Future<void> _confirmLink() async {
    if (widget.student == null) return;

    final studentId = widget.student!['id'] as int?;
    final parentId = widget.parent['id'] as int?;
    if (studentId == null || parentId == null) return;

    setState(() => _saving = true);

    final repo = ParentStudentRepo();
    final alreadyLinked =
        await repo.isParentConnectedToStudent(parentId, studentId);
    if (alreadyLinked) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: CustomSnackbar(
              title: 'Info',
              message: 'អាណាព្យាបាលនេះបានភ្ជាប់រួចហើយ។',
              icon: Icons.info,
              color: Colors.blue,
            ),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      setState(() => _saving = false);
      return;
    }

    await repo.connectParentToStudent(parentId: parentId, studentId: studentId);

    if (mounted) {
      setState(() => _saving = false);
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final studentName =
        '${widget.student?['first_name'] ?? ''} ${widget.student?['last_name'] ?? ''}'
            .trim();
    final parentName =
        '${widget.parent['first_name'] ?? ''} ${widget.parent['last_name'] ?? ''}'
            .trim();

    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          top: 20,
        ),
        child: Container(
          decoration: const BoxDecoration(
            color: AppColors.backgroundLight,
            borderRadius:
                BorderRadius.vertical(top: Radius.circular(AppNumber.radiusPill)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 5,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: AppColors.grey.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(AppNumber.radiusMedium),
                  ),
                ),
                Text("ភ្ជាប់អាណាព្យាបាល", style: AppTextStyle.screenTitle24),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _roleCard(
                      icon: Icons.school,
                      title: "សិស្ស",
                      subtitle: studentName,
                      color: AppColors.primaryMain.withValues(alpha: 0.3),
                    ),
                    const SizedBox(width: 12),
                    CircleAvatar(
                      radius: 20,
                      backgroundColor:
                          AppColors.primaryMain.withValues(alpha: 0.2),
                      child: Icon(Icons.link, color: AppColors.primaryMain),
                    ),
                    const SizedBox(width: 12),
                    _roleCard(
                      icon: Icons.person,
                      title: "អាណាព្យាបាល",
                      subtitle: parentName,
                      color: AppColors.success.withValues(alpha: 0.3),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _saving ? null : _confirmLink,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryMain,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppNumber.radiusRounded),
                      ),
                    ),
                    child: Text(
                      _saving ? 'កំពុងភ្ជាប់...' : 'យល់ព្រម',
                      style: AppTextStyle.bodyWhite,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(AppNumber.radiusRounded),
                        ),
                        shadowColor: AppColors.transparent),
                    child: Text(
                      "បោះបង់",
                      style: AppTextStyle.body.copyWith(
                        color: AppColors.error,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _roleCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Container(
      width: 120,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppNumber.radiusRounded),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: AppColors.white,
            child: Icon(icon, color: AppColors.grey),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTextStyle.subtitle16,
          ),
          const SizedBox(height: 4),
          Text(
            subtitle.isEmpty ? '—' : subtitle,
            textAlign: TextAlign.center,
            style: AppTextStyle.body.copyWith(fontSize: 12),
          ),
        ],
      ),
    );
  }

}

