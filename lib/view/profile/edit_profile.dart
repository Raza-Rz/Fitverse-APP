import 'package:flutter/material.dart';
import 'package:fitverse/utils/app_colors.dart';
import 'package:fitverse/common_widgets/round_gradient_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditProfileScreen extends StatefulWidget {
  static String routeName = "/EditProfileScreen";

  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  TextEditingController? fullNameController;
  TextEditingController? emailController;
  TextEditingController? weightController;
  TextEditingController? heightController;

  String? firstName;
  String? lastName;
  String? email;
  String? weight;
  String? height;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  Future<void> _initializeControllers() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        if (userDoc.exists) {
          final data = userDoc.data();
          setState(() {
            email = data?['email'];
            firstName = data?['firstName'];
            lastName = data?['lastName'];
            weight = data?['weight'];
            height = data?['height'];

            fullNameController = TextEditingController(text: '${firstName ?? ''} ${lastName ?? ''}');
            emailController = TextEditingController(text: email ?? '');
            weightController = TextEditingController(text: weight ?? '');
            heightController = TextEditingController(text: height ?? '');
          });
        }
      } catch (e) {
        // Handle potential errors here
        print('Error fetching user data: $e');
      }
    }
  }

  @override
  void dispose() {
    fullNameController?.dispose();
    emailController?.dispose();
    weightController?.dispose();
    heightController?.dispose();
    super.dispose();
  }

  void updateUserProfile() async {
    if (fullNameController?.text.isNotEmpty == true && emailController?.text.isNotEmpty == true) {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final nameParts = fullNameController?.text.split(' ') ?? [];
        final firstName = nameParts.length > 1 ? nameParts.first : '';
        final lastName = nameParts.length > 1 ? nameParts.last : fullNameController?.text ?? '';

        await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
          'firstName': firstName,
          'lastName': lastName,
          'weight': weightController?.text ?? '',
          'height': heightController?.text ?? '',
        });

        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile Updated Successfully')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
          'Edit Profile',
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
            const Stack(
              children: [
               CircleAvatar(
              radius: 50,
              backgroundColor: AppColors.primaryColor2, // Solid color background
              child: Icon(Icons.person, color: Colors.white, size: 40), // Placeholder icon
            ),
                // Positioned(
                //   bottom: 0,
                //   right: 0,
                //   child: CircleAvatar(
                //     backgroundColor: AppColors.primaryColor2,
                //     radius: 12,
                //     child: const Icon(Icons.edit, size: 16, color: Colors.white),
                //   ),
                // ),
              ],
            ),
            const SizedBox(height: 10),
            profileFormField('Full Name', fullNameController),
            profileFormField('Email', emailController, isReadOnly: true),
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

  Widget profileFormField(String label, TextEditingController? controller, {bool isReadOnly = false}) {
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
          readOnly: isReadOnly,
          decoration: InputDecoration(
            fillColor: Colors.grey[100],
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
