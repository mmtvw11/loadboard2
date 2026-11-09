import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/theme/app_theme.dart';
import 'features/auth/presentation/auth_screen.dart';

class LoadBoardApp extends StatefulWidget {
  const LoadBoardApp({
    required this.preferences,
    required this.initialThemeMode,
    super.key,
  });

  final SharedPreferences preferences;
  final ThemeMode initialThemeMode;

  @override
  State<LoadBoardApp> createState() => _LoadBoardAppState();
}

class _LoadBoardAppState extends State<LoadBoardApp> {
  late ThemeMode _themeMode = widget.initialThemeMode;

  Future<void> _changeTheme(ThemeMode mode) async {
    setState(() => _themeMode = mode);
    await widget.preferences.setString('theme_mode', mode.name);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LoadBoard',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: _themeMode,
      home: AuthScreen(
        themeMode: _themeMode,
        onThemeChanged: _changeTheme,
      ),
    );
  }
}
