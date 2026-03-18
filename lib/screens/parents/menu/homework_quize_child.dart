import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tamdansers_app/constants/app_colors.dart';
import 'package:tamdansers_app/constants/app_images.dart';
import 'package:tamdansers_app/constants/app_number.dart';
import 'package:tamdansers_app/constants/text_style.dart';
import 'package:tamdansers_app/database/db_helper.dart';
import 'package:tamdansers_app/repositories/parent_student_repo.dart';
import 'package:tamdansers_app/repositories/user_repo.dart';
import 'package:tamdansers_app/screens/parents/menu/homework_student_data.dart';

class HomeworkQuizeScreen extends StatefulWidget {
  const HomeworkQuizeScreen({super.key});
  @override
  State<HomeworkQuizeScreen> createState() => _HomeworkQuizeScreenState();
}

class _HomeworkQuizeScreenState extends State<HomeworkQuizeScreen> {
  final HomeworkStudentData _homeworkData = HomeworkStudentData();
  final ParentStudentRepo _parentStudentRepo = ParentStudentRepo();

  int _selectedTab = 0;
  bool _isLoading = true;
  String? _errorMessage;

  List<Map<String, dynamic>> _students = [];
  Map<String, dynamic>? _selectedStudent;
  List<Map<String, dynamic>> _homeworkItems = [];
  Map<String, int> _summary = {
    'total': 0,
    'submitted': 0,
    'pending': 0,
    'overdue': 0,
  };

  double _fs(double base, BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return base * (width / 390).clamp(0.78, 1.15);
  }

  @override
  void initState() {
    super.initState();
    _loadRoleBasedHomework();
  }

  Future<void> _loadRoleBasedHomework() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final pref = await SharedPreferences.getInstance();
      final userId = pref.getInt('userId');
      final role = pref.getString('role');

      if (userId == null || role == null) {
        setState(() {
          _errorMessage = 'មិនមានព័ត៌មានអ្នកប្រើប្រាស់';
          _isLoading = false;
        });
        return;
      }

      if (role == 'parent') {
        _students = await _parentStudentRepo.getStudentsByParent(userId);
      } else if (role == 'student') {
        final student = await _resolveStudentFromCurrentUser(userId);
        _students = student != null ? [student] : [];
      } else {
        _students = [];
      }

      if (_students.isEmpty) {
        setState(() {
          _errorMessage = 'មិនមានទិន្នន័យសិស្សសម្រាប់បង្ហាញកិច្ចការផ្ទះ';
          _homeworkItems = [];
          _summary = {
            'total': 0,
            'submitted': 0,
            'pending': 0,
            'overdue': 0,
          };
          _isLoading = false;
        });
        return;
      }

