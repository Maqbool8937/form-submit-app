// lib/view/screens/help_form_view.dart
import 'package:flutter/material.dart';
import 'package:form_submit_app/controllers/getxControllers/help_form_controller.dart';
// ignore: unused_import
import 'package:form_submit_app/controllers/utils/app_colors.dart';
import 'package:get/get.dart';
import 'package:form_submit_app/view/widgets/custom_button.dart';
import 'package:form_submit_app/view/screens/dashboard/list_form_screen.dart';

class HelpForm extends StatelessWidget {
  const HelpForm({super.key});

  @override
  Widget build(BuildContext context) {
    // Put controller (will be disposed by Get when route popped)
    final controller = Get.put(HelpFormController());

    // NOTE: If you want to navigate back to a real DashboardScreen after submit,
    // replace the placeholder Get.off in controller.submitForm with:
    // Get.off(() => DashboardScreen(userData: {}));

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            // original behavior: go back to InspectVehicleFormScreen
            Get.off(() => const InspectVehicleFormScreen());
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text('Help Form'),
        backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Obx(
          () => Form(
            key: controller.formKey,
            child: Column(
              children: [
                // Date & Time tiles
                _infoTile('Date', DateTime.now().toString().split(' ')[0]),
                _infoTile('Time', TimeOfDay.now().format(context)),
                const SizedBox(height: 10),

                // Region
                DropdownButtonFormField<String>(
                  value: controller.selectedRegion.value,
                  decoration: const InputDecoration(
                    labelText: 'Select Region',
                    border: OutlineInputBorder(),
                  ),
                  items: controller.regionData.keys
                      .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                      .toList(),
                  onChanged: (val) {
                    controller.selectedRegion.value = val;
                    controller.selectedDistrict.value = null;
                    controller.selectedPost.value = null;
                    controller.selectedShiftIncharge.value = null;
                  },
                  validator: (v) => v == null ? 'Select region' : null,
                ),
                const SizedBox(height: 10),

                // District
                if (controller.selectedRegion.value != null)
                  DropdownButtonFormField<String>(
                    value: controller.selectedDistrict.value,
                    decoration: const InputDecoration(
                      labelText: 'Select District',
                      border: OutlineInputBorder(),
                    ),
                    items: controller
                        .regionData[controller.selectedRegion.value]!
                        .keys
                        .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                        .toList(),
                    onChanged: (val) {
                      controller.selectedDistrict.value = val;
                      controller.selectedPost.value = null;
                      controller.selectedShiftIncharge.value = null;
                    },
                    validator: (v) =>
                        controller.selectedRegion.value != null && v == null
                        ? 'Select district'
                        : null,
                  ),
                const SizedBox(height: 10),

                // Post
                if (controller.selectedDistrict.value != null)
                  DropdownButtonFormField<String>(
                    value: controller.selectedPost.value,
                    decoration: const InputDecoration(
                      labelText: 'Select PHP Post',
                      border: OutlineInputBorder(),
                    ),
                    items: controller
                        .regionData[controller.selectedRegion.value]![controller
                            .selectedDistrict
                            .value]!
                        .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                        .toList(),
                    onChanged: (val) {
                      controller.selectedPost.value = val;
                      controller.selectedShiftIncharge.value = null;
                    },
                    validator: (v) =>
                        controller.selectedDistrict.value != null && v == null
                        ? 'Select post'
                        : null,
                  ),
                const SizedBox(height: 10),

                // Shift incharge
                if (controller.selectedPost.value != null)
                  DropdownButtonFormField<String>(
                    value: controller.selectedShiftIncharge.value,
                    decoration: const InputDecoration(
                      labelText: 'Select Shift Incharge',
                      border: OutlineInputBorder(),
                    ),
                    items:
                        (controller.shiftInchargeData[controller
                                    .selectedPost
                                    .value] ??
                                [])
                            .map(
                              (s) => DropdownMenuItem(value: s, child: Text(s)),
                            )
                            .toList(),
                    onChanged: (val) =>
                        controller.selectedShiftIncharge.value = val,
                    validator: (v) =>
                        controller.selectedPost.value != null && v == null
                        ? 'Select incharge'
                        : null,
                  ),
                const SizedBox(height: 12),

                // GPS Row
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        controller.gpsLocation.value ?? 'GPS not set',
                      ),
                    ),
                    const SizedBox(width: 8),
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
                            ? 'Locating...'
                            : 'Set GPS',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // CNIC
                _textField(controller.cnicController, 'CNIC'),

                // Source of info dropdown
                _dropdownRx(
                  selectedRx: controller.sourceOfInfo,
                  label: 'Source of Info',
                  items: ['1124', '15', 'Routine Patrolling', 'Private Person'],
                ),

                // Place
                _textField(controller.placeController, 'Place (Landmark)'),

                // Police station (optional)
                _textField(
                  controller.policeStationController,
                  'Police Station (If any)',
                  required: false,
                ),

                // Type of help
                _dropdownRx(
                  selectedRx: controller.typeOfHelp,
                  label: 'Type of Help',
                  items: [
                    'Mechanical',
                    'Tyer Puncture',
                    'First Aid',
                    'Towchain',
                    'Fuel',
                    'Security',
                    'Life Saved',
                    'Other',
                  ],
                ),

                // Name / address / contact (optional)
                _textField(
                  controller.nameAddressContactController,
                  'Name, Address & Contact #',
                  maxLines: 2,
                  required: false,
                ),

                // Vehicle type
                _dropdownRx(
                  selectedRx: controller.vehicleType,
                  label: 'Vehicle Type',
                  items: [
                    'MC',
                    'Car',
                    'Rickshaw',
                    'Hiace',
                    'Hilux',
                    'Shahzor',
                    'Bus',
                    'Mazda',
                    'Truck',
                    'Troller',
                    'Pedestrian',
                    'Other',
                  ],
                ),

                // Vehicle registration (optional)
                _textField(
                  controller.vehicleRegNoController,
                  'Vehicle Registration # (Excise)',
                  required: false,
                ),

                // Action taken (optional)
                _textField(
                  controller.actionController,
                  'Action Taken by Officer',
                  maxLines: 3,
                  required: false,
                ),

                // First responder
                _dropdownRx(
                  selectedRx: controller.firstResponder,
                  label: 'First Responder',
                  items: ['PHP', 'Local Police', 'Traffic Police'],
                ),

                // Response time
                _dropdownRx(
                  selectedRx: controller.responseTime,
                  label: 'Response Time',
                  items: [
                    'Less than 10 Min',
                    'Less than 15 Min',
                    'Less than 30 Min',
                    'One Hour',
                  ],
                ),

                // Brief description
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: TextFormField(
                    controller: controller.descriptionController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Brief Description',
                    ),
                    validator: (val) =>
                        val == null || val.isEmpty ? 'Required field' : null,
                  ),
                ),

                // Notes optional
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: TextFormField(
                    controller: controller.notesController,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Notes (Optional)',
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Submit button
                controller.isSubmitting.value
                    ? const CircularProgressIndicator()
                    : CustomButton(
                        name: 'Submit Help Form',
                        onTap: () => controller.submitForm(context),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // small helpers (kept same as original)
  Widget _infoTile(String label, String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text('$label: $value'),
    );
  }

  Widget _textField(
    TextEditingController controller,
    String label, {
    int maxLines = 1,
    bool required = true,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: required
            ? (v) => v == null || v.isEmpty ? 'Required field' : null
            : null,
      ),
    );
  }

  Widget _dropdownRx({
    required RxString selectedRx,
    required String label,
    required List<String> items,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Obx(
        () => DropdownButtonFormField<String>(
          value: selectedRx.value,
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
          ),
          items: items
              .map((i) => DropdownMenuItem(value: i, child: Text(i)))
              .toList(),
          onChanged: (v) => selectedRx.value = v!,
        ),
      ),
    );
  }
}











