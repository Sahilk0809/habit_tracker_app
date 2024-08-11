import 'package:flutter/material.dart';
import 'package:habbit_tracker_app/database/habit_database.dart';
import 'package:habbit_tracker_app/provider/skip_intro_screen.dart';
import 'package:habbit_tracker_app/provider/theme_provider.dart';
import 'package:habbit_tracker_app/view/intro_screen.dart';
import 'package:habbit_tracker_app/view/intro_screen2.dart';
import 'package:habbit_tracker_app/view/splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'view/home_screen.dart';

bool isLogged = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

  //initialize database

  await HabitDatabase.initialize();
  await HabitDatabase().saveFirstLaunchDate();
  isLogged = sharedPreferences.getBool('skip') ?? false;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => HabitDatabase(),
        ),
        ChangeNotifierProvider(
          create: (context) => ThemeProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => SkipIntroScreen(isLogged),
        ),
      ],
      builder: (context, child) => const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    var skipIntro = Provider.of<SkipIntroScreen>(context, listen: true);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}
