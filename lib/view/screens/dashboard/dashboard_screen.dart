import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_submit_app/controllers/getxControllers/dashboard_controller.dart';
import 'package:form_submit_app/view/screens/authentication/profile_screen.dart';
import 'package:form_submit_app/view/screens/dashboard/crime_detail_screen.dart';
import 'package:form_submit_app/view/screens/dashboard/help_detail_screen.dart';
import 'package:form_submit_app/view/screens/dashboard/list_form_screen.dart';
import 'package:form_submit_app/view/widgets/crime_card_widget.dart';
import 'package:form_submit_app/view/widgets/dashboard_drawer.dart';
import 'package:form_submit_app/view/widgets/help_card_widget.dart';
import 'package:form_submit_app/view/widgets/kpi_card.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

// adjust this import to match where you save the controller

class DashboardScreen extends StatefulWidget {
  final Map<String, dynamic> userData;
  DashboardScreen({Key? key, required this.userData}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late final DashboardController controller;

  @override
  void initState() {
    super.initState();
    // register controller once
    if (Get.isRegistered<DashboardController>()) {
      controller = Get.find<DashboardController>();
    } else {
      controller = Get.put(DashboardController(widget.userData));
    }
  }

  /// Date picker helper that writes result into controller
  Future<void> _pickDateTime({required bool isStart}) async {
    DateTime now = DateTime.now();
    DateTime initialDate = isStart
        ? now.subtract(const Duration(days: 1))
        : now;

    DateTime? date = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (date == null) return;

    TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(now),
    );
    if (time == null) return;

    final combined = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );

    if (isStart) {
      controller.setStartDate(combined);
    } else {
      controller.setEndDate(combined);
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaquerysize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Get.off(() => ProfileScreen(userData: widget.userData));
            },
            icon: const Icon(Icons.person),
          ),
        ],
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: const Text(
          "Dashboard",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(height: mediaquerysize.height * 0.03),
              // Date pickers + search
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _pickDateTime(isStart: true),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Obx(() {
                          final dt = controller.startDate.value;
                          return Text(
                            dt != null
                                ? controller.formatter.format(dt)
                                : "Start Date",
                          );
                        }),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _pickDateTime(isStart: false),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Obx(() {
                          final dt = controller.endDate.value;
                          return Text(
                            dt != null
                                ? controller.formatter.format(dt)
                                : "End Date",
                          );
                        }),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    height: mediaquerysize.height * 0.06,
                    width: mediaquerysize.width * 0.25,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Obx(() {
                      return TextButton(
                        onPressed: controller.isLoading.value
                            ? null
                            : controller.searchInspections,
                        child: controller.isLoading.value
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(
                                Icons.search,
                                color: Colors.white,
                                size: 30,
                              ),
                      );
                    }),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Labels
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Heads",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "Counts",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // GestureDetector(
              //   onTap: () {
              //     Get.to(() => HelpDetailScreen(collectionName: 'help_forms'));
              //   },
              //   child: Container(
              //     height: mediaquerysize.height * 0.07,
              //     width: mediaquerysize.width * 1,
              //     decoration: BoxDecoration(
              //       borderRadius: BorderRadius.circular(10),
              //       color: Colors.blue,
              //     ),
              //     child: const Padding(
              //       padding: EdgeInsets.all(16.0),
              //       child: Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //         children: [
              //           Text(
              //             'Road Safety KPI',
              //             style: TextStyle(
              //               color: Colors.white,
              //               fontWeight: FontWeight.bold,
              //               fontSize: 15,
              //             ),
              //           ),
              //           Text(
              //             '2',
              //             style: TextStyle(
              //               fontSize: 16,
              //               fontWeight: FontWeight.bold,
              //             ),
              //           ),
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
              KpiCard(mediaquerysize: mediaquerysize),
              const SizedBox(height: 8),
              HelpCard(mediaquerysize: mediaquerysize),
              const SizedBox(height: 8),
              CrimeCard(mediaquerysize: mediaquerysize),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () {
                  Get.to(
                    () => CrimeDetailScreen(collectionName: 'crime_reports'),
                  );
                },
                child: Container(
                  height: mediaquerysize.height * 0.07,
                  width: mediaquerysize.width * 1,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color.fromARGB(255, 200, 159, 12),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Accident',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          '2',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(height: mediaquerysize.height * 0.3),
              // Inspect a Vehicle button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    bool? didSave = await Navigator.push<bool>(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const InspectVehicleFormScreen(),
                      ),
                    );

                    if (didSave == true) {
                      await controller.searchInspections();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                      side: const BorderSide(color: Colors.green, width: 1),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 15,
                    ),
                  ),
                  child: const Text(
                    "Add New Record",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),

              // Optionally render list of fetched records
              const SizedBox(height: 16),
              Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (controller.records.isEmpty) {
                  return const SizedBox.shrink();
                }
                return Column(
                  children: controller.records.map((doc) {
                    final data = doc.data();
                    final ts = data['timestamp'] as Timestamp?;
                    final created = ts != null
                        ? DateFormat('dd-MM-yyyy hh:mm a').format(ts.toDate())
                        : 'N/A';
                    return ListTile(
                      title: Text(data['title'] ?? 'Record'),
                      subtitle: Text(created),
                      onTap: () {
                        // open details if needed
                      },
                    );
                  }).toList(),
                );
              }),
            ],
          ),
        ),
      ),
      drawer: DashboardDrawer(onItemSelected: controller.handleDrawerItem),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:form_submit_app/view/screens/authentication/profile_screen.dart';
