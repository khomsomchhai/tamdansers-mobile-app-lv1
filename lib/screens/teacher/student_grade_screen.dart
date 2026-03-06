// // ignore_for_file: deprecated_member_use

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:tamdansers_app/constants/app_colors.dart';
// import 'package:tamdansers_app/constants/app_number.dart';
// import 'package:tamdansers_app/constants/text_style.dart';
// import 'package:tamdansers_app/repositories/homework_repo.dart';

// class StudentGradeScreen extends StatefulWidget {
//   const StudentGradeScreen({super.key});

//   @override
//   State<StudentGradeScreen> createState() => _StudentGradeScreenState();
// }

// class _StudentGradeScreenState extends State<StudentGradeScreen> {
//   late Map<String, dynamic> _hw;
//   late Map<String, dynamic> _student;
//   bool _initialized = false;
//   bool _saving = false;

//   final TextEditingController _scoreCtrl = TextEditingController();
//   final TextEditingController _commentCtrl = TextEditingController();

//   static const double _maxScore = 100;

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     if (_initialized) return;
//     _initialized = true;
//     final args = ModalRoute.of(context)?.settings.arguments;
//     if (args is Map<String, dynamic>) {
//       _hw = Map.from(args['hw'] as Map? ?? {});
//       _student = Map.from(args['student'] as Map? ?? {});
//     } else {
//       _hw = {};
//       _student = {};
//     }
//     _loadExistingGrade();
//   }

//   Future<void> _loadExistingGrade() async {
//     final homeworkId = _hw['id'] as int?;
//     final studentId = _student['id'] as int?;
//     if (homeworkId == null || studentId == null) return;
//     final row = await HomeworkRepo().getSubmissionForStudent(
//       homeworkId: homeworkId,
//       studentId: studentId,
//     );
//     if (row != null && mounted) {
//       final score = row['score'];
//       final comment = row['teacher_comment'] as String? ?? '';
//       setState(() {
//         if (score != null) _scoreCtrl.text = (score as num).toStringAsFixed(0);
//         if (comment.isNotEmpty) _commentCtrl.text = comment;
//       });
//     }
//   }

//   Future<void> _save() async {
//     final scoreText = _scoreCtrl.text.trim();
//     if (scoreText.isEmpty) {
//       _showSnack('សូមបញ្ចូលពិន្ទុ');
//       return;
//     }
//     final score = double.tryParse(scoreText);
//     if (score == null || score < 0 || score > _maxScore) {
//       _showSnack('ពិន្ទុត្រូវតែស្ថិតនៅចន្លោះ 0 ដល់ ${_maxScore.toInt()}');
//       return;
//     }
//     setState(() => _saving = true);
//     await HomeworkRepo().gradeSubmission(
//       homeworkId: _hw['id'] as int,
//       studentId: _student['id'] as int,
//       score: score,
//       teacherComment:
//           _commentCtrl.text.trim().isEmpty ? null : _commentCtrl.text.trim(),
//     );
//     if (mounted) {
//       setState(() => _saving = false);
//       Navigator.pop(context, true);
//     }
//   }

//   void _showSnack(String msg) {
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
//   }

//   String get _studentName =>
//       '${_student['first_name'] ?? ''} ${_student['last_name'] ?? ''}'.trim();
//   String get _studentCode => _student['student_code'] as String? ?? '';
//   String get _hwTitle => _hw['title'] as String? ?? '';
//   String get _hwSubject => _hw['subject'] as String? ?? '';
//   String get _hwDeadline => _hw['deadline'] as String? ?? '';
//   String get _hwCreatedAt => _hw['created_at'] as String? ?? '';
//   String get _hwStatus => _hw['status'] as String? ?? 'active';

//   String _formatDate(String iso) {
//     if (iso.isEmpty) return '—';
//     try {
//       final dt = DateTime.parse(iso);
//       return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
//     } catch (_) {
//       return iso;
//     }
//   }

