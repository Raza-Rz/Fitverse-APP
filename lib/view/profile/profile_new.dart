import 'package:fitverse/utils/app_colors.dart';
import 'package:fitverse/view/activity/workout_screen.dart';
import 'package:fitverse/view/dashboard/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:fitverse/view/profile/edit_profile.dart';
import '../login/login_screen.dart';
class RefinedProfileScreen extends StatelessWidget {
  static String routeName = "/RefinedProfileScreen";

  const RefinedProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // Set background color to white
      body: Stack(
        children: [
          // Gradient background for the upper body
          Container(
            height: 250,  // Adjust height to cover only upper part
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
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_back, color: Colors.white), // Back button color
                              onPressed: () => Navigator.pushNamed(context, DashboardScreen.routeName),
                            ),
                            const Expanded(
                              child: Center(
                                child: Text(
                                  'My Profile',
                                  style: TextStyle(
                                    color: Colors.white, // Title text color
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 48), // Placeholder to align title center
                          ],
                        ),
                      ),
                    ),
                    // Profile header content
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.white,
                            backgroundImage: AssetImage('assets/images/profile.jpg'), // Profile picture
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Anus',
                            style: TextStyle(
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
                          // Padding(
                          //   padding: const EdgeInsets.symmetric(horizontal: 0),
                          //   child: Row(
                          //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          //     children: [
                          //       // infoCard('Lose Fat Program', ''),
                          //       // infoCard('28', 'Years Old'),
                          //       // infoCard('5.5ft', 'Height'),
                          //     ],
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              // Lower body section with white background and rounded upper corners
              Expanded(
                
                child: Container(
                  transform: Matrix4.translationValues(0.0, -50.0, 0.0),
                  // padding: const EdgeInsets.symmetric(horizontal: 20),
                  // margin: const EdgeInsets.only(top: -5),
                  decoration: const BoxDecoration(
                    
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(30), // Rounded upper corners
                    ),
                    boxShadow: [
                      // Shadow to create depth and separation effect
                      // BoxShadow(
                      //   color: Colors.black12,
                      //   spreadRadius: 2,
                      //   blurRadius: 10,
                      // ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0), // Added padding for spacing
                      child: menuList(context), // Pass context to menuList
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

  Widget infoCard(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white, // Text color
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white60, // Subtext color
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget menuList(BuildContext context) { // Accept context parameter
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          menuItem(Icons.person, 'Profile', () {
            Navigator.pushNamed(context, EditProfileScreen.routeName);
          }),
          menuItem(Icons.star, 'Favorite', () {
            // Example of navigation
           Navigator.pushNamed(context, WorkoutScreen.routeName);

          }),
          menuItem(Icons.privacy_tip, 'Privacy Policy', () {
            Navigator.pushNamed(context, '/privacy');
          }),
          menuItem(Icons.settings, 'Settings', () {
            Navigator.pushNamed(context, '/settings');
          }),
          menuItem(Icons.help, 'Help', () {
            Navigator.pushNamed(context, '/help');
          }),
          menuItem(Icons.logout, 'Logout', () {
            Navigator.pushNamed(context, LoginScreen.routeName);
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
          backgroundColor: AppColors.primaryColor1, // Purple background for icon
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
        onTap: onTap, // Call the onTap callback
      ),
    );
  }
}
