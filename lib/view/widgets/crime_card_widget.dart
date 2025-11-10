import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:form_submit_app/controllers/getxControllers/dashboard_controller.dart';
import 'package:form_submit_app/view/screens/dashboard/crime_detail_screen.dart';

class CrimeCard extends StatelessWidget {
  final Size mediaquerysize;
  final DashboardController controller;

  const CrimeCard({
    super.key,
    required this.mediaquerysize,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to(
        () => const CrimeDetailScreen(collectionName: "crime_reports"),
      ),
      child: Container(
        height: mediaquerysize.height * 0.07,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.red,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Crimes',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Obx(
                () => Text(
                  '${controller.crimeCount.value}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:form_submit_app/view/screens/dashboard/crime_detail_screen.dart';
// import 'package:get/get.dart';

// class CrimeCard extends StatelessWidget {
//   final Size mediaquerysize;
//   const CrimeCard({super.key, required this.mediaquerysize});

//   Stream<int> getCrimeCount() {
//     return FirebaseFirestore.instance
//         .collection("crime_reports")
//         .snapshots()
//         .map((snapshot) => snapshot.docs.length);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         // Navigate to the detail screen and pass collection name
//         Get.to(() => const CrimeDetailScreen(collectionName: "crime_reports"));
//       },
//       child: Container(
//         height: mediaquerysize.height * 0.07,
//         width: mediaquerysize.width * 1,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(10),
//           color: Colors.red,
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               const Text(
//                 'Crime',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 15,
//                 ),
//               ),
//               StreamBuilder<int>(
//                 stream: getCrimeCount(),
//                 builder: (context, snapshot) {
//                   if (!snapshot.hasData) {
//                     return const Text(
//                       "0",
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     );
//                   }
//                   return Text(
//                     snapshot.data.toString(),
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   );
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
