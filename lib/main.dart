import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:user_pagination_app/core/router/app_router.dart';
import 'package:user_pagination_app/core/services/service_locator.dart';
import 'package:user_pagination_app/core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await initServiceLocator();
  runApp(const UserPaginationApp());
}

class UserPaginationApp extends StatelessWidget {
  const UserPaginationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'User Directory',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: AppRouter.router,
    );
  }
}
