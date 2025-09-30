import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_submit_app/controllers/getxControllers/auth_controller.dart';
import 'package:form_submit_app/controllers/utils/app_textstyles.dart';
import 'package:form_submit_app/view/widgets/custom_field.dart';
import 'package:get/get.dart';

import '../../../controllers/utils/app_extension.dart';
import '../../widgets/custom_button.dart';
import 'forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> formKey = GlobalKey();
  final AuthControllers authControllers = Get.put(AuthControllers());
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size mediaQuerySize = MediaQuery.of(context).size;

    return Obx(() {
      return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: SafeArea(
            child: Form(
              key: formKey,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: mediaQuerySize.width * 0.05.w,
                  vertical: mediaQuerySize.height * 0.01.h,
                ),
                child: Column(
                  children: [
                    SizedBox(height: mediaQuerySize.height * 0.07.h),
                    Container(
                      height: mediaQuerySize.height * 0.12,
                      width: mediaQuerySize.width * 0.25,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: const DecorationImage(
                          image: AssetImage('assets/images/php_logo.jpeg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(height: mediaQuerySize.height * 0.03.h),
                    Center(
                      child: Text(
                        'Welcome PHP',
                        style: AppTextstyles.BoldBlackText(),
                      ),
                    ),
                    SizedBox(height: mediaQuerySize.height * 0.02.h),
                    CustomField(
                      controller: emailController,
                      text: 'Email',
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter the email field';
                        }
                        if (!AppExtension.emailExtension.hasMatch(
                          value.trim(),
                        )) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: mediaQuerySize.height * 0.03.h),
                    CustomField(
                      text: 'Password',
                      controller: passwordController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                      isPasswordField: true,
                      isObscured: !authControllers.isPasswordVisible.value,
                      isSuffixIcon: true,
                      suffixIcon: IconButton(
                        icon: Icon(
                          authControllers.isPasswordVisible.value
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: authControllers.togglePasswordVisibility,
                      ),
                    ),
                    SizedBox(height: mediaQuerySize.height * 0.01.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.circle_outlined, size: 20),
                            SizedBox(width: 5.w),
                            Text(
                              'Remember Password',
                              style: AppTextstyles.SimpleBlackText(),
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed: () {
                            Get.to(() => ForgotPasswordScreen());
                          },
                          child: Text(
                            'Forget Password?',
                            style: AppTextstyles.SimpleBlackText(),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: mediaQuerySize.height * 0.03.h),
                    CustomButton(
                      isLoading: authControllers.isLoading.value,
                      name: 'Sign in',
                      onTap: authControllers.isLoading.value
                          ? null
                          : () async {
                              if (formKey.currentState!.validate()) {
                                bool loggedIn = await authControllers
                                    .signInWithEmailAndPassword(
                                      email: emailController.text.trim(),
                                      password: passwordController.text.trim(),
                                    );

                                if (loggedIn) {
                                  // Get.offAll(() => DashboardScreen());
                                } else {
                                  // Show error handled inside controller (Get.snackbar)
                                }
                              }
                            },
                    ),
                    SizedBox(height: mediaQuerySize.height * 0.03.h),
                    Row(
                      children: [
                        Expanded(
                          child: Divider(color: Colors.grey, thickness: 1),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: mediaQuerySize.width * 0.02.w,
                          ),
                          child: Text(
                            'Or With',
                            style: AppTextstyles.simpleGreyText(),
                          ),
                        ),
                        Expanded(
                          child: Divider(color: Colors.grey, thickness: 1),
                        ),
                      ],
                    ),
                    SizedBox(height: mediaQuerySize.height * 0.02.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "If you don't have an account",
                          style: AppTextstyles.simpleGreyText(),
                        ),
                        TextButton(
                          onPressed: () {
                            // Navigate to Signup screen or registration
                            // For example:
                            // Get.to(() => SignupScreen());
                          },
                          child: Text(
                            'Sign Up',
                            style: AppTextstyles.simpleRedText(),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: mediaQuerySize.height * 0.03.h),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
