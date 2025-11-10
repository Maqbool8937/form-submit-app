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
