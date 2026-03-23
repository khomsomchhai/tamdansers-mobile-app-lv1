import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tamdansers_app/constants/app_colors.dart';
import 'package:tamdansers_app/constants/app_number.dart';
import 'package:tamdansers_app/constants/text_style.dart';
import 'package:tamdansers_app/repositories/homework_repo.dart';
import 'package:tamdansers_app/repositories/user_repo.dart';
import 'package:tamdansers_app/screens/student/menu/homework.dart';

Color _statusColor(TaskStatus status) {
  switch (status) {
    case TaskStatus.completed:
      return Colors.green;
    case TaskStatus.notSubmitted:
      return Colors.red;
    case TaskStatus.inProgress:
      return Colors.blue;
    case TaskStatus.late:
      return Colors.orange;
  }
}

String _statusText(TaskStatus status) {
  switch (status) {
    case TaskStatus.completed:
      return "បានបញ្ចប់";
    case TaskStatus.notSubmitted:
      return "មិនទាន់ផ្ញើរ";
    case TaskStatus.inProgress:
      return "កំពុងរៀបចំ";
    case TaskStatus.late:
      return "យឺតយ៉ាវ";
  }
}

class Deatilscreen extends StatefulWidget {
  final Map<String, dynamic>? homework;
  final int? userId;
  const Deatilscreen({super.key, this.homework, this.userId});

  @override
  State<Deatilscreen> createState() => _DeatilscreenState();
}

class _DeatilscreenState extends State<Deatilscreen> {
  List<PlatformFile> submissionFiles = [];
  bool isSubmitting = false;
  String teacherName = '';
  final UserRepo userRepo = UserRepo();
  final HomeworkRepo homeworkRepo = HomeworkRepo();
  int? currentStudentId;

  @override
  void initState() {
    super.initState();
    _fetchTeacherName();
    _getCurrentStudentId();
  }

  Future<void> _getCurrentStudentId() async {
    try {
      if (widget.userId != null) {
        setState(() {
          currentStudentId = widget.userId;
        });
      } else {
        final prefs = await SharedPreferences.getInstance();
        final studentId = prefs.getInt('userid');
        if (studentId != null) {
          setState(() {
            currentStudentId = studentId;
          });
        }
      }
    } catch (e) {
      debugPrint('Error getting student ID: $e');
    }
  }

  Future<void> _fetchTeacherName() async {
    try {
      final teacherId = widget.homework?['teacher_id'] as int?;
      if (teacherId != null) {
        final teacher = await userRepo.getUserById(teacherId);
        if (teacher != null && mounted) {
          final firstName = teacher['first_name'] ?? '';
          final lastName = teacher['last_name'] ?? '';
          setState(() {
            teacherName = '$firstName $lastName'.trim();
          });
        }
      }
    } catch (e) {
      debugPrint('Error getting teacher: $e');
    }
  }