      _selectedStudent = _students.first;
      await _loadHomeworkForSelectedStudent();
    } catch (_) {
      setState(() {
        _errorMessage = 'មិនអាចទាញយកទិន្នន័យកិច្ចការផ្ទះបានទេ';
        _isLoading = false;
      });
    }
  }

  Future<Map<String, dynamic>?> _resolveStudentFromCurrentUser(
      int userId) async {
    final user = await UserRepo().getUserById(userId);
    if (user == null) return null;

    final db = await DbHelper().initDatabase();

    final email = user['email'] as String?;
    if (email != null && email.trim().isNotEmpty) {
      final byEmail = await db.rawQuery(
        '''SELECT sc.id as student_id, sc.first_name, sc.last_name, sc.class_id, c.name as class_name
           FROM tbl_student_class sc
           LEFT JOIN tbl_class c ON sc.class_id = c.id
           WHERE sc.email = ?
           LIMIT 1''',
        [email.trim()],
      );
      if (byEmail.isNotEmpty) return Map<String, dynamic>.from(byEmail.first);
    }

    final classId = user['class_id'] as int?;
    final byNameAndClass = await db.rawQuery(
      '''SELECT sc.id as student_id, sc.first_name, sc.last_name, sc.class_id, c.name as class_name
         FROM tbl_student_class sc
         LEFT JOIN tbl_class c ON sc.class_id = c.id
         WHERE sc.first_name = ? AND sc.last_name = ?
           AND (? IS NULL OR sc.class_id = ?)
         ORDER BY sc.id DESC
         LIMIT 1''',
      [user['first_name'], user['last_name'], classId, classId],
    );

    if (byNameAndClass.isNotEmpty) {
      return Map<String, dynamic>.from(byNameAndClass.first);
    }

    return null;
  }

  Future<void> _loadHomeworkForSelectedStudent() async {
    if (_selectedStudent == null) return;

    final studentId =
        (_selectedStudent!['student_id'] ?? _selectedStudent!['id']) as int?;

    if (studentId == null) {
      setState(() {
        _errorMessage = 'រកមិនឃើញលេខសម្គាល់សិស្ស';
        _isLoading = false;
      });
      return;
    }

    final homework = await _homeworkData.getHomeworkByStudent(studentId);
    final summary = await _homeworkData.getHomeworkSummaryByStudent(studentId);

    if (!mounted) return;
    setState(() {
      _homeworkItems = homework;
      _summary = summary;
      _isLoading = false;
      _errorMessage = null;
    });
  }

  Future<void> _pickStudent() async {
    if (_students.length <= 1) return;

    final selected = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      backgroundColor: AppColors.white,
      builder: (context) {
        return SafeArea(
          child: ListView.separated(
            itemCount: _students.length,
            separatorBuilder: (_, __) => Divider(color: AppColors.lightgrey),
            itemBuilder: (context, index) {
              final student = _students[index];
              final name =
                  '${student['first_name'] ?? ''} ${student['last_name'] ?? ''}'
                      .trim();
              final className = (student['class_name'] as String?) ?? '';

              return ListTile(
                title: Text(
                  name.isEmpty ? 'Student' : name,
                  style: AppTextStyle.subtitle16,
                ),
                subtitle: className.isEmpty ? null : Text(className),
                onTap: () => Navigator.pop(context, student),
              );
            },
          ),
        );
      },
    );

    if (selected == null) return;

    setState(() {
      _selectedStudent = selected;
      _isLoading = true;
    });

    await _loadHomeworkForSelectedStudent();
  }

  DateTime? _itemDate(Map<String, dynamic> item) {
    final deadline = item['deadline'] as String?;
    final created = item['created_at'] as String?;
    return DateTime.tryParse(deadline ?? created ?? '');
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '-';
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  List<Map<String, dynamic>> _todayHomework() {
    final now = DateTime.now();
    return _homeworkItems.where((item) {
      final d = _itemDate(item);
      if (d == null) return false;
      return d.year == now.year && d.month == now.month && d.day == now.day;
    }).toList();
  }

  List<Map<String, dynamic>> _recentHomework() {
    final list = List<Map<String, dynamic>>.from(_homeworkItems);
    list.sort((a, b) {
      final da = DateTime.tryParse((a['submitted_at'] as String?) ?? '');
      final db = DateTime.tryParse((b['submitted_at'] as String?) ?? '');
      if (da == null && db == null) return 0;
      if (da == null) return 1;
      if (db == null) return -1;
      return db.compareTo(da);
    });
    return list
        .where((e) => (e['submitted'] as int? ?? 0) == 1)
        .take(4)
        .toList();
  }

  List<Map<String, dynamic>> _quizLikeItems() {
    return _homeworkItems.take(6).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundLight,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          'កិច្ចការផ្ទះ',
          style:
              AppTextStyle.screenTitle24.copyWith(fontSize: _fs(24, context)),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child:
                Icon(Icons.notifications_sharp, color: AppColors.primaryText),
          ),
        ],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primaryText),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_errorMessage != null) ...[
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.errorBG,
                          borderRadius:
                              BorderRadius.circular(AppNumber.radiusSmall),
                        ),
                        child: Text(
                          _errorMessage!,
                          style: AppTextStyle.caption14Secondary
                              .copyWith(color: AppColors.error),
                        ),
                      ),
                    ],
                    const SizedBox(height: 12),
                    _buildProfileHeader(),
                    const SizedBox(height: 16),
                    _buildTabSelector(),
                    const SizedBox(height: 16),
                    _buildStatsRow(),
                    const SizedBox(height: 20),
                    if (_selectedTab == 0) ...[
                      _buildTodaySection(),
                      const SizedBox(height: 20),
                      _buildRecentSection(),
                      const SizedBox(height: 20),
                      _buildNewQuizzesSection(),
                    ] else ...[
                      _buildNewQuizzesSection(),
                    ],
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildProfileHeader() {
    final firstName = (_selectedStudent?['first_name'] as String?) ?? '';
    final lastName = (_selectedStudent?['last_name'] as String?) ?? '';
    final className = (_selectedStudent?['class_name'] as String?) ?? '';
    final studentId =
        (_selectedStudent?['student_id'] ?? _selectedStudent?['id'])
                ?.toString() ??
            '-';

    return Row(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primaryBg,
            border: Border.all(color: AppColors.primaryMain, width: 2),
          ),
          child: ClipOval(
            child: Image.asset(AppImages.userProfile, fit: BoxFit.cover),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    '$firstName $lastName'.trim().isEmpty
                        ? 'Student'
                        : '$firstName $lastName'.trim(),
                    style: AppTextStyle.subtitle18,
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: _pickStudent,
                    child: Icon(Icons.keyboard_arrow_down,
                        size: 20, color: AppColors.secondaryText),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                '${className.isEmpty ? "ថ្នាក់" : className} ID: #$studentId',
                style: AppTextStyle.caption13Secondary,
              ),
            ],
          ),
        ),
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.backgroundLight,
            border: Border.all(color: AppColors.lightgrey),
          ),
          child: Icon(Icons.person_outline_rounded,
              size: 22, color: AppColors.secondaryText),
        ),
      ],
    );
  }

  Widget _buildTabSelector() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(AppNumber.radiusMedium),
      ),
      child: Row(
        children: [
          _buildTab("កិច្ចការផ្ទះ", 0),
          _buildTab("កម្រងសំណួរ", 1),
        ],
      ),
    );
  }

  Widget _buildTab(String label, int index) {
    final isSelected = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTab = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryMain : Colors.transparent,
            borderRadius: BorderRadius.circular(AppNumber.radiusSmall),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: GoogleFonts.kantumruyPro(
              fontSize: _fs(15, context),
              fontWeight: FontWeight.w600,
              color: isSelected ? AppColors.white : AppColors.primaryText,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatsRow() {
    final total = _summary['total'] ?? 0;
    final submitted = _summary['submitted'] ?? 0;
    final pending = _summary['pending'] ?? 0;
    final overdue = _summary['overdue'] ?? 0;

    final completion = total == 0 ? 0 : ((submitted / total) * 100).round();

    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppNumber.radiusLarge),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColors.primaryBg,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Icon(Icons.flag_outlined,
                          size: 18, color: AppColors.primaryMain),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text("សរុបកិច្ចការ",
                          style: AppTextStyle.caption14Secondary),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('បានផ្ញើ: $submitted',
                            style: AppTextStyle.caption12Primary),
                        Text('មិនទាន់ផ្ញើ: $pending • យឺត: $overdue',
                            style: AppTextStyle.caption12Secondary),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppNumber.radiusLarge),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$completion%',
                  style: GoogleFonts.kantumruyPro(
                    fontSize: _fs(32, context),
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryText,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'អត្រាបញ្ចប់កិច្ចការ',
                  style: AppTextStyle.caption12Secondary,
                  maxLines: 2,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTodaySection() {
    final items = _todayHomework();
    if (items.isEmpty) {
      return _buildEmptyBox('មិនមានកិច្ចការផ្ទះសម្រាប់ថ្ងៃនេះ');
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("ថ្ងៃនេះ", style: AppTextStyle.subtitle18),
            Text(_formatDate(DateTime.now()),
                style: AppTextStyle.caption14Secondary),
          ],
        ),
        const SizedBox(height: 12),
        ...items.map((item) {
          final isSubmitted = (item['submitted'] as int? ?? 0) == 1;
          final title = (item['title'] as String?) ?? '-';
          final subject = (item['subject'] as String?) ?? '';

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildHomeworkCard(
              icon: isSubmitted
                  ? Icons.check_circle_outline
                  : Icons.pending_actions,
              iconColor: isSubmitted ? AppColors.success : AppColors.orange,
              iconBgColor:
                  isSubmitted ? AppColors.successBG : const Color(0xFFFFF3E0),
              title: title,
              tag: isSubmitted ? 'បានផ្ញើ' : 'មិនទាន់ផ្ញើ',
              tagColor: isSubmitted ? AppColors.success : AppColors.orange,
              tagBgColor:
                  isSubmitted ? AppColors.successBG : const Color(0xFFFFF3E0),
              subtitle: subject,
              hasTimeInfo: true,
              timeText: 'កំណត់ថ្ងៃ: ${_formatDate(_itemDate(item))}',
              hasButton: !isSubmitted,
              buttonText: 'ពិនិត្យកិច្ចការ',
              accentColor: isSubmitted ? AppColors.success : AppColors.orange,
            ),
          );
        }),
      ],
    );
  }

  Widget _buildRecentSection() {
    final items = _recentHomework();
    if (items.isEmpty) {
      return _buildEmptyBox('មិនមានប្រវត្តិកិច្ចការដែលបានផ្ញើ');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("រៀបមិញ", style: AppTextStyle.subtitle18),
        const SizedBox(height: 12),
        ...items.map((item) {
          final title = (item['title'] as String?) ?? '-';
          final subject = (item['subject'] as String?) ?? '';
          final submittedAt =
              DateTime.tryParse((item['submitted_at'] as String?) ?? '');

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildHomeworkCard(
              icon: Icons.task_alt,
              iconColor: AppColors.success,
              iconBgColor: AppColors.successBG,
              title: title,
              tag: 'បានផ្ញើ',
              tagColor: AppColors.success,
              tagBgColor: AppColors.successBG,
              subtitle: subject,
              dateText: 'ផ្ញើនៅ: ${_formatDate(submittedAt)}',
            ),
          );
        }),
      ],
    );
  }

  Widget _buildNewQuizzesSection() {
    final items = _quizLikeItems();
    if (items.isEmpty) {
      return _buildEmptyBox('មិនមានទិន្នន័យកម្រងសំណួរ/កិច្ចការថ្មី');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("កម្រងសំណួរថ្មីៗ", style: AppTextStyle.subtitle18),
            if (_summary['overdue'] != null && (_summary['overdue'] ?? 0) > 0)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.errorBG,
                  borderRadius: BorderRadius.circular(AppNumber.radiusRounded),
                ),
                child: Text(
                  'យឺត ${_summary['overdue']}',
                  style: GoogleFonts.kantumruyPro(
                    fontSize: _fs(12, context),
                    color: AppColors.error,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        ...items.map((item) {
          final isSubmitted = (item['submitted'] as int? ?? 0) == 1;
          final due = _itemDate(item);

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildQuizCard(
              icon: isSubmitted ? Icons.quiz : Icons.pending_actions,
              iconColor: isSubmitted ? AppColors.success : AppColors.orange,
              iconBgColor:
                  isSubmitted ? AppColors.successBG : const Color(0xFFFFF3E0),
              title: (item['title'] as String?) ?? '-',
              score: isSubmitted ? 'DONE' : 'TODO',
              scoreColor: isSubmitted ? AppColors.success : AppColors.orange,
              stats:
                  '${_formatDate(due)} • ${(item['subject'] as String?) ?? '-'}',
              tag: isSubmitted ? 'បានបញ្ចប់' : 'កំពុងបន្ត',
              tagColor: isSubmitted ? AppColors.success : AppColors.orange,
              tagBgColor:
                  isSubmitted ? AppColors.successBG : const Color(0xFFFFF3E0),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildEmptyBox(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppNumber.radiusLarge),
      ),
      child: Text(text, style: AppTextStyle.caption14Secondary),
    );
  }

  // ==================== HOMEWORK CARD WIDGET ====================
  Widget _buildHomeworkCard({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    required String tag,
    required Color tagColor,
    required Color tagBgColor,
    required String subtitle,
    bool hasTimeInfo = false,
    String? timeText,
    bool hasButton = false,
    String? buttonText,
    Color? accentColor,
    String? dateText,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppNumber.radiusLarge),
        border: accentColor != null
            ? Border(left: BorderSide(color: accentColor, width: 4))
            : null,
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: iconBgColor,
                    borderRadius: BorderRadius.circular(AppNumber.radiusSmall),
                  ),
                  child: Icon(icon, color: iconColor, size: 20),
                ),
                const SizedBox(width: 10),
                // Title + Tag + Subtitle
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(title,
                                style: AppTextStyle.subtitle16,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: tagBgColor,
                              borderRadius: BorderRadius.circular(
                                  AppNumber.radiusRounded),
                            ),
                            child: Text(
                              tag,
                              style: GoogleFonts.kantumruyPro(
                                fontSize: _fs(11, context),
                                color: tagColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(subtitle, style: AppTextStyle.caption13Secondary),
                    ],
                  ),
                ),
              ],
            ),
            if (hasTimeInfo && timeText != null) ...[
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.only(left: 46),
                child: Row(
                  children: [
                    Icon(Icons.access_time,
                        size: 14, color: AppColors.secondaryText),
                    const SizedBox(width: 4),
                    Text(timeText, style: AppTextStyle.caption12Secondary),
                  ],
                ),
              ),
            ],
            if (dateText != null) ...[
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.only(left: 46),
                child: Text(dateText, style: AppTextStyle.caption12Secondary),
              ),
            ],
            if (hasButton && buttonText != null) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accentColor ?? AppColors.success,
                        foregroundColor: AppColors.white,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(AppNumber.radiusMedium),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        buttonText,
                        style: GoogleFonts.kantumruyPro(
                          fontSize: _fs(14, context),
                          fontWeight: FontWeight.w600,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: (accentColor ?? AppColors.success)
                          .withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.info_outline,
                        size: 18, color: accentColor ?? AppColors.success),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ==================== QUIZ CARD WIDGET ====================
  Widget _buildQuizCard({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    required String score,
    required Color scoreColor,
    required String stats,
    required String tag,
    required Color tagColor,
    required Color tagBgColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppNumber.radiusLarge),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(AppNumber.radiusSmall),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 12),
          // Title + Stats + Tag
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: AppTextStyle.subtitle16,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(stats, style: AppTextStyle.caption12Secondary),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: tagBgColor,
                        borderRadius:
                            BorderRadius.circular(AppNumber.radiusRounded),
                      ),
                      child: Text(
                        tag,
                        style: GoogleFonts.kantumruyPro(
                          fontSize: _fs(11, context),
                          color: tagColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Score
          Text(
            score,
            style: GoogleFonts.kantumruyPro(
              fontSize: _fs(18, context),
              fontWeight: FontWeight.bold,
              color: scoreColor,
            ),
          ),
        ],
      ),
    );
  }
}
