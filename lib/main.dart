import 'package:ecommerce/screen/admin/categries/categories_view.dart';
import 'package:ecommerce/screen/auth/SplashScreen.dart';
import 'package:ecommerce/screen/auth/forget_password.dart';
import 'package:ecommerce/screen/auth/mailer.dart';
import 'package:ecommerce/screen/auth/otp.dart';
import 'package:ecommerce/screen/home/home_page.dart';
import 'package:ecommerce/screen/home/home_screen.dart';
import 'package:ecommerce/screen/home/profile_page.dart';
import 'package:ecommerce/screen/auth/login.dart';
import 'package:ecommerce/screen/auth/signup.dart';
import 'package:ecommerce/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyAVm_KPFmqRT0OQW_qidmlNUo1VF5J3fOM",
      authDomain: "ecommerce-e0c9c.firebaseapp.com",
      projectId: "ecommerce-e0c9c",
      storageBucket: "ecommerce-e0c9c.firebasestorage.app",
      messagingSenderId: "384803671736",
      appId: "1:384803671736:web:6fa253278a836181b0ee4d",
      measurementId: "G-BQ3S8J228Z",
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      // Define the initial route
      initialRoute: '/',
      // Define named routes
      routes: {
        '/': (context) => SplashScreen(),
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignUpScreen(),
        '/forgetpassword': (context) => ForgotPasswordScreen(),
        '/otp': (context) => OtpVerificationScreen(),
        '/home': (context) => HomeScreen(
              role: 'customers',
            ), // Set a default role for testing
        '/homeadmin': (context) => HomeScreen(
              role: 'admin',
            ), // Set a default role for testing
        '/profile': (context) => ProfilePage(),
        '/cate': (context) => CategoryListScreen(),
      },
    );
  }
}
