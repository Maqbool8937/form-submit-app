import 'package:flutter/material.dart';
import 'package:form_submit_app/controllers/getxControllers/crime_report_controller.dart';
import 'package:get/get.dart';
import 'package:form_submit_app/view/widgets/custom_button.dart';

class CrimeReportForm extends StatelessWidget {
  const CrimeReportForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CrimeReportController());

    return Scaffold(
      appBar: AppBar(
        title: const Text("Crime Report Form"),
        backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),

              // 🔹 Region Dropdown
              Obx(
                () => DropdownButtonFormField<String>(
                  value: controller.selectedRegion.value,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Select Region",
                  ),
                  items: controller.regionData.keys
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (val) {
                    controller.selectedRegion.value = val;
                    controller.selectedDistrict.value = null;
                    controller.selectedPost.value = null;
                    controller.selectedShiftIncharge.value = null;
                  },
                ),
              ),
              const SizedBox(height: 10),

              // 🔹 District Dropdown
              Obx(
                () => controller.selectedRegion.value == null
                    ? const SizedBox()
                    : DropdownButtonFormField<String>(
                        value: controller.selectedDistrict.value,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Select District",
                        ),
                        items: controller
                            .regionData[controller.selectedRegion.value]!
                            .keys
                            .map(
                              (e) => DropdownMenuItem(value: e, child: Text(e)),
                            )
                            .toList(),
                        onChanged: (val) {
                          controller.selectedDistrict.value = val;
                          controller.selectedPost.value = null;
                          controller.selectedShiftIncharge.value = null;
                        },
                      ),
              ),
              const SizedBox(height: 10),

              // 🔹 Post Dropdown
              Obx(
                () => controller.selectedDistrict.value == null
                    ? const SizedBox()
                    : DropdownButtonFormField<String>(
                        value: controller.selectedPost.value,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Select PHP Post",
                        ),
                        items: controller
                            .regionData[controller
                                .selectedRegion
                                .value]![controller.selectedDistrict.value]!
                            .map(
                              (e) => DropdownMenuItem(value: e, child: Text(e)),
                            )
                            .toList(),
                        onChanged: (val) {
                          controller.selectedPost.value = val;
                          controller.selectedShiftIncharge.value = null;
                        },
                      ),
              ),
              const SizedBox(height: 10),

              // 🔹 Shift Incharge Dropdown
              Obx(
                () => controller.selectedPost.value == null
                    ? const SizedBox()
                    : DropdownButtonFormField<String>(
                        value: controller.selectedShiftIncharge.value,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Select Shift Incharge",
                        ),
                        items:
                            (controller.shiftInchargeData[controller
                                        .selectedPost
                                        .value] ??
                                    [])
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e),
                                  ),
                                )
                                .toList(),
                        onChanged: (val) =>
                            controller.selectedShiftIncharge.value = val,
                      ),
              ),
              const SizedBox(height: 10),

              // 🔹 GPS Section
              Obx(
                () => Row(
                  children: [
                    Expanded(
                      child: Text(
                        controller.gpsLocation.value ?? "GPS not set",
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: controller.isFetchingLocation.value
                          ? null
                          : controller.getCurrentLocation,
                      icon: controller.isFetchingLocation.value
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.my_location),
                      label: Text(
                        controller.isFetchingLocation.value
                            ? "Locating..."
                            : "Set GPS",
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // 🔹 All Text Fields
              // _buildTextField(controller.cnicController, "CNIC"),
              _buildDropdown(controller.sourceInfo, "Source of Intimation", [
                "1124",
                "15",
                "Routine Patrolling",
                "Private Person",
              ]),
              _buildDropdown(controller.crimeHead, "Crime Head", [
                "Dacoity/Robbery with Murder",
                "Dacoity/Robbery with Injury",
                "Dacoity",
                "Highway Robbery",
                "MV Snatching",
                "Kidnapping",
                "Murder",
                "Attempt Murder",
                "Rape",
                "Police Encounter",
                "Other",
              ]),
              _buildTextField(controller.placeController, "Place of Incident"),
              _buildTextField(
                controller.informerController,
                "Informer Details",
              ),
              _buildTextField(
                controller.stolenSnatchedController,
                "Stolen / Snatched",
              ),
              _buildDropdown(controller.victimStatus, "Victim Status", [
                "Safe",
                "Injured",
                "Death",
              ]),
              _buildTextField(
                controller.accusedCountController,
                "Number of Accused",
                type: TextInputType.number,
              ),
              _buildTextField(
                controller.accusedArrestedController,
                "Accused Arrested",
              ),
              _buildDropdown(controller.weapon, "Weapon Used", [
                "Pistol",
                "Rifle",
                "Gun",
                "Kalashankove",
                "Other",
              ]),
              _buildDropdown(controller.vehicle, "Vehicle Used", [
                "MC",
                "Car",
                "Rickshaw",
                "Hiace",
                "Hilux",
                "Shahzor",
                "Bus",
                "Mazda",
                "Truck",
                "Troller",
                "Pedestrian",
                "Other",
              ]),
              _buildDropdown(controller.firstResponder, "First Responder", [
                "PHP",
                "Local Police",
                "Traffic Police",
              ]),
              _buildDropdown(controller.responseTime, "Response Time", [
                "Less than 10 Min",
                "Less than 15 Min",
                "Less than 30 Min",
                "One Hour",
              ]),
              _buildTextField(
                controller.descriptionController,
                "Brief Description",
                maxLines: 3,
              ),
              _buildTextField(
                controller.actionController,
                "Action Taken",
                maxLines: 3,
              ),
              _buildTextField(controller.firNoController, "FIR No. / E-TAG"),
              _buildTextField(
                controller.firDateController,
                "Date of FIR / E-TAG",
              ),
              _buildTextField(
                controller.firSectionsController,
                "Sections of FIR",
              ),
              _buildTextField(
                controller.policeStationController,
                "Police Station",
              ),

              const SizedBox(height: 20),

              Obx(
                () => CustomButton(
                  name: controller.isSubmitting.value
                      ? "Submitting..."
                      : "Submit Report",
                  onTap: controller.isSubmitting.value
                      ? null
                      : () => controller.submitForm(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    TextInputType type = TextInputType.text,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        controller: controller,
        keyboardType: type,
        maxLines: maxLines,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: label,
        ),
        validator: (val) =>
            val == null || val.isEmpty ? "Required field" : null,
      ),
    );
  }

  Widget _buildDropdown(
    RxString selectedValue,
    String label,
    List<String> items,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Obx(
        () => DropdownButtonFormField<String>(
          value: selectedValue.value,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: label,
          ),
          items: items
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: (val) => selectedValue.value = val!,
        ),
      ),
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:form_submit_app/view/screens/dashboard/dashboard_screen.dart';
// import 'package:get/get.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:form_submit_app/view/widgets/custom_button.dart';
// import 'package:form_submit_app/view/screens/dashboard/list_form_screen.dart';

// class CrimeReportForm extends StatefulWidget {
//   const CrimeReportForm({super.key});

//   @override
//   State<CrimeReportForm> createState() => _CrimeReportFormState();
// }

// class _CrimeReportFormState extends State<CrimeReportForm> {
//   final _formKey = GlobalKey<FormState>();

//   // Text Controllers
//   final TextEditingController cnicController = TextEditingController();
//   final TextEditingController placeController = TextEditingController();
//   final TextEditingController informerController = TextEditingController();
//   final TextEditingController stolenSnatchedController =
//       TextEditingController();
//   final TextEditingController accusedCountController = TextEditingController();
//   final TextEditingController accusedArrestedController =
//       TextEditingController();
//   final TextEditingController descriptionController = TextEditingController();
//   final TextEditingController actionController = TextEditingController();
//   final TextEditingController firNoController = TextEditingController();
//   final TextEditingController firDateController = TextEditingController();
//   final TextEditingController firSectionsController = TextEditingController();
//   final TextEditingController policeStationController = TextEditingController();

//   // Dropdown default values
//   String sourceInfo = "1124";
//   String crimeHead = "Murder";
//   String victimStatus = "Safe";
//   String weapon = "Pistol";
//   String vehicle = "Car";
//   String firstResponder = "PHP";
//   String responseTime = "Less than 10 Min";

//   // Dynamic dropdowns for region → district → post → incharge
//   String? selectedRegion;
//   String? selectedDistrict;
//   String? selectedPost;
//   String? selectedShiftIncharge;

//   // GPS variables
//   String? gpsLocation;
//   bool isFetchingLocation = false;

//   // Region → District → Post data
//   final Map<String, Map<String, List<String>>> regionData = {
//     "LHR": {
//       "SKP": ["Post 1", "Post 2"],
//       "NNK": ["Post 3", "Post 4"],
//       "LHR": ["Post 5"],
//       "KSR": ["Post 6"],
//       "OKR": ["Post 7"],
//     },
//     "DGK": {
//       "DGK": ["Post 8"],
//       "MLT": ["Post 9", "Post 10"],
//     },
//     "FSD": {
//       "FSD": ['KAMALPUR', 'AMINPUR BYPASS', 'PAINSRA'],
//       "TTS": ["Post 12"],
//     },
//   };

//   // Shift Incharge data
//   final Map<String, List<String>> shiftInchargeData = {
//     "PAINSRA": ["Insp. Ali", 'ASGHAR SI'],
//     "Post 2": ["Insp. Kamran"],
//     "Post 3": ["Insp. Bilal"],
//     "Post 4": ["Insp. Hassan"],
//     "Post 5": ["Insp. John"],
//     "Post 6": ["Insp. Qasim"],
//     "Post 7": ["Insp. Imran"],
//     "Post 8": ["Insp. Usman"],
//     "Post 9": ["Insp. Javed"],
//     "Post 10": ["Insp. Kashif"],
//     "Post 11": ["Insp. Zain"],
//     "Post 12": ["Insp. Salman"],
//   };

//   @override
//   void initState() {
//     super.initState();
//     _getCurrentLocation();
//   }

//   /// 📍 Fetch Live GPS Location
//   Future<void> _getCurrentLocation() async {
//     setState(() => isFetchingLocation = true);

//     try {
//       bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//       if (!serviceEnabled) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Location services are disabled.")),
//         );
//         setState(() => isFetchingLocation = false);
//         return;
//       }

//       LocationPermission permission = await Geolocator.checkPermission();
//       if (permission == LocationPermission.denied) {
//         permission = await Geolocator.requestPermission();
//       }

//       if (permission == LocationPermission.denied ||
//           permission == LocationPermission.deniedForever) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Location permission denied.")),
//         );
//         setState(() => isFetchingLocation = false);
//         return;
//       }

//       Geolocator.getPositionStream(
//         locationSettings: const LocationSettings(
//           accuracy: LocationAccuracy.high,
//           distanceFilter: 5,
//         ),
//       ).listen((Position position) {
//         setState(() {
//           gpsLocation =
//               "${position.latitude.toStringAsFixed(5)}, ${position.longitude.toStringAsFixed(5)}";
//         });
//       });
//     } catch (e) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text("Error getting location: $e")));
//     } finally {
//       setState(() => isFetchingLocation = false);
//     }
//   }

//   /// 📤 Submit Form
//   Future<void> submitForm() async {
//     if (_formKey.currentState!.validate()) {
//       if (gpsLocation == null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Please set GPS location first 📍")),
//         );
//         return;
//       }
//       if (selectedRegion == null ||
//           selectedDistrict == null ||
//           selectedPost == null ||
//           selectedShiftIncharge == null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text(
//               "Please select Region, District, Post, and Shift Incharge.",
//             ),
//           ),
//         );
//         return;
//       }

//       try {
//         await FirebaseFirestore.instance.collection("crime_reports").add({
//           "date": DateTime.now().toIso8601String(),
//           "time": TimeOfDay.now().format(context),
//           "region": selectedRegion,
//           "district": selectedDistrict,
//           "php_post": selectedPost,
//           "shift_incharge": selectedShiftIncharge,
//           "cnic": cnicController.text,
//           "source_info": sourceInfo,
//           "crime_head": crimeHead,
//           "place": placeController.text,
//           "gps_location": gpsLocation,
//           "informer": informerController.text,
//           "stolen_snatched": stolenSnatchedController.text,
//           "victim_status": victimStatus,
//           "number_of_accused": accusedCountController.text,
//           "accused_arrested": accusedArrestedController.text,
//           "weapon": weapon,
//           "vehicle": vehicle,
//           "first_responder": firstResponder,
//           "response_time": responseTime,
//           "description": descriptionController.text,
//           "action_taken": actionController.text,
//           "fir_no": firNoController.text,
//           "fir_date": firDateController.text,
//           "fir_sections": firSectionsController.text,
//           "police_station": policeStationController.text,
//         });

//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Crime Report Submitted ✅")),
//         );

//         Get.off(() => DashboardScreen(userData: {}));
//         _formKey.currentState!.reset();
//         setState(() {
//           gpsLocation = null;
//           selectedRegion = null;
//           selectedDistrict = null;
//           selectedPost = null;
//           selectedShiftIncharge = null;
//         });
//       } catch (e) {
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(SnackBar(content: Text("Error: $e")));
//       }
//     }
//   }

//   @override
//   void dispose() {
//     cnicController.dispose();
//     placeController.dispose();
//     informerController.dispose();
//     stolenSnatchedController.dispose();
//     accusedCountController.dispose();
//     accusedArrestedController.dispose();
//     descriptionController.dispose();
//     actionController.dispose();
//     firNoController.dispose();
//     firDateController.dispose();
//     firSectionsController.dispose();
//     policeStationController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           onPressed: () {
//             Get.off(() => InspectVehicleFormScreen());
//           },
//           icon: Icon(Icons.arrow_back),
//         ),
//         title: const Text("Crime Report Form"),
//         backgroundColor: Colors.red,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               const SizedBox(height: 10),

//               /// Region Dropdown
//               DropdownButtonFormField<String>(
//                 value: selectedRegion,
//                 decoration: const InputDecoration(
//                   border: OutlineInputBorder(),
//                   labelText: "Select Region",
//                 ),
//                 items: regionData.keys
//                     .map((e) => DropdownMenuItem(value: e, child: Text(e)))
//                     .toList(),
//                 onChanged: (val) {
//                   setState(() {
//                     selectedRegion = val;
//                     selectedDistrict = null;
//                     selectedPost = null;
//                     selectedShiftIncharge = null;
//                   });
//                 },
//               ),
//               const SizedBox(height: 10),

//               /// District Dropdown
//               if (selectedRegion != null)
//                 DropdownButtonFormField<String>(
//                   value: selectedDistrict,
//                   decoration: const InputDecoration(
//                     border: OutlineInputBorder(),
//                     labelText: "Select District",
//                   ),
//                   items: regionData[selectedRegion]!.keys
//                       .map((e) => DropdownMenuItem(value: e, child: Text(e)))
//                       .toList(),
//                   onChanged: (val) {
//                     setState(() {
//                       selectedDistrict = val;
//                       selectedPost = null;
//                       selectedShiftIncharge = null;
//                     });
//                   },
//                 ),
//               const SizedBox(height: 10),

//               /// Post Dropdown
//               if (selectedDistrict != null)
//                 DropdownButtonFormField<String>(
//                   value: selectedPost,
//                   decoration: const InputDecoration(
//                     border: OutlineInputBorder(),
//                     labelText: "Select PHP Post",
//                   ),
//                   items: regionData[selectedRegion]![selectedDistrict]!
//                       .map((e) => DropdownMenuItem(value: e, child: Text(e)))
//                       .toList(),
//                   onChanged: (val) {
//                     setState(() {
//                       selectedPost = val;
//                       selectedShiftIncharge = null;
//                     });
//                   },
//                 ),
//               const SizedBox(height: 10),

//               /// Shift Incharge Dropdown
//               if (selectedPost != null)
//                 DropdownButtonFormField<String>(
//                   value: selectedShiftIncharge,
//                   decoration: const InputDecoration(
//                     border: OutlineInputBorder(),
//                     labelText: "Select Shift Incharge",
//                   ),
//                   items: (shiftInchargeData[selectedPost] ?? [])
//                       .map((e) => DropdownMenuItem(value: e, child: Text(e)))
//                       .toList(),
//                   onChanged: (val) =>
//                       setState(() => selectedShiftIncharge = val),
//                 ),
//               const SizedBox(height: 10),

//               /// GPS Section
//               Row(
//                 children: [
//                   Expanded(
//                     child: Text(
//                       gpsLocation ?? "GPS not set",
//                       style: const TextStyle(fontSize: 14),
//                     ),
//                   ),
//                   ElevatedButton.icon(
//                     onPressed: isFetchingLocation ? null : _getCurrentLocation,
//                     icon: isFetchingLocation
//                         ? const SizedBox(
//                             width: 16,
//                             height: 16,
//                             child: CircularProgressIndicator(strokeWidth: 2),
//                           )
//                         : const Icon(Icons.my_location),
//                     label: Text(isFetchingLocation ? "Locating..." : "Set GPS"),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 10),

//               /// Remaining Fields
//               _buildTextField(cnicController, "CNIC"),
//               _buildDropdown(
//                 sourceInfo,
//                 "Source of Intimation",
//                 ["1124", "15", "Routine Patrolling", "Private Person"],
//                 (val) => setState(() => sourceInfo = val!),
//               ),
//               _buildDropdown(crimeHead, "Crime Head", [
//                 "Dacoity/Robbery with Murder",
//                 "Dacoity/Robbery with Injury",
//                 "Dacoity",
//                 "Highway Robbery",
//                 "MV Snatching",
//                 "Kidnapping",
//                 "Murder",
//                 "Attempt Murder",
//                 "Rape",
//                 "Police Encounter",
//                 "Other",
//               ], (val) => setState(() => crimeHead = val!)),
//               _buildTextField(placeController, "Place of Incident (Landmark)"),
//               _buildTextField(informerController, "Informer Details"),
//               _buildTextField(stolenSnatchedController, "Stolen / Snatched"),
//               _buildDropdown(
//                 victimStatus,
//                 "Victim Status",
//                 ["Safe", "Injured", "Death"],
//                 (val) => setState(() => victimStatus = val!),
//               ),
//               _buildTextField(
//                 accusedCountController,
//                 "Number of Accused",
//                 type: TextInputType.number,
//               ),
//               _buildTextField(accusedArrestedController, "Accused Arrested"),
//               _buildDropdown(weapon, "Weapon Used", [
//                 "Pistol",
//                 "Rifle",
//                 "Gun",
//                 "Kalashankove",
//                 "Other",
//               ], (val) => setState(() => weapon = val!)),
//               _buildDropdown(vehicle, "Vehicle Used", [
//                 "MC",
//                 "Car",
//                 "Rickshaw",
//                 "Hiace",
//                 "Hilux",
//                 "Shahzor",
//                 "Bus",
//                 "Mazda",
//                 "Truck",
//                 "Troller",
//                 "Pedestrian",
//                 "Other",
//               ], (val) => setState(() => vehicle = val!)),
//               _buildDropdown(
//                 firstResponder,
//                 "First Responder",
//                 ["PHP", "Local Police", "Traffic Police"],
//                 (val) => setState(() => firstResponder = val!),
//               ),
//               _buildDropdown(
//                 responseTime,
//                 "Response Time",
//                 [
//                   "Less than 10 Min",
//                   "Less than 15 Min",
//                   "Less than 30 Min",
//                   "One Hour",
//                 ],
//                 (val) => setState(() => responseTime = val!),
//               ),
//               _buildTextField(
//                 descriptionController,
//                 "Brief Description",
//                 maxLines: 3,
//               ),
//               _buildTextField(
//                 actionController,
//                 "Action Taken by Officer",
//                 maxLines: 3,
//               ),
//               _buildTextField(firNoController, "FIR No. / E-TAG"),
//               _buildTextField(firDateController, "Date of FIR / E-TAG"),
//               _buildTextField(firSectionsController, "Sections of FIR"),
//               _buildTextField(policeStationController, "Police Station"),

//               const SizedBox(height: 20),
//               CustomButton(name: 'Submit Report', onTap: submitForm),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   /// Utility Widgets
//   Widget _buildTextField(
//     TextEditingController controller,
//     String label, {
//     TextInputType type = TextInputType.text,
//     int maxLines = 1,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 10),
//       child: TextFormField(
//         controller: controller,
//         keyboardType: type,
//         maxLines: maxLines,
//         decoration: InputDecoration(
//           border: const OutlineInputBorder(),
//           labelText: label,
//         ),
//         validator: (val) =>
//             val == null || val.isEmpty ? "Required field" : null,
//       ),
//     );
//   }

//   Widget _buildDropdown(
//     String value,
//     String label,
//     List<String> items,
//     ValueChanged<String?> onChanged,
//   ) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 10),
//       child: DropdownButtonFormField<String>(
//         value: value,
//         decoration: InputDecoration(
//           border: const OutlineInputBorder(),
//           labelText: label,
//         ),
//         items: items
//             .map((e) => DropdownMenuItem(value: e, child: Text(e)))
//             .toList(),
//         onChanged: onChanged,
//       ),
//     );
//   }
// }








