import 'package:firebase_core/firebase_core.dart';
import 'package:fitverse/routes.dart';
import 'package:fitverse/utils/app_colors.dart';
import 'package:fitverse/view/dashboard/dashboard_screen.dart';
import 'package:fitverse/view/login/login_screen.dart';
import 'package:fitverse/view/on_boarding/on_boarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Widget _initialScreen;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _determineInitialScreen();
  }

  Future<void> _determineInitialScreen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool seenOnboarding = prefs.getBool('seenOnboarding') ?? false;
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    // Decide which screen to show
    if (!seenOnboarding) {
      _initialScreen = const OnBoardingScreen();
    } else if (isLoggedIn) {
      _initialScreen = const LoaderScreen(); // Show loader before Dashboard
    } else {
      _initialScreen = const LoginScreen();
    }

    setState(() {
      _isLoading = false; // Loading complete
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      );
    }

    return MaterialApp(
      title: 'Fitverse',
      debugShowCheckedModeBanner: false,
      routes: routes,
      theme: ThemeData(
        primaryColor: AppColors.primaryColor1,
        scaffoldBackgroundColor: AppColors.whiteColor,
        useMaterial3: true,
        fontFamily: "Poppins",
      ),
      home: _initialScreen,
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

@override
Widget build(BuildContext context) {
  return Scaffold(
    body: SizedBox.expand(
      child: Image.asset(
        'assets/splash.png',
        fit: BoxFit.cover, // Ensures the image scales and covers the entire screen
      ),
    ),
  );
}
}

class LoaderScreen extends StatefulWidget {
  const LoaderScreen({Key? key}) : super(key: key);

  @override
  State<LoaderScreen> createState() => _LoaderScreenState();
}

class _LoaderScreenState extends State<LoaderScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToDashboard();
  }

  Future<void> _navigateToDashboard() async {
    // Ensure the loader is visible for at least 2 seconds
    await Future.delayed(const Duration(seconds: 2));
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const DashboardScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: AppColors.primaryColor1,
            ),
            const SizedBox(height: 20),
            const Text(
              "Loading Dashboard...",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
