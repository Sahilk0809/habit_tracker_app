import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  colorScheme: ColorScheme.light(
    surface: Colors.grey[300]!,
    primary: Colors.grey[500]!,
    secondary: Colors.grey[200]!,
    tertiary: Colors.white,
    inversePrimary: Colors.grey[900],
  ),
);

ThemeData darkMode = ThemeData(
  colorScheme: ColorScheme.light(
    surface: Colors.grey[900]!,
    primary: Colors.grey[600]!,
    secondary: Colors.grey[700]!,
    tertiary: Colors.grey[800],
    inversePrimary: Colors.grey[300],
  ),
);

class ThemeProvider extends ChangeNotifier{
  ThemeData _themeData = lightMode;

  ThemeData get themeData => _themeData;

  bool get isDark => _themeData == darkMode;

  set themeData(ThemeData themeData){
    _themeData = themeData;
    notifyListeners();
  }

  void toggleTheme(){
    if(_themeData == lightMode){
      themeData = darkMode;
    }
    else{
      themeData = lightMode;
    }
  }
}