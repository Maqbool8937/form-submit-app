import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:form_submit_app/view/screens/dashboard/dashboard_screen.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart'; // ✅ for opening Google Maps

class CrimeDetailScreen extends StatefulWidget {
  final String collectionName;

  const CrimeDetailScreen({super.key, required this.collectionName});

  @override
  State<CrimeDetailScreen> createState() => _CrimeDetailScreenState();
}

class _CrimeDetailScreenState extends State<CrimeDetailScreen> {
  /// ✅ Open location in Google Maps
  Future<void> _openMap(String gpsLocation) async {
    try {
      final parts = gpsLocation.split(',');
      final lat = parts[0].trim();
      final lon = parts[1].trim();
      final googleMapsUrl = 'https://www.google.com/maps?q=$lat,$lon';
      if (await canLaunchUrl(Uri.parse(googleMapsUrl))) {
        await launchUrl(
          Uri.parse(googleMapsUrl),
          mode: LaunchMode.externalApplication,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open Google Maps')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid GPS location format: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaquerySize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.off(() => DashboardScreen(userData: {}));
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: const Text('Crime Details'),
        backgroundColor: Colors.red,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection(widget.collectionName)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                "No crime reports found",
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          final crimes = snapshot.data!.docs;

          return ListView.builder(
            itemCount: crimes.length,
            itemBuilder: (context, index) {
              var data = crimes[index].data() as Map<String, dynamic>;

              return GestureDetector(
                onTap: () {
                  // Show bottom sheet with detailed info
                  showModalBottomSheet(
                    context: context,
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
                                data['action_taken'] ?? 'No crime head',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                data['crime_head'] ?? 'No crime head',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.person,
                                    color: Colors.black54,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      "CNIC: ${data['cnic'] ?? 'N/A'}",
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.local_police,
                                    color: Colors.black54,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      "Action Taken: ${data['action_taken'] ?? 'N/A'}",
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),

                              // ✅ GPS Location Section
                              if (data['gps_location'] != null)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.location_on,
                                          color: Colors.black54,
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            "GPS: ${data['gps_location']}",
                                            style: const TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Center(
                                      child: ElevatedButton.icon(
                                        icon: const Icon(Icons.map),
                                        label: const Text("View on Map"),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                        ),
                                        onPressed: () => _openMap(
                                          data['gps_location'].toString(),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                  ],
                                ),

                              // Description
                              if (data['description'] != null)
                                Text(
                                  "Description:\n${data['description']}",
                                  style: const TextStyle(fontSize: 15),
                                ),
                              const SizedBox(height: 10),

                              // Optional image
                              if (data['imageUrl'] != null &&
                                  (data['imageUrl'] as String).isNotEmpty)
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    data['imageUrl'],
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: 200,
                                  ),
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
                      leading: const Icon(Icons.report, color: Colors.red),
                      title: Text(
                        data['action_taken'] ?? 'No action_taken',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        data['cnic'] ?? 'No cnic',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Text(
                        data['crime_head'] ?? '',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
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
}









// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:url_launcher/url_launcher.dart';

// class CrimeDetailScreen extends StatefulWidget {
//   final String collectionName;

//   const CrimeDetailScreen({super.key, required this.collectionName});

//   @override
//   State<CrimeDetailScreen> createState() => _CrimeDetailScreenState();
// }

// class _CrimeDetailScreenState extends State<CrimeDetailScreen> {
//   /// ✅ Function to open Google Maps
//   Future<void> _openMap(String gpsLocation) async {
//     try {
//       final parts = gpsLocation.split(',');
//       final lat = parts[0].trim();
//       final lon = parts[1].trim();
//       final googleMapsUrl = 'https://www.google.com/maps?q=$lat,$lon';
//       if (await canLaunchUrl(Uri.parse(googleMapsUrl))) {
//         await launchUrl(
//           Uri.parse(googleMapsUrl),
//           mode: LaunchMode.externalApplication,
//         );
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Could not open Google Maps')),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text('Invalid GPS format: $e')));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final mediaquerySize = MediaQuery.of(context).size;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Crime Details'),
//         backgroundColor: Colors.red,
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection(widget.collectionName)
//             .orderBy('created_at', descending: true)
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return const Center(child: Text("No crime reports found"));
//           }

//           final crimes = snapshot.data!.docs;

//           return ListView.builder(
//             itemCount: crimes.length,
//             itemBuilder: (context, index) {
//               var data = crimes[index].data() as Map<String, dynamic>;

//               return GestureDetector(
//                 onTap: () {
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
//                             children: [
//                               Center(
//                                 child: Container(
//                                   width: 50,
//                                   height: 4,
//                                   decoration: BoxDecoration(
//                                     color: Colors.grey[300],
//                                     borderRadius: BorderRadius.circular(10),
//                                   ),
//                                 ),
//                               ),
//                               const SizedBox(height: 20),
//                               Text(
//                                 data['crime_head'] ?? 'No Crime Title',
//                                 style: const TextStyle(
//                                   fontSize: 22,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.red,
//                                 ),
//                               ),
//                               const SizedBox(height: 10),

//                               _buildInfoRow(
//                                 Icons.person,
//                                 "Reporter Name",
//                                 data['reporter_name'],
//                               ),
//                               _buildInfoRow(Icons.badge, "CNIC", data['cnic']),
//                               _buildInfoRow(
//                                 Icons.phone,
//                                 "Phone",
//                                 data['phone'],
//                               ),
//                               _buildInfoRow(
//                                 Icons.email,
//                                 "Email",
//                                 data['email'],
//                               ),
//                               _buildInfoRow(
//                                 Icons.date_range,
//                                 "Date",
//                                 data['date'],
//                               ),
//                               _buildInfoRow(
//                                 Icons.numbers,
//                                 "FIR Number",
//                                 data['fir_no'],
//                               ),
//                               _buildInfoRow(
//                                 Icons.location_city,
//                                 "Region",
//                                 data['region'],
//                               ),
//                               _buildInfoRow(
//                                 Icons.map,
//                                 "District",
//                                 data['district'],
//                               ),
//                               _buildInfoRow(
//                                 Icons.apartment,
//                                 "Police Post",
//                                 data['post'],
//                               ),
//                               _buildInfoRow(
//                                 Icons.location_on,
//                                 "Address",
//                                 data['address'],
//                               ),
//                               _buildInfoRow(
//                                 Icons.local_police,
//                                 "Action Taken",
//                                 data['action_taken'],
//                               ),
//                               _buildInfoRow(
//                                 Icons.report_problem,
//                                 "Crime Type",
//                                 data['crime_type'],
//                               ),
//                               _buildInfoRow(
//                                 Icons.policy,
//                                 "Status",
//                                 data['status'],
//                               ),
//                               _buildInfoRow(
//                                 Icons.timer,
//                                 "Created At",
//                                 data['created_at']?.toString(),
//                               ),

//                               // ✅ GPS location
//                               if (data['gps_location'] != null)
//                                 Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     _buildInfoRow(
//                                       Icons.gps_fixed,
//                                       "GPS Coordinates",
//                                       data['gps_location'],
//                                     ),
//                                     const SizedBox(height: 10),
//                                     Center(
//                                       child: ElevatedButton.icon(
//                                         icon: const Icon(Icons.map),
//                                         label: const Text("View on Map"),
//                                         style: ElevatedButton.styleFrom(
//                                           backgroundColor: Colors.red,
//                                           shape: RoundedRectangleBorder(
//                                             borderRadius: BorderRadius.circular(
//                                               10,
//                                             ),
//                                           ),
//                                         ),
//                                         onPressed: () => _openMap(
//                                           data['gps_location'].toString(),
//                                         ),
//                                       ),
//                                     ),
//                                     const SizedBox(height: 15),
//                                   ],
//                                 ),

//                               // ✅ Description
//                               if (data['description'] != null)
//                                 Text(
//                                   "Description:\n${data['description']}",
//                                   style: const TextStyle(fontSize: 16),
//                                 ),

//                               const SizedBox(height: 20),

//                               // ✅ Crime images
//                               if (data['images'] != null &&
//                                   data['images'] is List)
//                                 Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     const Text(
//                                       "Evidence Images:",
//                                       style: TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 16,
//                                       ),
//                                     ),
//                                     const SizedBox(height: 8),
//                                     SizedBox(
//                                       height: 120,
//                                       child: ListView.builder(
//                                         scrollDirection: Axis.horizontal,
//                                         itemCount:
//                                             (data['images'] as List).length,
//                                         itemBuilder: (context, imgIndex) {
//                                           final imageUrl =
//                                               (data['images']
//                                                   as List)[imgIndex];
//                                           return Padding(
//                                             padding: const EdgeInsets.only(
//                                               right: 10,
//                                             ),
//                                             child: ClipRRect(
//                                               borderRadius:
//                                                   BorderRadius.circular(10),
//                                               child: Image.network(
//                                                 imageUrl,
//                                                 width: 150,
//                                                 height: 120,
//                                                 fit: BoxFit.cover,
//                                               ),
//                                             ),
//                                           );
//                                         },
//                                       ),
//                                     ),
//                                   ],
//                                 ),

//                               const SizedBox(height: 25),
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
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   );
//                 },
//                 child: Card(
//                   margin: const EdgeInsets.symmetric(
//                     horizontal: 12,
//                     vertical: 8,
//                   ),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   elevation: 3,
//                   child: ListTile(
//                     leading: const Icon(Icons.report, color: Colors.red),
//                     title: Text(
//                       data['crime_head'] ?? 'Unknown Crime',
//                       style: const TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                     subtitle: Text(
//                       "Reporter: ${data['reporter_name'] ?? 'N/A'}\nCNIC: ${data['cnic'] ?? 'N/A'}",
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     trailing: Text(
//                       data['status'] ?? 'Pending',
//                       style: const TextStyle(fontSize: 12, color: Colors.grey),
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

//   /// ✅ Reusable info row
//   Widget _buildInfoRow(IconData icon, String label, dynamic value) {
//     return value != null && value.toString().isNotEmpty
//         ? Padding(
//             padding: const EdgeInsets.symmetric(vertical: 4.0),
//             child: Row(
//               children: [
//                 Icon(icon, color: Colors.black54, size: 20),
//                 const SizedBox(width: 8),
//                 Expanded(
//                   child: Text(
//                     "$label: $value",
//                     style: const TextStyle(fontSize: 16),
//                   ),
//                 ),
//               ],
//             ),
//           )
//         : const SizedBox.shrink();
//   }
// }


