import 'package:fitverse/view/welcome/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:fitverse/utils/app_colors.dart';
import '../../common_widgets/round_gradient_button.dart';
import '../../common_widgets/round_textfield.dart';

class CompleteProfileScreen extends StatefulWidget {
  static String routeName = "/CompleteProfileScreen";

  const CompleteProfileScreen({Key? key}) : super(key: key);

  @override
  _CompleteProfileScreenState createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  String? selectedGender;

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(right: 15, left: 15),
          child: Column(
            children: [
              Image.asset("assets/images/complete_profile.png", width: media.width),
              const SizedBox(height: 15),
              Text(
                "Let’s complete your profile",
                style: TextStyle(
                    color: AppColors.blackColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 5),
              Text(
                "It will help us to know more about you!",
                style: TextStyle(
                  color: AppColors.grayColor,
                  fontSize: 12,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 25),
              Container(
                decoration: BoxDecoration(
                    color: AppColors.lightGrayColor,
                    borderRadius: BorderRadius.circular(15)),
                child: Row(
                  children: [
                    Container(
                        alignment: Alignment.center,
                        width: 50,
                        height: 50,
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Image.asset(
                          "assets/icons/gender_icon.png",
                          width: 20,
                          height: 20,
                          fit: BoxFit.contain,
                          color: AppColors.grayColor,
                        )),
                    Expanded(
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedGender,
                          items: ["Male", "Female"].map((name) {
                            return DropdownMenuItem<String>(
                              value: name,
                              child: Text(
                                name,
                                style: TextStyle(
                                    color: AppColors.grayColor, fontSize: 14),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedGender = value;
                            });
                            print("Selected Gender: $value");
                          },
                          isExpanded: true,
                          hint: Text(
                            "Choose Gender",
                            style: TextStyle(
                                color: AppColors.grayColor, fontSize: 12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8)
                  ],
                ),
              ),
              const SizedBox(height: 15),
              const RoundTextField(
                hintText: "Date of Birth",
                icon: "assets/icons/calendar_icon.png",
                textInputType: TextInputType.text,
              ),
              const SizedBox(height: 15),
              const RoundTextField(
                hintText: "Your Weight",
                icon: "assets/icons/weight_icon.png",
                textInputType: TextInputType.text,
              ),
              const SizedBox(height: 15),
              const RoundTextField(
                hintText: "Your Height",
                icon: "assets/icons/swap_icon.png",
                textInputType: TextInputType.text,
              ),
              const SizedBox(height: 15),
              RoundGradientButton(
                title: "Next >",
                onPressed: () {
                  // Navigate to the next screen, e.g., YourGoalScreen
                  Navigator.pushNamed(context, WelcomeScreen.routeName);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
