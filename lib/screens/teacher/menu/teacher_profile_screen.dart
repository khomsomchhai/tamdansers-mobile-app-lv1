import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tamdansers_app/constants/app_colors.dart';
import 'package:tamdansers_app/constants/app_icon.dart';
import 'package:tamdansers_app/constants/app_number.dart';
import 'package:tamdansers_app/constants/text_style.dart';
import 'package:tamdansers_app/repositories/profile_repo.dart';
import 'package:tamdansers_app/repositories/user_repo.dart';
import 'package:tamdansers_app/routes/app_routes.dart';
import 'package:tamdansers_app/state/profile_image_state.dart';

class TeacherProfileScreen extends StatefulWidget {
  final int teacherId;
  const TeacherProfileScreen({super.key, required this.teacherId});

  @override
  State<TeacherProfileScreen> createState() => _TeacherProfileScreenState();
}

class _TeacherProfileScreenState extends State<TeacherProfileScreen> {
  Map<String, dynamic>? _teacherData;
  bool _loading = true;
  String _imagePath = '';
  final ProfileRepo _profileRepo = ProfileRepo();
  final UserRepo _userRepo = UserRepo();

  @override
  void initState() {
    super.initState();
    _loadTeacherData();
    _loadImage();
  }

  Future<void> _loadTeacherData() async {
    final data = await _userRepo.getUserById(widget.teacherId);
    if (mounted) {
      setState(() {
        _teacherData = data;
        _loading = false;
      });
    }
  }

  Future<void> _loadImage() async {
    final saved = await _profileRepo.getImage(widget.teacherId);
    if (saved != null && saved.isNotEmpty) {
      final file = File(saved);
      if (await file.exists()) {
        if (mounted) setState(() => _imagePath = saved);
        ProfileImageState.updateImage(widget.teacherId, saved);
      }
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: source, imageQuality: 70);
    if (picked != null) {
      await _profileRepo.saveImage(picked.path, widget.teacherId);
      if (mounted) setState(() => _imagePath = picked.path);
    }
  }

