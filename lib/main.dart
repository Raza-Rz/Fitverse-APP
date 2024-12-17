import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  Widget _initialScreen = const SplashScreen(); // Default to SplashScreen

  @override
  void initState() {
    super.initState();
    _determineInitialScreen();
  }

  Future<void> _determineInitialScreen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool seenOnboarding = prefs.getBool('seenOnboarding') ?? false;
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (!seenOnboarding) {
      _initialScreen = const OnBoardingScreen();
    } else if (isLoggedIn) {
      _initialScreen = const DashboardLoader();
    } else {
      _initialScreen = const LoginScreen();
    }

    // Trigger a rebuild after determining the correct screen
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
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
      home: _initialScreen, // Directly show the determined screen
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

class DashboardLoader extends StatefulWidget {
  const DashboardLoader({Key? key}) : super(key: key);

  @override
  State<DashboardLoader> createState() => _DashboardLoaderState();
}

class _DashboardLoaderState extends State<DashboardLoader> {
  @override
  void initState() {
    super.initState();
    _autoLogin();
  }

  Future<void> _autoLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedEmail = prefs.getString('email');
    String? savedPassword = prefs.getString('password');
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn && savedEmail != null && savedPassword != null) {
      try {
        // Attempt to sign in with Firebase
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: savedEmail,
          password: savedPassword,
        );

        _navigateToScreen(const DashboardScreen());
      } catch (e) {
        print('Auto-login failed: $e');
        _navigateToScreen(const LoginScreen());
      }
    } else {
      _navigateToScreen(const LoginScreen());
    }
  }

  void _navigateToScreen(Widget screen) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