//   @override
//   void dispose() {
//     _scoreCtrl.dispose();
//     _commentCtrl.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.backgroundLight,
//       appBar: AppBar(
//         backgroundColor: AppColors.backgroundLight,
//         elevation: 0,
//         leading: IconButton(
//           onPressed: () => Navigator.pop(context),
//           icon: const Icon(Icons.arrow_back_ios_new_rounded),
//           color: AppColors.primaryText,
//         ),
//         centerTitle: true,
//         title: Text('អាក់ពិន្ទុកិច្ចការ', style: AppTextStyle.screenTitle24),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.more_vert_rounded),
//             color: AppColors.primaryText,
//             onPressed: () {},
//           ),
//         ],
//       ),
//       body: ListView(
//         padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
//         children: [
//           // ── Student card ────────────────────────────────────────────────
//           _Card(
//             child: Row(
//               children: [
//                 CircleAvatar(
//                   radius: 30,
//                   backgroundColor: AppColors.primaryMain.withValues(alpha: 0.1),
//                   child: Icon(Icons.person_outline,
//                       size: 32, color: AppColors.primaryMain),
//                 ),
//                 const SizedBox(width: 14),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(_studentName.isEmpty ? '—' : _studentName,
//                           style: AppTextStyle.subtitle16),
//                       if (_studentCode.isNotEmpty) ...[
//                         const SizedBox(height: 4),
//                         Text('លេខសម្គាល់: $_studentCode',
//                             style: AppTextStyle.caption12Secondary),
//                       ],
//                     ],
//                   ),
//                 ),
//                 if (_hwSubject.isNotEmpty)
//                   Container(
//                     padding:
//                         const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                     decoration: BoxDecoration(
//                       color: const Color(0xFFE3F2FD),
//                       borderRadius: BorderRadius.circular(AppNumber.radiusPill),
//                     ),
//                     child: Text(
//                       _hwSubject,
//                       style: AppTextStyle.caption12Secondary
//                           .copyWith(color: AppColors.primaryMain),
//                     ),
//                   ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 16),

//           // ── Homework info ───────────────────────────────────────────────
//           _SectionLabel(label: 'ព័ត៌មានកិច្ចការ'),
//           const SizedBox(height: 8),
//           _Card(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(_hwTitle.isEmpty ? '—' : _hwTitle,
//                     style: AppTextStyle.subtitle16
//                         .copyWith(fontWeight: FontWeight.w700, fontSize: 17)),
//                 const SizedBox(height: 12),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text('កាលបរិច្ឆេទចំណាប',
//                               style: AppTextStyle.caption12Secondary),
//                           const SizedBox(height: 2),
//                           Text(_formatDate(_hwCreatedAt),
//                               style: AppTextStyle.body14),
//                         ],
//                       ),
//                     ),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text('ថ្ងៃផុតកំណត',
//                               style: AppTextStyle.caption12Secondary),
//                           const SizedBox(height: 2),
//                           Text(
//                             _formatDate(_hwDeadline),
//                             style: AppTextStyle.body14.copyWith(
//                               color: _hwStatus == 'active'
//                                   ? AppColors.primaryMain
//                                   : AppColors.secondaryText,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 10),
//                 Container(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//                   decoration: BoxDecoration(
//                     color: _hwStatus == 'active'
//                         ? AppColors.success.withValues(alpha: 0.12)
//                         : AppColors.secondaryText.withValues(alpha: 0.1),
//                     borderRadius: BorderRadius.circular(AppNumber.radiusPill),
//                   ),
//                   child: Text(
//                     _hwStatus == 'active' ? 'ដាក់ពេលណា' : 'ផុតកំណត',
//                     style: AppTextStyle.caption12Secondary.copyWith(
//                       color: _hwStatus == 'active'
//                           ? AppColors.success
//                           : AppColors.secondaryText,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 16),

