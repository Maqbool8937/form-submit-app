import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:form_submit_app/view/screens/dashboard/dashboard_screen.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:form_submit_app/controllers/getxControllers/dashboard_controller.dart';

class HelpDetailScreen extends StatefulWidget {
  final String collectionName; // e.g. 'help_forms'

  const HelpDetailScreen({super.key, required this.collectionName});

  @override
  State<HelpDetailScreen> createState() => _HelpDetailScreenState();
}

class _HelpDetailScreenState extends State<HelpDetailScreen> {
  final DashboardController dashboardController =
      Get.find<DashboardController>();

  /// 🔍 Stream based on selected date filter
  Stream<QuerySnapshot> _filteredStream() {
    Query query = FirebaseFirestore.instance.collection(widget.collectionName);

    final start = dashboardController.startDate.value;
    final end = dashboardController.endDate.value;

    if (start != null) {
      query = query.where('timestamp', isGreaterThanOrEqualTo: start);
    }
    if (end != null) {
      query = query.where('timestamp', isLessThanOrEqualTo: end);
    }

    return query.orderBy('timestamp', descending: true).snapshots();
  }

  @override
  Widget build(BuildContext context) {
    final mediaquerySize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.off(
              () => DashboardScreen(userData: dashboardController.userData),
            );
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text('Help Form Details'),
        backgroundColor: Colors.green,
      ),
      body: Obx(() {
        return StreamBuilder<QuerySnapshot>(
          stream: _filteredStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text(
                  "No help form reports found",
                  style: TextStyle(fontSize: 16),
                ),
              );
            }

            final helps = snapshot.data!.docs;

            return ListView.builder(
              itemCount: helps.length,
              itemBuilder: (context, index) {
                var data = helps[index].data() as Map<String, dynamic>;

                final timestamp = data['timestamp'];
                final formattedDate = timestamp is Timestamp
                    ? DateFormat(
                        'dd-MM-yyyy  hh:mm a',
                      ).format(timestamp.toDate())
                    : 'N/A';

                return GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.white,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
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
                                Text(
                                  data['type_of_help'] ?? 'No Type Provided',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                  ),
                                ),
                                const SizedBox(height: 12),

                                // --- Basic Info ---
                                _infoRow(Icons.person, "CNIC", data['cnic']),
                                _infoRow(
                                  Icons.source,
                                  "Source of Info",
                                  data['source_of_info'],
                                ),
                                _infoRow(
                                  Icons.location_on,
                                  "Place (Landmark)",
                                  data['place'],
                                ),
                                _infoRow(
                                  Icons.map,
                                  "GPS Location",
                                  data['gps_location'],
                                ),
                                _infoRow(
                                  Icons.local_police,
                                  "Police Station",
                                  data['police_station'],
                                ),
                                _infoRow(
                                  Icons.time_to_leave,
                                  "Vehicle Type",
                                  data['vehicle_type'],
                                ),
                                _infoRow(
                                  Icons.confirmation_number,
                                  "Vehicle Registration #",
                                  data['vehicle_registration'],
                                ),
                                _infoRow(
                                  Icons.account_tree,
                                  "Region",
                                  data['region'],
                                ),
                                _infoRow(
                                  Icons.account_balance,
                                  "District",
                                  data['district'],
                                ),
                                _infoRow(
                                  Icons.policy,
                                  "PHP Post",
                                  data['php_post'],
                                ),
                                _infoRow(
                                  Icons.person_outline,
                                  "Shift Incharge",
                                  data['shift_incharge'],
                                ),

                                const SizedBox(height: 10),

                                if (data['name_address_contact'] != null)
                                  _sectionText(
                                    "Name, Address & Contact",
                                    data['name_address_contact'],
                                  ),

                                if (data['action_taken'] != null)
                                  _sectionText(
                                    "Action Taken by Officer",
                                    data['action_taken'],
                                  ),

                                const SizedBox(height: 20),
                                Center(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text(
                                      'Close',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: Container(
                    width: mediaquerySize.width,
                    height: mediaquerySize.height * 0.18,
                    child: Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 4,
                      child: ListTile(
                        leading: const Icon(
                          Icons.assignment,
                          color: Colors.red,
                        ),
                        title: Text(
                          data['region'] ?? 'No Region',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          data['shift_incharge'] ?? 'No Shift Incharge',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: Text(
                          formattedDate,
                          textAlign: TextAlign.end,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        // trailing: Text(
                        //   data['date_time'] ?? '',
                        //   style: const TextStyle(
                        //     fontSize: 12,
                        //     color: Colors.grey,
                        //   ),
                        // ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );
      }),
    );
  }

  // --- Reusable Widgets ---
  Widget _infoRow(IconData icon, String label, dynamic value) {
    if (value == null || value.toString().isEmpty) return const SizedBox();
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.black54, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              "$label: ${value ?? '-'}",
              style: const TextStyle(fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionText(String title, dynamic value) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$title:",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 5),
          Text(value ?? '-', style: const TextStyle(fontSize: 15)),
        ],
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:form_submit_app/view/screens/dashboard/dashboard_screen.dart';
// import 'package:get/get.dart';

// class HelpDetailScreen extends StatefulWidget {
//   final String collectionName; // e.g. 'help_forms'

//   const HelpDetailScreen({super.key, required this.collectionName});

//   @override
//   State<HelpDetailScreen> createState() => _HelpDetailScreenState();
// }

// class _HelpDetailScreenState extends State<HelpDetailScreen> {
//   @override
//   Widget build(BuildContext context) {
//     final mediaquerySize = MediaQuery.of(context).size;

//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           onPressed: () {
//             Get.off(() => DashboardScreen(userData: {}));
//             // Get.off(() => DashboardScreen());
//           },
//           icon: Icon(Icons.arrow_back),
//         ),
//         title: const Text('Help Form Details'),
//         backgroundColor: Colors.red,
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection(widget.collectionName)
//             .orderBy('date', descending: true)
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return const Center(
//               child: Text(
//                 "No help form reports found",
//                 style: TextStyle(fontSize: 16),
//               ),
//             );
//           }

//           final helps = snapshot.data!.docs;

//           return ListView.builder(
//             itemCount: helps.length,
//             itemBuilder: (context, index) {
//               var data = helps[index].data() as Map<String, dynamic>;

//               return GestureDetector(
//                 onTap: () {
//                   // Show bottom sheet with detailed info
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
//                                 data['type_of_help'] ?? 'No Type Provided',
//                                 style: const TextStyle(
//                                   fontSize: 20,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.red,
//                                 ),
//                               ),
//                               const SizedBox(height: 12),

//                               // --- Basic Info ---
//                               _infoRow(Icons.person, "CNIC", data['cnic']),
//                               _infoRow(
//                                 Icons.source,
//                                 "Source of Info",
//                                 data['source_of_info'],
//                               ),
//                               _infoRow(
//                                 Icons.location_on,
//                                 "Place (Landmark)",
//                                 data['place'],
//                               ),
//                               _infoRow(
//                                 Icons.map,
//                                 "GPS Location",
//                                 data['gps_location'],
//                               ),
//                               _infoRow(
//                                 Icons.local_police,
//                                 "Police Station",
//                                 data['police_station'],
//                               ),
//                               _infoRow(
//                                 Icons.time_to_leave,
//                                 "Vehicle Type",
//                                 data['vehicle_type'],
//                               ),
//                               _infoRow(
//                                 Icons.confirmation_number,
//                                 "Vehicle Registration #",
//                                 data['vehicle_registration'],
//                               ),
//                               _infoRow(
//                                 Icons.account_tree,
//                                 "Region",
//                                 data['region'],
//                               ),
//                               _infoRow(
//                                 Icons.account_balance,
//                                 "District",
//                                 data['district'],
//                               ),
//                               _infoRow(
//                                 Icons.policy,
//                                 "PHP Post",
//                                 data['php_post'],
//                               ),
//                               _infoRow(
//                                 Icons.person_outline,
//                                 "Shift Incharge",
//                                 data['shift_incharge'],
//                               ),

//                               const SizedBox(height: 10),

//                               if (data['name_address_contact'] != null)
//                                 _sectionText(
//                                   "Name, Address & Contact",
//                                   data['name_address_contact'],
//                                 ),

//                               if (data['action_taken'] != null)
//                                 _sectionText(
//                                   "Action Taken by Officer",
//                                   data['action_taken'],
//                                 ),

//                               const SizedBox(height: 20),
//                               Center(
//                                 child: ElevatedButton(
//                                   style: ElevatedButton.styleFrom(
//                                     backgroundColor: Colors.red,
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
//                   width: mediaquerySize.width,
//                   height: mediaquerySize.height * 0.18,
//                   child: Card(
//                     margin: const EdgeInsets.symmetric(
//                       horizontal: 12,
//                       vertical: 8,
//                     ),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     elevation: 4,
//                     child: ListTile(
//                       leading: const Icon(Icons.help, color: Colors.red),
//                       title: Text(
//                         data['type_of_help'] ?? 'No Type of Help',
//                         style: const TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                       subtitle: Text(
//                         data['place'] ?? 'No place mentioned',
//                         maxLines: 2,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                       trailing: Text(
//                         data['vehicle_type'] ?? '',
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

//   // --- Reusable Widgets ---
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

//   Widget _sectionText(String title, dynamic value) {
//     return Padding(
//       padding: const EdgeInsets.only(top: 10),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             "$title:",
//             style: const TextStyle(
//               fontWeight: FontWeight.bold,
//               fontSize: 16,
//               color: Colors.black87,
//             ),
//           ),
//           const SizedBox(height: 5),
//           Text(value ?? '-', style: const TextStyle(fontSize: 15)),
//         ],
//       ),
//     );
//   }
// }
