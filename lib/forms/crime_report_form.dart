import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:form_submit_app/view/widgets/custom_button.dart';
import 'package:form_submit_app/view/screens/dashboard/list_form_screen.dart';

class CrimeReportForm extends StatefulWidget {
  const CrimeReportForm({super.key});

  @override
  State<CrimeReportForm> createState() => _CrimeReportFormState();
}

class _CrimeReportFormState extends State<CrimeReportForm> {
  final _formKey = GlobalKey<FormState>();

  // Text Controllers
  final TextEditingController cnicController = TextEditingController();
  final TextEditingController placeController = TextEditingController();
  final TextEditingController informerController = TextEditingController();
  final TextEditingController stolenSnatchedController =
      TextEditingController();
  final TextEditingController accusedCountController = TextEditingController();
  final TextEditingController accusedArrestedController =
      TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController actionController = TextEditingController();
  final TextEditingController firNoController = TextEditingController();
  final TextEditingController firDateController = TextEditingController();
  final TextEditingController firSectionsController = TextEditingController();
  final TextEditingController policeStationController = TextEditingController();

  // Dropdowns
  String sourceInfo = "1124";
  String crimeHead = "Murder";
  String victimStatus = "Safe";
  String weapon = "Pistol";
  String vehicle = "Car";
  String firstResponder = "PHP";
  String responseTime = "Less than 10 Min";

  // Auto-fetched values (example placeholders)
  String region = "Region A";
  String district = "District B";
  String phpPost = "PHP-Post 1";
  String shiftIncharge = "Inspector John";
  String gpsLocation = "31.5204, 74.3587"; // Example lat-long

