import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class DashboardController extends GetxController {
  /// If you prefer this final, change the screen to always provide same userData.
  Map<String, dynamic> userData;
  DashboardController(this.userData);

  final selectedPage = 'Dashboard'.obs;
  final Rxn<DateTime> startDate = Rxn<DateTime>();
  final Rxn<DateTime> endDate = Rxn<DateTime>();
  final isLoading = false.obs;

  // Use typed QueryDocumentSnapshot to avoid dynamic surprises
  final records = <QueryDocumentSnapshot<Map<String, dynamic>>>[].obs;

  final DateFormat formatter = DateFormat("dd-MM-yyyy hh:mm a");

  void handleDrawerItem(String item) {
    selectedPage.value = item;
    if (item == 'Logout') {
      // TODO: Add your logout logic here (e.g. Get.offAllNamed('/login'))
    }
  }

  void setStartDate(DateTime dt) => startDate.value = dt;
  void setEndDate(DateTime dt) => endDate.value = dt;

  Future<void> searchInspections() async {
    if (startDate.value == null || endDate.value == null) {
      Get.snackbar(
        'Missing',
        'Please select start and end date',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoading.value = true;
    records.clear();

    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance
              .collection('inspections')
              .where(
                'timestamp',
                isGreaterThanOrEqualTo: Timestamp.fromDate(startDate.value!),
              )
              .where(
                'timestamp',
                isLessThanOrEqualTo: Timestamp.fromDate(endDate.value!),
              )
              .get();

      records.assignAll(snapshot.docs);
    } catch (e, st) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
      // for debugging in console
      debugPrint('searchInspections error: $e\n$st');
    } finally {
      isLoading.value = false;
    }
  }
}
