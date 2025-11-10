import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:form_submit_app/controllers/getxControllers/dashboard_controller.dart';

class KpiDetailScreen extends StatefulWidget {
  const KpiDetailScreen({super.key});

  @override
  State<KpiDetailScreen> createState() => _KpiDetailScreenState();
}

class _KpiDetailScreenState extends State<KpiDetailScreen> {
  final DashboardController controller = Get.find<DashboardController>();

  /// 🔍 Stream for filtered KPI data (based on date filter)
  Stream<QuerySnapshot> getKpiStream() {
    final start = controller.startDate.value;
    final end = controller.endDate.value;

    Query baseQuery = FirebaseFirestore.instance
        .collection('kpi_reports')
        .orderBy('timestamp', descending: true);

    if (start != null && end != null) {
      // normalize dates
      final normalizedStart = DateTime(
        start.year,
        start.month,
        start.day,
        0,
        0,
        0,
      );
      final normalizedEnd = DateTime(end.year, end.month, end.day, 23, 59, 59);

      baseQuery = baseQuery
          .where('timestamp', isGreaterThanOrEqualTo: normalizedStart)
          .where('timestamp', isLessThanOrEqualTo: normalizedEnd);
    }

    return baseQuery.snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('KPI Enforcement Details'),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: getKpiStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                "No KPI reports found for selected dates.",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;

              final timestamp = data['timestamp'];
              final formattedDate = timestamp is Timestamp
                  ? DateFormat('dd-MM-yyyy  hh:mm a').format(timestamp.toDate())
                  : 'N/A';

              return GestureDetector(
                onTap: () => _showKpiDetailBottomSheet(context, data),
                child: Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.assignment, color: Colors.blue),
                    title: Text(
                      data['region'] ?? 'No Region',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    subtitle: Text(
                      "Officer: ${data['officer_observer'] ?? 'N/A'}\nViolation: ${data['violation'] ?? 'N/A'}",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: Text(
                      formattedDate,
                      textAlign: TextAlign.end,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  /// 📋 KPI Detail Bottom Sheet
  void _showKpiDetailBottomSheet(
    BuildContext context,
    Map<String, dynamic> data,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Container(
                    width: 60,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "KPI Enforcement Report",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 12),
                _infoRow(
                  Icons.calendar_today,
                  "Date & Time",
                  data['timestamp'],
                ),
                _infoRow(Icons.map, "Region", data['region']),
                _infoRow(Icons.location_city, "District", data['district']),
                _infoRow(Icons.account_balance, "PHP Post", data['php_post']),
                _infoRow(Icons.alt_route, "Road", data['road']),
                _infoRow(Icons.person, "Officer", data['officer_observer']),
                _infoRow(Icons.badge, "Officer Rank", data['officer_rank']),
                _infoRow(
                  Icons.confirmation_number,
                  "Officer Belt No",
                  data['officer_belt_no'],
                ),
                _infoRow(
                  Icons.credit_card,
                  "Officer CNIC",
                  data['officer_cnic'],
                ),
                _infoRow(Icons.person, "Road User", data['road_user_name']),
                _infoRow(
                  Icons.credit_card,
                  "Road User CNIC",
                  data['road_user_cnic'],
                ),
                _infoRow(Icons.phone, "Mobile", data['road_user_mobile']),
                _infoRow(Icons.category, "Category", data['category']),
                _infoRow(
                  Icons.flag,
                  "Violation Indicator",
                  data['violation_indicator'],
                ),
                _infoRow(Icons.warning_amber, "Violation", data['violation']),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      "Close",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// 🔹 Info row
  Widget _infoRow(IconData icon, String label, dynamic value) {
    String displayValue;
    if (value is Timestamp) {
      displayValue = DateFormat('dd-MM-yyyy  hh:mm a').format(value.toDate());
    } else {
      displayValue = value?.toString() ?? '-';
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.black54, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              "$label: $displayValue",
              style: const TextStyle(fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:get/get.dart';
// import 'package:form_submit_app/view/screens/dashboard/dashboard_screen.dart';

// class KpiDetailScreen extends StatefulWidget {
//   const KpiDetailScreen({super.key});

//   @override
//   State<KpiDetailScreen> createState() => _KpiDetailScreenState();
// }

// class _KpiDetailScreenState extends State<KpiDetailScreen> {
//   @override
//   Widget build(BuildContext context) {
//     final mediaQuery = MediaQuery.of(context).size;
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () {
//             Get.off(() => DashboardScreen(userData: {}));
//             //Get.off(() => DashboardScreen());
//           },
//         ),
//         title: const Text('KPI Enforcement Details'),
//         backgroundColor: Colors.green,
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection('kpi_reports')
//             .orderBy('date_time', descending: true)
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return const Center(
//               child: Text(
//                 "No KPI reports found",
//                 style: TextStyle(fontSize: 16),
//               ),
//             );
//           }

//           final kpis = snapshot.data!.docs;

//           return ListView.builder(
//             itemCount: kpis.length,
//             itemBuilder: (context, index) {
//               final data = kpis[index].data() as Map<String, dynamic>;

//               return GestureDetector(
//                 onTap: () {
//                   // Open detail bottom sheet
//                   showModalBottomSheet(
//                     context: context,
//                     isScrollControlled: true,
//                     backgroundColor: Colors.white,
//                     shape: const RoundedRectangleBorder(
//                       borderRadius: BorderRadius.vertical(
//                         top: Radius.circular(20),
//                       ),
//                     ),
//                     builder: (context) {
//                       return Padding(
//                         padding: const EdgeInsets.all(20.0),
//                         child: SingleChildScrollView(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               Center(
//                                 child: Container(
//                                   width: 60,
//                                   height: 5,
//                                   decoration: BoxDecoration(
//                                     color: Colors.grey.shade300,
//                                     borderRadius: BorderRadius.circular(10),
//                                   ),
//                                 ),
//                               ),
//                               const SizedBox(height: 16),

//                               Text(
//                                 "KPI Enforcement Report",
//                                 style: const TextStyle(
//                                   fontSize: 20,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.green,
//                                 ),
//                               ),
//                               const SizedBox(height: 12),

//                               _infoRow(
//                                 Icons.calendar_today,
//                                 "Date & Time",
//                                 data['date_time'],
//                               ),
//                               _infoRow(Icons.map, "Region", data['region']),
//                               _infoRow(
//                                 Icons.location_city,
//                                 "District",
//                                 data['district'],
//                               ),
//                               _infoRow(
//                                 Icons.account_balance,
//                                 "PHP Post",
//                                 data['php_post'],
//                               ),
//                               _infoRow(
//                                 Icons.r_mobiledata,
//                                 "Road",
//                                 data['road'],
//                               ),
//                               _infoRow(
//                                 Icons.person,
//                                 "Officer Name",
//                                 data['officer_name'],
//                               ),
//                               _infoRow(
//                                 Icons.badge,
//                                 "Officer Rank",
//                                 data['officer_rank'],
//                               ),
//                               _infoRow(
//                                 Icons.confirmation_number,
//                                 "Officer Belt No.",
//                                 data['officer_belt_no'],
//                               ),
//                               _infoRow(
//                                 Icons.credit_card,
//                                 "Officer CNIC",
//                                 data['officer_cnic'],
//                               ),
//                               _infoRow(
//                                 Icons.directions_car,
//                                 "Driver Name",
//                                 data['driver_name'],
//                               ),
//                               _infoRow(
//                                 Icons.credit_card,
//                                 "Driver CNIC",
//                                 data['driver_cnic'],
//                               ),
//                               _infoRow(Icons.phone, "Mobile #", data['mobile']),
//                               _infoRow(
//                                 Icons.category,
//                                 "Category",
//                                 data['category'],
//                               ),
//                               _infoRow(
//                                 Icons.flag,
//                                 "Violation Indicator",
//                                 data['violation_indicator'],
//                               ),
//                               _infoRow(
//                                 Icons.warning_amber,
//                                 "Violation",
//                                 data['violation'],
//                               ),

//                               const SizedBox(height: 20),
//                               Center(
//                                 child: ElevatedButton(
//                                   style: ElevatedButton.styleFrom(
//                                     backgroundColor: Colors.green,
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(10),
//                                     ),
//                                   ),
//                                   onPressed: () => Navigator.pop(context),
//                                   child: const Text(
//                                     'Close',
//                                     style: TextStyle(color: Colors.white),
//                                   ),
//                                 ),
//                               ),
//                               const SizedBox(height: 10),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   );
//                 },
//                 child: Container(
//                   width: mediaQuery.width,
//                   height: mediaQuery.height * 0.16,
//                   child: Card(
//                     margin: const EdgeInsets.symmetric(
//                       horizontal: 12,
//                       vertical: 8,
//                     ),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     elevation: 3,
//                     child: ListTile(
//                       leading: const Icon(
//                         Icons.assignment,
//                         color: Colors.green,
//                       ),
//                       title: Text(
//                         data['region'] ?? 'No Region',
//                         style: const TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                       subtitle: Text(
//                         "Officer: ${data['officer_name'] ?? 'N/A'}\nViolation: ${data['violation'] ?? 'N/A'}",
//                         maxLines: 2,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                       trailing: Text(
//                         data['date_time'] ?? '',
//                         style: const TextStyle(
//                           fontSize: 12,
//                           color: Colors.grey,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }

//   // Reusable Info Row
//   Widget _infoRow(IconData icon, String label, dynamic value) {
//     if (value == null || value.toString().isEmpty) return const SizedBox();
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 6),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Icon(icon, color: Colors.black54, size: 20),
//           const SizedBox(width: 8),
//           Expanded(
//             child: Text(
//               "$label: ${value ?? '-'}",
//               style: const TextStyle(fontSize: 15),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
