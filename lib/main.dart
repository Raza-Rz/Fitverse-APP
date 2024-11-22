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

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  Future<Map<String, bool>> _getInitialScreenPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool seenOnboarding = prefs.getBool('seenOnboarding') ?? false;
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    return {
      "seenOnboarding": seenOnboarding,
      "isLoggedIn": isLoggedIn,
    };
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, bool>>(
      future: _getInitialScreenPreferences(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: SplashScreen(),
          );
        }

        if (snapshot.hasData) {
          bool seenOnboarding = snapshot.data!['seenOnboarding']!;
          bool isLoggedIn = snapshot.data!['isLoggedIn']!;

          return MaterialApp(
            title: 'FitVerse',
            debugShowCheckedModeBanner: false,
            routes: routes,
            theme: ThemeData(
              primaryColor: AppColors.primaryColor1,
              scaffoldBackgroundColor: AppColors.whiteColor,
              useMaterial3: true,
              fontFamily: "Poppins",
            ),
            home: !seenOnboarding
                ? const OnBoardingScreen()
                : isLoggedIn
                    ? const DashboardScreen()
                    : const LoginScreen(),
          );
        }

        // In case of an error, show a fallback screen
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            body: Center(
              child: Text("Error loading app preferences."),
            ),
          ),
        );
      },
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Center(
        child: Image.asset(
          'assets/images/splash_logo.png',
          width: 200,
          height: 200,
        ),
      ),
    );
  }
}