// import 'package:form_submit_app/view/screens/dashboard/crime_detail_screen.dart';
// import 'package:form_submit_app/view/screens/dashboard/help_detail_screen.dart';
// import 'package:form_submit_app/view/screens/dashboard/list_form_screen.dart';
// import 'package:form_submit_app/view/widgets/crime_card_widget.dart';
// import 'package:form_submit_app/view/widgets/dashboard_drawer.dart';
// import 'package:form_submit_app/view/widgets/help_card_widget.dart';
// import 'package:get/get.dart';
// // ignore: unnecessary_import
// import 'package:get/get_core/src/get_main.dart';
// import 'package:intl/intl.dart';

// class DashboardScreen extends StatefulWidget {
//   final Map<String, dynamic> userData;
//   DashboardScreen({Key? key, required this.userData}) : super(key: key);

//   @override
//   State<DashboardScreen> createState() => _DashboardScreenState();
// }

// class _DashboardScreenState extends State<DashboardScreen> {
//   String _selectedPage = "Dashboard";

//   void _handleDrawerItem(String item) {
//     setState(() {
//       _selectedPage = item;
//     });

//     // Handle navigation or logic here
//     if (item == "Logout") {
//       // Add logout logic
//     }
//   }

//   DateTime? _startDate;
//   DateTime? _endDate;
//   bool _loading = false;
//   List<QueryDocumentSnapshot> _records = [];

//   final DateFormat _formatter = DateFormat("dd-MM-yyyy hh:mm a");

//   Future<void> _pickDateTime({required bool isStart}) async {
//     DateTime now = DateTime.now();
//     DateTime initialDate = isStart
//         ? now.subtract(const Duration(days: 1))
//         : now;
//     DateTime? date = await showDatePicker(
//       context: context,
//       initialDate: initialDate,
//       firstDate: DateTime(2020),
//       lastDate: DateTime(2100),
//     );
//     if (date == null) return;

//     TimeOfDay? time = await showTimePicker(
//       context: context,
//       initialTime: TimeOfDay.fromDateTime(now),
//     );
//     if (time == null) return;

//     DateTime combined = DateTime(
//       date.year,
//       date.month,
//       date.day,
//       time.hour,
//       time.minute,
//     );

