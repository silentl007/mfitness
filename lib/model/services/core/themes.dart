import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeClass {
  ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.dark);

  ThemeClass() {
    _loadTheme(); // Load saved theme on app launch
  }

  // Getter
  ThemeMode get theme => themeNotifier.value;

  // Setter
  set themeSetter(ThemeMode newTheme) {
    themeNotifier.value = newTheme;
    _saveTheme(newTheme); // Save theme preference
  }

  // Notifier Getter
  ValueNotifier<ThemeMode> get themeNotifierGetter => themeNotifier;

  // ThemeData
  ThemeData get lightMode => ThemeData(
        scaffoldBackgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        iconButtonTheme: const IconButtonThemeData(
          style: ButtonStyle(iconColor: WidgetStatePropertyAll(Colors.black)),
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.black),
          bodyMedium: TextStyle(color: Colors.black),
          bodySmall: TextStyle(color: Colors.black),
        ),
        // textTheme: const TextTheme(
        //   bodyLarge: TextStyle(fontFamily: 'Poppins', color: Colors.black),
        //   bodyMedium: TextStyle(fontFamily: 'Poppins', color: Colors.black),
        //   bodySmall: TextStyle(fontFamily: 'Poppins', color: Colors.black),
        // ),
      );

  ThemeData get darkMode => ThemeData(
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.black,
          iconTheme: const IconThemeData(color: Colors.white),
          titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        iconButtonTheme: const IconButtonThemeData(
          style: ButtonStyle(iconColor: WidgetStatePropertyAll(Colors.white)),
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
          bodySmall: TextStyle(color: Colors.white),
        ),
      );

  // Toggle Theme Function
  void toggleTheme() {
    themeNotifier.value = (themeNotifier.value == ThemeMode.light)
        ? ThemeMode.dark
        : ThemeMode.light;
    _saveTheme(themeNotifier.value);
  }

  // Get current ThemeData based on ThemeMode
  ThemeData get currentTheme =>
      themeNotifier.value == ThemeMode.light ? lightMode : darkMode;

  // Load Theme Preference
  Future<void> _loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedTheme = prefs.getString('theme_mode');

    if (savedTheme == 'dark') {
      themeNotifier.value = ThemeMode.dark;
    } else {
      themeNotifier.value = ThemeMode.light;
    }
  }

  // Save Theme Preference
  Future<void> _saveTheme(ThemeMode themeMode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        'theme_mode', themeMode == ThemeMode.dark ? 'dark' : 'light');
  }
}

// Global Instance
ThemeClass themeClass = ThemeClass();
