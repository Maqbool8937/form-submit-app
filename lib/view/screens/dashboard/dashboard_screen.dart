import 'package:flutter/material.dart';
import 'package:form_submit_app/view/screens/dashboard/list_form_screen.dart';
import 'package:form_submit_app/view/widgets/dashboard_drawer.dart';
import 'package:get/get.dart';

import 'package:form_submit_app/controllers/getxControllers/dashboard_controller.dart';
import 'package:form_submit_app/view/widgets/kpi_card.dart';
import 'package:form_submit_app/view/widgets/help_card_widget.dart';
import 'package:form_submit_app/view/widgets/crime_card_widget.dart';

class DashboardScreen extends StatefulWidget {
  final Map<String, dynamic> userData;
  const DashboardScreen({Key? key, required this.userData}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late final DashboardController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(DashboardController(widget.userData));
  }

  Future<void> _pickDate({required bool isStart}) async {
    DateTime now = DateTime.now();
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked == null) return;
    final cleanDate = DateTime(picked.year, picked.month, picked.day);
    if (isStart) {
      controller.setStartDate(cleanDate);
    } else {
      controller.setEndDate(
        cleanDate.add(const Duration(hours: 23, minutes: 59, seconds: 59)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.red,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: const Text(
          "Dashboard",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Obx(() {
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(height: size.height * 0.03),

              /// 📅 Filter Row
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _pickDate(isStart: true),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          controller.startDate.value != null
                              ? controller.formatter.format(
                                  controller.startDate.value!,
                                )
                              : "Start Date",
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _pickDate(isStart: false),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          controller.endDate.value != null
                              ? controller.formatter.format(
                                  controller.endDate.value!,
                                )
                              : "End Date",
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    height: size.height * 0.06,
                    width: size.width * 0.18,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextButton(
                      onPressed: controller.isLoading.value
                          ? null
                          : controller.filterAllCollections,
                      child: controller.isLoading.value
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(
                              Icons.search,
                              color: Colors.white,
                              size: 24,
                            ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              /// Header Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "Heads",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    "Counts",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              /// Cards Section
              KpiCard(mediaquerysize: size, controller: controller),
              const SizedBox(height: 8),
              HelpCard(mediaquerysize: size, controller: controller),
              const SizedBox(height: 8),
              CrimeCard(mediaquerysize: size, controller: controller),

              const SizedBox(height: 60),
            ],
          ),
        );
      }),

      /// 🟢 Bottom Add Record Button
      bottomSheet: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 50, left: 15, right: 15),
          child: SizedBox(
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
                  await controller.filterAllCollections();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text(
                "Add New Record",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        ),
      ),
      drawer: DashboardDrawer(
        userData: widget.userData,
        onItemSelected: (item) => controller.handleDrawerItem(item),
      ),
      //       drawer: Dashboardr(
      //   userData: widget.userData,
      //   onItemSelected: controller.handleDrawerItem,
      // ),
    );
  }
}
    


  


  





// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:form_submit_app/controllers/getxControllers/dashboard_controller.dart';
// import 'package:form_submit_app/view/screens/dashboard/crime_detail_screen.dart';
// import 'package:form_submit_app/view/screens/dashboard/help_detail_screen.dart';
// import 'package:form_submit_app/view/screens/dashboard/kpi_detail_screen.dart';
// import 'package:form_submit_app/view/screens/dashboard/list_form_screen.dart';
// import 'package:form_submit_app/view/widgets/crime_card_widget.dart';
// import 'package:form_submit_app/view/widgets/dashboard_drawer.dart';
// import 'package:form_submit_app/view/widgets/help_card_widget.dart';
// import 'package:form_submit_app/view/widgets/kpi_card.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';

// class DashboardScreen extends StatefulWidget {
//   final Map<String, dynamic> userData;

//   const DashboardScreen({Key? key, required this.userData}) : super(key: key);

//   @override
//   State<DashboardScreen> createState() => _DashboardScreenState();
// }

// class _DashboardScreenState extends State<DashboardScreen> {
//   late final DashboardController controller;

//   @override
//   void initState() {
//     super.initState();
//     controller = Get.put(DashboardController(widget.userData));
//   }

//   /// 📅 Pick Date (Start or End)
//   Future<void> _pickDate({required bool isStart}) async {
//     DateTime now = DateTime.now();

//     DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: now,
//       firstDate: DateTime(2020),
//       lastDate: DateTime(2100),
//     );

//     if (picked == null) return;

//     final cleanDate = DateTime(picked.year, picked.month, picked.day);