// // help_form.dart
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:form_submit_app/view/screens/dashboard/dashboard_screen.dart';
// import 'package:form_submit_app/view/screens/dashboard/help_detail_screen.dart';
// import 'package:get/get.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:form_submit_app/view/widgets/custom_button.dart';
// import 'package:form_submit_app/view/screens/dashboard/list_form_screen.dart'; // InspectVehicleFormScreen path used earlier

// class HelpForm extends StatefulWidget {
//   const HelpForm({super.key});

//   @override
//   State<HelpForm> createState() => _HelpFormState();
// }

// class _HelpFormState extends State<HelpForm> {
//   final _formKey = GlobalKey<FormState>();

//   // Text controllers for all fields
//   final TextEditingController cnicController = TextEditingController();
//   final TextEditingController placeController = TextEditingController();
//   final TextEditingController nameAddressContactController =
//       TextEditingController();
//   final TextEditingController vehicleRegNoController = TextEditingController();
//   final TextEditingController actionController = TextEditingController();
//   final TextEditingController policeStationController = TextEditingController();
//   final TextEditingController descriptionController = TextEditingController();
//   final TextEditingController notesController = TextEditingController();

//   // Dropdown default values (help-specific)
//   String sourceOfInfo = "1124";
//   String typeOfHelp = "Mechanical";
//   String vehicleType = "Car";
//   String firstResponder = "PHP";
//   String responseTime = "Less than 10 Min";

