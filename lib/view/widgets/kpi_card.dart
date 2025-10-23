import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:form_submit_app/view/screens/dashboard/crime_detail_screen.dart';
import 'package:form_submit_app/view/screens/dashboard/kpi_detail_screen.dart';
import 'package:get/get.dart';

class KpiCard extends StatelessWidget {
  final Size mediaquerysize;
  const KpiCard({super.key, required this.mediaquerysize});

  Stream<int> getCrimeCount() {
    return FirebaseFirestore.instance
        .collection("kpi_reports")
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to the detail screen and pass collection name
        Get.to(() => const KpiDetailScreen());
      },
      child: Container(
        height: mediaquerysize.height * 0.07,
        width: mediaquerysize.width * 1,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.blue,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Road Safety KPI',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              StreamBuilder<int>(
                stream: getCrimeCount(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Text(
                      "0",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  }
                  return Text(
                    snapshot.data.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
