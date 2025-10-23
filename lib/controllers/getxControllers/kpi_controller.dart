import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class KPIController extends GetxController {
  final formKey = GlobalKey<FormState>();

  // Reactive Dropdowns
  final selectedRegion = RxnString();
  final selectedDistrict = RxnString();
  final selectedPost = RxnString();
  final selectedRoad = RxnString();
  final selectedOfficer = RxnString();
  final selectedCategory = RxnString();
  final selectedViolationIndicator = RxnString();
  final selectedViolation = RxnString();

  // Text controllers
  final officerRank = TextEditingController();
  final officerBeltNo = TextEditingController();
  final officerCnic = TextEditingController();
  final roadUserName = TextEditingController();
  final roadUserCnic = TextEditingController();
  final mobileNo = TextEditingController();

  final selectedDateTime = Rx<DateTime>(DateTime.now());
  final isSubmitting = false.obs;

  // Dummy region data (replace with your live data)
  final regions = {
    "Region A": ["District 1", "District 2"],
    "Region B": ["District X"],
  };

  final posts = ["Post 1", "Post 2", "Post 3"];
  final roads = ["Road A", "Road B", "Road C"];
  final officers = ["Officer A", "Officer B", "Officer C"];
  final categories = [
    "Public Transport",
    "Private Vehicle",
    "Commercial",
    "Other",
  ];
  final violationIndicators = ["Observed", "Not Observed"];
  final violations = [
    "Speeding",
    "Overloading",
    "Helmet Missing",
    "Wrong Side",
    "Other",
  ];

  // Firestore save
  Future<void> submitForm(BuildContext context) async {
    if (!(formKey.currentState?.validate() ?? false)) {
      Get.snackbar(
        "Error",
        "Please fill all required fields",
        backgroundColor: Colors.red.shade100,
      );
      return;
    }

    try {
      isSubmitting.value = true;

      await FirebaseFirestore.instance.collection("kpi_reports").add({
        "timestamp": FieldValue.serverTimestamp(),
        "date_time": selectedDateTime.value.toIso8601String(),
        "region": selectedRegion.value,
        "district": selectedDistrict.value,
        "php_post": selectedPost.value,
        "road": selectedRoad.value,
        "officer_observer": selectedOfficer.value,
        "officer_rank": officerRank.text.trim(),
        "officer_belt_no": officerBeltNo.text.trim(),
        "officer_cnic": officerCnic.text.trim(),
        "road_user_name": roadUserName.text.trim(),
        "road_user_cnic": roadUserCnic.text.trim(),
        "road_user_mobile": mobileNo.text.trim(),
        "category": selectedCategory.value,
        "violation_indicator": selectedViolationIndicator.value,
        "violation": selectedViolation.value,
      });

      Get.snackbar(
        "Success",
        "Form submitted successfully!",
        backgroundColor: Colors.green.shade100,
      );

      resetForm();
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to submit: $e",
        backgroundColor: Colors.red.shade100,
      );
    } finally {
      isSubmitting.value = false;
    }
  }

  void resetForm() {
    selectedRegion.value = null;
    selectedDistrict.value = null;
    selectedPost.value = null;
    selectedRoad.value = null;
    selectedOfficer.value = null;
    selectedCategory.value = null;
    selectedViolationIndicator.value = null;
    selectedViolation.value = null;

    officerRank.clear();
    officerBeltNo.clear();
    officerCnic.clear();
    roadUserName.clear();
    roadUserCnic.clear();
    mobileNo.clear();

    selectedDateTime.value = DateTime.now();
  }
}
