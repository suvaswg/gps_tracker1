import 'package:flutter/material.dart';

class AlertsPage extends StatelessWidget {
  final List<Map<String, dynamic>> alerts = [
    {
      "title": "Child exited Safe Zone",
      "time": "10:32 AM",
      "type": "danger",
    },
    {
      "title": "Child entered Safe Zone",
      "time": "9:50 AM",
      "type": "success",
    },
    {
      "title": "Low GPS Signal Detected",
      "time": "9:15 AM",
      "type": "warning",
    },
  ];

  AlertsPage({super.key});

  Color _getAlertColor(String type) {
    switch (type) {
      case "danger":
        return Colors.redAccent;
      case "success":
        return Colors.green;
      case "warning":
        return Colors.orange;
      default:
        return Colors.blueGrey;
    }
  }

  IconData _getAlertIcon(String type) {
    switch (type) {
      case "danger":
        return Icons.warning_amber_rounded;
      case "success":
        return Icons.check_circle;
      case "warning":
        return Icons.gps_off;
      default:
        return Icons.notifications;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        padding: EdgeInsets.all(12),
        itemCount: alerts.length,
        itemBuilder: (context, index) {
          final alert = alerts[index];
          return Card(
            elevation: 3,
            margin: EdgeInsets.symmetric(vertical: 6),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: _getAlertColor(alert["type"]),
                child: Icon(
                  _getAlertIcon(alert["type"]),
                  color: Colors.white,
                ),
              ),
              title: Text(
                alert["title"],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text("Time: ${alert["time"]}"),
              trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ),
          );
        },
      ),
    );
  }
}
