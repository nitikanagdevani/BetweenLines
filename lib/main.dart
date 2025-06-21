import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'database_helper.dart'; // ✅ Import your database helper

// Screens
import 'screens/GetStarted.dart';
import 'screens/login.dart';
import 'screens/signup.dart';
import 'screens/homepage.dart';
import 'screens/profile.dart';
import 'screens/EditProfile.dart';
import 'screens/News.dart';
import 'screens/Explore.dart';
import 'screens/Library.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // ✅ Initialize SQLite Database
  await DatabaseHelper.database;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BetweenLines',
      theme: ThemeData(
        primaryColor: Colors.brown,
      ),
      initialRoute: '/GetStarted',
      routes: {
        '/': (context) => const GetStarted(),
        '/GetStarted': (context) => const GetStarted(),
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignupPage(),
        '/homepage': (context) => HomePage(),
        '/profile': (context) => ProfilePage(),
        '/editProfile': (context) => EditProfilePage(),
        '/News': (context) => NewsPage(),
        '/Explore': (context) => ExplorePage(),
        '/Library': (context) => LibraryPage(),
      },
    );
  }
}