//   // Dynamic dropdowns for region -> district -> post -> shift incharge
//   String? selectedRegion;
//   String? selectedDistrict;
//   String? selectedPost;
//   String? selectedShiftIncharge;

//   // Live GPS
//   String? gpsLocation;
//   bool isFetchingLocation = false;

//   // FULL region → district → post map (use same data you provided earlier)
//   final Map<String, Map<String, List<String>>> regionData = {
//     'LHR': {
//       'SKP': [
//         'KHANPUR',
//         'HERDEV',
//         'SAIKHUM',
//         'SAOMORIA',
//         'FAROOQABAD',
//         'BHIKHI',
//         'KALASHAHKAKU',
//         'BHAGODIAL',
//         'KAKKARGILL',
//       ],
//       'NNK': ['ALIABAD', 'JAAT NAGAR', 'MALIKPUR'],
//       'LHR': ['JIA BAGGA', 'MANGA MANDI', 'WAHGRAIN'],
//       'KSR': [
//         'NOOR PUR',
//         'KOREY SIAL',
//         'BHEO ASAL',
//         'BHEEM KH.UR.RASHEED',
//         'MALIK MEHBOOB',
//         'KARANI WALA',
//         'SABIR SHAHEED',
//         'CHAK DEDA',
//         'MUHAMMAD MALAK',
//       ],
//       'OKR': [
//         '48/2.L',
//         '48/3.R',
//         'SUKHPUR',
//         'QILA SONDA SING',
//         'MIRAN SHAH',
//         'BHUMAN SHAH',
//         'HASAN GELAN',
//         'BONGA SALEH',
//         'KHOKAR KOTHI',
//       ],
//     },
//     'BWP': {
//       'BWP': [
//         'RAMAN',
//         'PUL BALOUCHAN',
//         'KHAIRPUR DAHA',
//         'TAHIR WALI',
//         'JABBAR SHAHEED',
//         'TAIL WALI',
//         'KUD WALA',
//         '82 MORR',
//         'MALSI LINK KHAIRPUR',
//         'PULL PHATIAN WALI',
//         'LAL SOHANRA',
//         'JHANGI WALA',
//         'FATTO WALI',
//         '69 SOLING',
//         'ABBASI MORE',
//         'FARHAN SHAHEED(CHAK 23 DNB )',
//         'BASTI MALKANI',
//       ],
//       'RYK': [
//         'MUHAMMAD PUR LAMMA',
//         'LUNDA PATHAK',
//         'PULL SMOOKA',
//         'THULL HAMZA',
//         'MAQBOOL MORR',
//         'MANTHAR TOWN',
//         'PULL DAGA',
//         'NAWAN KOTT',
//         'KALAYWALI',
//         'BAUDIPUR MACHIAN',
//         '173/P',
//         'PUL QADIR WALI',
//         'GHULAM MUHUDIN SHAHEED',
//         'DINO SHAH',
//         'GARHI IKHTYAR KHAN',
//         'TAHLI MORR',
//         'FAZAL ABAD',
//         'CHOWK METLA',
//         'CHAK NO.88/A',
//         'MOUZA BHARA',
//       ],
//       'BWN': [
//         'BUXIN KHAN',
//         'SHAHEED CHOWK',
//         '138/6-R DHARI',
//         'BARIKA',
//         'ADDA LATIF ABAD',
//         'SUNNATIKA MORR',
//         'PIR SIKANDAR',
//         'LOHARKA',
//         'ADDA PUL GAGIANI',
//         'CHAK 117/M',
//         'SAHI WALA',
//         '206 MURAD',
//         'DHAK PATTAN',
//         'SAHOOKA PATTAN',
//         '340/HR MAROT',
//       ],
//     },
//     'DGK': {
//       'DGK': [
//         'RIND ADA',
//         'TRIMIN',
//         'KOT MOR',
//         'BOHAR',
//         'SHADAN LOUND',
//         'TOMI MOR',
//         'SAKHI SARWAR',
//         'CHOTI BALA',
//         'ADA HAIDERABAD',
//         'MANA BANGLA',
//       ],
//       'LYA': [
//         'LADHANA MOR',
//         'RAFIQ ABAD',
//         'KAPOORI',
//         'NAWAN KOT',
//         'GHAZI GHAT',
//         'QADIRABAD',
//         'SHADAD KOT',
//         'KOT SULTAN',
//         'PEER JAGO',
//         'BASTI KOTLA',
//         'MAIRA',
//         'JALLI WALI',
//         'PULL BINDRA',
//         'JAGMAL WALA',
//       ],
//       'MGR': [
//         'HEAD BAKAINI',
//         'HAMZAYWALI',
//         'HEAD PUNJNAD',
//         'KHANDER MERANI',
//         'MIR HAJI',
//         'KHANPUR BUGA SHER',
//         'GHAZI GHAT',
//         'HEAD TOUNSA',
//         'GABER AREIN',
//         'RIAZABAD',
//         'H.M.WALA',
//         'LANGER WAH',
//         'JAWANA BANGLA',
//       ],
//       'RJP': [
//         'BANGLA DHENGAN',
//         'BANGLA HIDAYAT',
//         'ROJHAN TOWER',
//         'KHAKHAR MOR',
//         'SHAHWALI',
//         'KOTLA ANDROON',
//         'MOSA SHAHEED',
//         'NAWAZ SHAHEED',
//         'TIBBI SOLGI',
//         'MAZHAR SHAHEED',
//       ],
//     },
//     'FSD': {
//       'FSD': [
//         'KAMALPUR',
//         'AMINPUR BYPASS',
//         'PAINSRA',
//         'ROSHEN WALI JHAL',
//         'JALLAH CHOWK',
//         'JASUANA BUNGALOW',
//         'BUCHAKI',
//         'ALIPUR BANGLOW',
//         'ASGHRABAD',
//         'PULL PROPIAN',
//         'SENSRA',
//         'SAHINWALA',
//         'VAC KHURRANWALA',
//         'MAKUANA',
//         '96 GB',
//         'KHIDERWALA',
//         'PULL KAHANA',
//         'BURREWAL',
//         'JHAMRA',
//         'KANJWANI BUNGALOW',
//         'KANIAN BUNGALOW',
//         'KHAI BUNGALOW',
//       ],
//       'FSD DIST 2': ['POST Z'],
//     },
//     'GRW': {
//       'GRW DIST 1': ['POST 1', 'POST 2'],
//     },
//     'MLN': {
//       'MLN DIST 1': ['POST 1'],
//     },
//     'SGD': {
//       'SGD DIST 1': ['POST 1', 'POST 2'],
//     },
//     'RWP': {
//       'RWP DIST 1': ['POST 1', 'POST 2'],
//     },
//   };

