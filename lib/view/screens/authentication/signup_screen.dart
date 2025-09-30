import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_submit_app/controllers/getxControllers/auth_controller.dart';
import 'package:form_submit_app/controllers/utils/app_extension.dart';
import 'package:form_submit_app/controllers/utils/app_textstyles.dart';
import 'package:form_submit_app/view/screens/authentication/login_screen.dart';
import 'package:form_submit_app/view/screens/authentication/register_successful.dart';
import 'package:form_submit_app/view/widgets/custom_field.dart';
import 'package:get/get.dart';
import '../../widgets/custom_button.dart';

class SignupScreen extends StatefulWidget {
  final bool isAdmin;
  SignupScreen({Key? key, this.isAdmin = false}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final AuthControllers authControllers = Get.put(AuthControllers());

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController cnicController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController regionController = TextEditingController();
  final TextEditingController districtController = TextEditingController();
  final TextEditingController postController = TextEditingController();
  final TextEditingController roleController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    Size mediaQuerySize = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Form(
            key: formKey,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: mediaQuerySize.width * 0.06.w,
                vertical: mediaQuerySize.height * 0.01.h,
              ),
              child: Column(
                children: [
                  SizedBox(height: mediaQuerySize.height * 0.1.h),
                  Center(
                    child: Text(
                      'Create Your Account',
                      style: AppTextstyles.BoldBlackText(),
                    ),
                  ),
                  SizedBox(height: mediaQuerySize.height * 0.04.h),

                  // Full Name Field
                  CustomField(
                    controller: fullNameController,
                    text: 'Full Name',
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your full name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 15.h),

                  // CNIC Field
                  CustomField(
                    controller: cnicController,
                    text: 'CNIC',
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your CNIC';
                      }
                      // Add CNIC format validation if needed here
                      return null;
                    },
                  ),
                  SizedBox(height: 15.h),

                  // Phone Number Field
                  CustomField(
                    controller: phoneNumberController,
                    text: '+92 | XXX-XXXXXXX',
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your phone number';
                      }
                      if (!AppExtension.phoneExtension.hasMatch(value.trim())) {
                        return 'Enter a valid phone number';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 15.h),

                  // Email Field
                  CustomField(
                    controller: emailController,
                    text: 'Email',
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!AppExtension.emailExtension.hasMatch(value.trim())) {
                        return 'Enter a valid email';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 15.h),

                  // Region Field
                  CustomField(
                    controller: regionController,
                    text: 'Region',
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your region';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 15.h),

                  // District Field
                  CustomField(
                    controller: districtController,
                    text: 'District',
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your district';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 15.h),

                  // Post Field
                  CustomField(
                    controller: postController,
                    text: 'Post',
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your post';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 15.h),

                  // Role Field
                  CustomField(
                    controller: roleController,
                    text: 'Role',
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your role';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 15.h),

                  // Username Field
                  CustomField(
                    controller: usernameController,
                    text: 'Username',
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your username';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 15.h),

                  // Password Field
                  Obx(
                    () => CustomField(
                      text: 'Password',
                      controller: passwordController,
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
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your password';
                        }
                        if (value.trim().length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 30.h),

                  // Submit Button
                  Obx(() {
                    return CustomButton(
                      name: 'Signup',
                      isLoading: authControllers.isLoading.value,
                      onTap: () async {
                        if (formKey.currentState!.validate()) {
                          final success = await authControllers
                              .signUpwithEmailandPassword(
                                email: emailController.text.trim(),
                                password: passwordController.text.trim(),
                                collectionName: widget.isAdmin
                                    ? 'admins'
                                    : 'shortfilers',
                                fullName: fullNameController.text.trim(),
                                cnic: cnicController.text.trim(),
                                phoneNumber: phoneNumberController.text.trim(),
                                region: regionController.text.trim(),
                                district: districtController.text.trim(),
                                post: postController.text.trim(),
                                role: roleController.text.trim(),
                                username: usernameController.text.trim(),
                              );

                          if (success) {
                            Get.to(() => RegisterSuccessfull());
                            Get.snackbar(
                              'Success',
                              'Account created successfully',
                            );
                          } else {
                            Get.snackbar('Error', 'Signup failed. Try again');
                          }
                        }
                      },
                    );
                  }),
                  SizedBox(height: 30.h),

                  // Divider
                  Row(
                    children: [
                      Expanded(
                        child: Divider(color: Colors.grey, thickness: 1),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
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
                  SizedBox(height: 20.h),

                  // Login Redirect
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account?',
                        style: AppTextstyles.simpleGreyText(),
                      ),
                      TextButton(
                        onPressed: () => Get.to(() => LoginScreen()),
                        child: Text(
                          'Log in',
                          style: AppTextstyles.simpleRedText(),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 50.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