  Future<void> _pickFiles() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'jpg', 'jpeg', 'png', 'txt'],
      );

      if (result != null) {
        setState(() {
          submissionFiles.addAll(result.files);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking files: $e', style: AppTextStyle.body)),
      );
    }
  }

  Future<void> _submitHomework() async {
    if (submissionFiles.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('សូមជ្រើសរើសឯកសារងាយ', style: AppTextStyle.body)),
      );
      return;
    }

    if (currentStudentId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('មិនបានស្វែងរកលេខសម្គាល់សិស្ស', style: AppTextStyle.body)),
      );
      return;
    }

    setState(() {
      isSubmitting = true;
    });

    try {
      final homeworkId = widget.homework?['id'] as int?;
      
      if (homeworkId == null) {
        throw Exception('មិនបានស្វែងរកលេខសម្គាល់កិច្ចការ');
      }
      await homeworkRepo.submitHomework(
        homeworkId: homeworkId,
        studentId: currentStudentId!,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('ឯកសារត្រូវបានផ្ញើដោយជោគជ័យ', style: AppTextStyle.body)),
        );
        setState(() {
          submissionFiles.clear();
        });
        
        await Future.delayed(const Duration(milliseconds: 500));
        if (mounted) {
          Navigator.pop(context);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error submitting: $e', style: AppTextStyle.body)),
        );
      }
    } finally {
      setState(() {
        isSubmitting = false;
      });
    }
  }

  void _removeFile(int index) {
    setState(() {
      submissionFiles.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final submitted = widget.homework?['submitted'] as int? ?? 0;
    final deadline = widget.homework?['deadline'] as String? ?? '';
    
    TaskStatus taskStatus = TaskStatus.notSubmitted;
    if (submitted == 1) {
      taskStatus = TaskStatus.completed;
    } else {
      try {
        final deadlineDate = DateTime.parse(deadline);
        final now = DateTime.now();
        if (now.isAfter(deadlineDate)) {
          taskStatus = TaskStatus.late;
        } else {
          taskStatus = TaskStatus.inProgress;
        }
      } catch (e) {
        taskStatus = TaskStatus.notSubmitted;
      }
    }
    
    final instructions = widget.homework?['instructions'] as String? ?? 
        'ការធ្វើកិច្ចការផ្ទះគឺជាកាតព្វកិច្ចសំខាន់របស់សិស្ស ដែលជួយបង្កើនការយល់ដឹង និងរំលឹកមេរៀនដែលបានរៀននៅក្នុងថ្នាក់។ '
        'តាមរយៈការធ្វើកិច្ចការផ្ទះ សិស្សអាចអនុវត្តចំណេះដឹង ធ្វើឲ្យមានវិន័យ និងបណ្តុះទម្លាប់ក្នុងការសិក្សាដោយខ្លួនឯង។ '
        'ប្រសិនបើសិស្សធ្វើកិច្ចការផ្ទះទៀងទាត់ នឹងជួយឲ្យមានលទ្ធផលសិក្សាល្អ និងរីកចម្រើនទាំងចំណេះដឹង និងការទទួលខុសត្រូវ។';
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "ព័ត៍មានកិច្ចការផ្ទះ",
          style: AppTextStyle.sectionTitle20,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: taskList(),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(height: 50, child: status(status: taskStatus)),
              SizedBox(
                height: 10,
              ),
              dashBoard(instructions: instructions),
              SizedBox(
                height: 10,
              ),
              fileUpload(),
              SizedBox(
                height: 10,
              ),
              submissionSection(),
              SizedBox(
                height: 10,
              ),
              teaComment()
            ],
          ),
        ),
      ),
    );
  }

  Widget taskCard({
    required String title,
    required String subtitle,
    required String tname,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppNumber.radiusMedium),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: color),
              ),
              SizedBox(
                width: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyle.fontsize18,
                  ),
                  Text(
                    subtitle,
                    style: AppTextStyle.body,
                  ),
                  Text(
                    "គ្រូបង្រៀន: $tname",
                    style: AppTextStyle.hintText,
                  )
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  Widget taskList() {
    final title = widget.homework?['title'] as String? ?? 'គណិតវិទ្យា';
    final subject = widget.homework?['subject'] as String? ?? 'លំហាត់សមីការដឺក្រេទី២';
    
    return taskCard(
        title: title,
        subtitle: subject,
        tname: teacherName.isNotEmpty ? teacherName : 'គ្រូបង្រៀន',
        icon: Icons.assignment_outlined,
        color: AppColors.primaryMain);
  }

  Widget status({required TaskStatus status}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppNumber.radiusSmall),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
            ),
          ],
        ),
        child: Row(
          children: [
            Text(
              "ស្ថានភាព៖ ",
              style: AppTextStyle.fontsize18,
            ),
            Text(
              _statusText(status),
              style: AppTextStyle.body,
            ),
            Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: _statusColor(status).withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                _statusText(status),
                style: AppTextStyle.caption12Secondary.copyWith(
                  fontWeight: FontWeight.bold,
                  color: _statusColor(status),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget dashBoard({String? instructions}) {
    final content = instructions ?? 
      'ការធ្វើកិច្ចការផ្ទះគឺជាកាតព្វកិច្ចសំខាន់របស់សិស្ស ដែលជួយបង្កើនការយល់ដឹង និងរំលឹកមេរៀនដែលបានរៀននៅក្នុងថ្នាក់។ '
      'តាមរយៈការធ្វើកិច្ចការផ្ទះ សិស្សអាចអនុវត្តចំណេះដឹង ធ្វើឲ្យមានវិន័យ និងបណ្តុះទម្លាប់ក្នុងការសិក្សាដោយខ្លួនឯង។ '
      'ប្រសិនបើសិស្សធ្វើកិច្ចការផ្ទះទៀងទាត់ នឹងជួយឲ្យមានលទ្ធផលសិក្សាល្អ និងរីកចម្រើនទាំងចំណេះដឹង និងការទទួលខុសត្រូវ។';
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppNumber.radiusMedium),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 12,
              ),
            ]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "សេចក្តីណែនាំ",
              style: AppTextStyle.sectionTitle20,
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              content,
              style: AppTextStyle.body.copyWith(height: 1.6),
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }

  Widget fileUpload() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 12,
              ),
            ]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "ឯកសារដែលបានជញ្ចូន",
              style: AppTextStyle.fontsize18,
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.uploadFile,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                children: [
                  Container(
                      height: 45,
                      width: 45,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color.fromARGB(80, 244, 67, 54)),
                      child: Icon(
                        Icons.picture_as_pdf,
                        color: Colors.red,
                      )),
                  SizedBox(
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "exercise_1.pdf",
                        style: AppTextStyle.fontsize18,
                      ),
                      Text(
                        "2.4 MB .24-01-2026",
                        style: AppTextStyle.hintText,
                      )
                    ],
                  ),
                  Spacer(),
                  Icon(Icons.download)
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            
          ],
        ),
      ),
    );
  }

  Widget teaComment() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppNumber.radiusMedium),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 12,
              ),
            ]),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.comment),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "មតិយោបល់របស់គ្រូ",
                  style: AppTextStyle.fontsize18,
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: AppColors.teacomment,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.comment),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 12,
                    ),
                  ]),
              child: Column(
                children: [
                  Text(
                    "ខិតខំប្រឹងប្រែងបន្តទៀត ការសិក្សាខែធ្វើបានល្អច្រើនហើយ\n សូមបន្តធ្វើអោយបានល្អបន្ថែមទៀតនៅខែក្រោយ",
                    style: AppTextStyle.body,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget submissionSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppNumber.radiusMedium),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 12,
              ),
            ]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.upload_file, color: AppColors.primaryMain),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "ផ្ញើឯកសារ",
                  style: AppTextStyle.fontsize18,
                )
              ],
            ),
            SizedBox(
              height: 15,
            ),
            if (submissionFiles.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "ឯកសារដែលបានជ្រើសរើស:",
                    style: AppTextStyle.body.copyWith(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ...submissionFiles.asMap().entries.map((entry) {
                    int index = entry.key;
                    PlatformFile file = entry.value;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.uploadFile,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            _getFileIcon(file.extension ?? 'unknown'),
                            SizedBox(
                              width: 12,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    file.name,
                                    style: AppTextStyle.body14,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    '${(file.size / 1024 / 1024).toStringAsFixed(2)} MB',
                                    style: AppTextStyle.hintText,
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            GestureDetector(
                              onTap: () => _removeFile(index),
                              child: Icon(Icons.close, color: Colors.red),
                            )
                          ],
                        ),
                      ),
                    );
                  }),
                  SizedBox(
                    height: 12,
                  ),
                ],
              ),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: isSubmitting ? null : _pickFiles,
                icon: Icon(Icons.add, color: AppColors.primaryText,),
                label: Text(
                  submissionFiles.isEmpty
                      ? "ជ្រើសរើសឯកសារ"
                      : "ថែមឯកសារលទ្ធផល",
                  style: AppTextStyle.body14.copyWith(color: AppColors.primaryText),
                ),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  side: BorderSide(
                    color: AppColors.primaryMain,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 12,
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: isSubmitting ? null : _submitHomework,
                icon: isSubmitting
                    ? SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Icon(Icons.send,color: AppColors.white,),
                label: Text(
                  isSubmitting ? "កំពុងផ្ញើ..." : "ផ្ញើឯកសារ",
                  style: AppTextStyle.buttonText16White,
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  backgroundColor: AppColors.primaryMain,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getFileIcon(String extension) {
    Color color;
    IconData icon;

    switch (extension.toLowerCase()) {
      case 'pdf':
        color = Colors.red;
        icon = Icons.picture_as_pdf;
        break;
      case 'doc':
      case 'docx':
        color = Colors.blue;
        icon = Icons.description;
        break;
      case 'jpg':
      case 'jpeg':
      case 'png':
        color = Colors.green;
        icon = Icons.image;
        break;
      case 'txt':
        color = Colors.orange;
        icon = Icons.text_fields;
        break;
      default:
        color = Colors.grey;
        icon = Icons.file_present;
    }

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color),
    );
  }
}
