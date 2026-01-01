
import 'package:flutter/material.dart';
import 'package:rentease/app/theme/app_theme.dart';
import 'package:rentease/screens/splash_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RENTEASE',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home:  SplashScreen(),
    );
  }
}