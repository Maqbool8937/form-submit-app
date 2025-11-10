import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class DashboardController extends GetxController {
  final Map<String, dynamic> userData;
  DashboardController(this.userData);

  final Rxn<DateTime> startDate = Rxn<DateTime>();
  final Rxn<DateTime> endDate = Rxn<DateTime>();
  final formatter = DateFormat('dd-MM-yyyy');

  var isLoading = false.obs;

  // for dashboard item:

  final selectedPage = 'Dashboard'.obs;

  void handleDrawerItem(String item) {
    selectedPage.value = item;
    Get.back(); // closes drawer
  }

  /// Counts
  var kpiCount = 0.obs;
  var helpCount = 0.obs;
  var crimeCount = 0.obs;

  /// 📊 Fetch all counts (no date filter)
  Future<void> loadAllCounts() async {
    isLoading.value = true;
    try {
      kpiCount.value = await _getCount('kpi_reports');
      helpCount.value = await _getCount('help_forms');
      crimeCount.value = await _getCount('crime_reports');
    } finally {
      isLoading.value = false;
    }
  }

  /// 📅 Fetch filtered counts
  Future<void> filterAllCollections() async {
    isLoading.value = true;
    try {
      kpiCount.value = await _getCount(
        'kpi_reports',
        start: startDate.value,
        end: endDate.value,
      );
      helpCount.value = await _getCount(
        'help_forms',
        start: startDate.value,
        end: endDate.value,
      );
      crimeCount.value = await _getCount(
        'crime_reports',
        start: startDate.value,
        end: endDate.value,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// 🔢 Helper: Get count by collection (optionally filtered)
  Future<int> _getCount(
    String collectionName, {
    DateTime? start,
    DateTime? end,
  }) async {
    Query query = FirebaseFirestore.instance.collection(collectionName);

    if (start != null) {
      query = query.where('timestamp', isGreaterThanOrEqualTo: start);
    }
    if (end != null) {
      query = query.where('timestamp', isLessThanOrEqualTo: end);
    }

    final snapshot = await query.get();
    return snapshot.docs.length;
  }

  /// Setters
  void setStartDate(DateTime date) => startDate.value = date;
  void setEndDate(DateTime date) => endDate.value = date;

  @override
  void onInit() {
    super.onInit();
    loadAllCounts(); // show all counts initially
  }
}















// import 'package:get/get.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:intl/intl.dart';
// import 'package:flutter/material.dart';

// class DashboardController extends GetxController {
//   final Map<String, dynamic> userData;
//   DashboardController(this.userData);

//   final selectedPage = 'Dashboard'.obs;
//   final Rxn<DateTime> startDate = Rxn<DateTime>();
//   final Rxn<DateTime> endDate = Rxn<DateTime>();
//   final isLoading = false.obs;

//   final crimeRecords = <QueryDocumentSnapshot<Map<String, dynamic>>>[].obs;
//   final helpRecords = <QueryDocumentSnapshot<Map<String, dynamic>>>[].obs;
//   final kpiRecords = <QueryDocumentSnapshot<Map<String, dynamic>>>[].obs;
//   final records = <QueryDocumentSnapshot<Map<String, dynamic>>>[].obs;

//   final crimeCount = 0.obs;
//   final helpCount = 0.obs;
//   final kpiCount = 0.obs;

//   final DateFormat formatter = DateFormat("dd-MM-yyyy");

//   void handleDrawerItem(String item) => selectedPage.value = item;
//   void setStartDate(DateTime dt) => startDate.value = dt;
//   void setEndDate(DateTime dt) => endDate.value = dt;

//   /// 🔍 Filter all 3 collections
//   Future<void> filterAllCollections() async {
//     if (startDate.value == null || endDate.value == null) {
//       Get.snackbar(
//         'Missing Dates',
//         'Please select both start and end dates to filter.',
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.red.shade400,
//         colorText: Colors.white,
//       );
//       return;
//     }

//     isLoading.value = true;
//     records.clear();

//     final Timestamp start = Timestamp.fromDate(startDate.value!);
//     final Timestamp end = Timestamp.fromDate(endDate.value!);

//     // ✅ Make sure field names match Firestore
//     final Map<String, String> collectionFields = {
//       'crime_reports':
//           'timestamp', // 👈 change if your field is createdAt or date
//       'help_forms': 'timestamp',
//       'kpi_reports': 'timestamp',
//     };

//     try {
//       for (final entry in collectionFields.entries) {
//         final collection = entry.key;
//         final field = entry.value;

//         debugPrint('Fetching from: $collection (field: $field)');

//         final snap = await FirebaseFirestore.instance
//             .collection(collection)
//             .where(field, isGreaterThanOrEqualTo: start)
//             .where(field, isLessThanOrEqualTo: end)
//             .orderBy(field, descending: true)
//             .get();

//         records.addAll(snap.docs);
//       }

//       // 🔹 Sort merged records
//       records.sort((a, b) {
//         final ta =
//             ((a.data()['timestamp'] ?? a.data()['createdAt']) as Timestamp?)
//                 ?.toDate() ??
//             DateTime(2000);
//         final tb =
//             ((b.data()['timestamp'] ?? b.data()['createdAt']) as Timestamp?)
//                 ?.toDate() ??
//             DateTime(2000);
//         return tb.compareTo(ta);
//       });

//       // 🔹 Update counts
//       crimeCount.value = records
//           .where((r) => r.reference.parent.id == 'crime_reports')
//           .length;
//       helpCount.value = records
//           .where((r) => r.reference.parent.id == 'help_forms')
//           .length;
//       kpiCount.value = records
//           .where((r) => r.reference.parent.id == 'kpi_reports')
//           .length;
//     } catch (e, st) {
//       debugPrint('❌ filterAllCollections error: $e\n$st');
//       Get.snackbar(
//         'Error',
//         'Failed to filter all collections: $e',
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.red.shade400,
//         colorText: Colors.white,
//       );
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }















