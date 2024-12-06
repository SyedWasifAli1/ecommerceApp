import 'package:ecommerce/screen/admin/categries/categories_view.dart';
import 'package:ecommerce/screen/admin/categries/pro.dart';
import 'package:ecommerce/screen/admin/categries/products.dart';
import 'package:ecommerce/screen/auth/SplashScreen.dart';
import 'package:ecommerce/screen/auth/forget_password.dart';
import 'package:ecommerce/screen/auth/mailer.dart';
import 'package:ecommerce/screen/auth/otp.dart';
import 'package:ecommerce/screen/home/categories_products.dart';
import 'package:ecommerce/screen/home/home_page.dart';
import 'package:ecommerce/screen/home/home_screen.dart';
import 'package:ecommerce/screen/home/profile_page.dart';
import 'package:ecommerce/screen/auth/login.dart';
import 'package:ecommerce/screen/auth/signup.dart';
import 'package:ecommerce/screen/home/widgets/demo_product_d.dart';
import 'package:ecommerce/screen/home/widgets/product_detail.dart';
import 'package:ecommerce/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:go_router/go_router.dart';  // Import go_router

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
        apiKey: "AIzaSyBeGl5FJE-ZkGeSJ2c_8BZZ67gXdTyLVeI",
        authDomain: "authwithfirebase-20a41.firebaseapp.com",
        databaseURL: "https://authwithfirebase-20a41-default-rtdb.firebaseio.com",
        projectId: "authwithfirebase-20a41",
        storageBucket: "authwithfirebase-20a41.appspot.com",
        messagingSenderId: "513334310836",
        appId: "1:513334310836:web:7090fa61046cd6f1dce4e1",
        measurementId: "G-11T09DTR7V"),
  );
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
   MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      routerConfig: _router, // Set the GoRouter configuration
    );
  }

  // Define GoRouter configuration
  final GoRouter _router = GoRouter(
    routes: [
      // Define named routes
      GoRoute(
        path: '/',
        builder: (context, state) => SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => LoginScreen(),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => SignUpScreen(),
      ),
      GoRoute(
        path: '/forgetpassword',
        builder: (context, state) => ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/otp',
        builder: (context, state) => OtpVerificationScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => HomeScreen(role: 'customers'),
      ),
      GoRoute(
        path: '/homeadmin',
        builder: (context, state) => HomeScreen(role: 'admin'),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => ProfilePage(),
      ),
      GoRoute(
        path: '/cate',
        builder: (context, state) => AddCategoryScreen(),
      ),
      GoRoute(
        path: '/products',
        builder: (context, state) => ProductsScreen(),
      ),
      // Dynamic path for product details
      GoRoute(
        path: '/product/:id', // Define path with dynamic parameter
        builder: (context, state) {
          final String productId = state.pathParameters['id']!; // Retrieve productId from the URL
          return ProductDetailPage(productId: productId); // Pass it to ProductDetailPage
        },
      ),
     GoRoute(
  path: '/category/:id', // Define path with dynamic parameter
  builder: (context, state) {
    final String categoryId = state.pathParameters['id']!; // Retrieve categoryId from the URL
    return CategoryDetailPage(categoryId: categoryId); // Pass categoryId to CategoryDetailPage
  },
),

    ],
  );
}
