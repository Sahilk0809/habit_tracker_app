import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class SkipIntroScreen extends ChangeNotifier{
  bool isSkip = false;

  Future<void> skipIntro() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    isSkip = true;
    sharedPreferences.setBool('skip', isSkip);
    print(isLogged);
    notifyListeners();
  }

  void getSkipIntro() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.getBool('skip') ?? false;
    print(isLogged);
  }

  SkipIntroScreen(bool isLogged){
    getSkipIntro();
    isLogged = isSkip;
    print(isLogged);
    notifyListeners();
  }
}