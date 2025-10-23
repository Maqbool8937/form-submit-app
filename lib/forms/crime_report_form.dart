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


