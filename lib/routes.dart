import 'package:fitverse/view/activity_tracker/activity_tracker_screen.dart';
import 'package:fitverse/view/dashboard/dashboard_screen.dart';
import 'package:fitverse/view/finish_workout/finish_workout_screen.dart';
import 'package:fitverse/view/login/forgot_screen.dart';
import 'package:fitverse/view/login/login_screen.dart';
import 'package:fitverse/view/notification/notification_screen.dart';
import 'package:fitverse/view/on_boarding/on_boarding_screen.dart';
import 'package:fitverse/view/on_boarding/start_screen.dart';
import 'package:fitverse/view/profile/complete_profile_screen.dart';
import 'package:fitverse/view/activity/workout_screen.dart';
import 'package:fitverse/view/signup/signup_screen.dart';
import 'package:fitverse/view/welcome/welcome_screen.dart';
import 'package:fitverse/view/workout_schedule_view/workout_schedule_view.dart';
import 'package:fitverse/view/profile/edit_profile.dart';
import 'package:fitverse/view/profile/profile_new.dart';
import 'package:flutter/material.dart';

final Map<String, WidgetBuilder> routes = {
  OnBoardingScreen.routeName: (context) => OnBoardingScreen(),
  LoginScreen.routeName: (context) => LoginScreen(),
  StartScreen.routeName: (context) => StartScreen(),
  SignupScreen.routeName: (context) => SignupScreen(),
  CompleteProfileScreen.routeName: (context) => CompleteProfileScreen(),
  WelcomeScreen.routeName: (context) => WelcomeScreen(),
  EditProfileScreen.routeName: (context) => EditProfileScreen(),
  DashboardScreen.routeName: (context) => DashboardScreen(),
  WorkoutScreen.routeName: (context) => WorkoutScreen(),
  ForgotPasswordScreen.routeName: (context) => ForgotPasswordScreen(),
  FinishWorkoutScreen.routeName: (context) => FinishWorkoutScreen(),
  NotificationScreen.routeName: (context) => NotificationScreen(),
  ActivityTrackerScreen.routeName: (context) => ActivityTrackerScreen(),
  WorkoutScheduleView.routeName: (context) => WorkoutScheduleView(),
  RefinedProfileScreen.routeName: (context) => RefinedProfileScreen(),
};
