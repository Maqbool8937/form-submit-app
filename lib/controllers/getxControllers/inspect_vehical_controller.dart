import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InspectVehicleController extends GetxController {
  // Text field controller
  final vehicleController = TextEditingController();

  // Observable values
  var selectedFormOption = RxnString();
  var saving = false.obs;

  // Form options
  final List<String> formOptions = [
    "Repeat a Help",
    "Repeat an Accident",
    "Repeat a Crime",
  ];

  final formKey = GlobalKey<FormState>();

  // Save to Firestore
  Future<void> saveInspection() async {
    if (!formKey.currentState!.validate()) return;
    if (selectedFormOption.value == null) {
      Get.snackbar(
        "Error",
        "Please select a form type",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    saving.value = true;

    try {
      await FirebaseFirestore.instance.collection('inspections').add({
        'vehicle_no': vehicleController.text.trim(),
        'timestamp': Timestamp.now(),
        'form_type': selectedFormOption.value,
      });

      saving.value = false;
      Get.back(result: true);
      Get.snackbar(
        "Success",
        "Inspection saved successfully",
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      saving.value = false;
      Get.snackbar(
        "Error",
        "Failed to save inspection: $e",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  void onClose() {
    vehicleController.dispose();
    super.onClose();
  }
}
