import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  final Map<String, dynamic> userData;

  const ProfileScreen({Key? key, required this.userData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Extract your fields safely with null checks
    String fullName = userData['fullName'] ?? 'N/A';
    String cnic = userData['cnic'] ?? 'N/A';
    String phoneNumber = userData['phoneNumber'] ?? 'N/A';
    String email = userData['email'] ?? 'N/A';
    String region = userData['region'] ?? 'N/A';
    String district = userData['district'] ?? 'N/A';
    String post = userData['post'] ?? 'N/A';
    String role = userData['role'] ?? 'N/A';
    String username = userData['username'] ?? 'N/A';

    return Scaffold(
      appBar: AppBar(title: Text('User Profile')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: ListView(
          children: [
            Text('Full Name: $fullName', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('CNIC: $cnic', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Phone Number: $phoneNumber', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Email: $email', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Region: $region', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('District: $district', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Post: $post', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Role: $role', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Username: $username', style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
