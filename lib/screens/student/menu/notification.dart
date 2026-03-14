import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tamdansers_app/constants/app_colors.dart';
import 'package:tamdansers_app/constants/text_style.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  List<bool> isOn = [false, false, false, false, false];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ការជូនដំណឹង', style: AppTextStyle.sectionTitle20),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ការជូនដំណឹងទូទៅ',
                style: AppTextStyle.body.copyWith(fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: AppColors.white,
                border: Border.all(color: AppColors.white, width: 1),
              ),
              child: Column(
                children: [
                  _buildNotificationCard(
                    icon: Icons.book,
                    iconColor: AppColors.primaryMain,
                    bgColor: AppColors.primaryBg,
                    title: 'រំលឹកកិច្ចការផ្ទះ',
                    value: isOn[0],
                    onChanged: (value) {
                      setState(() {
                        isOn[0] = value;
                      });
                    },
                  ),
                  _buildNotificationCard(
                    icon: Icons.score,
                    iconColor: AppColors.pepure,
                    bgColor: AppColors.lightPink,
                    title: 'ដំណឹងពិន្ទុ',
                    value: isOn[1],
                    onChanged: (value) {
                      setState(() {
                        isOn[1] = value;
                      });
                    },
                  ),
                  _buildNotificationCard(
                    icon: Icons.person_2,
                    iconColor: AppColors.success,
                    bgColor: AppColors.successBG,
                    title: 'ដំណឹងវត្តមាន',
                    value: isOn[2],
                    onChanged: (value) {
                      setState(() {
                        isOn[2] = value;
                      });
                    },
                  ),
                  _buildNotificationCard(
                    icon: Icons.school,
                    iconColor: AppColors.orange,
                    bgColor: const Color.fromARGB(41, 252, 170, 88),
                    title: 'ព័ត៌មានសាលា',
                    value: isOn[3],
                    onChanged: (value) {
                      setState(() {
                        isOn[3] = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text('ការកំណត់ដំណឹងទូទៅ',
                style: AppTextStyle.body.copyWith(fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.white, width: 1),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.errorBG,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(
                          Icons.notifications_off_sharp,
                          color: AppColors.error,
                        ),
                      ),
                      SizedBox(width: 10),
                      Text('ស្ងាត់',
                          style: AppTextStyle.body
                              .copyWith(fontWeight: FontWeight.bold)),
                      Spacer(),
                      CupertinoSwitch(
                        activeTrackColor: AppColors.primaryMain,
                        value: isOn[4],
                        onChanged: (value) {
                          setState(() {
                            isOn[4] = value;
                          });
                        },
                      )
                    ],
                  ),
                  SizedBox(height: 30),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('ចាប់ផ្តើម', style: AppTextStyle.body),
                            SizedBox(height: 5),
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    color: AppColors.primary300, width: 1),
                              ),
                              child: Row(
                                children: [
                                  Text('10:00 AM',
                                      style: AppTextStyle.body.copyWith(
                                          fontWeight: FontWeight.bold)),
                                  Spacer(),
                                  Icon(Icons.watch_later_outlined,
                                      color: AppColors.primaryMain)
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(width: 30),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('បញ្ចប់', style: AppTextStyle.body),
                            SizedBox(height: 5),
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    color: AppColors.primary300, width: 1),
                              ),
                              child: Row(
                                children: [
                                  Text('11:00 AM',
                                      style: AppTextStyle.body.copyWith(
                                          fontWeight: FontWeight.bold)),
                                  Spacer(),
                                  Icon(Icons.watch_later_outlined,
                                      color: AppColors.primaryMain)
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text(
                    'រាល់ការជូនដំណឹងនឹងត្រូវបិទសំឡេងក្នុងកំឡុងពេលនេះ',
                    style: AppTextStyle.body14,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationCard({
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required String title,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: bgColor,
        child: Icon(icon, color: iconColor),
      ),
      title: Text(title, style: AppTextStyle.fontsize18),
      trailing: CupertinoSwitch(
        activeTrackColor: AppColors.success,
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}