//   // Shift incharge map (post -> list of incharges)
//   final Map<String, List<String>> shiftInchargeData = {
//     "KHANPUR": ["Insp. Ali"],
//     "MANGA MANDI": ["Insp. Bilal"],
//     "PAINSRA": ["Insp. Asghar"],
//     "ROJHAN TOWER": ["Insp. Umar"],
//     "HEAD PUNJNAD": ["Insp. Saleem"],
//     // add more mapping as needed...
//   };

//   @override
//   void initState() {
//     super.initState();
//     _getCurrentLocation();
//   }

//   /// Fetch live GPS location (stream)
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

//   /// Submit help form to Firestore
//   Future<void> submitForm() async {
//     if (!_formKey.currentState!.validate()) return;

//     if (gpsLocation == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Please set GPS location first 📍")),
//       );
//       return;
//     }

//     if (selectedRegion == null ||
//         selectedDistrict == null ||
//         selectedPost == null ||
//         selectedShiftIncharge == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text("Please select Region, District, Post and Incharge."),
//         ),
//       );
//       return;
//     }

//     try {
//       await FirebaseFirestore.instance.collection('help_forms').add({
//         'date': DateTime.now().toIso8601String(),
//         'time': TimeOfDay.now().format(context),
//         'region': selectedRegion,
//         'district': selectedDistrict,
//         'php_post': selectedPost,
//         'shift_incharge': selectedShiftIncharge,
//         'cnic': cnicController.text,
//         'source_of_info': sourceOfInfo,
//         'place': placeController.text,
//         'gps_location': gpsLocation,
//         'police_station': policeStationController.text,
//         'type_of_help': typeOfHelp,
//         'name_address_contact': nameAddressContactController.text,
//         'vehicle_type': vehicleType,
//         'vehicle_registration': vehicleRegNoController.text,
//         'action_taken': actionController.text,
//         'first_responder': firstResponder,
//         'response_time': responseTime,
//         'brief_description': descriptionController.text,
//         'notes': notesController.text,
//       });

