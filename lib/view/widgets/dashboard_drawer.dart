import 'package:flutter/material.dart';

class DashboardDrawer extends StatelessWidget {
  final Function(String) onItemSelected;

  const DashboardDrawer({Key? key, required this.onItemSelected})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // Header / Profile Section
          UserAccountsDrawerHeader(
            accountName: Text("John Doe"),
            accountEmail: Text("john.doe@example.com"),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(
                "https://www.example.com/profile-image.jpg",
              ),
            ),
            decoration: BoxDecoration(color: Colors.blue),
          ),

          // Menu Items
          ListTile(
            leading: Icon(Icons.dashboard),
            title: Text("Dashboard"),
            onTap: () {
              Navigator.pop(context);
              onItemSelected("Dashboard");
            },
          ),
          ListTile(
            leading: Icon(Icons.analytics),
            title: Text("Reports"),
            onTap: () {
              Navigator.pop(context);
              onItemSelected("Reports");
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text("Settings"),
            onTap: () {
              Navigator.pop(context);
              onItemSelected("Settings");
            },
          ),
          Spacer(),

          // Logout Button at Bottom
          ListTile(
            leading: Icon(Icons.logout, color: Colors.red),
            title: Text("Logout", style: TextStyle(color: Colors.red)),
            onTap: () {
              Navigator.pop(context);
              onItemSelected("Logout");
            },
          ),
        ],
      ),
    );
  }
}
