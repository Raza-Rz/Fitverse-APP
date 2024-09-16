import 'package:flutter/material.dart';
import 'package:fitverse/utils/app_colors.dart';
import 'package:fitverse/common_widgets/round_gradient_button.dart';

// Define a UserProfile class to manage user data
class UserProfile {
  String fullName;
  String email;
  String mobileNumber;
  String dateOfBirth;
  String weight;
  String height;

  UserProfile({
    required this.fullName,
    required this.email,
    required this.mobileNumber,
    required this.dateOfBirth,
    required this.weight,
    required this.height,
  });
}

class EditProfileScreen extends StatefulWidget {
  static String routeName = "/EditProfileScreen";

  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  // Initialize user data
  final UserProfile userProfile = UserProfile(
    fullName: 'M.Anus',
    email: 'guestuser@gmail.com',
    mobileNumber: '+123 567 89000',
    dateOfBirth: '01 / 04 / 2000',
    weight: '75 Kg',
    height: '5.5 ft',
  );

  // Define controllers for the TextFields
  late TextEditingController fullNameController;
  late TextEditingController emailController;
  late TextEditingController mobileNumberController;
  late TextEditingController dateOfBirthController;
  late TextEditingController weightController;
  late TextEditingController heightController;

  @override
  void initState() {
    super.initState();

    // Initialize controllers with existing user data
    fullNameController = TextEditingController(text: userProfile.fullName);
    emailController = TextEditingController(text: userProfile.email);
    mobileNumberController = TextEditingController(text: userProfile.mobileNumber);
    dateOfBirthController = TextEditingController(text: userProfile.dateOfBirth);
    weightController = TextEditingController(text: userProfile.weight);
    heightController = TextEditingController(text: userProfile.height);
  }

  @override
  void dispose() {
    // Dispose controllers when not needed
    fullNameController.dispose();
    emailController.dispose();
    // mobileNumberController.dispose();
    // dateOfBirthController.dispose();
    weightController.dispose();
    heightController.dispose();
    super.dispose();
  }

  // Function to update the user profile
  void updateUserProfile() {
    setState(() {
      // Update the user profile with new values
      userProfile.fullName = fullNameController.text;
      userProfile.email = emailController.text;
      // userProfile.mobileNumber = mobileNumberController.text;
      // userProfile.dateOfBirth = dateOfBirthController.text;
      userProfile.weight = weightController.text;
      userProfile.height = heightController.text;
    });

    // Here you can add the code to persist the changes to a database or an API

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile Updated Successfully')),
    );

    // Navigate to another screen after updating
    // Navigator.pushNamed(context, DashboardScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.blackColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'My Profile',
          style: TextStyle(
            color: AppColors.blackColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Stack(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: AppColors.primaryColor1,
                  // Use an image for user profile picture if needed
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    backgroundColor: AppColors.primaryColor2,
                    radius: 12,
                    child: const Icon(Icons.edit, size: 16, color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Text(
              'M.Anus',
              style: TextStyle(
                color: AppColors.blackColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            profileFormField('Full name', fullNameController),
            profileFormField('Email', emailController),
            // profileFormField('Mobile Number', mobileNumberController),
            // profileFormField('Date of birth', dateOfBirthController),
            profileFormField('Weight', weightController),
            profileFormField('Height', heightController),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(13),
              child: RoundGradientButton(
                title: "Update Profile",
                onPressed: updateUserProfile,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget profileFormField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 15),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.blackColor,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 5),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            fillColor: const Color.fromARGB(255, 240, 240, 240),
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}