//           // ── Submitted docs placeholder ──────────────────────────────────
//           _SectionLabel(label: 'ឯកសារដែរមក', trailing: 'ជំរើស 1 ឯកសារ'),
//           const SizedBox(height: 8),
//           _Card(
//             child: Column(
//               children: [
//                 Container(
//                   height: 140,
//                   width: double.infinity,
//                   decoration: BoxDecoration(
//                     color: const Color(0xFFF5F5F5),
//                     borderRadius: BorderRadius.circular(AppNumber.radiusMedium),
//                   ),
//                   child: Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(Icons.insert_drive_file_outlined,
//                             size: 40,
//                             color:
//                                 AppColors.secondaryText.withValues(alpha: 0.5)),
//                         const SizedBox(height: 8),
//                         Text('គ្មានឯកសារ',
//                             style: AppTextStyle.caption12Secondary),
//                       ],
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 12),
//                 SizedBox(
//                   width: double.infinity,
//                   child: OutlinedButton.icon(
//                     onPressed: () {},
//                     icon: Icon(Icons.search_rounded,
//                         size: 18, color: AppColors.primaryText),
//                     label: Text('មើលឯកសារតែនេះ',
//                         style: AppTextStyle.body14
//                             .copyWith(color: AppColors.primaryText)),
//                     style: OutlinedButton.styleFrom(
//                       side: BorderSide(color: AppColors.lightgrey, width: 1.2),
//                       padding: const EdgeInsets.symmetric(vertical: 12),
//                       shape: RoundedRectangleBorder(
//                           borderRadius:
//                               BorderRadius.circular(AppNumber.radiusMedium)),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 16),

