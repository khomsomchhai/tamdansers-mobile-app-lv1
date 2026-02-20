import 'package:flutter/material.dart';
import 'package:tamdansers_app/constants/app_colors.dart';
import 'package:tamdansers_app/constants/text_style.dart';
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
  const Deatilscreen({super.key});

  @override
  State<Deatilscreen> createState() => _DeatilscreenState();
}

class _DeatilscreenState extends State<Deatilscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ព័ត៍មានកិច្ចការផ្ទះ",style: AppTextStyle.screenTitle24,),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            children: [
              SizedBox(
                height: 100,
                child: taskList()),
              SizedBox(height: 10,),
              SizedBox(
                height: 50,
                child: status(status: TaskStatus.completed)),
              SizedBox(height: 10,),
              dashBoard(),
              SizedBox(height: 10,),
              fileUpload(),
              SizedBox(height: 10,),
              teaComment()
            ],
          ),
        ),
      ),
    );
  }
  Widget taskCard(
    {required String title,
    required String subtitle,
    required String tname,
    required IconData icon,
    required Color color,}
  ){
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
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
                Text(title,
                style: AppTextStyle.fontsize18,
                ),
                Text(subtitle,
                style: AppTextStyle.body,
                ),
                Text("គ្រូបង្រៀន: $tname",style: AppTextStyle.hintText,)
              ],
            )
          ],
        )
      ],
    ),
    );
  }
  Widget taskList(){
    return ListView(
      padding: EdgeInsets.all(10),
      children: [
        taskCard(
          title: "គណិតវិទ្យា", 
          subtitle: "លំហាត់សមីការដឺក្រេទី២", 
          tname: "ជំុ លីណូ", 
          icon: Icons.grid_3x3, 
          color: AppColors.primaryMain),
      ],
    );
  }
  Widget status({required TaskStatus status}){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
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
        ],
      ),
      child: Row(
        children: [
          Text("ស្ថានភាព៖ ",style: AppTextStyle.fontsize18,),
          Text(_statusText(status),style: AppTextStyle.body,),
          Spacer(),
          Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: _statusColor(status).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _statusText(status),
                  style: TextStyle(
                    fontSize: 12,
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
  Widget dashBoard(){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
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
          ]
        ),
        child: Column(
          crossAxisAlignment:CrossAxisAlignment.start,
          children: [
            Text("សេចក្តីណែនាំ",style: AppTextStyle.sectionTitle20,),
            SizedBox(height: 15,),
            Text(
                  'ការធ្វើកិច្ចការផ្ទះគឺជាកាតព្វកិច្ចសំខាន់របស់សិស្ស ដែលជួយបង្កើនការយល់ដឹង និងរំលឹកមេរៀនដែលបានរៀននៅក្នុងថ្នាក់។ '
                  'តាមរយៈការធ្វើកិច្ចការផ្ទះ សិស្សអាចអនុវត្តចំណេះដឹង ធ្វើឲ្យមានវិន័យ និងបណ្តុះទម្លាប់ក្នុងការសិក្សាដោយខ្លួនឯង។ '
                  'ប្រសិនបើសិស្សធ្វើកិច្ចការផ្ទះទៀងទាត់ នឹងជួយឲ្យមានលទ្ធផលសិក្សាល្អ និងរីកចម្រើនទាំងចំណេះដឹង និងការទទួលខុសត្រូវ។',
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.6, // line spacing (good for Khmer)
                  ),
                  textAlign: TextAlign.justify,
                ),
          ],
        ),
      ),
    );
  }
  Widget fileUpload(){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
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
            ]
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("ឯកសារដែលបានជញ្ចូន",style: AppTextStyle.fontsize18,),
              SizedBox(height: 20,),
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
                        color: const Color.fromARGB(80, 244, 67, 54)
                      ),
                      child: Icon(Icons.picture_as_pdf,color: Colors.red,)),
                    SizedBox(width: 20,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("exercise_1.pdf",style: AppTextStyle.fontsize18,),
                        Text("2.4 MB .24-01-2026",style: AppTextStyle.hintText,)
                      ],
                    ),
                    Spacer(),
                    Icon(Icons.download)
                  ],
                ),
              ),
              SizedBox(height: 20,),
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
                        color: const Color.fromARGB(31, 33, 149, 243),
                        shape: BoxShape.circle
                      ),
                      child: Icon(Icons.image,color: AppColors.primaryMain,)),
                    SizedBox(width: 20,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("homework1.jpg",style: AppTextStyle.fontsize18,),
                        Text("2.4 MB .24-01-2026",style: AppTextStyle.hintText,)
                      ],
                    ),
                    Spacer(),
                    Icon(Icons.download)
                  ],
                ),
              )
            ],
          ),
      ),
    );
  }
  Widget teaComment(){
    return Padding(
      padding: const EdgeInsets.all(8.0),
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
          ]
        ),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.comment),
                SizedBox(width: 10,),
                Text("មតិយោបល់របស់គ្រូ",style: AppTextStyle.fontsize18,)
              ],
            ),
            SizedBox(height: 20,),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
              color: AppColors.teacomment,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppColors.comment
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 12,
                  ),
                ]
              ),
              child: Column(
                children: [
                  Text("ខិតខំប្រឹងប្រែងបន្តទៀត ការសិក្សាខែធ្វើបានល្អច្រើនហើយ\n សូមបន្តធ្វើអោយបានល្អបន្ថែមទៀតនៅខែក្រោយ",style: AppTextStyle.body,)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}