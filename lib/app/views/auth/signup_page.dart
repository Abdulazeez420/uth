// views/auth/signup_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uth_task/app/constant/appColors.dart';
import 'package:uth_task/app/routes/app_pages.dart';
import '../../controllers/auth_controller.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final AuthController authController = Get.find();
    final GlobalKey<FormState> formKeySignup = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.backgroundGradient,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          
          title: const Text('Sign Up'),
          backgroundColor: const Color.fromRGBO(50, 236, 193, 0.096),
          titleTextStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: formKeySignup,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: authController.emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: const BorderSide(color: Colors.blueAccent),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: const BorderSide(color: Colors.blueAccent),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: const BorderSide(color: Colors.blueAccent),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  Obx(() => TextFormField(
                    controller: authController.passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: const BorderSide(color: Colors.blueAccent),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: const BorderSide(color: Colors.blueAccent),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: const BorderSide(color: Colors.blueAccent),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          authController.obscurePassword.value ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          authController.obscurePassword.value = !authController.obscurePassword.value;
                        },
                      ),
                    ),
                    obscureText: authController.obscurePassword.value,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters long';
                      }
                      return null;
                    },
                  )),
                  const SizedBox(height: 16),
                  Obx(() => TextFormField(
                    controller:authController.confirmPasswordController,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: const BorderSide(color: Colors.blueAccent),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: const BorderSide(color: Colors.blueAccent),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: const BorderSide(color: Colors.blueAccent),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          authController.obscureConfirmPassword.value ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          authController.obscureConfirmPassword.value = !authController.obscureConfirmPassword.value;
                        },
                      ),
                    ),
                    obscureText: authController.obscureConfirmPassword.value,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your password';
                      }
                      if (value != authController.passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  )),
                  const SizedBox(height: 20),
                  Obx(
                    () => ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(AppColors.btnColor),
                        textStyle: MaterialStateProperty.all(const TextStyle(fontSize: 15)),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                      ),
                      onPressed: () {
                        if (formKeySignup.currentState!.validate()) {
                          authController.signUp(
                            authController.emailController.text.trim(),
                            authController.passwordController.text.trim(),
                            authController.confirmPasswordController.text.trim()
                          );
                        }
                      },
                      child: authController.loading.value
                          ? const SizedBox(
                              height: 25,
                              width: 25,
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              ),
                            )
                          : const Text('Sign Up', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                       Get.offAllNamed(Routes.LOGIN);
                    },
                    child: const Text('Already have an account? Login', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
