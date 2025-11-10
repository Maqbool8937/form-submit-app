import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:form_submit_app/controllers/getxControllers/dashboard_controller.dart';
import 'package:form_submit_app/view/screens/dashboard/help_detail_screen.dart';

class HelpCard extends StatelessWidget {
  final Size mediaquerysize;
  final DashboardController controller;

  const HelpCard({
    super.key,
    required this.mediaquerysize,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          Get.to(() => const HelpDetailScreen(collectionName: 'help_forms')),
      child: Container(
        height: mediaquerysize.height * 0.07,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.green,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Helps',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Obx(
                () => Text(
                  '${controller.helpCount.value}',
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
// import 'package:form_submit_app/view/screens/dashboard/help_detail_screen.dart';
// import 'package:get/get.dart';

// class HelpCard extends StatelessWidget {
//   final Size mediaquerysize;
//   const HelpCard({super.key, required this.mediaquerysize});

//   Stream<int> getHelpCount() {
//     return FirebaseFirestore.instance
//         .collection("help_forms") // Firestore collection name
//         .snapshots()
//         .map((snapshot) => snapshot.docs.length);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         Get.to(() => const HelpDetailScreen(collectionName: 'help_forms'));
//       },
//       child: Container(
//         height: mediaquerysize.height * 0.07,
//         width: mediaquerysize.width * 1,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(10),
//           color: Colors.green,
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               const Text(
//                 'Helps',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 15,
//                 ),
//               ),
//               StreamBuilder<int>(
//                 stream: getHelpCount(),
//                 builder: (context, snapshot) {
//                   if (!snapshot.hasData) {
//                     return const Text(
//                       "0",
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     );
//                   }
//                   return Text(
//                     snapshot.data.toString(),
//                     style: const TextStyle(
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
