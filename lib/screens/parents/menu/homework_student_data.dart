import 'package:tamdansers_app/database/db_helper.dart';

class HomeworkStudentData {
  Future<List<Map<String, dynamic>>> getHomeworkByStudent(int studentId) async {
    final db = await DbHelper().initDatabase();

    return await db.rawQuery(
      '''SELECT h.id,
                h.title,
                h.subject,
                h.instructions,
                h.deadline,
                h.status,
                h.created_at,
                h.class_id,
                c.name as class_name,
                sc.first_name,
                sc.last_name,
                sc.id as student_id,
                CASE WHEN sub.id IS NOT NULL THEN 1 ELSE 0 END as submitted,
                sub.submitted_at
         FROM tbl_student_class sc
         JOIN tbl_homework h ON h.class_id = sc.class_id
         LEFT JOIN tbl_submission sub
           ON sub.homework_id = h.id AND sub.student_id = sc.id
         LEFT JOIN tbl_class c ON c.id = sc.class_id
         WHERE sc.id = ?
         ORDER BY COALESCE(h.deadline, h.created_at) DESC''',
      [studentId],
    );
  }

  Future<Map<String, int>> getHomeworkSummaryByStudent(int studentId) async {
    final items = await getHomeworkByStudent(studentId);

    int submitted = 0;
    int pending = 0;
    int overdue = 0;

    final now = DateTime.now();
    for (final item in items) {
      final isSubmitted = (item['submitted'] as int? ?? 0) == 1;
      if (isSubmitted) {
        submitted++;
      } else {
        pending++;
      }

      final deadlineRaw = item['deadline'] as String?;
      final deadline =
          deadlineRaw == null ? null : DateTime.tryParse(deadlineRaw);
      if (!isSubmitted && deadline != null && deadline.isBefore(now)) {
        overdue++;
      }
    }

    return {
      'total': items.length,
      'submitted': submitted,
      'pending': pending,
      'overdue': overdue,
    };
  }
}
