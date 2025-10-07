import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CrimeDetailScreen extends StatefulWidget {
  final String collectionName;

  const CrimeDetailScreen({super.key, required this.collectionName});

  @override
  State<CrimeDetailScreen> createState() => _CrimeDetailScreenState();
}

class _CrimeDetailScreenState extends State<CrimeDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final mediaquerySize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Crime Details'),
        backgroundColor: Colors.red,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection(widget.collectionName)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                "No crime reports found",
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          final crimes = snapshot.data!.docs;

          return ListView.builder(
            itemCount: crimes.length,
            itemBuilder: (context, index) {
              var data = crimes[index].data() as Map<String, dynamic>;

              return GestureDetector(
                onTap: () {
                  // Show bottom sheet with detailed info
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.white,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    builder: (context) {
                      return Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Center(
                                child: Container(
                                  width: 60,
                                  height: 5,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                data['crime_head'] ?? 'No crime head',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.person,
                                    color: Colors.black54,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      "CNIC: ${data['cnic'] ?? 'N/A'}",
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.local_police,
                                    color: Colors.black54,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      "Action Taken: ${data['action_taken'] ?? 'N/A'}",
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              if (data['location'] != null)
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.location_on,
                                      color: Colors.black54,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        "Location: ${data['location']}",
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ),
                                  ],
                                ),
                              const SizedBox(height: 10),
                              if (data['description'] != null)
                                Text(
                                  "Description:\n${data['description']}",
                                  style: const TextStyle(fontSize: 15),
                                ),
                              const SizedBox(height: 10),
                              if (data['imageUrl'] != null &&
                                  (data['imageUrl'] as String).isNotEmpty)
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    data['imageUrl'],
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: 200,
                                  ),
                                ),
                              const SizedBox(height: 20),
                              Center(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text(
                                    'Close',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                child: Container(
                  width: mediaquerySize.width,
                  height: mediaquerySize.height * 0.18,
                  child: Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 4,
                    child: ListTile(
                      leading: const Icon(Icons.report, color: Colors.red),
                      title: Text(
                        data['action_taken'] ?? 'No action_taken',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        data['cnic'] ?? 'No cnic',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Text(
                        data['crime_head'] ?? '',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class CrimeDetailScreen extends StatelessWidget {
//   final String collectionName;

//   const CrimeDetailScreen({super.key, required this.collectionName});

//   @override
//   Widget build(BuildContext context) {
//     final mediaquerySize = MediaQuery.of(context).size;
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Crime Details'),
//         backgroundColor: Colors.red,
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection(collectionName)
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return const Center(
//               child: Text(
//                 "No crime reports found",
//                 style: TextStyle(fontSize: 16),
//               ),
//             );
//           }

//           final crimes = snapshot.data!.docs;

//           return ListView.builder(
//             itemCount: crimes.length,
//             itemBuilder: (context, index) {
//               var data = crimes[index].data() as Map<String, dynamic>;

//               return Container(
//                 height: mediaquerySize.height * 0.18,
//                 width: mediaquerySize.width,
//                 child: Card(
//                   margin: const EdgeInsets.symmetric(
//                     horizontal: 12,
//                     vertical: 8,
//                   ),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),

//                   elevation: 4,
//                   child: ListTile(
//                     leading: const Icon(Icons.report, color: Colors.red),
//                     title: Text(
//                       data['action_taken'] ?? 'No action_taken',
//                       style: const TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                     subtitle: Text(
//                       data['cnic'] ?? 'No cnic',
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     trailing: Text(
//                       data['crime_head'] ?? '',
//                       style: const TextStyle(fontSize: 12, color: Colors.grey),
//                     ),
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
