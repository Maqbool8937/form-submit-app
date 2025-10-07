import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:form_submit_app/view/screens/dashboard/list_form_screen.dart';
import 'package:form_submit_app/view/widgets/custom_button.dart';

class HelpForm extends StatefulWidget {
  const HelpForm({super.key});

  @override
  State<HelpForm> createState() => _HelpFormState();
}

class _HelpFormState extends State<HelpForm> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController placeController = TextEditingController();
  final TextEditingController nameAddressContactController =
      TextEditingController();
  final TextEditingController vehicleRegNoController = TextEditingController();
  final TextEditingController actionController = TextEditingController();

  // Dropdown values
  String sourceOfInfo = "1124";
  String typeOfHelp = "Mechanical";
  String vehicleType = "Car";

  // Auto fetched values (placeholders for now)
  String region = "Region A";
  String district = "District B";
  String phpPost = "PHP Post 1";
  String shiftIncharge = "Inspector Ahmed";
  String cnic = "35202-1234567-8";
  String gpsLocation = "31.5204, 74.3587";
  String policeStation = "Model Town PS";

  Future<void> submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseFirestore.instance.collection("help_forms").add({
          "date": DateTime.now().toIso8601String(),
          "time": TimeOfDay.now().format(context),
          "region": region,
          "district": district,
          "php_post": phpPost,
          "shift_incharge": shiftIncharge,
          "cnic": cnic,
          "source_of_info": sourceOfInfo,
          "place": placeController.text,
          "gps_location": gpsLocation,
          "police_station": policeStation,
          "type_of_help": typeOfHelp,
          "name_address_contact": nameAddressContactController.text,
          "vehicle_type": vehicleType,
          "vehicle_registration": vehicleRegNoController.text,
          "action_taken": actionController.text,
        });

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Help Form Submitted ✅")));

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
    placeController.dispose();
    nameAddressContactController.dispose();
    vehicleRegNoController.dispose();
    actionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Help Form")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 10),

              // Auto Fetched Info
              _buildInfoTile("Date", DateTime.now().toString().split(' ')[0]),
              _buildInfoTile("Time", TimeOfDay.now().format(context)),
              _buildInfoTile("Region", region),
              _buildInfoTile("District", district),
              _buildInfoTile("PHP Post", phpPost),
              _buildInfoTile("Shift Incharge", shiftIncharge),
              _buildInfoTile("CNIC", cnic),
              const SizedBox(height: 10),

              // Source of Info
              DropdownButtonFormField<String>(
                value: sourceOfInfo,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Source of Info",
                ),
                items: ["1124", "15", "Routine Patrolling", "Private Person"]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) => setState(() => sourceOfInfo = val!),
              ),

              const SizedBox(height: 10),

              // Place
              TextFormField(
                controller: placeController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Place (Landmark)",
                ),
                validator: (val) =>
                    val == null || val.isEmpty ? "Required field" : null,
              ),

              const SizedBox(height: 10),

              _buildInfoTile("GPS Location", gpsLocation),
              _buildInfoTile("Police Station", policeStation),

              const SizedBox(height: 10),

              // Type of Help
              DropdownButtonFormField<String>(
                value: typeOfHelp,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Type of Help",
                ),
                items:
                    [
                          "Mechanical",
                          "Tyer Puncture",
                          "First Aid",
                          "Towchain",
                          "Fuel",
                          "Security",
                          "Life Saved",
                          "Other",
                        ]
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                onChanged: (val) => setState(() => typeOfHelp = val!),
              ),

              const SizedBox(height: 10),

              // Name, Address & Contact
              TextFormField(
                controller: nameAddressContactController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Name, Address & Contact #",
                ),
                maxLines: 2,
              ),

              const SizedBox(height: 10),

              // Vehicle Type
              DropdownButtonFormField<String>(
                value: vehicleType,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Vehicle Type",
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
                onChanged: (val) => setState(() => vehicleType = val!),
              ),

              const SizedBox(height: 10),

              // Vehicle Registration #
              TextFormField(
                controller: vehicleRegNoController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Vehicle Registration # (Excise)",
                ),
              ),

              const SizedBox(height: 10),

              // Action Taken
              TextFormField(
                controller: actionController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Action Taken by Officer",
                ),
                maxLines: 3,
              ),

              const SizedBox(height: 20),

              // Submit Button
              CustomButton(name: "Submit Help Form", onTap: submitForm),
            ],
          ),
        ),
      ),
    );
  }

  // Helper Widget for Auto Fields
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



// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:form_submit_app/view/screens/dashboard/list_form_screen.dart';
// import 'package:get/get.dart';

// class HelpForm extends StatefulWidget {
//   @override
//   _HelpFormState createState() => _HelpFormState();
// }

// class _HelpFormState extends State<HelpForm> {
//   final _formKey = GlobalKey<FormState>();

//   // Controllers
//   TextEditingController placeController = TextEditingController();
//   TextEditingController nameController = TextEditingController();
//   TextEditingController actionController = TextEditingController();

//   String? sourceOfInfo; 
//   String? typeOfHelp;
//   String? vehicleType;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Help Form")),
//       body: Form(
//         key: _formKey,
//         child: ListView(
//           padding: EdgeInsets.all(16),
//           children: [
//             DropdownButtonFormField(
//               decoration: InputDecoration(labelText: "Source of Info"),
//               items: [
//                 "1124",
//                 "15",
//                 "Routine Patrolling",
//                 "Private Person",
//               ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
//               onChanged: (val) => setState(() => sourceOfInfo = val),
//             ),
//             TextFormField(
//               controller: placeController,
//               decoration: InputDecoration(labelText: "Place (Landmark)"),
//             ),
//             DropdownButtonFormField(
//               decoration: InputDecoration(labelText: "Type of Help"),
//               items: [
//                 "Mechanical",
//                 "Tyer Puncture",
//                 "First Aid",
//                 "Towchain",
//                 "Fuel",
//                 "Security",
//                 "Life Saved",
//                 "Other",
//               ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
//               onChanged: (val) => setState(() => typeOfHelp = val),
//             ),
//             TextFormField(
//               controller: nameController,
//               decoration: InputDecoration(
//                 labelText: "Name, Address & Contact #",
//               ),
//               maxLines: 2,
//             ),
//             DropdownButtonFormField(
//               decoration: InputDecoration(labelText: "Vehicle Type"),
//               items: [
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
//                 "Pedestarian",
//                 "Other",
//               ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
//               onChanged: (val) => setState(() => vehicleType = val),
//             ),
//             TextFormField(
//               controller: actionController,
//               decoration: InputDecoration(labelText: "Action Taken by Officer"),
//               maxLines: 2,
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(onPressed: _submitForm, child: Text("Submit")),
//           ],
//         ),
//       ),
//     );
//   }

//   Future<void> _submitForm() async {
//     if (_formKey.currentState!.validate()) {
//       final now = DateTime.now();
//       final data = {
//         "date": now.toIso8601String(),
//         "sourceOfInfo": sourceOfInfo,
//         "place": placeController.text,
//         "typeOfHelp": typeOfHelp,
//         "nameAddressContact": nameController.text,
//         "vehicleType": vehicleType,
//         "actionTaken": actionController.text,
//         "createdAt": now,
//       };

//       await FirebaseFirestore.instance.collection("help_forms").add(data).then((
//         value,
//       ) {
//         Get.off(() => InspectVehicleFormScreen());
//       });
//     }
//   }
// }
