import 'package:fitverse/routes.dart';
import 'package:fitverse/view/activity/workout_screen.dart';
import 'package:fitverse/utils/app_colors.dart';
import 'package:fitverse/view/on_boarding/on_boarding_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fitness',
      debugShowCheckedModeBanner: false,
      routes: routes,
      theme: ThemeData(
        primaryColor: AppColors.primaryColor1,
        useMaterial3: true,
        fontFamily: "Poppins"
      ),
      home: OnBoardingScreen(),
    );
  }
}