//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text("Help Form Submitted ✅")));

//       // Navigate like your crime form
//       // Get.to(() => HelpDetailScreen(collectionName: 'help_forms'));
//       Get.off(() => DashboardScreen(userData: {}));
//       // Get.to(() => const InspectVehicleFormScreen());

//       _formKey.currentState!.reset();

//       setState(() {
//         gpsLocation = null;
//         selectedRegion = null;
//         selectedDistrict = null;
//         selectedPost = null;
//         selectedShiftIncharge = null;
//         sourceOfInfo = "1124";
//         typeOfHelp = "Mechanical";
//         vehicleType = "Car";
//         firstResponder = "PHP";
//         responseTime = "Less than 10 Min";
//       });

//       // clear controllers
//       cnicController.clear();
//       placeController.clear();
//       nameAddressContactController.clear();
//       vehicleRegNoController.clear();
//       actionController.clear();
//       policeStationController.clear();
//       descriptionController.clear();
//       notesController.clear();
//     } catch (e) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text("Error: $e")));
//     }
//   }

//   @override
//   void dispose() {
//     cnicController.dispose();
//     placeController.dispose();
//     nameAddressContactController.dispose();
//     vehicleRegNoController.dispose();
//     actionController.dispose();
//     policeStationController.dispose();
//     descriptionController.dispose();
//     notesController.dispose();
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
//         title: const Text('Help Form'),
//         backgroundColor: Colors.teal,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               // Date & Time info tiles
//               _infoTile('Date', DateTime.now().toString().split(' ')[0]),
//               _infoTile('Time', TimeOfDay.now().format(context)),

//               const SizedBox(height: 10),

//               // Region dropdown
//               DropdownButtonFormField<String>(
//                 value: selectedRegion,
//                 decoration: const InputDecoration(
//                   labelText: 'Select Region',
//                   border: OutlineInputBorder(),
//                 ),
//                 items: regionData.keys
//                     .map((r) => DropdownMenuItem(value: r, child: Text(r)))
//                     .toList(),
//                 onChanged: (val) {
//                   setState(() {
//                     selectedRegion = val;
//                     selectedDistrict = null;
//                     selectedPost = null;
//                     selectedShiftIncharge = null;
//                   });
//                 },
//                 validator: (v) => v == null ? 'Select region' : null,
//               ),
//               const SizedBox(height: 10),

