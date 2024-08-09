import 'package:flutter/material.dart';
import 'package:habbit_tracker_app/provider/theme_provider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var themeProviderTrue = Provider.of<ThemeProvider>(context);
    var themeProviderFalse = Provider.of<ThemeProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: GestureDetector(
              onTap: () {
                Provider.of<ThemeProvider>(context, listen: false)
                    .toggleTheme();
              },
              child: (themeProviderTrue.isDark)
                  ? Icon(
                      Icons.dark_mode,
                      color: Theme.of(context).colorScheme.inversePrimary,
                    )
                  : const Icon(Icons.sunny),
            ),
          ),
        ],
      ),
    );
  }
}
