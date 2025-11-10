import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_submit_app/view/screens/authentication/login_screen.dart';
import 'package:form_submit_app/view/screens/dashboard/dashboard_screen.dart';
import 'package:get/get.dart';

class DashboardDrawer extends StatelessWidget {
  final Function(String) onItemSelected;
  final Map<String, dynamic> userData;

  const DashboardDrawer({
    Key? key,
    required this.onItemSelected,
    required this.userData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String fullName = userData['fullName'] ?? 'N/A';
    final String email = userData['email'] ?? 'N/A';
    final String imageUrl = userData['profileImage'] ?? '';

    return Drawer(
      backgroundColor: Colors.red.shade700,
      child: Column(
        children: [
          Container(
            color: Colors.red.shade800,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white,
                  backgroundImage: imageUrl.isNotEmpty
                      ? NetworkImage(imageUrl)
                      : null,
                  child: imageUrl.isEmpty
                      ? const Icon(Icons.person, size: 45, color: Colors.grey)
                      : null,
                ),
                const SizedBox(height: 12),
                Text(
                  fullName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  email,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Drawer Menu Items
          Expanded(
            child: ListView(
              children: [
                _buildDrawerItem(
                  icon: Icons.dashboard,
                  label: "Dashboard",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) {
                          return DashboardScreen(userData: userData);
                          //return DashboardScreen(userData: ,);
                        },
                      ),
                    );
                  },
                ),

                _buildDrawerItem(
                  icon: Icons.analytics,
                  label: "Reports",
                  onTap: () => onItemSelected("Reports"),
                ),
                _buildDrawerItem(
                  icon: Icons.settings_cell,
                  label: "Settings",
                  onTap: () => onItemSelected("Settings"),
                ),
              ],
            ),
          ),

          // Logout Section
          const Divider(color: Colors.white54, height: 1),
          _buildDrawerItem(
            icon: Icons.logout,
            label: "Logout",
            onTap: () {
              FirebaseAuth.instance.signOut().then((_) {
                Get.off(() => LoginScreen());
              });
              onItemSelected("Logout");
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(
        label,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
      onTap: onTap,
    );
  }
}