//               // District dropdown
//               if (selectedRegion != null)
//                 DropdownButtonFormField<String>(
//                   value: selectedDistrict,
//                   decoration: const InputDecoration(
//                     labelText: 'Select District',
//                     border: OutlineInputBorder(),
//                   ),
//                   items: regionData[selectedRegion]!.keys
//                       .map((d) => DropdownMenuItem(value: d, child: Text(d)))
//                       .toList(),
//                   onChanged: (val) {
//                     setState(() {
//                       selectedDistrict = val;
//                       selectedPost = null;
//                       selectedShiftIncharge = null;
//                     });
//                   },
//                   validator: (v) => selectedRegion != null && v == null
//                       ? 'Select district'
//                       : null,
//                 ),
//               const SizedBox(height: 10),

//               // Post dropdown
//               if (selectedDistrict != null)
//                 DropdownButtonFormField<String>(
//                   value: selectedPost,
//                   decoration: const InputDecoration(
//                     labelText: 'Select PHP Post',
//                     border: OutlineInputBorder(),
//                   ),
//                   items: regionData[selectedRegion]![selectedDistrict]!
//                       .map((p) => DropdownMenuItem(value: p, child: Text(p)))
//                       .toList(),
//                   onChanged: (val) {
//                     setState(() {
//                       selectedPost = val;
//                       selectedShiftIncharge = null;
//                     });
//                   },
//                   validator: (v) => selectedDistrict != null && v == null
//                       ? 'Select post'
//                       : null,
//                 ),
//               const SizedBox(height: 10),

//               // Shift incharge dropdown
//               if (selectedPost != null)
//                 DropdownButtonFormField<String>(
//                   value: selectedShiftIncharge,
//                   decoration: const InputDecoration(
//                     labelText: 'Select Shift Incharge',
//                     border: OutlineInputBorder(),
//                   ),
//                   items: (shiftInchargeData[selectedPost] ?? [])
//                       .map((s) => DropdownMenuItem(value: s, child: Text(s)))
//                       .toList(),
//                   onChanged: (val) =>
//                       setState(() => selectedShiftIncharge = val),
//                   validator: (v) => selectedPost != null && v == null
//                       ? 'Select incharge'
//                       : null,
//                 ),
//               const SizedBox(height: 12),

//               // GPS row
//               Row(
//                 children: [
//                   Expanded(child: Text(gpsLocation ?? 'GPS not set')),
//                   const SizedBox(width: 8),
//                   ElevatedButton.icon(
//                     onPressed: isFetchingLocation ? null : _getCurrentLocation,
//                     icon: isFetchingLocation
//                         ? const SizedBox(
//                             width: 16,
//                             height: 16,
//                             child: CircularProgressIndicator(strokeWidth: 2),
//                           )
//                         : const Icon(Icons.my_location),
//                     label: Text(isFetchingLocation ? 'Locating...' : 'Set GPS'),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 12),

//               // CNIC
//               _textField(cnicController, 'CNIC'),

//               // Source of info
//               _dropdown(
//                 value: sourceOfInfo,
//                 label: 'Source of Info',
//                 items: ['1124', '15', 'Routine Patrolling', 'Private Person'],
//                 onChanged: (v) => setState(() => sourceOfInfo = v!),
//               ),

//               // Place
//               _textField(placeController, 'Place (Landmark)'),

//               // Police station
//               _textField(
//                 policeStationController,
//                 'Police Station (If any)',
//                 required: false,
//               ),

//               // Type of help
//               _dropdown(
//                 value: typeOfHelp,
//                 label: 'Type of Help',
//                 items: [
//                   'Mechanical',
//                   'Tyer Puncture',
//                   'First Aid',
//                   'Towchain',
//                   'Fuel',
//                   'Security',
//                   'Life Saved',
//                   'Other',
//                 ],
//                 onChanged: (v) => setState(() => typeOfHelp = v!),
//               ),

