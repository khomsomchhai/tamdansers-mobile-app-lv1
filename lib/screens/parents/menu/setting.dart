import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'
    show SharedPreferences;
import 'package:tamdansers_app/constants/app_icon.dart';
import 'package:tamdansers_app/repositories/parent_student_repo.dart';
import 'package:tamdansers_app/repositories/user_repo.dart';

import '../../../constants/app_colors.dart' show AppColors;
import '../../../constants/app_number.dart' show AppNumber;
import '../../../constants/text_style.dart' show AppTextStyle;
import '../../../routes/app_routes.dart' show AppRoutes;
import '../../../widget/class_child.dart' show ChildCard;

class ParentSetting extends StatefulWidget {
  const ParentSetting({super.key});

  @override
  State<ParentSetting> createState() => _ParentSettingState();
}

class _ParentSettingState extends State<ParentSetting> {
  Map<String, dynamic>? _parent;
  List<Map<String, dynamic>> _children = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadParentAndChildren();
  }

  Future<void> _loadParentAndChildren() async {
    setState(() => _isLoading = true);
    final pref = await SharedPreferences.getInstance();
    final userId = pref.getInt("userId");
    if (userId != null) {
      final parent = await UserRepo().getUserById(userId);
      final children = await ParentStudentRepo().getStudentsByParent(userId);
      setState(() {
        _parent = parent;
        _children = children;
        _isLoading = false;
      });
    } else {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppColors.backgroundLight,
        appBar: AppBar(
          backgroundColor: AppColors.backgroundLight,
          elevation: 0,
          title: Text("ប្រវត្តិរូប", style: AppTextStyle.sectionTitle20),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(AppNumber.screenPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfileHeader(),
              const SizedBox(height: 24),
              _rowIconText("កូនៗរបស់អ្នក"),
              const SizedBox(height: 15),
              _buildChildrenRow(),
              const SizedBox(height: 24),
              _buildInfoSection(),
              const SizedBox(height: 24),
              _buildSettingsSection(context),
              const SizedBox(height: 16),
              _buildLogoutButton(context),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    final parent = _parent;
    return Center(
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primaryMain, width: 3),
                  image: DecorationImage(
                    image: AssetImage(AppIcon.profileParent),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: GestureDetector(
                  onTap: _showEditInfoSheet,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.primaryMain,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(
                      Icons.edit,
                      size: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            (parent?["first_name"] ?? "") + " " + (parent?["last_name"] ?? ""),
            style: AppTextStyle.sectionTitle20.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: AppNumber.sectionPadding,
                vertical: AppNumber.spacingSmall),
            decoration: BoxDecoration(
              color: AppColors.primaryMain.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppNumber.radiusRounded),
            ),
            child: Text("អាណាព្យាបាលសិស្ស",
                style: AppTextStyle.caption14Secondary
                    .copyWith(color: AppColors.link)),
          ),
        ],
      ),
    );
  }

  Widget _rowIconText(String text) {
    return Text(text,
        style: AppTextStyle.fontsize18.copyWith(fontWeight: FontWeight.w600));
  }

  Widget _buildChildrenRow() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_children.isEmpty) {
      return addChildCard();
    }
    return SizedBox(
      height: 190,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _children.length + 1,
        separatorBuilder: (context, i) => const SizedBox(width: 16),
        itemBuilder: (context, i) {
          if (i == _children.length) return addChildCard();
          final child = _children[i];
          return ChildCard(
            name: (child['first_name'] ?? '') + ' ' + (child['last_name'] ?? ''),
            grade: child['email'] ?? '',
            gender: child['gender'] ?? '',
            imageUrl: (child['photo_path'] != null && child['photo_path'].toString().isNotEmpty)
                ? child['photo_path']
                : (child['gender'] == 'ប្រុស' || child['gender'] == 'male'
                    ? AppIcon.maleAvatar
                    : AppIcon.femaleAvatar),
          );
        },
      ),
    );
  }

  Widget addChildCard() {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, AppRoutes.parentConnectStudent);
      },
      child: Container(
        width: 110,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppNumber.radiusMedium),
          border: Border.all(
            color: const Color(0xFFD9D9D9),
          ),
        ),
        child: const Center(
          child: Text(
            "Add",
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF9CA3AF),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoSection() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    final parent = _parent;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppNumber.cardPadding),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppNumber.radiusLarge),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _infoRow(Icons.email_outlined, parent?["email"] ?? "មិនមានអ៊ីមែល"),
          const Divider(height: 24, thickness: 0.5),
          _infoRow(Icons.phone_outlined, parent?["phone"] ?? "មិនមានលេខទូរស័ព្ទ"),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String value) {
    return Row(
      children: [
        Icon(icon, color: AppColors.secondaryText, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Text(value, style: AppTextStyle.body14),
        ),
      ],
    );
  }

  Widget _buildSettingsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 10),
          child: Text("ការកំណត់", style: AppTextStyle.sectionTitle20),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppNumber.radiusLarge),
          ),
          child: Column(
            children: [
              _settingsTile(
                icon: Icons.person_outline_rounded,
                title: "កែប្រែព័ត៌មាន",
                onTap: _showEditInfoSheet,
                showDivider: true,
              ),
              _settingsTile(
                icon: Icons.lock_outline_rounded,
                title: "ប្ដូរពាក្យសម្ងាត់",
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.changePassword);
                },
                showDivider: true,
              ),
              _settingsTile(
                icon: Icons.settings_outlined,
                title: "ការកំណត់ទូទៅ",
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.notifications);
                },
                showDivider: true,
              ),
              _settingsTile(
                icon: Icons.help_outline_rounded,
                title: "ជំនួយ & គាំទ្រ",
                onTap: () {},
                showDivider: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _settingsTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required bool showDivider,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppNumber.radiusLarge),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Icon(icon, color: AppColors.secondaryText, size: 22),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(title, style: AppTextStyle.body14),
                ),
                const Icon(
                  Icons.chevron_right,
                  color: AppColors.secondaryText,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
        if (showDivider)
          const Divider(
            height: 1,
            thickness: 0.5,
            indent: 52,
            endIndent: 0,
          ),
      ],
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () => _confirmLogout(context),
        icon: const Icon(
          Icons.logout_rounded,
          color: AppColors.error,
          size: 20,
        ),
        label: Text(
          "Logout",
          style: AppTextStyle.subtitle16.copyWith(color: AppColors.error),
        ),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          side: const BorderSide(color: AppColors.error, width: 1.2),
          backgroundColor: AppColors.error.withOpacity(0.05),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppNumber.radiusLarge),
          ),
        ),
      ),
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppNumber.radiusLarge),
        ),
        backgroundColor: AppColors.backgroundLight,
        title: Text("ចាកចេញ?", style: AppTextStyle.subtitle18),
        content: Text(
          "តើអ្នកពិតជាចង់ចាកចេញពីគណនីនេះមែនទេ?",
          style: AppTextStyle.body14,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text("បោះបង់", style: AppTextStyle.bodyPrimary),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final pref = await SharedPreferences.getInstance();
              await pref.setBool("isLogin", false);
              await pref.remove("role");
              await pref.remove("userId");

              if (context.mounted) {
                Navigator.of(context, rootNavigator: true)
                    .pushNamedAndRemoveUntil(
                  AppRoutes.roleSelectionScreen,
                  (route) => false,
                );
              }
            },
            child: Text(
              "ចាកចេញ",
              style: AppTextStyle.subtitle16.copyWith(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

  void _showEditInfoSheet() {
    final firstCtrl = TextEditingController(text: _parent?['first_name'] ?? '');
    final lastCtrl = TextEditingController(text: _parent?['last_name'] ?? '');
    final phoneCtrl = TextEditingController(text: _parent?['phone'] ?? '');
    final emailCtrl = TextEditingController(text: _parent?['email'] ?? '');
    final formKey = GlobalKey<FormState>();
    bool saving = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(builder: (ctx, setSheetState) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            ),
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.primaryMain.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.edit_outlined,
                            color: AppColors.primaryMain, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Text("កែប្រែព័ត៌មាន",
                          style: AppTextStyle.sectionTitle20.copyWith(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    "ផ្លាស់ប្តូរព័ត៌មានផ្ទាល់ខ្លួនរបស់អ្នក",
                    style: AppTextStyle.body14.copyWith(color: AppColors.secondaryText),
                  ),
                ),
                const SizedBox(height: 20),
                const Divider(height: 1, thickness: 0.5),
                const SizedBox(height: 20),
                Form(
                  key: formKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _editField(
                                controller: lastCtrl,
                                label: "នាមត្រកូល",
                                icon: Icons.badge_outlined,
                                validator: (v) => (v == null || v.trim().isEmpty) ? "សូមបញ្ចូល" : null,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _editField(
                                controller: firstCtrl,
                                label: "នាមខ្លួន",
                                icon: Icons.person_outline_rounded,
                                validator: (v) => (v == null || v.trim().isEmpty) ? "សូមបញ្ចូល" : null,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        _editField(
                          controller: phoneCtrl,
                          label: "លេខទូរស័ព្ទ",
                          icon: Icons.phone_outlined,
                          keyboardType: TextInputType.phone,
                        ),
                        const SizedBox(height: 14),
                        _editField(
                          controller: emailCtrl,
                          label: "អ៊ីមែល",
                          icon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => Navigator.pop(ctx),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  side: const BorderSide(color: AppColors.secondaryText, width: 1),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(AppNumber.radiusLarge),
                                  ),
                                ),
                                child: Text("បោះបង់", style: AppTextStyle.subtitle16.copyWith(color: AppColors.secondaryText)),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              flex: 2,
                              child: ElevatedButton(
                                onPressed: saving
                                    ? null
                                    : () async {
                                    if (!formKey.currentState!.validate()) return;
                                    setSheetState(() => saving = true);
                                    final ok = await UserRepo().updateUser(
                                      userId: _parent?["id"],
                                      firstName: firstCtrl.text.trim(),
                                      lastName: lastCtrl.text.trim(),
                                      phone: phoneCtrl.text.trim().isEmpty ? null : phoneCtrl.text.trim(),
                                      email: emailCtrl.text.trim().isEmpty ? null : emailCtrl.text.trim(),
                                    );
                                    setSheetState(() => saving = false);
                                    if (ok && ctx.mounted) {
                                      Navigator.pop(ctx);
                                      _loadParentAndChildren();
                                    }
                                  },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryMain,
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(AppNumber.radiusLarge),
                                  ),
                                ),
                                child: saving
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                      )
                                    : Text("រក្សាទុក", style: AppTextStyle.subtitle16.copyWith(color: Colors.white)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        });
      },
    );
  }

  Widget _editField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      style: AppTextStyle.body14,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: AppTextStyle.body14.copyWith(color: AppColors.secondaryText),
        prefixIcon: Icon(icon, color: AppColors.secondaryText, size: 20),
        filled: true,
        fillColor: AppColors.backgroundLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppNumber.radiusMedium),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0), width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppNumber.radiusMedium),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppNumber.radiusMedium),
          borderSide: const BorderSide(color: AppColors.primaryMain, width: 1.8),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppNumber.radiusMedium),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppNumber.radiusMedium),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }

}
