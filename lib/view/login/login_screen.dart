import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitverse/utils/app_colors.dart';
import 'package:fitverse/view/dashboard/dashboard_screen.dart';
import 'package:fitverse/view/signup/signup_screen.dart';
import 'package:fitverse/view/login/forgot_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../common_widgets/round_gradient_button.dart';
import '../../common_widgets/round_textfield.dart';

class LoginScreen extends StatefulWidget {
  static String routeName = "/LoginScreen";
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  bool _rememberMe = false; // Remember Me state
  final RegExp passwordRegExp = RegExp(r'^(?=.*[A-Z])(?=.*\d)[A-Za-z\d]{8,}$');

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials(); // Load saved credentials if any
  }

  // Load saved email and password from SharedPreferences
  Future<void> _loadSavedCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedEmail = prefs.getString('email');
    String? savedPassword = prefs.getString('password');
    bool? savedRememberMe = prefs.getBool('remember_me') ?? false;

    if (savedRememberMe) {
      setState(() {
        _emailController.text = savedEmail ?? '';
        _passwordController.text = savedPassword ?? '';
        _rememberMe = savedRememberMe;
      });
    }
  }

  // Save email and password to SharedPreferences
  Future<void> _saveCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (_rememberMe) {
      await prefs.setString('email', _emailController.text);
      await prefs.setString('password', _passwordController.text);
      await prefs.setBool('remember_me', _rememberMe);
    } else {
      await prefs.remove('email');
      await prefs.remove('password');
      await prefs.setBool('remember_me', false);
    }
  }

  // Method to handle Firebase login
  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true; // Show loading overlay
      });

      await Future.delayed(const Duration(seconds: 2)); // Add 2-second delay

      String email = _emailController.text.trim();
      String password = _passwordController.text.trim();

      try {
        // Authenticate user with Firebase
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Save credentials if "Remember Me" is checked
        await _saveCredentials();

        // Navigate to the dashboard on successful login
        // ignore: use_build_context_synchronously
        Navigator.pushNamed(context, DashboardScreen.routeName);
      } on FirebaseAuthException catch (e) {
        // Show error message if login fails
        String errorMessage;
        if (e.code == 'user-not-found') {
          errorMessage = 'No user found for that email.';
        } else if (e.code == 'wrong-password') {
          errorMessage = 'Wrong password provided for that user.';
        } else {
          errorMessage = 'No user found for that email, please Register';
        }

        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      } finally {
        setState(() {
          _isLoading = false; // Hide loading overlay
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 135, horizontal: 25),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(
                        width: media.width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: media.width * 0.03,
                            ),
                            const Text(
                              "Hey there,",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors.blackColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            SizedBox(height: media.width * 0.01),
                            const Text(
                              "Welcome Back",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors.blackColor,
                                fontSize: 20,
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: media.width * 0.05),
                      RoundTextField(
                        controller: _emailController,
                        hintText: "Email",
                        icon: "assets/icons/message_icon.png",
                        textInputType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: media.width * 0.05),
                      RoundTextField(
                        controller: _passwordController,
                        hintText: "Password",
                        icon: "assets/icons/lock_icon.png",
                        textInputType: TextInputType.text,
                        isObscureText: !_isPasswordVisible,
                        rightIcon: TextButton(
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: 20,
                            height: 20,
                            child: Image.asset(
                              _isPasswordVisible
                                  ? "assets/icons/show_pwd_icon.png"
                                  : "assets/icons/hide_pwd_icon.png",
                              width: 20,
                              height: 20,
                              fit: BoxFit.contain,
                              color: AppColors.grayColor,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          } else if (!passwordRegExp.hasMatch(value)) {
                            return 'Password must contain 1 uppercase letter, 1 number, and be at least 8 characters long';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: media.width * 0.03),
                      Row(
                        children: [
                          Checkbox(
                            value: _rememberMe,
                            onChanged: (bool? value) {
                              setState(() {
                                _rememberMe = value ?? false;
                              });
                            },
                          ),
                          const Text(
                            "Remember Me",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppColors.grayColor,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: media.width * 0.03),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, ForgotPasswordScreen.routeName);
                        },
                        child: const Text(
                          "Forgot your password?",
                          style: TextStyle(
                            color: AppColors.grayColor,
                            fontSize: 10,
                          ),
                        ),
                      ),
                      SizedBox(height: media.width * 0.05),
                      RoundGradientButton(
                        title: "Login",
                        onPressed: _login,
                      ),
                      SizedBox(height: media.width * 0.01),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              width: double.maxFinite,
                              height: 1,
                              color: AppColors.grayColor.withOpacity(0.5),
                            ),
                          ),
                          const Text(
                            "  Or  ",
                            style: TextStyle(
                              color: AppColors.grayColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Expanded(
                            child: Container(
                              width: double.maxFinite,
                              height: 1,
                              color: AppColors.grayColor.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              width: 50,
                              height: 50,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: AppColors.primaryColor1.withOpacity(0.5),
                                  width: 1,
                                ),
                              ),
                              child: Image.asset(
                                "assets/icons/google_icon.png",
                                width: 20,
                                height: 20,
                                
                              ),
                            ),
                          ),
                          



                          



                          const SizedBox(width: 30),
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              width: 50,
                              height: 50,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: AppColors.primaryColor1.withOpacity(0.5),
                                  width: 1,
                                ),
                              ),
                              child: Image.asset(
                                "assets/icons/facebook_icon.png",
                                width: 20,
                                height: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, SignupScreen.routeName);
                        },
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: const TextSpan(
                            style: TextStyle(
                              color: AppColors.blackColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                            children: [
                              TextSpan(text: "Don’t have an account yet? "),
                              TextSpan(
                                text: "Register",
                                style: TextStyle(
                                  color: AppColors.secondaryColor1,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.white.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