//     if (isStart) {
//       controller.setStartDate(cleanDate);
//     } else {
//       controller.setEndDate(
//         cleanDate.add(const Duration(hours: 23, minutes: 59, seconds: 59)),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;

//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         iconTheme: const IconThemeData(color: Colors.white),
//         centerTitle: true,
//         title: const Text(
//           "Dashboard",
//           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//         ),
//         backgroundColor: Colors.red,
//       ),
      // drawer: Dashboardr(
      //   userData: widget.userData,
      //   onItemSelected: controller.handleDrawerItem,
      // ),

//       /// 🧠 Main Body
//       body: Obx(
//         () => SingleChildScrollView(
//           padding: const EdgeInsets.symmetric(horizontal: 20),
//           child: Column(
//             children: [
//               SizedBox(height: size.height * 0.03),

//               /// 📅 Date Filters
//               Row(
//                 children: [
//                   Expanded(
//                     child: GestureDetector(
//                       onTap: () => _pickDate(isStart: true),
//                       child: Container(
//                         padding: const EdgeInsets.all(12),
//                         decoration: BoxDecoration(
//                           border: Border.all(color: Colors.grey),
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: Text(
//                           controller.startDate.value != null
//                               ? controller.formatter.format(
//                                   controller.startDate.value!,
//                                 )
//                               : "Start Date",
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   Expanded(
//                     child: GestureDetector(
//                       onTap: () => _pickDate(isStart: false),
//                       child: Container(
//                         padding: const EdgeInsets.all(12),
//                         decoration: BoxDecoration(
//                           border: Border.all(color: Colors.grey),
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: Text(
//                           controller.endDate.value != null
//                               ? controller.formatter.format(
//                                   controller.endDate.value!,
//                                 )
//                               : "End Date",
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 8),

//                   /// 🔍 Search Button (kept!)
//                   Container(
//                     height: size.height * 0.06,
//                     width: size.width * 0.18,
//                     decoration: BoxDecoration(
//                       color: Colors.blue,
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: TextButton(
//                       onPressed: controller.isLoading.value
//                           ? null
//                           : controller.filterAllCollections,
//                       child: controller.isLoading.value
//                           ? const SizedBox(
//                               width: 18,
//                               height: 18,
//                               child: CircularProgressIndicator(
//                                 strokeWidth: 2,
//                                 color: Colors.white,
//                               ),
//                             )
//                           : const Icon(
//                               Icons.search,
//                               color: Colors.white,
//                               size: 24,
//                             ),
//                     ),
//                   ),
//                 ],
//               ),

//               const SizedBox(height: 20),

//               /// 🔹 Header Row
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: const [
//                   Text(
//                     "Heads",
//                     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//                   ),
//                   Text(
//                     "Counts",
//                     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 8),

//               /// 🔹 Cards for each form
//               KpiCard(mediaquerysize: size),
//               const SizedBox(height: 8),
//               HelpCard(mediaquerysize: size),
//               const SizedBox(height: 8),
//               CrimeCard(mediaquerysize: size),

//               const SizedBox(height: 16),

//               /// 🔹 Filtered Records Section
//               if (controller.isLoading.value)
//                 const Padding(
//                   padding: EdgeInsets.symmetric(vertical: 20),
//                   child: CircularProgressIndicator(),
//                 )
//               else if (controller.records.isEmpty)
//                 const Padding(
//                   padding: EdgeInsets.only(top: 20),
//                   child: Text(
//                     "No records found for selected dates.",
//                     style: TextStyle(color: Colors.grey),
//                   ),
//                 )
//               else
//                 ListView.builder(
//                   shrinkWrap: true,
//                   physics: const NeverScrollableScrollPhysics(),
//                   itemCount: controller.records.length,
//                   itemBuilder: (context, index) {
//                     final record = controller.records[index];
//                     final data = record.data();
//                     final Timestamp? ts =
//                         data['timestamp'] ?? data['createdAt'];
//                     final created = ts != null
//                         ? DateFormat('dd-MM-yyyy').format(ts.toDate())
//                         : 'N/A';
//                     final collectionName = record.reference.parent.id;

//                     return Card(
//                       margin: const EdgeInsets.symmetric(vertical: 6),
//                       elevation: 2,
//                       child: ListTile(
//                         title: Text(data['title'] ?? 'Untitled Record'),
//                         subtitle: Text('Date: $created\nFrom: $collectionName'),
//                         trailing: const Icon(Icons.arrow_forward_ios, size: 16),
//                         onTap: () {
//                           /// ✅ Navigate based on collection
//                           if (collectionName == 'crime_reports') {
//                             Get.to(
//                               () => CrimeDetailScreen(
//                                 collectionName: collectionName,
//                               ),
//                             );
//                           } else if (collectionName == 'help_forms') {
//                             Get.to(
//                               () => HelpDetailScreen(
//                                 collectionName: collectionName,
//                               ),
//                             );
//                           } else if (collectionName == 'kpi_reports') {
//                             Get.to(() => KpiDetailScreen());
//                           } else {
//                             Get.snackbar(
//                               "Unknown Collection",
//                               "No detail screen available for '$collectionName'",
//                               snackPosition: SnackPosition.BOTTOM,
//                               backgroundColor: Colors.redAccent,
//                               colorText: Colors.white,
//                             );
//                           }
//                         },
//                       ),
//                     );
//                   },
//                 ),

//               SizedBox(height: size.height * 0.1),
//             ],
//           ),
//         ),
//       ),

//       /// 🟢 Bottom Add Record Button
//       bottomSheet: Container(
//         color: Colors.white,
//         child: Padding(
//           padding: const EdgeInsets.only(bottom: 50, left: 15, right: 15),
//           child: SizedBox(
//             width: double.infinity,
//             child: ElevatedButton(
//               onPressed: () async {
//                 bool? didSave = await Navigator.push<bool>(
//                   context,
//                   MaterialPageRoute(
//                     builder: (_) => const InspectVehicleFormScreen(),
//                   ),
//                 );
//                 if (didSave == true) {
//                   await controller.filterAllCollections();
//                 }
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.green,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(6),
//                 ),
//                 padding: const EdgeInsets.symmetric(vertical: 14),
//               ),
//               child: const Text(
//                 "Add New Record",
//                 style: TextStyle(color: Colors.white, fontSize: 16),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

























// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:form_submit_app/controllers/getxControllers/dashboard_controller.dart';
// import 'package:form_submit_app/view/screens/dashboard/crime_detail_screen.dart';
// import 'package:form_submit_app/view/screens/dashboard/help_detail_screen.dart';
// import 'package:form_submit_app/view/screens/dashboard/kpi_detail_screen.dart';
// import 'package:form_submit_app/view/screens/dashboard/list_form_screen.dart';
// import 'package:form_submit_app/view/widgets/crime_card_widget.dart';
// import 'package:form_submit_app/view/widgets/dashboard_drawer.dart';
// import 'package:form_submit_app/view/widgets/help_card_widget.dart';
// import 'package:form_submit_app/view/widgets/kpi_card.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';

// class DashboardScreen extends StatefulWidget {
//   final Map<String, dynamic> userData;

//   const DashboardScreen({Key? key, required this.userData}) : super(key: key);

//   @override
//   State<DashboardScreen> createState() => _DashboardScreenState();
// }

// class _DashboardScreenState extends State<DashboardScreen> {
//   late final DashboardController controller;

//   @override
//   void initState() {
//     super.initState();
//     controller = Get.put(DashboardController(widget.userData));
//   }

//   /// 📅 Pick Date (Start or End)
//   Future<void> _pickDate({required bool isStart}) async {
//     DateTime now = DateTime.now();

//     DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: now,
//       firstDate: DateTime(2020),
//       lastDate: DateTime(2100),
//     );

//     if (picked == null) return;

//     final cleanDate = DateTime(picked.year, picked.month, picked.day);

//     if (isStart) {
//       controller.setStartDate(cleanDate);
//     } else {
//       controller.setEndDate(
//         cleanDate.add(const Duration(hours: 23, minutes: 59)),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;

//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         iconTheme: const IconThemeData(color: Colors.white),
//         centerTitle: true,
//         title: const Text(
//           "Dashboard",
//           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//         ),
//         backgroundColor: Colors.red,
//       ),
//       r: DashboardDrawer(
//         userData: widget.userData,
//         onItemSelected: controller.handleDrawerItem,
//       ),
//       body: Obx(
//         () => SingleChildScrollView(
//           padding: const EdgeInsets.symmetric(horizontal: 20),
//           child: Column(
//             children: [
//               SizedBox(height: size.height * 0.03),

//               /// 📅 Date Filters
//               Row(
//                 children: [
//                   Expanded(
//                     child: GestureDetector(
//                       onTap: () => _pickDate(isStart: true),
//                       child: Container(
//                         padding: const EdgeInsets.all(12),
//                         decoration: BoxDecoration(
//                           border: Border.all(color: Colors.grey),
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: Text(
//                           controller.startDate.value != null
//                               ? controller.formatter.format(
//                                   controller.startDate.value!,
//                                 )
//                               : "Start Date",
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   Expanded(
//                     child: GestureDetector(
//                       onTap: () => _pickDate(isStart: false),
//                       child: Container(
//                         padding: const EdgeInsets.all(12),
//                         decoration: BoxDecoration(
//                           border: Border.all(color: Colors.grey),
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: Text(
//                           controller.endDate.value != null
//                               ? controller.formatter.format(
//                                   controller.endDate.value!,
//                                 )
//                               : "End Date",
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   Container(
//                     height: size.height * 0.06,
//                     width: size.width * 0.20,
//                     decoration: BoxDecoration(
//                       color: Colors.blue,
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: TextButton(
//                       onPressed: controller.isLoading.value
//                           ? null
//                           : controller.filterAllCollections,
//                       child: controller.isLoading.value
//                           ? const SizedBox(
//                               width: 18,
//                               height: 18,
//                               child: CircularProgressIndicator(
//                                 strokeWidth: 2,
//                                 color: Colors.white,
//                               ),
//                             )
//                           : const Icon(
//                               Icons.search,
//                               color: Colors.white,
//                               size: 26,
//                             ),
//                     ),
//                   ),
//                 ],
//               ),

//               const SizedBox(height: 20),

//               /// 🔹 Heads Section
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: const [
//                   Text(
//                     "Heads",
//                     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//                   ),
//                   Text(
//                     "Counts",
//                     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 8),

//               /// 🔹 Form Head Cards
//               KpiCard(mediaquerysize: size),
//               const SizedBox(height: 8),
//               HelpCard(mediaquerysize: size),
//               const SizedBox(height: 8),
//               CrimeCard(mediaquerysize: size),
//               const SizedBox(height: 16),

//               /// 🔹 Filtered Records Section
//               if (controller.isLoading.value)
//                 const Padding(
//                   padding: EdgeInsets.symmetric(vertical: 20),
//                   child: CircularProgressIndicator(),
//                 )
//               else if (controller.records.isEmpty)
//                 const Padding(
//                   padding: EdgeInsets.only(top: 20),
//                   child: Text("No records found for selected dates."),
//                 )
//               else
//                 ListView.builder(
//                   shrinkWrap: true,
//                   physics: const NeverScrollableScrollPhysics(),
//                   itemCount: controller.records.length,
//                   itemBuilder: (context, index) {
//                     final record = controller.records[index];
//                     final data = record.data();
//                     final ts = data['timestamp'] as Timestamp?;
//                     final created = ts != null
//                         ? DateFormat('dd-MM-yyyy').format(ts.toDate())
//                         : 'N/A';
//                     final collectionName = record.reference.parent.id;

//                     return Card(
//                       margin: const EdgeInsets.symmetric(vertical: 6),
//                       elevation: 2,
//                       child: ListTile(
//                         title: Text(data['title'] ?? 'Untitled Record'),
//                         subtitle: Text('Date: $created\nFrom: $collectionName'),
//                         trailing: const Icon(Icons.arrow_forward_ios, size: 16),
//                         onTap: () {
//                           // ✅ Navigate dynamically based on collection
//                           if (collectionName == 'crime_reports') {
//                             Get.to(
//                               () => CrimeDetailScreen(
//                                 collectionName: collectionName,
//                               ),
//                             );
//                           } else if (collectionName == 'help_forms') {
//                             Get.to(
//                               () => HelpDetailScreen(
//                                 collectionName: collectionName,
//                               ),
//                             );
//                           } else if (collectionName == 'kpi_reports') {
//                             Get.to(() => KpiDetailScreen());
//                           } else {
//                             Get.snackbar(
//                               "Unknown Collection",
//                               "No detail screen available for '$collectionName'",
//                               snackPosition: SnackPosition.BOTTOM,
//                               backgroundColor: Colors.redAccent,
//                               colorText: Colors.white,
//                             );
//                           }
//                         },
//                       ),
//                     );
//                   },
//                 ),

//               SizedBox(height: size.height * 0.1),
//             ],
//           ),
//         ),
//       ),
//       bottomSheet: Container(
//         color: Colors.white,
//         child: Padding(
//           padding: const EdgeInsets.only(bottom: 50, left: 15, right: 15),
//           child: SizedBox(
//             width: double.infinity,
//             child: ElevatedButton(
//               onPressed: () async {
//                 bool? didSave = await Navigator.push<bool>(
//                   context,
//                   MaterialPageRoute(
//                     builder: (_) => const InspectVehicleFormScreen(),
//                   ),
//                 );
//                 if (didSave == true) await controller.filterAllCollections();
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.green,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(6),
//                 ),
//                 padding: const EdgeInsets.symmetric(vertical: 14),
//               ),
//               child: const Text(
//                 "Add New Record",
//                 style: TextStyle(color: Colors.white, fontSize: 16),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

 















