import 'package:ecommerce/screen/home/home_screen.dart';
import 'package:ecommerce/screen/login.dart';
import 'package:ecommerce/theme/theme.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: Ecommercetheme.lightTheme,
      darkTheme: Ecommercetheme.darkTheme,
      home: HomeScreen(),
    );
  }
}
