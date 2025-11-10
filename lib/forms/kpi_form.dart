import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:form_submit_app/controllers/getxControllers/kpi_controller.dart';

class KPIFormScreen extends StatelessWidget {
  const KPIFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(KPIController());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text(
          "KPIs Enforcement by PHP",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 🕒 Date & Time
              Obx(
                () => Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Date & Time: ${DateFormat('dd/MM/yyyy, hh:mm a').format(controller.selectedDateTime.value)}",
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.access_time),
                      onPressed: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: controller.selectedDateTime.value,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2030),
                        );
                        if (date != null) {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(
                              controller.selectedDateTime.value,
                            ),
                          );
                          if (time != null) {
                            controller.selectedDateTime.value = DateTime(
                              date.year,
                              date.month,
                              date.day,
                              time.hour,
                              time.minute,
                            );
                          }
                        }
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),

              /// 🔹 REGION
              _buildDropdown(
                label: "Select Region",
                value: controller.selectedRegion,
                items: controller.regionData.keys.toList(),
                onChanged: (v) {
                  controller.selectedRegion.value = v;
                  controller.selectedDistrict.value = null;
                  controller.selectedPost.value = null;
                  controller.selectedOfficer.value = null;
                },
              ),
              const SizedBox(height: 10),

              /// 🔹 DISTRICT (depends on region)
              Obx(
                () => _buildDropdown(
                  label: "Select District",
                  value: controller.selectedDistrict,
                  items: controller.selectedRegion.value == null
                      ? []
                      : controller
                            .regionData[controller.selectedRegion.value]!
                            .keys
                            .toList(),
                  onChanged: (v) {
                    controller.selectedDistrict.value = v;
                    controller.selectedPost.value = null;
                    controller.selectedOfficer.value = null;
                  },
                ),
              ),
              const SizedBox(height: 10),

              /// 🔹 PHP POST (depends on district)
              Obx(
                () => _buildDropdown(
                  label: "Select PHP Post",
                  value: controller.selectedPost,
                  items:
                      (controller.selectedRegion.value != null &&
                          controller.selectedDistrict.value != null)
                      ? controller.regionData[controller
                                .selectedRegion
                                .value]![controller.selectedDistrict.value] ??
                            []
                      : [],
                  onChanged: (v) {
                    controller.selectedPost.value = v;
                    controller.selectedOfficer.value = null;
                  },
                ),
              ),
              const SizedBox(height: 10),

              /// 🔹 ROAD
              _buildDropdown(
                label: "Select Road",
                value: controller.selectedRoad,
                items: controller.roads,
              ),
              const SizedBox(height: 10),

              /// 🔹 Officer (depends on Post)
              Obx(
                () => _buildDropdown(
                  label: "Select Officer (Shift Incharge)",
                  value: controller.selectedOfficer,
                  items: controller.selectedPost.value != null
                      ? controller.officers[controller.selectedPost.value] ?? []
                      : [],
                ),
              ),
              const SizedBox(height: 10),

              /// 👮 Officer Details
              _buildTextField(controller.officerRank, "Officer Rank"),
              _buildTextField(controller.officerBeltNo, "Officer Belt No"),
              _buildTextField(controller.officerCnic, "Officer CNIC"),

              /// 🚗 Road User Details
              _buildTextField(
                controller.roadUserName,
                "Road User / Driver Name",
              ),
              _buildTextField(
                controller.roadUserCnic,
                "CNIC #",
                type: TextInputType.number,
              ),
              _buildTextField(
                controller.mobileNo,
                "Mobile #",
                type: TextInputType.phone,
              ),

              /// 🔹 Category
              _buildDropdown(
                label: "Select Category",
                value: controller.selectedCategory,
                items: controller.categories,
              ),
              const SizedBox(height: 10),

              /// 🔹 Violation Indicator
              _buildDropdown(
                label: "Violation Indicator (Observed)",
                value: controller.selectedViolationIndicator,
                items: controller.violationIndicators,
              ),
              const SizedBox(height: 10),

              /// 🔹 Violation
              _buildDropdown(
                label: "Violation",
                value: controller.selectedViolation,
                items: controller.violations,
              ),
              const SizedBox(height: 20),

              /// ✅ Submit Button
              Obx(
                () => SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: controller.isSubmitting.value
                        ? null
                        : () => controller.submitForm(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: Text(
                      controller.isSubmitting.value
                          ? "Submitting..."
                          : "Submit",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  /// 🔹 Text Field Builder
  Widget _buildTextField(
    TextEditingController c,
    String label, {
    TextInputType type = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        controller: c,
        keyboardType: type,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          border: const OutlineInputBorder(),
          labelText: label,
        ),
        validator: (val) =>
            val == null || val.trim().isEmpty ? "Required" : null,
      ),
    );
  }

  /// 🔹 Dropdown Builder
  Widget _buildDropdown({
    required String label,
    required RxnString value,
    required List<String> items,
    void Function(String?)? onChanged,
  }) {
    return Obx(
      () => DropdownButtonFormField<String>(
        value: value.value,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          border: const OutlineInputBorder(),
          labelText: label,
        ),
        items: items
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: onChanged ?? (v) => value.value = v,
        validator: (v) => v == null ? "Required" : null,
      ),
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:form_submit_app/controllers/getxControllers/kpi_controller.dart';

// class KPIFormScreen extends StatelessWidget {
//   const KPIFormScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(KPIController());

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.red,
//         title: const Text(
//           "KPIs Enforcement by PHP",
//           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//         ),
//         centerTitle: true,
//         iconTheme: const IconThemeData(color: Colors.white),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Form(
//           key: controller.formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               /// 🕒 Date & Time
//               Obx(
//                 () => Row(
//                   children: [
//                     Expanded(
//                       child: Text(
//                         "Date & Time: ${DateFormat('dd/MM/yyyy, hh:mm a').format(controller.selectedDateTime.value)}",
//                         style: const TextStyle(fontWeight: FontWeight.w500),
//                       ),
//                     ),
//                     IconButton(
//                       icon: const Icon(Icons.access_time),
//                       onPressed: () async {
//                         final date = await showDatePicker(
//                           context: context,
//                           initialDate: controller.selectedDateTime.value,
//                           firstDate: DateTime(2020),
//                           lastDate: DateTime(2030),
//                         );
//                         if (date != null) {
//                           final time = await showTimePicker(
//                             context: context,
//                             initialTime: TimeOfDay.fromDateTime(
//                               controller.selectedDateTime.value,
//                             ),
//                           );
//                           if (time != null) {
//                             controller.selectedDateTime.value = DateTime(
//                               date.year,
//                               date.month,
//                               date.day,
//                               time.hour,
//                               time.minute,
//                             );
//                           }
//                         }
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 10),

//               /// 🔹 REGION
//               _buildDropdown(
//                 label: "Select Region",
//                 value: controller.selectedRegion,
//                 items: controller.regionData.keys.toList(),
//                 onChanged: (v) {
//                   controller.selectedRegion.value = v;
//                   controller.selectedDistrict.value = null;
//                   controller.selectedPost.value = null;
//                   controller.selectedOfficer.value = null;
//                 },
//               ),
//               const SizedBox(height: 8),

//               /// 🔹 DISTRICT (depends on region)
//               Obx(
//                 () => _buildDropdown(
//                   label: "Select District",
//                   value: controller.selectedDistrict,
//                   items: controller.selectedRegion.value == null
//                       ? []
//                       : controller
//                             .regionData[controller.selectedRegion.value]!
//                             .keys
//                             .toList(),
//                   onChanged: (v) {
//                     controller.selectedDistrict.value = v;
//                     controller.selectedPost.value = null;
//                     controller.selectedOfficer.value = null;
//                   },
//                 ),
//               ),
//               const SizedBox(height: 8),

//               /// 🔹 PHP POST (depends on district)
//               Obx(
//                 () => _buildDropdown(
//                   label: "Select PHP Post",
//                   value: controller.selectedPost,
//                   items:
//                       (controller.selectedRegion.value != null &&
//                           controller.selectedDistrict.value != null)
//                       ? controller.regionData[controller
//                                 .selectedRegion
//                                 .value]![controller.selectedDistrict.value] ??
//                             []
//                       : [],
//                   onChanged: (v) {
//                     controller.selectedPost.value = v;
//                     controller.selectedOfficer.value = null;
//                   },
//                 ),
//               ),
//               const SizedBox(height: 8),

//               /// 🔹 ROAD
//               _buildDropdown(
//                 label: "Select Road",
//                 value: controller.selectedRoad,
//                 items: controller.roads,
//               ),
//               const SizedBox(height: 8),

//               /// 🔹 Officer (depends on Post)
//               Obx(
//                 () => _buildDropdown(
//                   label: "Select Officer (Shift Incharge)",
//                   value: controller.selectedOfficer,
//                   items: controller.selectedPost.value != null
//                       ? controller.officers[controller.selectedPost.value] ?? []
//                       : [],
//                 ),
//               ),
//               const SizedBox(height: 8),

//               /// 👮 Officer Details
//               _buildTextField(controller.officerRank, "Officer Rank"),
//               _buildTextField(controller.officerBeltNo, "Officer Belt No"),
//               _buildTextField(controller.officerCnic, "Officer CNIC"),

//               /// 🚗 Road User Details
//               _buildTextField(
//                 controller.roadUserName,
//                 "Road User / Driver Name",
//               ),
//               _buildTextField(
//                 controller.roadUserCnic,
//                 "CNIC #",
//                 type: TextInputType.number,
//               ),
//               _buildTextField(
//                 controller.mobileNo,
//                 "Mobile #",
//                 type: TextInputType.phone,
//               ),

//               /// 🔹 Category
//               _buildDropdown(
//                 label: "Select Category",
//                 value: controller.selectedCategory,
//                 items: controller.categories,
//               ),
//               const SizedBox(height: 8),

//               /// 🔹 Violation Indicator
//               _buildDropdown(
//                 label: "Violation Indicator (Observed)",
//                 value: controller.selectedViolationIndicator,
//                 items: controller.violationIndicators,
//               ),
//               const SizedBox(height: 8),

//               /// 🔹 Violation
//               _buildDropdown(
//                 label: "Violation",
//                 value: controller.selectedViolation,
//                 items: controller.violations,
//               ),
//               const SizedBox(height: 16),

//               /// ✅ Submit Button
//               Obx(
//                 () => SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     onPressed: controller.isSubmitting.value
//                         ? null
//                         : () => controller.submitForm(context),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.red,
//                       padding: const EdgeInsets.symmetric(vertical: 12),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(6),
//                       ),
//                     ),
//                     child: Text(
//                       controller.isSubmitting.value
//                           ? "Submitting..."
//                           : "Submit",
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.w600,
//                         fontSize: 15,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 20),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   /// 🔹 Compact Text Field Builder
//   Widget _buildTextField(
//     TextEditingController c,
//     String label, {
//     TextInputType type = TextInputType.text,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 8),
//       child: TextFormField(
//         controller: c,
//         keyboardType: type,
//         style: const TextStyle(fontSize: 14),
//         decoration: InputDecoration(
//           isDense: true,
//           contentPadding: const EdgeInsets.symmetric(
//             horizontal: 12,
//             vertical: 10,
//           ),
//           labelText: label,
//           labelStyle: const TextStyle(fontSize: 14),
//           border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
//         ),
//         validator: (val) =>
//             val == null || val.trim().isEmpty ? "Required" : null,
//       ),
//     );
//   }

//   /// 🔹 Compact Dropdown Builder
//   Widget _buildDropdown({
//     required String label,
//     required RxnString value,
//     required List<String> items,
//     void Function(String?)? onChanged,
//   }) {
//     return Obx(
//       () => DropdownButtonFormField<String>(
//         value: value.value,
//         decoration: InputDecoration(
//           isDense: true,
//           contentPadding: const EdgeInsets.symmetric(
//             horizontal: 12,
//             vertical: 10,
//           ),
//           labelText: label,
//           labelStyle: const TextStyle(fontSize: 14),
//           border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
//         ),
//         style: const TextStyle(fontSize: 14),
//         items: items
//             .map(
//               (e) => DropdownMenuItem(
//                 value: e,
//                 child: Text(e, style: const TextStyle(fontSize: 14)),
//               ),
//             )
//             .toList(),
//         onChanged: onChanged ?? (v) => value.value = v,
//         validator: (v) => v == null ? "Required" : null,
//       ),
//     );
//   }
// }


