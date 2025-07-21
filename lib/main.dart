import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:think/Core/Models/book_model.dart';
import 'package:think/Features/Auth/view/register_screen.dart';
import 'package:think/Features/Rent/book_details_screen.dart';
import 'package:think/Features/Home/books/book_screen.dart';
import 'package:think/Features/Home/home_screen.dart';
import 'package:think/Features/Auth/view/login_screen.dart';
import 'package:think/Features/Profile/profile_screen.dart';
import 'package:think/Features/Splash/splash_screen.dart';
import 'package:think/Features/post/post_screen.dart';
import 'package:think/shared_prefs.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  SharedPrefs.prefs = await SharedPreferences.getInstance();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final String email = SharedPrefs.getEmail();
  final String password = SharedPrefs.getPassword();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primaryColor: const Color.fromARGB(255, 3, 19, 38),
          textTheme: const TextTheme(
              bodyLarge: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              bodySmall: TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              )),
          appBarTheme: const AppBarTheme(centerTitle: true)),
      debugShowCheckedModeBanner: false,
      initialRoute: SplashScreen.routeName,
      routes: {
        SplashScreen.routeName: (context) => const SplashScreen(),
        LoginScreen.routeName: (context) => LoginScreen(),
        HomeScreen.routeName: (context) => HomeScreen(),
        ProfileScreen.routeName: (context) => ProfileScreen(),
        RegisterScreen.routeName: (context) => RegisterScreen(),
        PostScreen.routeName: (context) => PostScreen(),
        BookScreen.routeName: (context) => BookScreen(),
      },
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case BookDetailsScreen.routeName:
            final Book book = settings.arguments as Book;
            return MaterialPageRoute(
              builder: (context) => BookDetailsScreen(book: book),
            );

          default:
            return null;
        }
      },
    );
  }
}
