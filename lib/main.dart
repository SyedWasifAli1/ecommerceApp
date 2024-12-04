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
import 'package:ecommerce/screen/home/widgets/product_d.dart';
import 'package:ecommerce/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
        apiKey: "AIzaSyBeGl5FJE-ZkGeSJ2c_8BZZ67gXdTyLVeI",
        authDomain: "authwithfirebase-20a41.firebaseapp.com",
        databaseURL:
            "https://authwithfirebase-20a41-default-rtdb.firebaseio.com",
        projectId: "authwithfirebase-20a41",
        storageBucket: "authwithfirebase-20a41.appspot.com",
        messagingSenderId: "513334310836",
        appId: "1:513334310836:web:7090fa61046cd6f1dce4e1",
        measurementId: "G-11T09DTR7V"),
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
        // '/pd': (context) => ProductDetailScreen(),
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
