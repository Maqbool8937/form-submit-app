import 'package:flutter/material.dart';
import 'package:form_submit_app/controllers/getxControllers/kpi_controller.dart';
import 'package:get/get.dart';

import 'package:intl/intl.dart';

class KPIFormScreen extends StatelessWidget {
  const KPIFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(KPIController());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text("KPIs Enforcement by PHP"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Date & Time
              Obx(
                () => Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Date & Time: ${DateFormat('dd/MM/yyyy, hh:mm a').format(controller.selectedDateTime.value)}",
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.access_time),
                      onPressed: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2030),
                        );
                        if (date != null) {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
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
              const SizedBox(height: 10),

              // Region
              _buildDropdown(
                label: "Select Region",
                value: controller.selectedRegion,
                items: controller.regions.keys.toList(),
              ),
              const SizedBox(height: 10),

              // District
              Obx(
                () => _buildDropdown(
                  label: "Select District",
                  value: controller.selectedDistrict,
                  items: controller.selectedRegion.value == null
                      ? []
                      : controller.regions[controller.selectedRegion.value]!,
                ),
              ),
              const SizedBox(height: 10),

              // PHP Post
              _buildDropdown(
                label: "Select PHP Post",
                value: controller.selectedPost,
                items: controller.posts,
              ),
              const SizedBox(height: 10),

              // Road
              _buildDropdown(
                label: "Select Road",
                value: controller.selectedRoad,
                items: controller.roads,
              ),
              const SizedBox(height: 10),

              // Officer (Observer)
              _buildDropdown(
                label: "Officer (Observer) Name",
                value: controller.selectedOfficer,
                items: controller.officers,
              ),
              const SizedBox(height: 10),

              _buildTextField(controller.officerRank, "Officer Rank"),
              _buildTextField(controller.officerBeltNo, "Officer Belt No"),
              _buildTextField(controller.officerCnic, "Officer CNIC"),
              _buildTextField(controller.roadUserName, "Road User/Driver Name"),
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

              _buildDropdown(
                label: "Category",
                value: controller.selectedCategory,
                items: controller.categories,
              ),
              const SizedBox(height: 10),

              _buildDropdown(
                label: "Violation Indicator (Observed)",
                value: controller.selectedViolationIndicator,
                items: controller.violationIndicators,
              ),
              const SizedBox(height: 10),

              _buildDropdown(
                label: "Violation",
                value: controller.selectedViolation,
                items: controller.violations,
              ),
              const SizedBox(height: 20),

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
                    ),
                    child: Text(
                      controller.isSubmitting.value
                          ? "Submitting..."
                          : "Submit",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

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
          border: const OutlineInputBorder(),
          labelText: label,
        ),
        validator: (val) =>
            val == null || val.trim().isEmpty ? "Required" : null,
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required RxnString value,
    required List<String> items,
  }) {
    return Obx(
      () => DropdownButtonFormField<String>(
        value: value.value,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: label,
        ),
        items: items
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: (v) => value.value = v,
        validator: (v) => v == null ? "Required" : null,
      ),
    );
  }
}
