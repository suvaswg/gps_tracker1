import 'package:flutter/material.dart';
import 'live_tracking_page.dart';
import 'safe_zones_page.dart';
import 'alerts_page.dart';
import 'security_page.dart';

void main() {
  runApp(SecureChildApp());
}

class SecureChildApp extends StatelessWidget {
  const SecureChildApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SecureChild Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SecureChildHomePage(),
    );
  }
}

class SecureChildHomePage extends StatefulWidget {
  const SecureChildHomePage({super.key});

  @override
  _SecureChildHomePageState createState() => _SecureChildHomePageState();
}

class _SecureChildHomePageState extends State<SecureChildHomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    LiveTrackingPage(),  // ✅ your existing live tracking page
    SafeZonesPage(),
    AlertsPage(),
    SecurityPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SecureChild Tracker"),
      ),
      body: Column(
        children: [
          // 🔹 Top Navigation Tabs
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildTabButton("Live Tracking", 0),
              _buildTabButton("Safe Zones", 1),
              _buildTabButton("Alerts", 2),
              _buildTabButton("Security", 3),
            ],
          ),
          SizedBox(height: 8),

          // 🔹 Page Content
          Expanded(
            child: _pages[_selectedIndex],
          ),
        ],
      ),
    );
  }

  /// 🔹 Helper for top nav button
  Widget _buildTabButton(String title, int index) {
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: _selectedIndex == index ? FontWeight.bold : FontWeight.normal,
              color: _selectedIndex == index ? Colors.blue : Colors.black54,
            ),
          ),
          if (_selectedIndex == index)
            Container(
              margin: EdgeInsets.only(top: 4),
              height: 3,
              width: 40,
              color: Colors.blue,
            ),
        ],
      ),
    );
  }
}
