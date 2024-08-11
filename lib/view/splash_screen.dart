import 'dart:async';

import 'package:flutter/material.dart';
import 'package:habbit_tracker_app/view/home_screen.dart';
import 'package:habbit_tracker_app/view/intro_screen2.dart';
import 'package:lottie/lottie.dart';

import '../main.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Timer(
      const Duration(seconds: 3),
      () {
        if (isLogged) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const HomeScreen(),
            ),
          );
        } else {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const IntroScreen2(),
            ),
          );
        }
      },
    );
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage(
                'https://img.pikbest.com/wp/202406/jogging-cartoon-boy-in-the-mountains_9612154.jpg!sw800'),
          ),
        ),
        child: Container(
          color: Colors.black26,
          child: Column(
            children: [
              const SizedBox(
                height: 350,
              ),
              const Text(
                'Habit Tracker',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 40,
                ),
              ),
              SizedBox(
                width: 150,
                child: Lottie.asset(
                  'assets/lottie/Animation - 1723359488930.json',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
