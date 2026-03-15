import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tamdansers_app/constants/app_colors.dart';
import 'package:tamdansers_app/constants/app_number.dart';
import 'package:tamdansers_app/constants/text_style.dart';
import 'package:tamdansers_app/repositories/activity_repo.dart';
import 'package:tamdansers_app/repositories/class_repo.dart';

class CreateClassDialog extends StatefulWidget {
  final List<String> grades;

  const CreateClassDialog({super.key, required this.grades});

  @override
  State<CreateClassDialog> createState() => _CreateClassDialogState();
}

class _CreateClassDialogState extends State<CreateClassDialog> {
  final _nameCtrl = TextEditingController();
  final _sectionCtrl = TextEditingController();
  final _schoolYearCtrl = TextEditingController(text: "2024-2025");

  String? _grade;
  String _semester = "ឆមាសទី ១";
  bool _saving = false;

  static const _classColors = [
    "#1976D2",
    "#00897B",
    "#546E7A",
    "#7B1FA2",
    "#C62828",
    "#E65100",
    "#558B2F",
    "#283593",
  ];
  late String _color;

  @override
  void initState() {
    super.initState();
    _color = _classColors[Random().nextInt(_classColors.length)];
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _sectionCtrl.dispose();
    _schoolYearCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_nameCtrl.text.trim().isEmpty ||
        _grade == null ||
        _sectionCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("សូមបំពេញព័ត៌មានទាំងអស់")),
      );
      return;
    }
    setState(() => _saving = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final teacherId = prefs.getInt('userId') ?? 1;
      await ClassRepo().createClass(
        name: _nameCtrl.text.trim(),
        grade: _grade!,
        section: _sectionCtrl.text.trim().toUpperCase(),
        teacherId: teacherId,
        colorHex: _color,
        semester: _semester,
        schoolYear: _schoolYearCtrl.text.trim(),
      );
      await ActivityRepo().logActivity(
        teacherId: teacherId,
        activityType: "class",
        title: "ថ្នាក់ត្រូវបានបង្កើត",
        subtitle:
            "${_nameCtrl.text.trim()} — $_grade ${_sectionCtrl.text.trim().toUpperCase()}",
      );
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("មិនអាចបង្កើតថ្នាក់បាន: $e")),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  InputDecoration _fieldDeco({String? hint}) => InputDecoration(
        hintText: hint,
        hintStyle: AppTextStyle.bodySecondary,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppNumber.radiusMedium),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppNumber.radiusMedium),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppNumber.radiusMedium),
          borderSide:
              const BorderSide(color: AppColors.primaryMain, width: 1.5),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      );

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.backgroundLight,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppNumber.radiusLarge)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Title ──
            Text(
              "បង្កើតថ្នាក់ថ្មី",
              style: AppTextStyle.sectionTitle20
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // ── Class name ──
            Text("ឈ្មោះថ្នាក់", style: AppTextStyle.bodySecondary),
            const SizedBox(height: 6),
            TextField(
              controller: _nameCtrl,
              style: AppTextStyle.body14,
              decoration: _fieldDeco(hint: "ឧ. 7A, Grade 7A"),
            ),
            const SizedBox(height: 16),

            // ── Grade ──
            Text("ថ្នាក់ទី", style: AppTextStyle.bodySecondary),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              value: _grade,
              hint: Text("ជ្រើសថ្នាក់ទី", style: AppTextStyle.bodySecondary),
              dropdownColor: Colors.white,
              style: AppTextStyle.body14,
              decoration: _fieldDeco(),
              items: widget.grades
                  .map((g) => DropdownMenuItem(
                        value: g,
                        child: Text(g,
                            style: AppTextStyle.body14
                                .copyWith(color: AppColors.primaryText)),
                      ))
                  .toList(),
              onChanged: (v) => setState(() => _grade = v),
            ),
            const SizedBox(height: 16),

            // ── Section ──
            Text("ផ្នែក (A, B, C…)", style: AppTextStyle.bodySecondary),
            const SizedBox(height: 6),
            TextField(
              controller: _sectionCtrl,
              style: AppTextStyle.body14,
              decoration: _fieldDeco(hint: "A"),
            ),
            const SizedBox(height: 16),

            // ── Semester ──
            Text("ឆមាស", style: AppTextStyle.bodySecondary),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              value: _semester,
              dropdownColor: Colors.white,
              style: AppTextStyle.body14,
              decoration: _fieldDeco(),
              items: ["ឆមាសទី ១", "ឆមាសទី ២"]
                  .map((s) => DropdownMenuItem(
                        value: s,
                        child: Text(s,
                            style: AppTextStyle.body14
                                .copyWith(color: AppColors.primaryText)),
                      ))
                  .toList(),
              onChanged: (v) => setState(() => _semester = v!),
            ),
            const SizedBox(height: 24),

            // ── Actions ──
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed:
                      _saving ? null : () => Navigator.pop(context, false),
                  child: Text("បោះបង់", style: AppTextStyle.bodySecondary),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _saving ? null : _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryMain,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppNumber.radiusMedium),
                    ),
                    elevation: 0,
                  ),
                  child: _saving
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white))
                      : Text("រក្សាទុក", style: AppTextStyle.bodyWhite),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
