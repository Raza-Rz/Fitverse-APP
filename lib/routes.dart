
import 'package:fitverse/view/dashboard/dashboard_screen.dart';

import 'package:fitverse/view/login/forgot_screen.dart';
import 'package:fitverse/view/login/login_screen.dart';

import 'package:fitverse/view/on_boarding/on_boarding_screen.dart';
import 'package:fitverse/view/on_boarding/start_screen.dart';
import 'package:fitverse/view/profile/complete_profile_screen.dart';
import 'package:fitverse/view/signup/email_verification.dart';

import 'package:fitverse/view/signup/signup_screen.dart';
import 'package:fitverse/view/welcome/welcome_screen.dart';

import 'package:fitverse/view/profile/edit_profile.dart';
import 'package:fitverse/view/profile/profile_new.dart';
import 'package:flutter/material.dart';

final Map<String, WidgetBuilder> routes = {
  OnBoardingScreen.routeName: (context) => const OnBoardingScreen(),
  LoginScreen.routeName: (context) => const LoginScreen(),
  StartScreen.routeName: (context) => const StartScreen(),
  SignupScreen.routeName: (context) => const SignupScreen(),
  CompleteProfileScreen.routeName: (context) => const CompleteProfileScreen(),
  WelcomeScreen.routeName: (context) => const WelcomeScreen(),
  EditProfileScreen.routeName: (context) => const EditProfileScreen(),
  DashboardScreen.routeName: (context) => const DashboardScreen(),
  
  ForgotPasswordScreen.routeName: (context) => ForgotPasswordScreen(),

  RefinedProfileScreen.routeName: (context) => const RefinedProfileScreen(),
  RefinedProfileScreen.routeName: (context) => const RefinedProfileScreen(),
  EmailVerificationScreen.routeName: (context) => const EmailVerificationScreen(),
};
