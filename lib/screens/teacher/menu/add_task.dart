// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tamdansers_app/constants/app_colors.dart';
import 'package:tamdansers_app/constants/app_number.dart';
import 'package:tamdansers_app/constants/text_style.dart';
import 'package:tamdansers_app/repositories/activity_repo.dart';
import 'package:tamdansers_app/repositories/homework_repo.dart';
import 'package:tamdansers_app/state/app_notifiers.dart';
import 'package:tamdansers_app/widget/primary_button.dart';

class AddTask extends StatefulWidget {
  const AddTask({super.key});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  String? _selectedSubject;
  bool _notifyStudents = true;
  bool _notifyParents = false;
  DateTime? _dueDate;
  TimeOfDay? _dueTime;
  int? _classId;
  bool _saving = false;
  String? _attachmentPath;
  String? _attachmentName;

  // Edit mode
  Map<String, dynamic>? _editingHw;
  bool get _isEditing => _editingHw != null;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map<String, dynamic>) {
      // Edit mode — pre-fill from existing homework map
      _editingHw = args;
      _classId = args['class_id'] as int?;
      _titleController.text = args['title'] as String? ?? '';
      _instructionController.text = args['instructions'] as String? ?? '';
      final subj = args['subject'] as String?;
      if (subj != null && _subjects.contains(subj)) _selectedSubject = subj;
      final attach = args['attachment_path'] as String?;
      if (attach != null && attach.isNotEmpty) {
        _attachmentPath = attach;
        _attachmentName = attach.split('/').last;
      }
      final deadline = args['deadline'] as String?;
      if (deadline != null && deadline.isNotEmpty) {
        final parts = deadline.split(' ');
        final dateParts = parts[0].split('-');
        if (dateParts.length == 3) {
          _dueDate = DateTime(
            int.parse(dateParts[0]),
            int.parse(dateParts[1]),
            int.parse(dateParts[2]),
          );
        }
        if (parts.length > 1) {
          final timeParts = parts[1].split(':');
          if (timeParts.length == 2) {
            _dueTime = TimeOfDay(
              hour: int.parse(timeParts[0]),
              minute: int.parse(timeParts[1]),
            );
          }
        }
      }
    } else {
      _classId = args as int?;
    }
  }

  Future<void> _saveHomework(String status) async {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('សូមបំពេញចម្ណងជើរ')));
      return;
    }
    setState(() => _saving = true);
    String? deadlineStr;
    if (_dueDate != null) {
      deadlineStr =
          '${_dueDate!.year}-${_dueDate!.month.toString().padLeft(2, '0')}-${_dueDate!.day.toString().padLeft(2, '0')}';
      if (_dueTime != null) {
        deadlineStr +=
            ' ${_dueTime!.hour.toString().padLeft(2, '0')}:${_dueTime!.minute.toString().padLeft(2, '0')}';
      }
    }
    if (_isEditing) {
      await HomeworkRepo().updateHomework(
        id: _editingHw!['id'] as int,
        title: title,
        subject: _selectedSubject ?? '',
        instructions: _instructionController.text.trim().isEmpty
            ? null
            : _instructionController.text.trim(),
        deadline: deadlineStr,
        status: status,
        attachmentPath: _attachmentPath,
      );
      await ActivityRepo().logActivity(
        teacherId:
            (await SharedPreferences.getInstance()).getInt('userId') ?? 1,
        activityType: 'homework',
        title: 'កិច្ចការត្រូវបានកែប្រែ',
        subtitle: title,
      );
    } else {
      await HomeworkRepo().createHomework(
        title: title,
        subject: _selectedSubject ?? '',
        classId: _classId ?? 0,
        teacherId:
            (await SharedPreferences.getInstance()).getInt('userId') ?? 1,
        instructions: _instructionController.text.trim().isEmpty
            ? null
            : _instructionController.text.trim(),
        deadline: deadlineStr,
        status: status,
        attachmentPath: _attachmentPath,
      );
      await ActivityRepo().logActivity(
        teacherId:
            (await SharedPreferences.getInstance()).getInt('userId') ?? 1,
        activityType: 'homework',
        title: status == 'active'
            ? 'កិច្ចការថ្មីត្រូវបានបង្កើត'
            : 'សេចក្តីព្រាងត្រូវបានរក្សាទុក',
        subtitle: title,
      );
    }
    if (mounted) {
      setState(() => _saving = false);
      notifyHomeworkChanged();
      Navigator.pop(context, true);
    }
  }

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _instructionController = TextEditingController();

  final List<String> _subjects = [
    'គណិតវិទ្យា',
    'ភាសាខ្មែរ',
    'ភាសាអង់គ្លេស',
    'វិទ្យាសាស្ត្រ',
    'សង្គមវិទ្យា',
  ];

  Future<void> _pickDateTime(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (date == null) return;
    if (!mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: _dueTime ?? TimeOfDay.now(),
    );
    if (!mounted) return;
    setState(() {
      _dueDate = date;
      _dueTime = time;
    });
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );
    if (result == null || result.files.isEmpty) return;
    final file = result.files.first;
    if (!mounted) return;
    setState(() {
      _attachmentPath = file.path;
      _attachmentName = file.name;
    });
  }

  String get _dueDateText {
    if (_dueDate == null) return 'mm/dd/yyyy, --:-- --';
    final d = _dueDate!;
    final dateStr =
        '${d.month.toString().padLeft(2, '0')}/${d.day.toString().padLeft(2, '0')}/${d.year}';
    if (_dueTime == null) return '$dateStr, --:-- --';
    final hour = _dueTime!.hourOfPeriod.toString().padLeft(2, '0');
    final minute = _dueTime!.minute.toString().padLeft(2, '0');
    final period = _dueTime!.period == DayPeriod.am ? 'AM' : 'PM';
    return '$dateStr, $hour:$minute $period';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _instructionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.primaryText),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          _isEditing ? 'កែប្រែកិច្ចការ' : 'បង្កើតកិច្ចការថ្មី',
          style: AppTextStyle.fontsize18,
        ),
        centerTitle: true,
        actions: [
          if (!_isEditing)
            TextButton(
              onPressed: _saving ? null : () => _saveHomework('draft'),
              child: Text(
                'សេចក្តីព្រាង',
                style: AppTextStyle.buttonText15Primary,
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Text(
                    _isEditing
                        ? 'កែប្រែព័ត៌មានកិច្ចការ'
                        : 'តើអ្នកចង់ដាក់កិច្ចការអ្វីថ្ងៃនេះ?',
                    style: AppTextStyle.sectionTitle20.copyWith(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _isEditing
                        ? 'កែប្រែ ឬផ្លាស់ប្ដូរព័ត៌មានកិច្ចការ'
                        : 'បង្កើតកិច្ចការថ្មីសម្រាប់សិស្សរបស់អ្នក',
                    style: AppTextStyle.body14.copyWith(
                      color: AppColors.primaryMain,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Subject dropdown
                  _buildLabel('មុខវិជ្ជា'),
                  const SizedBox(height: 8),
                  _buildSubjectDropdown(),
                  const SizedBox(height: 20),

                  // Title field
                  _buildLabel('ចំណងជើង'),
                  const SizedBox(height: 8),
                  _buildTextField(
                    controller: _titleController,
                    hint: 'ឧ. ពិជគណិត ជំពូកទី ៥',
                    maxLines: 1,
                  ),
                  const SizedBox(height: 20),

                  // Instructions field
                  _buildLabel('ការណែនាំ'),
                  const SizedBox(height: 8),
                  _buildTextField(
                    controller: _instructionController,
                    hint: 'បន្ថែមការណែនាំសម្រាប់សិស្ស...',
                    maxLines: 5,
                  ),
                  const SizedBox(height: 20),

                  // Due date/time
                  _buildLabel('កាលបរិច្ឆេទកំណត់'),
                  const SizedBox(height: 8),
                  _buildDateTimeField(context),
                  const SizedBox(height: 20),

                  // File attachment
                  _buildFileAttachment(),
                  const SizedBox(height: 28),

                  // Notifications
                  Text(
                    'ជូនដំណឹង',
                    style: AppTextStyle.subtitle16,
                  ),
                  const SizedBox(height: 12),
                  _buildNotificationTile(
                    icon: Icons.school_rounded,
                    iconBgColor: const Color(0xFF4285F4),
                    title: 'ជូនដំណឹងសិស្ស',
                    // subtitle: 'ម្ចាស់ជូនដំណឹង Push',
                    value: _notifyStudents,
                    onChanged: (v) => setState(() => _notifyStudents = v),
                  ),
                  const SizedBox(height: 12),
                  _buildNotificationTile(
                    icon: Icons.people_alt_rounded,
                    iconBgColor: const Color(0xFF34C759),
                    title: 'ជូនដំណឹងអាណាព្យាបាល',
                    // subtitle: 'តាមអ៊ីមែល និង SMS',
                    value: _notifyParents,
                    onChanged: (v) => setState(() => _notifyParents = v),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          // Submit button
          Container(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            decoration: BoxDecoration(
              color: AppColors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: PrimaryButton(
              label: _saving
                  ? 'កំពុងរក្សាទុក...'
                  : _isEditing
                      ? 'រក្សាទុកការកែប្រែ'
                      : 'បញ្ចូលកិច្ចការ',
              backgroundColor: AppColors.primaryMain,
              foregroundColor: AppColors.white,
              onPressed: () {
                if (!_saving) _saveHomework('active');
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: AppTextStyle.body14.copyWith(fontWeight: FontWeight.w600),
    );
  }

  Widget _buildSubjectDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppNumber.radiusMedium),
        border: Border.all(color: const Color(0xFFE5E5EA)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedSubject,
          hint: Text(
            'ជ្រើសរើសមុខវិជ្ជា',
            style: AppTextStyle.caption14Secondary,
          ),
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down_rounded,
              color: AppColors.secondaryText),
          items: _subjects
              .map((s) => DropdownMenuItem(
                    value: s,
                    child: Text(
                      s,
                      style: AppTextStyle.body14,
                    ),
                  ))
              .toList(),
          onChanged: (v) => setState(() => _selectedSubject = v),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppNumber.radiusMedium),
        border: Border.all(color: const Color(0xFFE5E5EA)),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        style: AppTextStyle.body14,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: AppTextStyle.caption14Secondary,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildDateTimeField(BuildContext context) {
    return GestureDetector(
      onTap: () => _pickDateTime(context),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppNumber.radiusMedium),
          border: Border.all(color: const Color(0xFFE5E5EA)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            const Icon(Icons.calendar_today_rounded,
                size: 18, color: AppColors.primaryMain),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                _dueDateText,
                style: _dueDate == null
                    ? AppTextStyle.caption14Secondary
                    : AppTextStyle.body14,
              ),
            ),
            const Icon(Icons.access_time_rounded,
                size: 18, color: AppColors.secondaryText),
          ],
        ),
      ),
    );
  }

  Widget _buildFileAttachment() {
    if (_attachmentName != null) {
      final ext = _attachmentName!.split('.').last.toLowerCase();
      final isPdf = ext == 'pdf';
      return Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF0F7FF),
          borderRadius: BorderRadius.circular(AppNumber.radiusMedium),
          border:
              Border.all(color: AppColors.primaryMain.withValues(alpha: 0.3)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(
              isPdf
                  ? Icons.picture_as_pdf_rounded
                  : Icons.insert_drive_file_rounded,
              color: isPdf ? Colors.red : AppColors.primaryMain,
              size: 26,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _attachmentName!,
                    style: AppTextStyle.body14
                        .copyWith(fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (_attachmentPath != null)
                    Text(
                      '${(File(_attachmentPath!).lengthSync() / 1024).toStringAsFixed(1)} KB',
                      style: AppTextStyle.caption14Secondary,
                    ),
                ],
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: _pickFile,
                  child: const Icon(Icons.swap_horiz_rounded,
                      color: AppColors.primaryMain, size: 22),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () =>
                      setState(() => _attachmentPath = _attachmentName = null),
                  child: const Icon(Icons.close,
                      color: AppColors.secondaryText, size: 22),
                ),
              ],
            ),
          ],
        ),
      );
    }
    return GestureDetector(
      onTap: _pickFile,
      child: CustomPaint(
        painter: _DashedBorderPainter(),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 22),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F0F5),
                  borderRadius: BorderRadius.circular(AppNumber.radiusPill),
                ),
                child: const Icon(Icons.attach_file_rounded,
                    color: AppColors.secondaryText, size: 22),
              ),
              const SizedBox(height: 10),
              Text(
                'ភ្ជាប់ឯកសារសិក្សា (PDF, Doc)',
                style: AppTextStyle.caption14Secondary,
              ),
              const SizedBox(height: 4),
              Text(
                'ចុចដើម្បីជ្រើសរើសឯកសារ',
                style: AppTextStyle.caption14Secondary
                    .copyWith(color: AppColors.primaryMain),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationTile({
    required IconData icon,
    required Color iconBgColor,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppNumber.radiusMedium),
        border: Border.all(color: const Color(0xFFE5E5EA)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(AppNumber.radiusMedium),
            ),
            child: Icon(icon, color: AppColors.white, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style:
                      AppTextStyle.body14.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                // Text(
                //   subtitle,
                //   style: AppTextStyle.caption12Secondary,
                // ),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primaryMain,
          ),
        ],
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const dashWidth = 6.0;
    const dashSpace = 4.0;
    const radius = 12.0;
    final paint = Paint()
      ..color = const Color(0xFFCCCCCC)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      const Radius.circular(radius),
    );

    final path = Path()..addRRect(rrect);
    final metrics = path.computeMetrics().toList();

    for (final metric in metrics) {
      double distance = 0;
      while (distance < metric.length) {
        final start = distance;
        final end = (distance + dashWidth).clamp(0, metric.length) as double;
        canvas.drawPath(metric.extractPath(start, end), paint);
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
