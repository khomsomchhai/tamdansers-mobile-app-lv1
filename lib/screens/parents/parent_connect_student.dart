import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tamdansers_app/constants/app_colors.dart';
import 'package:tamdansers_app/constants/app_images.dart';
import 'package:tamdansers_app/constants/app_number.dart';
import 'package:tamdansers_app/constants/text_style.dart';
import 'package:tamdansers_app/constants/validators.dart';
import 'package:tamdansers_app/repositories/parent_student_repo.dart';
import 'package:tamdansers_app/repositories/student_class_repo.dart';
import 'package:tamdansers_app/repositories/user_repo.dart';
import 'package:tamdansers_app/widget/auth_field.dart';
import 'package:tamdansers_app/widget/custom_dialog.dart';
import 'package:tamdansers_app/widget/custom_snackbar.dart';
import 'package:tamdansers_app/widget/primary_button_2.dart';

class ParentConnectStudent extends StatefulWidget {
  const ParentConnectStudent({super.key});

  @override
  State<ParentConnectStudent> createState() => _ParentConnectStudentState();
}

class _ParentConnectStudentState extends State<ParentConnectStudent> {
  var formKey = GlobalKey<FormState>();
  var invCodeCtrl = TextEditingController();
  bool _isLoading = false;

  Future<void> _connectToStudent() async {
    if (!formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final identifier = invCodeCtrl.text.trim();
      final pref = await SharedPreferences.getInstance();
      final parentId = pref.getInt("userId");

      if (parentId == null) {
        _showError("User not logged in");
        return;
      }
      final userRepo = UserRepo();
      final studentUser = await userRepo.getUserByPhoneOrEmail(identifier);
      if (studentUser == null) {
        _showError(
            "សិស្សដែលមានអ៊ីម៉ែល ឬ លេខទូរស័ព្ទនេះមិនមាននៅក្នុងប្រព័ន្ធទេ");
        return;
      }
      if (studentUser["role"] != "student") {
        _showError("គណនីនេះមិនមែនជាគណនីសិស្សទេ");
        return;
      }
      final studentClassRepo = StudentClassRepo();
      var studentRow = await studentClassRepo
          .getStudentByLinkedUserId(studentUser["id"] as int);

      studentRow ??= await studentClassRepo.getStudentByEmailOrPhone(
          studentUser["email"] as String?,
          studentUser["phone"] as String?,
        );
      if (studentRow == null) {
        _showError("សិស្សនេះមិនមាននៅក្នុងថ្នាក់ទេ។ សូមព្យាយាមធ្វើការ ម្តងទៀត។");
        return;
      }

      final studentClassId = studentRow["id"] as int;

      final parentStudentRepo = ParentStudentRepo();
      final isConnected = await parentStudentRepo.isParentConnectedToStudent(
          parentId, studentClassId);

      if (isConnected) {
        _showError("អ្នកបានភ្ជាប់ទៅកាន់សិស្សនេះរួចហើយ");
        return;
      }

      final result = await parentStudentRepo.connectParentToStudent(
        parentId: parentId,
        studentId: studentClassId,
      );
      debugPrint(
          'parentId=$parentId, studentClassId=$studentClassId, result=$result');

      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => CustomDialog(
            label: "យល់ព្រម",
            title: "សំណើរត្រូវបានដាក់ស្នើរ",
            description:
                "សូមរង់ចាំការទទួលសំណើរពីសិស្ស។ អ្នកនឹងទទួលបានការជូនដំណឹងនៅពេលដែលសំណើរបស់អ្នកត្រូវបានទទួល ឬ បដិសេធ។",
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
          ),
        );
      }
    } catch (e) {
      _showError("មានបញ្ហាបច្ចេកទេស សូមព្យាយាមម្ដងទៀត។");
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        content: CustomSnackbar(
          title: "មិនត្រឹមត្រូវ!",
          message: message,
          icon: Icons.close,
          color: AppColors.error,
        ),
      ),
    );
  }

  @override
  void dispose() {
    invCodeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.primaryText,
            size: AppNumber.iconMedium,
          ),
        ),
        title: Text(
          "ភ្ជាប់គណនីសិស្ស",
          style: AppTextStyle.sectionTitle20,
        ),
        centerTitle: true,
        elevation: 0,
        surfaceTintColor: AppColors.transparent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                _buildHeader(),
                SizedBox(
                  height: 16,
                ),
                _buildForm(),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: PrimaryButton2(
            label: _isLoading ? "" : "ដាក់ស្នើរ",
            backgroundColor: AppColors.primaryMain,
            foregroundColor: AppColors.white,
            processIndicator: _isLoading
                ? SizedBox(
                    width: 26,
                    height: 26,
                    child: CircularProgressIndicator(
                      color: AppColors.white,
                      strokeWidth: 2,
                    ),
                  )
                : null,
            onPressed: () async {
              setState(() {
                _isLoading = true;
              });
              await Future.delayed(Duration(seconds: 2));
              setState(() {
                _isLoading = false;
              });
              await _connectToStudent();
            }),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.30,
          child: SvgPicture.asset(AppImages.connection),
        ),
        SizedBox(height: 20),
        Text(
          "ភ្ជាប់ទៅកាន់គណនីរបស់សិស្ស",
          style: AppTextStyle.sectionTitle20,
        ),
        SizedBox(
          height: 16,
        ),
        Center(
          child: Text(
            "សូមបញ្ចូលអ៊ីម៉ែល ឬ លេខទូរស័ព្ទរបស់សិស្សដែលអ្នកចង់ភ្ជាប់។ អ៊ីម៉ែល ឬ លេខទូរស័ព្ទដែលបានចុះឈ្មោះជាមួយគណនីសិស្សរួចហើយ។",
            style: AppTextStyle.body,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  _buildForm() {
    return Column(
      children: [
        AuthField(
          hintText: "អ៊ីម៉ែល ឬ លេខទូរស័ព្ទរបស់សិស្ស",
          icon: Icon(
            Icons.email_outlined,
            color: AppColors.secondaryText,
          ),
          textController: invCodeCtrl,
          validator: Validators.emailOrPhone,
        ),
        SizedBox(
          height: 10,
        )
      ],
    );
  }
}
