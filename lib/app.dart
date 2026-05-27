import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'config/app_theme.dart';
import 'config/app_routes.dart';
import 'providers/theme_provider.dart';

class ZuhaApp extends StatelessWidget {
  const ZuhaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Zuha',
          debugShowCheckedModeBanner: false,
          theme: ZTheme.lightTheme,
          darkTheme: ZTheme.darkTheme,
          themeMode: themeProvider.themeMode,
          initialRoute: AppRoutes.splash,
          routes: AppRoutes.routes,
        );
      },
    );
  }
}