//               // Name / address / contact
//               _textField(
//                 nameAddressContactController,
//                 'Name, Address & Contact #',
//                 maxLines: 2,
//                 required: false,
//               ),

//               // Vehicle type
//               _dropdown(
//                 value: vehicleType,
//                 label: 'Vehicle Type',
//                 items: [
//                   'MC',
//                   'Car',
//                   'Rickshaw',
//                   'Hiace',
//                   'Hilux',
//                   'Shahzor',
//                   'Bus',
//                   'Mazda',
//                   'Truck',
//                   'Troller',
//                   'Pedestrian',
//                   'Other',
//                 ],
//                 onChanged: (v) => setState(() => vehicleType = v!),
//               ),

//               // Vehicle registration
//               _textField(
//                 vehicleRegNoController,
//                 'Vehicle Registration # (Excise)',
//                 required: false,
//               ),

//               // Action taken
//               _textField(
//                 actionController,
//                 'Action Taken by Officer',
//                 maxLines: 3,
//                 required: false,
//               ),

//               // First responder
//               _dropdown(
//                 value: firstResponder,
//                 label: 'First Responder',
//                 items: ['PHP', 'Local Police', 'Traffic Police'],
//                 onChanged: (v) => setState(() => firstResponder = v!),
//               ),

//               // Response time
//               _dropdown(
//                 value: responseTime,
//                 label: 'Response Time',
//                 items: [
//                   'Less than 10 Min',
//                   'Less than 15 Min',
//                   'Less than 30 Min',
//                   'One Hour',
//                 ],
//                 onChanged: (v) => setState(() => responseTime = v!),
//               ),

//               // Brief description
//               Padding(
//                 padding: const EdgeInsets.only(bottom: 10),
//                 child: TextFormField(
//                   controller: descriptionController,
//                   maxLines: 3,
//                   decoration: const InputDecoration(
//                     border: OutlineInputBorder(),
//                     labelText: 'Brief Description',
//                   ),
//                   validator: (val) =>
//                       val == null || val.isEmpty ? 'Required field' : null,
//                 ),
//               ),

//               // Notes (optional)
//               Padding(
//                 padding: const EdgeInsets.only(bottom: 10),
//                 child: TextFormField(
//                   controller: notesController,
//                   maxLines: 2,
//                   decoration: const InputDecoration(
//                     border: OutlineInputBorder(),
//                     labelText: 'Notes (Optional)',
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 16),

//               CustomButton(name: 'Submit Help Form', onTap: submitForm),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // small helpers
//   Widget _infoTile(String label, String value) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(8),
//       margin: const EdgeInsets.only(bottom: 8),
//       decoration: BoxDecoration(
//         border: Border.all(color: Colors.grey.shade300),
//         borderRadius: BorderRadius.circular(6),
//       ),
//       child: Text('$label: $value'),
//     );
//   }

//   Widget _textField(
//     TextEditingController controller,
//     String label, {
//     int maxLines = 1,
//     bool required = true,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 10),
//       child: TextFormField(
//         controller: controller,
//         maxLines: maxLines,
//         decoration: InputDecoration(
//           labelText: label,
//           border: const OutlineInputBorder(),
//         ),
//         validator: required
//             ? (v) => v == null || v.isEmpty ? 'Required field' : null
//             : null,
//       ),
//     );
//   }

//   Widget _dropdown({
//     required String value,
//     required String label,
//     required List<String> items,
//     required ValueChanged<String?> onChanged,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 10),
//       child: DropdownButtonFormField<String>(
//         value: value,
//         decoration: InputDecoration(
//           labelText: label,
//           border: const OutlineInputBorder(),
//         ),
//         items: items
//             .map((i) => DropdownMenuItem(value: i, child: Text(i)))
//             .toList(),
//         onChanged: onChanged,
//       ),
//     );
//   }
// }


