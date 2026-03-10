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
      initialRoute: AppRoutes.roleSelectionScreen,
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}