//           // ── Grading section ─────────────────────────────────────────────
//           _SectionLabel(label: 'ការអាក់ពិន្ទុ'),
//           const SizedBox(height: 8),
//           _Card(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text('ពិន្ទុ', style: AppTextStyle.subtitle16),
//                 const SizedBox(height: 8),
//                 TextField(
//                   controller: _scoreCtrl,
//                   keyboardType:
//                       const TextInputType.numberWithOptions(decimal: true),
//                   inputFormatters: [
//                     FilteringTextInputFormatter.allow(
//                         RegExp(r'^\d+\.?\d{0,2}')),
//                   ],
//                   style: AppTextStyle.subtitle16,
//                   decoration: InputDecoration(
//                     hintText: '00',
//                     hintStyle: AppTextStyle.subtitle16
//                         .copyWith(color: AppColors.secondaryText),
//                     suffixText: '/ ${_maxScore.toInt()}',
//                     suffixStyle: AppTextStyle.body14
//                         .copyWith(color: AppColors.secondaryText),
//                     filled: true,
//                     fillColor: AppColors.backgroundLight,
//                     border: OutlineInputBorder(
//                       borderRadius:
//                           BorderRadius.circular(AppNumber.radiusMedium),
//                       borderSide: BorderSide(color: AppColors.lightgrey),
//                     ),
//                     enabledBorder: OutlineInputBorder(
//                       borderRadius:
//                           BorderRadius.circular(AppNumber.radiusMedium),
//                       borderSide: BorderSide(color: AppColors.lightgrey),
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderRadius:
//                           BorderRadius.circular(AppNumber.radiusMedium),
//                       borderSide:
//                           BorderSide(color: AppColors.primaryMain, width: 1.5),
//                     ),
//                     contentPadding: const EdgeInsets.symmetric(
//                         horizontal: 14, vertical: 14),
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 Text('មតិយោបល់របស់គ្រូ', style: AppTextStyle.subtitle16),
//                 const SizedBox(height: 8),
//                 TextField(
//                   controller: _commentCtrl,
//                   maxLines: 4,
//                   minLines: 4,
//                   style: AppTextStyle.body14,
//                   decoration: InputDecoration(
//                     hintText: 'សរសេរមតិយោបល់អំពីទំនួញទំរីនេះ...',
//                     hintStyle: AppTextStyle.body14
//                         .copyWith(color: AppColors.secondaryText),
//                     filled: true,
//                     fillColor: AppColors.backgroundLight,
//                     border: OutlineInputBorder(
//                       borderRadius:
//                           BorderRadius.circular(AppNumber.radiusMedium),
//                       borderSide: BorderSide(color: AppColors.lightgrey),
//                     ),
//                     enabledBorder: OutlineInputBorder(
//                       borderRadius:
//                           BorderRadius.circular(AppNumber.radiusMedium),
//                       borderSide: BorderSide(color: AppColors.lightgrey),
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderRadius:
//                           BorderRadius.circular(AppNumber.radiusMedium),
//                       borderSide:
//                           BorderSide(color: AppColors.primaryMain, width: 1.5),
//                     ),
//                     contentPadding: const EdgeInsets.all(14),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//       bottomNavigationBar: Container(
//         padding: EdgeInsets.fromLTRB(
//             16, 12, 16, MediaQuery.of(context).padding.bottom + 16),
//         decoration: BoxDecoration(
//           color: AppColors.white,
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withValues(alpha: 0.06),
//               blurRadius: 12,
//               offset: const Offset(0, -2),
//             ),
//           ],
//         ),
//         child: Row(
//           children: [
//             Expanded(
//               child: OutlinedButton(
//                 onPressed: _saving ? null : () => Navigator.pop(context),
//                 style: OutlinedButton.styleFrom(
//                   side: BorderSide(color: AppColors.lightgrey, width: 1.2),
//                   shape: RoundedRectangleBorder(
//                       borderRadius:
//                           BorderRadius.circular(AppNumber.radiusPill)),
//                   padding: const EdgeInsets.symmetric(vertical: 14),
//                 ),
//                 child: Text('រំលូតក្រោយ',
//                     style: AppTextStyle.body14
//                         .copyWith(color: AppColors.primaryText)),
//               ),
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               flex: 2,
//               child: ElevatedButton.icon(
//                 onPressed: _saving ? null : _save,
//                 icon: _saving
//                     ? const SizedBox(
//                         width: 18,
//                         height: 18,
//                         child: CircularProgressIndicator(
//                           strokeWidth: 2,
//                           color: Colors.white,
//                         ),
//                       )
//                     : const Icon(Icons.check_circle_outline_rounded,
//                         size: 18, color: Colors.white),
//                 label: Text(
//                   'អាក់ពិន្ទុបានល',
//                   style: AppTextStyle.body14.copyWith(color: AppColors.white),
//                 ),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: AppColors.primaryMain,
//                   elevation: 0,
//                   shape: RoundedRectangleBorder(
//                       borderRadius:
//                           BorderRadius.circular(AppNumber.radiusPill)),
//                   padding: const EdgeInsets.symmetric(vertical: 14),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // ── Shared helpers ─────────────────────────────────────────────────────────

// class _Card extends StatelessWidget {
//   final Widget child;
//   const _Card({required this.child});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: AppColors.white,
//         borderRadius: BorderRadius.circular(AppNumber.radiusLarge),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withValues(alpha: 0.04),
//             blurRadius: 10,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: child,
//     );
//   }
// }

// class _SectionLabel extends StatelessWidget {
//   final String label;
//   final String? trailing;
//   const _SectionLabel({required this.label, this.trailing});

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Icon(Icons.star_border_rounded, size: 16, color: AppColors.primaryMain),
//         const SizedBox(width: 6),
//         Text(label,
//             style:
//                 AppTextStyle.subtitle16.copyWith(color: AppColors.primaryMain)),
//         if (trailing != null) ...[
//           const Spacer(),
//           Text(trailing!, style: AppTextStyle.caption12Secondary),
//         ],
//       ],
//     );
//   }
// }
