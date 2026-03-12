import 'package:flutter/material.dart';
import 'package:tamdansers_app/constants/app_colors.dart';
import 'package:tamdansers_app/constants/app_number.dart';
import 'package:tamdansers_app/constants/text_style.dart';
import 'package:tamdansers_app/routes/app_router.dart';
import 'package:tamdansers_app/screens/student/menu/attendance.dart';
import 'package:tamdansers_app/screens/student/menu/homepage.dart';
import 'package:tamdansers_app/screens/student/menu/homework.dart';
import 'package:tamdansers_app/screens/student/menu/profile.dart';

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({super.key});

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  int _index = 0;

  final List<GlobalKey<NavigatorState>> _navKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  static const _tabs = [
    _NavItem(
      icon: Icons.home_outlined,
      activeIcon: Icons.home_rounded,
      label: 'ទំព័រដើម',
    ),
    _NavItem(
      icon: Icons.assignment_outlined,
      activeIcon: Icons.assignment_rounded,
      label: 'កិច្ចការផ្ទះ',
    ),
    _NavItem(
      icon: Icons.check_circle_outline,
      activeIcon: Icons.check_circle,
      label: 'វត្តមាន',
    ),
    _NavItem(
      icon: Icons.person_outline_rounded,
      activeIcon: Icons.person_rounded,
      label: 'ប្រវត្តិរូប',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        final nav = _navKeys[_index].currentState;
        if (nav != null && nav.canPop()) nav.pop();
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundLight,
        bottomNavigationBar: _StudentBottomNav(
          currentIndex: _index,
          tabs: _tabs,
          onTap: (i) {
            if (i == _index) {
              _navKeys[i].currentState?.popUntil((r) => r.isFirst);
              return;
            }
            setState(() => _index = i);
          },
        ),
        body: IndexedStack(
          index: _index,
          children: List.generate(
            _tabs.length,
            (i) => Navigator(
              key: _navKeys[i],
              onGenerateRoute: (settings) {
                if (settings.name == Navigator.defaultRouteName) {
                  return MaterialPageRoute(
                    builder: (_) {
                      if (i == 0) {
                        return const Homepage();
                      } else if (i == 1) {
                        return const Homework();
                      } else if (i == 2) {
                        return const Attendance();
                      } else {
                        return const Profile();
                      }
                    },
                    settings: settings,
                  );
                }
                return AppRouter.generateRoute(settings);
              },
            ),
          ),
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// DATA MODEL
////////////////////////////////////////////////////////////

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

////////////////////////////////////////////////////////////
/// CUSTOM BOTTOM NAV
////////////////////////////////////////////////////////////

class _StudentBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<_NavItem> tabs;

  const _StudentBottomNav({
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

////////////////////////////////////////////////////////////
/// SINGLE TAB ITEM
////////////////////////////////////////////////////////////

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
                borderRadius: BorderRadius.circular(
                  AppNumber.radiusPill,
                ),
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
              child: Text(
                item.label,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
