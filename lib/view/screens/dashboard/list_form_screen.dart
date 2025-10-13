import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_submit_app/controllers/getxControllers/inspect_vehical_controller.dart';
import 'package:form_submit_app/forms/crime_report_form.dart';
import 'package:form_submit_app/forms/help_form.dart';
import 'package:form_submit_app/view/screens/dashboard/dashboard_screen.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class InspectVehicleFormScreen extends StatelessWidget {
  const InspectVehicleFormScreen({Key? key}) : super(key: key);

  Future<void> _launchExternalUrl(String url) async {
    final Uri uri = Uri.parse(url);
    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched) {
        Get.snackbar('Error', 'Could not launch $url');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to open link: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(InspectVehicleController());
    final mediaquerysize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.off(() => DashboardScreen(userData: {})),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        centerTitle: true,
        title: const Text(
          "List of Forms",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () =>
                    _launchExternalUrl('https://phpkpis.phppolice.com'),
                child: Card(
                  child: Container(
                    height: mediaquerysize.height * 0.07,
                    width: mediaquerysize.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: const Center(
                      child: Text(
                        'Road Safety KPI',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () => _launchExternalUrl(
                  'https://punjab-tamis.phppolice.com/index.php',
                ),
                child: Card(
                  child: Container(
                    height: mediaquerysize.height * 0.07,
                    width: mediaquerysize.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: const Center(
                      child: Text(
                        'Report an Accident',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () => Get.to(() => const CrimeReportForm()),
                child: Card(
                  child: Container(
                    height: mediaquerysize.height * 0.07.h,
                    width: mediaquerysize.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: const Center(
                      child: Text(
                        'Report a Crime',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () => Get.to(() => const HelpForm()),
                child: Card(
                  child: Container(
                    height: mediaquerysize.height * 0.07.h,
                    width: mediaquerysize.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: const Center(
                      child: Text(
                        'Report a Help',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // FORM FIELDS
              // Form(
              //   key: controller.formKey,
              //   child: Column(
              //     children: [
              //       TextFormField(
              //         controller: controller.vehicleController,
              //         decoration: const InputDecoration(
              //           labelText: "Vehicle Number",
              //           border: OutlineInputBorder(),
              //         ),
              //         validator: (value) {
              //           if (value == null || value.trim().isEmpty) {
              //             return "Enter vehicle number";
              //           }
              //           return null;
              //         },
              //       ),
              //       const SizedBox(height: 16),
              //       DropdownButtonFormField<String>(
              //         decoration: const InputDecoration(
              //           labelText: "Select Form Type",
              //           border: OutlineInputBorder(),
              //         ),
              //         items: controller.formOptions
              //             .map(
              //               (opt) =>
              //                   DropdownMenuItem(value: opt, child: Text(opt)),
              //             )
              //             .toList(),
              //         onChanged: (value) =>
              //             controller.selectedFormOption.value = value,
              //         validator: (value) {
              //           if (value == null) return "Select a form type";
              //           return null;
              //         },
              //       ),
              //     ],
              //   ),
              // ),
              // const SizedBox(height: 24),
              // Obx(
              //   () => controller.saving.value
              //       ? const CircularProgressIndicator()
              //       : SizedBox(
              //           width: double.infinity,
              //           child: ElevatedButton(
              //             onPressed: controller.saveInspection,
              //             style: ElevatedButton.styleFrom(
              //               backgroundColor: Colors.green,
              //             ),
              //             child: const Text("SAVE"),
              //           ),
              //         ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:form_submit_app/forms/crime_report_form.dart';
// import 'package:form_submit_app/forms/help_form.dart';
// import 'package:get/get.dart';
// import 'package:url_launcher/url_launcher.dart';

// class InspectVehicleFormScreen extends StatefulWidget {
//   const InspectVehicleFormScreen({Key? key}) : super(key: key);

//   @override
//   State<InspectVehicleFormScreen> createState() =>
//       _InspectVehicleFormScreenState();
// }

// class _InspectVehicleFormScreenState extends State<InspectVehicleFormScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _vehicleController = TextEditingController();

//   // options for form type
//   final List<String> _formOptions = [
//     "Repeat a Help",
//     "Repeat an Accident",
//     "Repeat a Crime",
//     // add more if needed
//   ];
//   String? _selectedFormOption;

//   bool _saving = false;

//   @override
//   void dispose() {
//     _vehicleController.dispose();
//     super.dispose();
//   }

//   Future<void> _saveInspection() async {
//     if (!_formKey.currentState!.validate()) return;
//     if (_selectedFormOption == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Please select a form type")),
//       );
//       return;
//     }
//     setState(() {
//       _saving = true;
//     });
//     try {
//       await FirebaseFirestore.instance.collection('inspections').add({
//         'vehicle_no': _vehicleController.text.trim(),
//         'timestamp': Timestamp.now(),
//         'form_type': _selectedFormOption,
//       });
//       setState(() {
//         _saving = false;
//       });
//       // return to previous screen and indicate success
//       Navigator.pop(context, true);
//     } catch (e) {
//       print("Error saving inspection: $e");
//       setState(() {
//         _saving = false;
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Failed to save inspection")),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final mediaquerysize = MediaQuery.of(context).size;
//     return Scaffold(
//       backgroundColor: Colors.grey.shade200,
//       appBar: AppBar(
//         leading: IconButton(
//           onPressed: () {
//             Get.back();
//           },
//           icon: Icon(Icons.arrow_back, color: Colors.white),
//         ),
//         centerTitle: true,
//         title: const Text(
//           "List of Forms",
//           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//         ),
//         backgroundColor: Colors.red,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             const SizedBox(height: 8),
//             GestureDetector(
//               onTap: () async {
//                 final Uri url = Uri.parse('https://phpkpis.phppolice.com');

//                 try {
//                   final launched = await launchUrl(
//                     url,
//                     mode: LaunchMode.externalApplication,
//                   );

//                   if (!launched) {
//                     print('Could not launch $url');
//                     // Optional: Show a Snackbar or Toast
//                   }
//                 } catch (e) {
//                   print('Error launching URL: $e');
//                 }
//               },
//               child: Card(
//                 child: Container(
//                   height: mediaquerysize.height * 0.07,
//                   width: mediaquerysize.width * 1.0,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(10),
//                     color: Colors.white,
//                   ),
//                   child: Center(
//                     child: Text(
//                       'Road Safety KPI',
//                       style: TextStyle(
//                         color: Colors.black,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 15,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),

//             const SizedBox(height: 8),
//             GestureDetector(
//               onTap: () async {
//                 final Uri url = Uri.parse(
//                   'https://punjab-tamis.phppolice.com/index.php',
//                 );

//                 try {
//                   final launched = await launchUrl(
//                     url,
//                     mode: LaunchMode.externalApplication,
//                   );

//                   if (!launched) {
//                     print('Could not launch $url');
//                     // Optional: Show a Snackbar or Toast
//                   }
//                 } catch (e) {
//                   print('Error launching URL: $e');
//                 }
//               },
//               child: Card(
//                 child: Container(
//                   height: mediaquerysize.height * 0.07,
//                   width: mediaquerysize.width * 1.0,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(10),
//                     color: Colors.white,
//                   ),
//                   child: Center(
//                     child: Text(
//                       'Report an Accident',
//                       style: TextStyle(
//                         color: Colors.black,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 15,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),

//             const SizedBox(height: 8),
//             GestureDetector(
//               onTap: () {
//                 Get.to(() => CrimeReportForm());
//               },
//               child: Card(
//                 child: Container(
//                   height: mediaquerysize.height * 0.07.h,
//                   width: mediaquerysize.width * 1.w,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(10),
//                     color: Colors.white,
//                   ),
//                   child: Center(
//                     child: Text(
//                       'Report a Crime',
//                       style: TextStyle(
//                         color: Colors.black,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 15,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 8),
//             GestureDetector(
//               onTap: () {
//                 Get.to(() => HelpForm());
//               },
//               child: Card(
//                 child: Container(
//                   height: mediaquerysize.height * 0.07.h,
//                   width: mediaquerysize.width * 1.w,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(10),
//                     color: Colors.white,
//                   ),
//                   child: Center(
//                     child: Text(
//                       'Report a Help',
//                       style: TextStyle(
//                         color: Colors.black,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 15,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),

//             const SizedBox(height: 8),

//             // Form(
//             //   key: _formKey,
//             //   child: Column(
//             //     children: [
//             //       TextFormField(
//             //         controller: _vehicleController,
//             //         decoration: const InputDecoration(
//             //           labelText: "Vehicle Number",
//             //           border: OutlineInputBorder(),
//             //         ),
//             //         validator: (value) {
//             //           if (value == null || value.trim().isEmpty) {
//             //             return "Enter vehicle number";
//             //           }
//             //           return null;
//             //         },
//             //       ),
//             //       const SizedBox(height: 16),
//             //       DropdownButtonFormField<String>(
//             //         decoration: const InputDecoration(
//             //           labelText: "Select Form Type",
//             //           border: OutlineInputBorder(),
//             //         ),
//             //         items: _formOptions.map((opt) {
//             //           return DropdownMenuItem<String>(
//             //             value: opt,
//             //             child: Text(opt),
//             //           );
//             //         }).toList(),
//             //         onChanged: (value) {
//             //           setState(() {
//             //             _selectedFormOption = value;
//             //           });
//             //         },
//             //         validator: (value) {
//             //           if (value == null) {
//             //             return "Select a form type";
//             //           }
//             //           return null;
//             //         },
//             //       ),
//             //     ],
//             //   ),
//             // ),
//             // const SizedBox(height: 24),
//             // _saving
//             //     ? const CircularProgressIndicator()
//             //     : SizedBox(
//             //         width: double.infinity,
//             //         child: ElevatedButton(
//             //           onPressed: _saveInspection,
//             //           style: ElevatedButton.styleFrom(
//             //             backgroundColor: Colors.green,
//             //           ),
//             //           child: const Text("SAVE"),
//             //         ),
//             //       ),
//           ],
//         ),
//       ),
//     );
//   }
// }
