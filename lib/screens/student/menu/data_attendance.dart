enum AttendanceStatus { present, absent }
class AttendanceEntryModel {
  final String date;
  final String subject;
  final String time;
  final AttendanceStatus status;

  const AttendanceEntryModel({
    required this.date,
    required this.subject,
    required this.time,
    required this.status,
  });

  bool get isPresent => status == AttendanceStatus.present;

  static const List<AttendanceEntryModel> attendanceHistory = [
    AttendanceEntryModel(
      date: '17 មករា 2026',
      subject: 'គណិតវិទ្យា',
      time: '7:00 AM - 8:00 AM',
      status: AttendanceStatus.present,
    ),
    AttendanceEntryModel(
      date: '18 មករា 2026',
      subject: 'ភាសាខ្មែរ',
      time: '8:10 AM - 9:00 AM',
      status: AttendanceStatus.present,
    ),
    AttendanceEntryModel(
      date: '19 មករា 2026',
      subject: 'ភូមិវិទ្យា',
      time: '9:10 AM - 10:00 AM',
      status: AttendanceStatus.absent,
    ),
    AttendanceEntryModel(
      date: '20 មករា 2026',
      subject: 'ជីវវិទ្យា',
      time: '10:10 AM - 11:00 AM',
      status: AttendanceStatus.present,
    ),
    AttendanceEntryModel(
      date: '21 មករា 2026',
      subject: 'រូបវិទ្យា',
      time: '1:00 PM - 1:50 PM',
      status: AttendanceStatus.present,
    ),
    AttendanceEntryModel(
      date: '24 មករា 2026',
      subject: 'គីមីវិទ្យា',
      time: '2:00 PM - 2:50 PM',
      status: AttendanceStatus.absent,
    ),
    AttendanceEntryModel(
      date: '25 មករា 2026',
      subject: 'ប្រវត្តិវិទ្យា',
      time: '3:00 PM - 3:50 PM',
      status: AttendanceStatus.present,
    ),
    AttendanceEntryModel(
      date: '26 មករា 2026',
      subject: 'ភាសាអង់គ្លេស',
      time: '4:00 PM - 5:00 PM',
      status: AttendanceStatus.present,
    ),
    AttendanceEntryModel(
      date: '27 មករា 2026',
      subject: 'គណិតវិទ្យា',
      time: '7:00 AM - 8:00 AM',
      status: AttendanceStatus.absent,
    ),
    AttendanceEntryModel(
      date: '28 មករា 2026',
      subject: 'ភាសាខ្មែរ',
      time: '8:10 AM - 9:00 AM',
      status: AttendanceStatus.present,
    ),
  ];
}

class AttendanceSummaryModel {
  final int totalDays;
  final int presentDays;
  final int absentDays;

  const AttendanceSummaryModel({
    required this.totalDays,
    required this.presentDays,
    required this.absentDays,
  });

  double get attendanceRate =>
      totalDays == 0 ? 0 : (presentDays / totalDays) * 100;
}
AttendanceSummaryModel get attendanceSummary {
  final history = AttendanceEntryModel.attendanceHistory;
  final total = history.length;
  final present = history.where((e) => e.isPresent).length;
  final absent = total - present;
  return AttendanceSummaryModel(
    totalDays: total,
    presentDays: present,
    absentDays: absent,
  );
}