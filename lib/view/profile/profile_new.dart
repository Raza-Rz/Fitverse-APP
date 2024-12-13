import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitverse/utils/app_colors.dart';
import 'package:fitverse/view/dashboard/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:fitverse/view/profile/edit_profile.dart';
import '../login/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RefinedProfileScreen extends StatelessWidget {
  static String routeName = "/RefinedProfileScreen";

  const RefinedProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Gradient background for the upper body
          Container(
            height: 250,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  AppColors.primaryColor1,
                  AppColors.primaryColor2,
                ],
              ),
            ),
          ),
          Column(
            children: [
              // Upper body with gradient and AppBar
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      AppColors.primaryColor1,
                      AppColors.primaryColor2,
                    ],
                  ),
                ),
                child: Column(
                  children: [
                    // AppBar content
                      SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
                        child: Row(
                          children: [
                            // Remove the back button or replace it with SizedBox for spacing
                            const SizedBox(width: 48), // Keeps the layout aligned
                            const Expanded(
                              child: Center(
                                child: Text(
                                  'My Profile',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 48), // To balance spacing on the right
                          ],
                        ),
                      ),
                    ),

                    // Profile header content
                    FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('users')
                          .doc(user?.uid)
                          .get(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}'));
                        }

                        if (!snapshot.hasData || !snapshot.data!.exists) {
                          return const Center(child: Text('No user data found.'));
                        }

                        final userData = snapshot.data!.data() as Map<String, dynamic>;
                        final firstName = userData['firstName'] ?? 'User';
                        final lastName = userData['lastName'] ?? '';

                        return Container(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Column(
                            children: [
                              const CircleAvatar(
                                radius: 50,
                                backgroundColor: Colors.white, // Solid color background
                                child: Icon(Icons.person, color: AppColors.primaryColor2, size: 40), // Placeholder icon
                              ),
                              const SizedBox(height: 10),
                              Text(
                                '$firstName $lastName',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Text(
                                "Lose a Fat Program",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Expanded(
                child: Container(
                  transform: Matrix4.translationValues(0.0, -50.0, 0.0),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(30),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: menuList(context),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget menuList(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          menuItem(Icons.person, 'Edit Profile', () {
            Navigator.pushNamed(context, EditProfileScreen.routeName);
          }),
          // menuItem(Icons.star, 'Favorite', () {
          //   Navigator.pushNamed(context, 'WorkoutScreen.routeName');
          // }),
          // menuItem(Icons.privacy_tip, 'Privacy Policy', () {
          //   Navigator.pushNamed(context, '/privacy');
          // }),
          // menuItem(Icons.settings, 'Settings', () {
          //   Navigator.pushNamed(context, '/settings');
          // }),
          // menuItem(Icons.help, 'Help', () {
          //   Navigator.pushNamed(context, '/help');
          // }),
          menuItem(Icons.logout, 'Logout', () async {
            await _logout(context); // Logout and clear preferences
          }),
        ],
      ),
    );
  }

  Widget menuItem(IconData icon, String title, VoidCallback onTap) {
    return Card(
      color: Colors.white,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.primaryColor2,
          child: Icon(icon, color: Colors.white),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, color: Color.fromARGB(255, 204, 204, 204)),
        onTap: onTap,
      ),
    );
  }

  Future<void> _logout(BuildContext context) async {
    // Sign out from Firebase
    await FirebaseAuth.instance.signOut();
    
    // Clear saved credentials from SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('email');
    await prefs.remove('password');
    await prefs.setBool('remember_me', false);
    await prefs.setBool('isLoggedIn', false); // Clear login status

    // Navigate to Login Screen
    Navigator.pushReplacementNamed(context, LoginScreen.routeName);
  }
}