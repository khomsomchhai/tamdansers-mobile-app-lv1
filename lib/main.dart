import 'package:flutter/material.dart';
import 'package:tamdansers_app/constants/app_colors.dart';
import 'package:tamdansers_app/routes/app_router.dart';
import 'package:tamdansers_app/routes/app_routes.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          scaffoldBackgroundColor: AppColors.backgroundLight,
          appBarTheme: AppBarTheme(
            backgroundColor: AppColors.backgroundLight,
            elevation: 0,
            surfaceTintColor: AppColors.transparent,
          )),
<<<<<<< HEAD
      initialRoute: AppRoutes.ParentsDashboard,
=======
      initialRoute: AppRoutes.roleSelectionScreen,
>>>>>>> 49aad77233a74a74050a7167d916392eebb526ac
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}
