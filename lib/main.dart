import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final preferences = await SharedPreferences.getInstance();
  final themeMode = preferences.getString('theme_mode') == 'dark'
      ? ThemeMode.dark
      : ThemeMode.light;

  runApp(
    LoadBoardApp(
      preferences: preferences,
      initialThemeMode: themeMode,
    ),
  );
}
