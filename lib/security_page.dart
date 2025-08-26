import 'package:flutter/material.dart';

class SecurityPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Title
            Text(
              "Security Settings",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            SizedBox(height: 20),

            // 🔹 Change Password
            ListTile(
              leading: Icon(Icons.lock, color: Colors.blue),
              title: Text("Change Password"),
              subtitle: Text("Update your account password"),
              trailing: Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // Later: Navigate to Change Password Page
              },
            ),
            Divider(),

            // 🔹 Enable/Disable 2FA
            SwitchListTile(
              secondary: Icon(Icons.security, color: Colors.green),
              title: Text("Two-Factor Authentication"),
              subtitle: Text("Add extra security to your account"),
              value: true, // default enabled
              onChanged: (val) {
                // Later: Save toggle state in DB
              },
            ),
            Divider(),

            // 🔹 Logout Option
            ListTile(
              leading: Icon(Icons.logout, color: Colors.red),
              title: Text("Logout"),
              subtitle: Text("Sign out of your account"),
              onTap: () {
                // Later: Add logout functionality
              },
            ),
          ],
        ),
      ),
    );
  }
}
