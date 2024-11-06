import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fitverse/common_widgets/round_gradient_button.dart';
import 'package:fitverse/view/profile/complete_profile_screen.dart';

class EmailVerificationScreen extends StatefulWidget {
  static String routeName = "/emailVerification";

  const EmailVerificationScreen({Key? key}) : super(key: key);

  @override
  _EmailVerificationScreenState createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  User? user;
  bool isLoading = false;
  
  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;

    // Send verification email if the user isn't already verified
    if (user != null && !user!.emailVerified) {
      user!.sendEmailVerification();
    }
  }

  Future<void> _checkEmailVerified() async {
    setState(() {
      isLoading = true; // Show loading indicator while checking
    });
    
    try {
      await Future.delayed(const Duration(seconds: 2)); // Add delay to ensure Firebase updates
      await user!.reload(); // Reload user to update verification status
      user = FirebaseAuth.instance.currentUser; // Get the updated user instance
      bool isEmailVerified = user!.emailVerified; // Check verification status

      if (isEmailVerified) {
        // Navigate to the Complete Profile screen if verified
        Navigator.pushReplacementNamed(context, CompleteProfileScreen.routeName);
      } else {
        // Show a message if the email is not verified
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Please verify your email before continuing."),
          ),
        );
      }
    } catch (e) {
      print('Error checking email verification: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    } finally {
      setState(() {
        isLoading = false; // Hide loading indicator after check
      });
    }
  }

  Future<void> _resendVerificationEmail() async {
    try {
      await user!.sendEmailVerification();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Verification email resent."),
        ),
      );
    } catch (e) {
      print('Error resending email verification: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Verify Email"),
      ),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "A verification link has been sent to your email address. Please click the link to verify your email.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 20),
                    RoundGradientButton(
                      title: "Continue",
                      onPressed: _checkEmailVerified,
                    ),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: _resendVerificationEmail,
                      child: const Text("Resend Verification Email"),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}