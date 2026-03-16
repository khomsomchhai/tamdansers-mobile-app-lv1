import 'package:flutter/material.dart';
import 'package:tamdansers_app/constants/app_colors.dart';
import 'package:tamdansers_app/constants/app_number.dart';
import 'package:tamdansers_app/constants/text_style.dart';
import 'package:tamdansers_app/repositories/user_repo.dart';
import 'package:tamdansers_app/screens/teacher/widget/link_parent_bottom_sheet.dart';
import 'package:tamdansers_app/widget/custom_snackbar.dart';
import 'package:tamdansers_app/widget/search_field.dart';

class LinkParentScreen extends StatefulWidget {
  final Map<String, dynamic>? student;

  const LinkParentScreen({super.key, this.student});

  @override
  State<LinkParentScreen> createState() => _LinkParentScreenState();
}

class _LinkParentScreenState extends State<LinkParentScreen> {
  final TextEditingController searchCtrl = TextEditingController();
  List<Map<String, dynamic>> _results = [];
  bool _isSearching = false;
  String? _error;

  Future<void> _searchParent() async {
    final query = searchCtrl.text.trim();
    if (query.isEmpty) {
      setState(() {
        _error = 'សូមបញ្ចូលលេខទូរស័ព្ទ ឬ អ៊ីមែល';
        _results = [];
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _error = null;
      _results = [];
    });

    final parents = await UserRepo().searchParents(query);

    setState(() {
      _isSearching = false;
      if (parents.isEmpty) {
        _error = 'មិនមានលទ្ធផលសម្រាប់ $query';
      } else {
        _results = parents;
      }
    });
  }

  Future<void> _showLinkParentSheet(Map<String, dynamic> parent) async {
    final result = await showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.transparent,
      isScrollControlled: true,
      builder: (_) => LinkParentBottomSheet(
        student: widget.student,
        parent: parent,
      ),
    );

    if (!mounted) return;

    if (result == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: CustomSnackbar(
            title: 'Success',
            message: 'ភ្ជាប់អាណាព្យាបាលជោគជ័យ',
            icon: Icons.check_circle,
            color: Colors.green,
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new_rounded,
              color: AppColors.primaryText),
        ),
        title: Text(
          "ភ្ជាប់អាណាព្យាបាល",
          style: AppTextStyle.screenTitle24,
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: SearchField(
              hintText: "ស្វែងរកតាមលេខទូរស័ព្ទ ឬ អ៊ីមែល",
              icon: Icon(Icons.search, color: AppColors.secondaryText),
              controller: searchCtrl,
              onSubmitted: (_) => _searchParent(),
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isSearching ? null : _searchParent,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryMain,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppNumber.radiusPill),
                      ),
                    ),
                    child: Text(
                      _isSearching ? 'កំពុងស្វែងរក...' : 'ស្វែងរក',
                      style: AppTextStyle.bodyWhite,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                Text("លទ្ធផលស្វែងរក", style: AppTextStyle.sectionTitle20),
                const SizedBox(height: 12),
                if (_error != null) ...[
                  Text(
                    _error!,
                    style: AppTextStyle.bodySecondary,
                  ),
                ] else if (_results.isEmpty) ...[
                  Text(
                    'សូមវាយវាលស្វែងរក ហើយចុច ប៊ូតុងស្វែងរក',
                    style: AppTextStyle.bodySecondary,
                  ),
                ] else ..._results.map((parent) {
                  final name =
                      '${parent['first_name'] ?? ''} ${parent['last_name'] ?? ''}'.trim();
                  final phone = parent['phone'] as String? ?? '';
                  final email = parent['email'] as String? ?? '';
                  return _parentTile(name, phone.isNotEmpty ? phone : email, parent);
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _parentTile(
    String name,
    String contact,
    Map<String, dynamic> parent,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppNumber.radiusPill),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: AppColors.orange.withValues(alpha: 0.1),
            child: Icon(Icons.person_outline, color: AppColors.orange),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: AppTextStyle.subtitle16),
                Text(contact, style: AppTextStyle.caption13Secondary),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _showLinkParentSheet(parent);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryMain.withValues(alpha: 0.1),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppNumber.radiusMedium),
              ),
              minimumSize: const Size(60, 36),
            ),
            child: Text(
              "ភ្ជាប់",
              style: AppTextStyle.bodyPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
