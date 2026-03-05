import 'package:flutter/material.dart';
import 'package:tamdansers_app/constants/app_colors.dart';
import 'package:tamdansers_app/constants/app_number.dart';
import 'package:tamdansers_app/constants/text_style.dart';
import 'package:tamdansers_app/repositories/user_repo.dart';
import 'package:tamdansers_app/screens/teacher/homework_screen.dart';
import 'package:tamdansers_app/screens/teacher/manage_all_class.dart';
import 'package:tamdansers_app/screens/teacher/teacher_dashboard.dart';
import 'package:tamdansers_app/screens/teacher/teacher_profile_screen.dart';

class TeacherMainScreen extends StatefulWidget {
  final int userId;
  const TeacherMainScreen({super.key, required this.userId});

  @override
  State<TeacherMainScreen> createState() => _TeacherMainScreenState();
}

class _TeacherMainScreenState extends State<TeacherMainScreen> {
  int _index = 0;
  Map<String, dynamic>? _teacher;
  bool _loading = true;

  static const _tabs = [
    _NavItem(
      icon: Icons.home_outlined,
      activeIcon: Icons.home_rounded,
      label: 'ទំព័រដើម',
    ),
    _NavItem(
      icon: Icons.class_outlined,
      activeIcon: Icons.class_rounded,
      label: 'ថ្នាក់',
    ),
    _NavItem(
      icon: Icons.assignment_outlined,
      activeIcon: Icons.assignment_rounded,
      label: 'កិច្ចការ',
    ),
    _NavItem(
      icon: Icons.person_outline_rounded,
      activeIcon: Icons.person_rounded,
      label: 'ប្រវត្តិរូប',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadTeacherData();
  }

  Future<void> _loadTeacherData() async {
    final teacher = await UserRepo().getUserById(widget.userId);
    if (mounted) {
      setState(() {
        _teacher = teacher;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        backgroundColor: AppColors.backgroundLight,
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      extendBody: true,
      bottomNavigationBar: _TeacherBottomNav(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        tabs: _tabs,
      ),
      body: IndexedStack(
        index: _index,
        children: [
          TeacherDashboard(),
          ManageAllClass(showBackButton: false),
          HomeworkScreen(showBackButton: false),
          TeacherProfileScreen(),
        ],
      ),
    );
  }
}

// ─── Data model ──────────────────────────────────────────────────────────────

class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}

// ─── Custom bottom nav bar ────────────────────────────────────────────────────

class _TeacherBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<_NavItem> tabs;

  const _TeacherBottomNav({
    required this.currentIndex,
    required this.onTap,
    required this.tabs,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppNumber.radiusRounded),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryMain.withValues(alpha: 0.12),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppNumber.screenPadding,
            vertical: 10,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(
              tabs.length,
              (i) => _NavTabItem(
                item: tabs[i],
                isActive: currentIndex == i,
                onTap: () => onTap(i),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Single tab item ──────────────────────────────────────────────────────────

class _NavTabItem extends StatelessWidget {
  final _NavItem item;
  final bool isActive;
  final VoidCallback onTap;

  const _NavTabItem({
    required this.item,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 72,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              width: isActive ? 52 : 40,
              height: 36,
              decoration: BoxDecoration(
                color: isActive
                    ? AppColors.primaryMain.withValues(alpha: 0.12)
                    : AppColors.transparent,
                borderRadius: BorderRadius.circular(AppNumber.radiusPill),
              ),
              child: Icon(
                isActive ? item.activeIcon : item.icon,
                size: 24,
                color:
                    isActive ? AppColors.primaryMain : AppColors.secondaryText,
              ),
            ),
            const SizedBox(height: 4),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: isActive
                  ? AppTextStyle.caption12Secondary.copyWith(
                      color: AppColors.primaryMain,
                      fontWeight: FontWeight.w700,
                    )
                  : AppTextStyle.caption12Secondary,
              child: Text(item.label, maxLines: 1),
            ),
          ],
        ),
      ),
    );
  }
}
