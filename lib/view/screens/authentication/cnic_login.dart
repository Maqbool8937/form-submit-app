import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_submit_app/controllers/getxControllers/auth_controller.dart';
import 'package:form_submit_app/controllers/getxControllers/auth_service.dart';
import 'package:form_submit_app/controllers/utils/app_textstyles.dart';
import 'package:form_submit_app/view/screens/dashboard/dashboard_screen.dart';
import 'package:form_submit_app/view/widgets/custom_button.dart';
import 'package:form_submit_app/view/widgets/custom_field.dart';
import 'package:get/get.dart';

class CnicLoginScreen extends StatefulWidget {
  CnicLoginScreen({super.key});

  @override
  State<CnicLoginScreen> createState() => _CnicLoginScreenState();
}

class _CnicLoginScreenState extends State<CnicLoginScreen> {
  final TextEditingController cnicController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final AuthControllers authControllers = Get.put(AuthControllers());

  final _formKey = GlobalKey<FormState>();

  String? validateCnic(String? v) {
    if (v == null || v.trim().isEmpty) {
      return 'Please enter CNIC';
    }
    // Accept dashed form
    if (!RegExp(r'^\d{5}-\d{7}-\d$').hasMatch(v.trim())) {
      return 'Use format 12345-6789012-3';
    }
    return null;
  }

  String? validatePassword(String? v) {
    if (v == null || v.isEmpty) return 'Enter password';
    if (v.length < 6) return 'Password too short';
    return null;
  }

  void login() async {
    if (!_formKey.currentState!.validate()) return;

    authControllers.isLoading.value = true;

    final result = await AuthService().loginWithCnic(
      cnic: cnicController.text.trim(),
      password: passwordController.text.trim(),
    );

    authControllers.isLoading.value = false;

    if (result != null) {
      // ✅ Pass result to DashboardScreen
      Get.off(() => DashboardScreen(userData: result));
      //Get.off(() => DashboardScreen());
    } else {
      Get.snackbar(
        'Login Failed',
        'Invalid CNIC or password',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }

  // void login() async {
  //   if (!_formKey.currentState!.validate()) return;

  //   authControllers.isLoading.value = true;

  //   final result = await AuthService().loginWithCnic(
  //     cnic: cnicController.text.trim(),
  //     password: passwordController.text.trim(),
  //   );

  //   authControllers.isLoading.value = false;

  //   if (result != null) {
  //     Get.off(() => DashboardScreen());
  //     //  Get.off(() => ProfileScreen(userData: result));
  //   } else {
  //     Get.snackbar(
  //       'Login Failed',
  //       'Invalid CNIC or password',
  //       snackPosition: SnackPosition.BOTTOM,
  //       backgroundColor: Colors.redAccent,
  //       colorText: Colors.white,
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final mediaQuerySize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: mediaQuerySize.height * 0.07.h),

                // Logo
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

                // Welcome Text
                Center(
                  child: Text(
                    'Welcome PHP',
                    style: AppTextstyles.BoldBlackText(),
                  ),
                ),
                const SizedBox(height: 40),

                // CNIC Field
                CustomField(
                  controller: cnicController,
                  text: '12345-6789012-3',
                  validator: validateCnic,
                ),
                SizedBox(height: mediaQuerySize.height * 0.03.h),

                // Password Field with Toggle using Obx
                Obx(
                  () => CustomField(
                    text: 'Password',
                    controller: passwordController,
                    validator: validatePassword,
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
                ),

                SizedBox(height: mediaQuerySize.height * 0.03.h),

                // Login Button with Loader using Obx
                Obx(
                  () => CustomButton(
                    isLoading: authControllers.isLoading.value,
                    name: 'Login',
                    onTap: authControllers.isLoading.value ? null : login,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
