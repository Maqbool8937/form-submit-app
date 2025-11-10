import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_submit_app/controllers/getxControllers/inspect_vehical_controller.dart';
import 'package:form_submit_app/forms/crime_report_form.dart';
import 'package:form_submit_app/forms/help_form.dart';
import 'package:form_submit_app/forms/kpi_form.dart';
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
          // Get.off(() => DashboardScreen()),
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
                onTap: () {
                  Get.to(() => KPIFormScreen());
                },
                // onTap: () =>
                //     _launchExternalUrl('https://phpkpis.phppolice.com'),
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
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () => _launchExternalUrl(
                  'https://phpkpis.phppolice.com/index.php',
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
                        'Road Safety KPI-FORM',
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
