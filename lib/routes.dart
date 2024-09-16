
import 'package:fitverse/view/activity_tracker/activity_tracker_screen.dart';
import 'package:fitverse/view/dashboard/dashboard_screen.dart';
import 'package:fitverse/view/finish_workout/finish_workout_screen.dart';
import 'package:fitverse/view/login/login_screen.dart';
import 'package:fitverse/view/notification/notification_screen.dart';
import 'package:fitverse/view/on_boarding/on_boarding_screen.dart';
import 'package:fitverse/view/on_boarding/start_screen.dart';
import 'package:fitverse/view/profile/complete_profile_screen.dart';
import 'package:fitverse/view/activity/workout_screen.dart';
import 'package:fitverse/view/signup/signup_screen.dart';
import 'package:fitverse/view/welcome/welcome_screen.dart';
import 'package:fitverse/view/workout_schedule_view/workout_schedule_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:fitverse/view/profile/edit_profile.dart';
// import 'package:fitverse/view/profile/user_profile.dart';
import 'package:fitverse/view/profile/profile_new.dart';
import 'package:flutter/material.dart';


final Map<String, WidgetBuilder> routes = {
  OnBoardingScreen.routeName: (context) => const OnBoardingScreen(),
  LoginScreen.routeName: (context) => const LoginScreen(),
  StartScreen.routeName: (context) => const StartScreen(),
  SignupScreen.routeName: (context) => const SignupScreen(),
  CompleteProfileScreen.routeName: (context) => const CompleteProfileScreen(),
  // YourGoalScreen.routeName: (context) => const YourGoalScreen(),
  WelcomeScreen.routeName: (context) => const WelcomeScreen(),
  EditProfileScreen.routeName: (context) => const EditProfileScreen(),
  // UserProfile.routeName: (context) => const UserProfile(),
  DashboardScreen.routeName: (context) => const DashboardScreen(),
  
  WorkoutScreen.routeName: (context) => const WorkoutScreen(),

  FinishWorkoutScreen.routeName: (context) => const FinishWorkoutScreen(),
  NotificationScreen.routeName: (context) => const NotificationScreen(),
  ActivityTrackerScreen.routeName: (context) => const ActivityTrackerScreen(),
  WorkoutScheduleView.routeName: (context) => const WorkoutScheduleView(),
  RefinedProfileScreen.routeName: (context) => const RefinedProfileScreen(),
};

// class AppRoutes {
//   static const String workoutScreen = '/workout';

//   static Map<String, WidgetBuilder> routes = {
//     workoutScreen: (context) => WorkoutScreen(),
//     // Add other routes here
//   };
// }