  Future<void> submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseFirestore.instance.collection("crime_reports").add({
          "date": DateTime.now().toIso8601String(),
          "time": TimeOfDay.now().format(context),
          "region": region,
          "district": district,
          "php_post": phpPost,
          "shift_incharge": shiftIncharge,
          "cnic": cnicController.text,
          "source_info": sourceInfo,
          "crime_head": crimeHead,
          "place": placeController.text,
          "gps_location": gpsLocation,
          "informer": informerController.text,
          "stolen_snatched": stolenSnatchedController.text,
          "victim_status": victimStatus,
          "number_of_accused": accusedCountController.text,
          "accused_arrested": accusedArrestedController.text,
          "weapon": weapon,
          "vehicle": vehicle,
          "first_responder": firstResponder,
          "response_time": responseTime,
          "description": descriptionController.text,
          "action_taken": actionController.text,
          "fir_no": firNoController.text,
          "fir_date": firDateController.text,
          "fir_sections": firSectionsController.text,
          "police_station": policeStationController.text,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Crime Report Submitted ✅")),
        );

        Get.to(() => const InspectVehicleFormScreen());
        _formKey.currentState!.reset();
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    }
  }

  @override
  void dispose() {
    cnicController.dispose();
    placeController.dispose();
    informerController.dispose();
    stolenSnatchedController.dispose();
    accusedCountController.dispose();
    accusedArrestedController.dispose();
    descriptionController.dispose();
    actionController.dispose();
    firNoController.dispose();
    firDateController.dispose();
    firSectionsController.dispose();
    policeStationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Crime Report Form")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 10),

              // Auto fetched display
              _buildInfoTile("Date", DateTime.now().toString().split(' ')[0]),
              _buildInfoTile("Time", TimeOfDay.now().format(context)),
              _buildInfoTile("Region", region),
              _buildInfoTile("District", district),
              _buildInfoTile("PHP Post", phpPost),
              _buildInfoTile("Shift Incharge", shiftIncharge),
              const SizedBox(height: 10),

              // CNIC
              TextFormField(
                controller: cnicController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "CNIC",
                ),
                validator: (val) =>
                    val == null || val.isEmpty ? "Required field" : null,
              ),
              const SizedBox(height: 10),

              // Source of Intimation
              DropdownButtonFormField<String>(
                value: sourceInfo,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Source of Intimation",
                ),
                items: ["1124", "15", "Routine Patrolling", "Private Person"]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) => setState(() => sourceInfo = val!),
              ),
              const SizedBox(height: 10),

              // Crime Head
              DropdownButtonFormField<String>(
                value: crimeHead,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Crime Head",
                ),
                items:
                    [
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
                        ]
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                onChanged: (val) => setState(() => crimeHead = val!),
              ),
              const SizedBox(height: 10),

              // Place of Incident
              TextFormField(
                controller: placeController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Place of Incident (Landmark)",
                ),
              ),
              const SizedBox(height: 10),

              _buildInfoTile("GPS Location", gpsLocation),

              const SizedBox(height: 10),

              // Informer Details
              TextFormField(
                controller: informerController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Informer Details",
                ),
              ),
              const SizedBox(height: 10),

              // Stolen / Snatched
              TextFormField(
                controller: stolenSnatchedController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Stolen / Snatched",
                ),
              ),
              const SizedBox(height: 10),

              // Victim Status
              DropdownButtonFormField<String>(
                value: victimStatus,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Victim Status",
                ),
                items: ["Safe", "Injured", "Death"]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) => setState(() => victimStatus = val!),
              ),
              const SizedBox(height: 10),

              // Number of Accused
              TextFormField(
                controller: accusedCountController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Number of Accused",
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),

              // Accused Arrested
              TextFormField(
                controller: accusedArrestedController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Accused Arrested",
                ),
              ),
              const SizedBox(height: 10),

              // Weapon Used
              DropdownButtonFormField<String>(
                value: weapon,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Weapon Used",
                ),
                items: ["Pistol", "Rifle", "Gun", "Kalashankove", "Other"]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) => setState(() => weapon = val!),
              ),
              const SizedBox(height: 10),

              // Vehicle Used
              DropdownButtonFormField<String>(
                value: vehicle,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Vehicle Used",
                ),
                items:
                    [
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
                        ]
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                onChanged: (val) => setState(() => vehicle = val!),
              ),
              const SizedBox(height: 10),

              // First Responder
              DropdownButtonFormField<String>(
                value: firstResponder,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "First Responder",
                ),
                items: ["PHP", "Local Police", "Traffic Police"]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) => setState(() => firstResponder = val!),
              ),
              const SizedBox(height: 10),

              // Response Time
              DropdownButtonFormField<String>(
                value: responseTime,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Response Time",
                ),
                items:
                    [
                          "Less than 10 Min",
                          "Less than 15 Min",
                          "Less than 30 Min",
                          "One Hour",
                        ]
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                onChanged: (val) => setState(() => responseTime = val!),
              ),
              const SizedBox(height: 10),

              // Brief Description
              TextFormField(
                controller: descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Brief Description",
                ),
              ),
              const SizedBox(height: 10),

              // Action Taken
              TextFormField(
                controller: actionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Action Taken by Officer",
                ),
              ),
              const SizedBox(height: 10),

              // FIR Details
              TextFormField(
                controller: firNoController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "FIR No. / E-TAG",
                ),
              ),
              const SizedBox(height: 10),

              TextFormField(
                controller: firDateController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Date of FIR / E-TAG",
                ),
              ),
              const SizedBox(height: 10),

              TextFormField(
                controller: firSectionsController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Sections of FIR",
                ),
              ),
              const SizedBox(height: 10),

              TextFormField(
                controller: policeStationController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Police Station",
                ),
              ),

              const SizedBox(height: 20),

              CustomButton(name: 'Submit Report', onTap: submitForm),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoTile(String label, String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text("$label: $value"),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:form_submit_app/view/screens/dashboard/list_form_screen.dart';
// import 'package:form_submit_app/view/widgets/custom_button.dart';
// import 'package:get/get.dart';

// class CrimeReportForm extends StatefulWidget {
//   const CrimeReportForm({super.key});

//   @override
//   State<CrimeReportForm> createState() => _CrimeReportFormState();
// }

// class _CrimeReportFormState extends State<CrimeReportForm> {
//   final _formKey = GlobalKey<FormState>();

//   // Controllers
//   final TextEditingController cnicController = TextEditingController();
//   final TextEditingController placeController = TextEditingController();
//   final TextEditingController informerController = TextEditingController();
//   final TextEditingController descriptionController = TextEditingController();
//   final TextEditingController actionController = TextEditingController();

//   String sourceinfo = "1124";
//   String crimeHead = "Murder";
//   String victimStatus = "Safe";
//   String weapon = "Pistol";
//   String vehicle = "Car";
//   String firstResponder = "PHP";
//   String responseTime = "Less than 10 Min";

//   Future<void> submitForm() async {
//     if (_formKey.currentState!.validate()) {
//       try {
//         await FirebaseFirestore.instance.collection("crime_reports").add({
//           "date": DateTime.now().toIso8601String(),
//           "cnic": cnicController.text,
//           "source_info": sourceinfo,
//           "crime_head": crimeHead,
//           "place": placeController.text,
//           "informer": informerController.text,
//           "victim_status": victimStatus,
//           "weapon": weapon,
//           "vehicle": vehicle,
//           "first_responder": firstResponder,
//           "response_time": responseTime,
//           "description": descriptionController.text,
//           "action_taken": actionController.text,
//         });

//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Crime Report Submitted ✅")),
//         );

//         // Navigate to next screen (make sure this class exists)
//         Get.to(() => const InspectVehicleFormScreen());

//         _formKey.currentState!.reset();
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
//     descriptionController.dispose();
//     actionController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Crime Report Form")),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               const SizedBox(height: 10),

//               // Source Info
//               DropdownButtonFormField<String>(
//                 value: sourceinfo,
//                 decoration: const InputDecoration(
//                   border: OutlineInputBorder(),
//                   labelText: "Source Info",
//                 ),
//                 items: ["1124", "15", "Routine Patrolling", "Private Person"]
//                     .map((e) => DropdownMenuItem(value: e, child: Text(e)))
//                     .toList(),
//                 onChanged: (val) => setState(() => sourceinfo = val!),
//               ),

//               const SizedBox(height: 10),

//               // Crime Head
//               DropdownButtonFormField<String>(
//                 value: crimeHead,
//                 decoration: const InputDecoration(
//                   border: OutlineInputBorder(),
//                   labelText: "Crime Head",
//                 ),
//                 items:
//                     [
//                           "Murder",
//                           "Dacoity",
//                           "Kidnapping",
//                           "Rape",
//                           "Robbery",
//                           "Other",
//                         ]
//                         .map((e) => DropdownMenuItem(value: e, child: Text(e)))
//                         .toList(),
//                 onChanged: (val) => setState(() => crimeHead = val!),
//               ),

//               const SizedBox(height: 10),

//               // Place
//               TextFormField(
//                 controller: placeController,
//                 decoration: const InputDecoration(
//                   border: OutlineInputBorder(),
//                   labelText: "Place of Incident",
//                 ),
//                 validator: (val) =>
//                     val == null || val.isEmpty ? "Required field" : null,
//               ),

//               const SizedBox(height: 10),

//               // Victim Status
//               DropdownButtonFormField<String>(
//                 value: victimStatus,
//                 decoration: const InputDecoration(
//                   border: OutlineInputBorder(),
//                   labelText: "Victim Status",
//                 ),
//                 items: ["Safe", "Injured", "Death"]
//                     .map((e) => DropdownMenuItem(value: e, child: Text(e)))
//                     .toList(),
//                 onChanged: (val) => setState(() => victimStatus = val!),
//               ),

//               const SizedBox(height: 10),

//               // Weapon Used
//               DropdownButtonFormField<String>(
//                 value: weapon,
//                 decoration: const InputDecoration(
//                   border: OutlineInputBorder(),
//                   labelText: "Weapon Used",
//                 ),
//                 items: ["Pistol", "Rifle", "Gun", "Kalashnikov", "Other"]
//                     .map((e) => DropdownMenuItem(value: e, child: Text(e)))
//                     .toList(),
//                 onChanged: (val) => setState(() => weapon = val!),
//               ),

//               const SizedBox(height: 10),

//               // Vehicle Used
//               DropdownButtonFormField<String>(
//                 value: vehicle,
//                 decoration: const InputDecoration(
//                   border: OutlineInputBorder(),
//                   labelText: "Vehicle Used",
//                 ),
//                 items: ["Car", "MC", "Rickshaw", "Truck", "Other"]
//                     .map((e) => DropdownMenuItem(value: e, child: Text(e)))
//                     .toList(),
//                 onChanged: (val) => setState(() => vehicle = val!),
//               ),

//               const SizedBox(height: 10),

//               // Informer
//               TextFormField(
//                 controller: informerController,
//                 decoration: const InputDecoration(
//                   border: OutlineInputBorder(),
//                   labelText: "Informer Details",
//                 ),
//               ),

//               const SizedBox(height: 10),

//               // First Responder
//               DropdownButtonFormField<String>(
//                 value: firstResponder,
//                 decoration: const InputDecoration(
//                   border: OutlineInputBorder(),
//                   labelText: "First Responder",
//                 ),
//                 items: ["PHP", "Local Police", "Traffic Police"]
//                     .map((e) => DropdownMenuItem(value: e, child: Text(e)))
//                     .toList(),
//                 onChanged: (val) => setState(() => firstResponder = val!),
//               ),

//               const SizedBox(height: 10),

//               // Response Time
//               DropdownButtonFormField<String>(
//                 value: responseTime,
//                 decoration: const InputDecoration(
//                   border: OutlineInputBorder(),
//                   labelText: "Response Time",
//                 ),
//                 items:
//                     [
//                           "Less than 10 Min",
//                           "Less than 15 Min",
//                           "Less than 30 Min",
//                           "One Hour",
//                         ]
//                         .map((e) => DropdownMenuItem(value: e, child: Text(e)))
//                         .toList(),
//                 onChanged: (val) => setState(() => responseTime = val!),
//               ),

//               const SizedBox(height: 10),

//               // Description
//               TextFormField(
//                 controller: descriptionController,
//                 maxLines: 3,
//                 decoration: const InputDecoration(
//                   border: OutlineInputBorder(),
//                   labelText: "Brief Description",
//                 ),
//               ),

//               const SizedBox(height: 10),

//               // Action Taken
//               TextFormField(
//                 controller: actionController,
//                 maxLines: 3,
//                 decoration: const InputDecoration(
//                   border: OutlineInputBorder(),
//                   labelText: "Action Taken by Officer",
//                 ),
//               ),

//               const SizedBox(height: 20),

//               // Submit Button
//               CustomButton(name: 'Submit Report', onTap: submitForm),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