  void _showImageOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16),
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Colors.blue),
              title: Text("ថតរូប", style: AppTextStyle.body),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo, color: Colors.green),
              title: Text("ជ្រើសរើសពីថតរូប", style: AppTextStyle.body),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showEditInfoSheet() {
    final firstCtrl = TextEditingController(
        text: _teacherData?['first_name'] as String? ?? '');
    final lastCtrl = TextEditingController(
        text: _teacherData?['last_name'] as String? ?? '');
    final phoneCtrl =
        TextEditingController(text: _teacherData?['phone'] as String? ?? '');
    final emailCtrl =
        TextEditingController(text: _teacherData?['email'] as String? ?? '');
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
                // Handle bar
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
                // Header
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
                          style: AppTextStyle.sectionTitle20
                              .copyWith(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    "ផ្លាស់ប្តូរព័ត៌មានផ្ទាល់ខ្លួនរបស់អ្នក",
                    style: AppTextStyle.body14
                        .copyWith(color: AppColors.secondaryText),
                  ),
                ),
                const SizedBox(height: 20),
                const Divider(height: 1, thickness: 0.5),
                const SizedBox(height: 20),
                // Fields
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
                                validator: (v) =>
                                    (v == null || v.trim().isEmpty)
                                        ? "សូមបញ្ចូល"
                                        : null,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _editField(
                                controller: firstCtrl,
                                label: "នាមខ្លួន",
                                icon: Icons.person_outline_rounded,
                                validator: (v) =>
                                    (v == null || v.trim().isEmpty)
                                        ? "សូមបញ្ចូល"
                                        : null,
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
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 14),
                                  side: const BorderSide(
                                      color: AppColors.secondaryText, width: 1),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        AppNumber.radiusLarge),
                                  ),
                                ),
                                child: Text("បោះបង់",
                                    style: AppTextStyle.subtitle16.copyWith(
                                        color: AppColors.secondaryText)),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              flex: 2,
                              child: ElevatedButton(
                                onPressed: saving
                                    ? null
                                    : () async {
                                        if (!formKey.currentState!.validate())
                                          return;
                                        setSheetState(() => saving = true);
                                        final ok = await _userRepo.updateUser(
                                          userId: widget.teacherId,
                                          firstName: firstCtrl.text.trim(),
                                          lastName: lastCtrl.text.trim(),
                                          phone: phoneCtrl.text.trim().isEmpty
                                              ? null
                                              : phoneCtrl.text.trim(),
                                          email: emailCtrl.text.trim().isEmpty
                                              ? null
                                              : emailCtrl.text.trim(),
                                        );
                                        setSheetState(() => saving = false);
                                        if (ok && ctx.mounted) {
                                          Navigator.pop(ctx);
                                          _loadTeacherData();
                                        }
                                      },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryMain,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 14),
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        AppNumber.radiusLarge),
                                  ),
                                ),
                                child: saving
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white),
                                      )
                                    : Text("រក្សាទុក",
                                        style: AppTextStyle.subtitle16
                                            .copyWith(color: Colors.white)),
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
        labelStyle:
            AppTextStyle.body14.copyWith(color: AppColors.secondaryText),
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
          borderSide:
              const BorderSide(color: AppColors.primaryMain, width: 1.8),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppNumber.radiusMedium),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppNumber.radiusMedium),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final teacherName = _teacherData != null
        ? "${_teacherData!['first_name']} ${_teacherData!['last_name']}"
        : "Teacher";
    final gender = _teacherData?['gender'] as String? ?? 'male';

    return Scaffold(
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
            _buildProfileHeader(teacherName, gender),
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
    );
  }

  Widget _buildProfileHeader(String teacherName, String gender) {
    final defaultAvatar = (gender == 'female' || gender == 'ស្រី')
        ? AppIcon.femaleAvatar
        : AppIcon.maleAvatar;

    return Center(
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 4),
                ),
                child: ClipOval(
                  child: _imagePath.isNotEmpty
                      ? Image.file(File(_imagePath), fit: BoxFit.cover)
                      : Image.asset(defaultAvatar, fit: BoxFit.cover),
                ),
              ),
              Material(
                color: AppColors.primary300,
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: _showImageOptions,
                  child: const SizedBox(
                    width: 38,
                    height: 38,
                    child: Icon(Icons.camera_alt_outlined,
                        color: Colors.white, size: 20),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(teacherName,
              style: AppTextStyle.sectionTitle20
                  .copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: AppNumber.sectionPadding,
                vertical: AppNumber.spacingSmall),
            decoration: BoxDecoration(
              color: AppColors.primaryMain.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppNumber.radiusRounded),
            ),
            child: Text(
              'គ្រូបង្រៀន',
              style: AppTextStyle.bodyPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection() {
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
          _infoRow(
              Icons.email_outlined,
              (_teacherData?['email'] as String?)?.isNotEmpty == true
                  ? _teacherData!['email'] as String
                  : 'មិនទាន់បញ្ចូលអ៊ីមែល'),
          const Divider(height: 24, thickness: 0.5),
          _infoRow(
              Icons.phone_outlined,
              (_teacherData?['phone'] as String?)?.isNotEmpty == true
                  ? _teacherData!['phone'] as String
                  : 'មិនទាន់បញ្ចូលលេខទូរស័ព្ទ'),
          const Divider(height: 24, thickness: 0.5),
          _infoRow(Icons.location_on_outlined, 'ភ្នំពេញ, កម្ពុជា'),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String value) {
    return Row(
      children: [
        Icon(icon, color: AppColors.secondaryText, size: 20),
        const SizedBox(width: 12),
        Expanded(child: Text(value, style: AppTextStyle.body14)),
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
                title: "ផ្លាស់ប្តូរពាក្យសម្ងាត់",
                onTap: () =>
                    Navigator.pushNamed(context, AppRoutes.changePassword),
                showDivider: true,
              ),
              _settingsTile(
                icon: Icons.help_outline_rounded,
                title: "ជំនួយ & សេវាកម្ម",
                onTap: () {},
                showDivider: false,
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
                const Icon(Icons.chevron_right,
                    color: AppColors.secondaryText, size: 20),
              ],
            ),
          ),
        ),
        if (showDivider)
          const Divider(height: 1, thickness: 0.5, indent: 52, endIndent: 0),
      ],
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () => _confirmLogout(context),
        icon:
            const Icon(Icons.logout_rounded, color: AppColors.error, size: 20),
        label: Text(
          "ចាកចេញ",
          style: AppTextStyle.subtitle16.copyWith(color: AppColors.error),
        ),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          side: const BorderSide(color: AppColors.error, width: 1.2),
          backgroundColor: AppColors.error.withValues(alpha: 0.05),
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
}