//     setState(() {
//       if (isStart) {
//         _startDate = combined;
//       } else {
//         _endDate = combined;
//       }
//     });
//   }

//   Future<void> _searchInspections() async {
//     if (_startDate == null || _endDate == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Please select start and end date")),
//       );
//       return;
//     }
//     setState(() {
//       _loading = true;
//       _records = [];
//     });
//     try {
//       QuerySnapshot snapshot = await FirebaseFirestore.instance
//           .collection('inspections')
//           .where(
//             'timestamp',
//             isGreaterThanOrEqualTo: Timestamp.fromDate(_startDate!),
//           )
//           .where(
//             'timestamp',
//             isLessThanOrEqualTo: Timestamp.fromDate(_endDate!),
//           )
//           .get();

//       setState(() {
//         _records = snapshot.docs;
//         _loading = false;
//       });
//     } catch (e) {
//       print("Error fetching inspections: $e");
//       setState(() {
//         _loading = false;
//       });
//     }
//   }

//   // Helper to convert DateTime to Firestore Timestamp
//   // ignore: unused_element
//   static Timestamp fromDate(DateTime dt) => Timestamp.fromDate(dt);

//   @override
//   Widget build(BuildContext context) {
//     final mediaquerysize = MediaQuery.of(context).size;
//     return Scaffold(
//       appBar: AppBar(
//         actions: [
//           IconButton(
//             onPressed: () {
//               Get.off(() => ProfileScreen(userData: widget.userData));
//             },
//             icon: Icon(Icons.person),
//           ),
//         ],
//         iconTheme: IconThemeData(color: Colors.white),
//         centerTitle: true,
//         title: const Text(
//           "Dashboard",
//           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//         ),
//         backgroundColor: Colors.red,
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20),
//           child: Column(
//             children: [
//               SizedBox(height: mediaquerysize.height * 0.03),
//               // Date pickers + search
//               Row(
//                 children: [
//                   Expanded(
//                     child: GestureDetector(
//                       onTap: () => _pickDateTime(isStart: true),
//                       child: Container(
//                         padding: const EdgeInsets.all(12),
//                         decoration: BoxDecoration(
//                           border: Border.all(color: Colors.grey),
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: Text(
//                           _startDate != null
//                               ? _formatter.format(_startDate!)
//                               : "Start Date",
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   Expanded(
//                     child: GestureDetector(
//                       onTap: () => _pickDateTime(isStart: false),
//                       child: Container(
//                         padding: const EdgeInsets.all(12),
//                         decoration: BoxDecoration(
//                           border: Border.all(color: Colors.grey),
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: Text(
//                           _endDate != null
//                               ? _formatter.format(_endDate!)
//                               : "End Date",
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   Container(
//                     height: mediaquerysize.height * 0.06.h,
//                     width: mediaquerysize.width * 0.25.w,
//                     decoration: BoxDecoration(
//                       color: Colors.blue,
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: TextButton(
//                       onPressed: _searchInspections,
//                       child: Icon(
//                         Icons.search,
//                         color: Colors.white,
//                         size: 30,
//                         weight: 40,
//                       ),
//                     ),
//                   ),
//                   // ElevatedButton(
//                   //   onPressed: _searchInspections,
//                   //   style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
//                   //   child: const Icon(Icons.search, color: Colors.white),
//                   // ),
//                 ],
//               ),
//               const SizedBox(height: 16),
//               // Labels
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Align(
//                     alignment: Alignment.centerLeft,
//                     child: const Text(
//                       "Heads",
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16,
//                       ),
//                     ),
//                   ),

//                   Align(
//                     alignment: Alignment.centerRight,
//                     child: const Text(
//                       "Counts",
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 8),
//               GestureDetector(
//                 onTap: () {
//                   Get.to(() => HelpDetailScreen(collectionName: 'help_forms'));
//                 },
//                 child: Container(
//                   height: mediaquerysize.height * 0.07.h,
//                   width: mediaquerysize.width * 1.w,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(10),
//                     color: Colors.blue,
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           'Road Safety KPI',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontWeight: FontWeight.bold,
//                             fontSize: 15,
//                           ),
//                         ),
//                         Text(
//                           '2',
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 8),
//               HelpCard(mediaquerysize: mediaquerysize),
//               // GestureDetector(
//               //   onTap: () {
//               //     Get.to(() => HelpDetailScreen());
//               //   },
//               //   child: Container(
//               //     height: mediaquerysize.height * 0.07.h,
//               //     width: mediaquerysize.width * 1.w,
//               //     decoration: BoxDecoration(
//               //       borderRadius: BorderRadius.circular(10),
//               //       color: Colors.green,
//               //     ),
//               //     child: Padding(
//               //       padding: const EdgeInsets.all(16.0),
//               //       child: Row(
//               //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               //         children: [
//               //           Text(
//               //             'Helps',
//               //             style: TextStyle(
//               //               color: Colors.white,
//               //               fontWeight: FontWeight.bold,
//               //               fontSize: 15,
//               //             ),
//               //           ),
//               //           Text(
//               //             '2',
//               //             style: TextStyle(
//               //               fontSize: 16,
//               //               fontWeight: FontWeight.bold,
//               //             ),
//               //           ),
//               //         ],
//               //       ),
//               //     ),
//               //   ),
//               // ),
//               const SizedBox(height: 8),
//               CrimeCard(mediaquerysize: mediaquerysize),
//               // GestureDetector(
//               //   onTap: () {
//               //     Get.to(() => CrimeDetailScreen());
//               //   },
//               //   child: Container(
//               //     height: mediaquerysize.height * 0.07.h,
//               //     width: mediaquerysize.width * 1.w,
//               //     decoration: BoxDecoration(
//               //       borderRadius: BorderRadius.circular(10),
//               //       color: Colors.red,
//               //     ),
//               //     child: Padding(
//               //       padding: const EdgeInsets.all(16.0),
//               //       child: Row(
//               //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               //         children: [
//               //           Text(
//               //             'Crime',
//               //             style: TextStyle(
//               //               color: Colors.white,
//               //               fontWeight: FontWeight.bold,
//               //               fontSize: 15,
//               //             ),
//               //           ),
//               //           Text(
//               //             '2',
//               //             style: TextStyle(
//               //               fontSize: 16,
//               //               fontWeight: FontWeight.bold,
//               //             ),
//               //           ),
//               //         ],
//               //       ),
//               //     ),
//               //   ),
//               // ),
//               SizedBox(height: 8),
//               GestureDetector(
//                 onTap: () {
//                   Get.to(
//                     () => CrimeDetailScreen(collectionName: 'crime_reports'),
//                   );
//                   // Get.to(() => CrimeDetailScreen());
//                 },
//                 child: Container(
//                   height: mediaquerysize.height * 0.07.h,
//                   width: mediaquerysize.width * 1.w,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(10),
//                     color: Color.fromARGB(255, 200, 159, 12),
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           'Accident',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontWeight: FontWeight.bold,
//                             fontSize: 15,
//                           ),
//                         ),
//                         Text(
//                           '2',
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),

//               SizedBox(height: mediaquerysize.height * 0.3),
//               // Inspect a Vehicle button
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: () async {
//                     bool? didSave = await Navigator.push<bool>(
//                       context,
//                       MaterialPageRoute(
//                         builder: (_) => const InspectVehicleFormScreen(),
//                       ),
//                     );

//                     if (didSave == true) {
//                       _searchInspections();
//                     }
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.green,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(4),
//                       side: BorderSide(color: Colors.green, width: 1),
//                     ),
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 24,
//                       vertical: 15,
//                     ), // optional
//                   ),
//                   child: const Text(
//                     "Add New Record",
//                     style: TextStyle(color: Colors.white),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//       drawer: DashboardDrawer(onItemSelected: _handleDrawerItem),
//     );
//   }
// }
