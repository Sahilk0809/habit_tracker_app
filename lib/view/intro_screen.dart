import 'package:flutter/material.dart';
import 'package:habbit_tracker_app/provider/skip_intro_screen.dart';
import 'package:habbit_tracker_app/view/home_screen.dart';
import 'package:provider/provider.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: height * 0.2,
            ),
            Container(
              height: height * 0.5,
              width: width,
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                color: Colors.blue[300],
                image: const DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                    'https://cdn.cdnparenting.com/articles/2019/01/21120025/1195922569-H.webp',
                  ),
                ),
              ),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'DO WHAT YOU\'VE LONGED FOR',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 35,
                        letterSpacing: 2,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    const Text(
                      'Set challenge for yourself and stop postponing your life for later.',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () {
                Provider.of<SkipIntroScreen>(context, listen: false).skipIntro();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const HomeScreen(),
                  ),
                );
              },
              child: Container(
                alignment: Alignment.center,
                height: height * 0.1,
                width: width,
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.black,
                ),
                child: const Text(
                  'LET\'S START',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
