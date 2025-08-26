import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/google_places_flutter.dart';

const kGoogleApiKey = "AIzaSyBrCgWbxjdQLFbStBcrRAy864JN1N6FDlo"; // 🔹 Replace with your API Key

class SafeZonesPage extends StatefulWidget {
  const SafeZonesPage({super.key});

  @override
  _SafeZonesPageState createState() => _SafeZonesPageState();
}

class _SafeZonesPageState extends State<SafeZonesPage> {
  late GoogleMapController _mapController;
  LatLng _center = const LatLng(3.1390, 101.6869); // Default: Kuala Lumpur
  final Set<Marker> _markers = {};
  final Set<Circle> _circles = {};
  int _zoneIdCounter = 1;

  final TextEditingController searchController = TextEditingController();

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void _moveToLocation(double lat, double lng) {
    setState(() {
      _center = LatLng(lat, lng);
      _mapController.animateCamera(
        CameraUpdate.newLatLngZoom(_center, 15),
      );
    });
    _showSafeZoneDialog(_center);
  }

  void _showSafeZoneDialog(LatLng position) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController radiusController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Set Safe Zone"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Zone Name"),
            ),
            TextField(
              controller: radiusController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Radius (meters)"),
            ),
          ],
        ),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () => Navigator.pop(ctx),
          ),
          ElevatedButton(
            child: const Text("Save"),
            onPressed: () {
              final name = nameController.text;
              final radius = double.tryParse(radiusController.text) ?? 200;

              setState(() {
                _markers.add(
                  Marker(
                    markerId: MarkerId("zone_$_zoneIdCounter"),
                    position: position,
                    infoWindow: InfoWindow(title: name),
                  ),
                );

                _circles.add(
                  Circle(
                    circleId: CircleId("circle_$_zoneIdCounter"),
                    center: position,
                    radius: radius,
                    fillColor: Colors.blue.withOpacity(0.2),
                    strokeColor: Colors.blue,
                    strokeWidth: 2,
                  ),
                );

                _zoneIdCounter++;
              });

              Navigator.pop(ctx);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 12,
            ),
            markers: _markers,
            circles: _circles,
          ),

          // 🔹 Search Autocomplete Field
          Positioned(
            top: 40,
            left: 16,
            right: 16,
            child: GooglePlaceAutoCompleteTextField(
              textEditingController: searchController,
              googleAPIKey: kGoogleApiKey,
              inputDecoration: InputDecoration(
                hintText: "Search location...",
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              debounceTime: 600,
              countries: const ["my"], // limit to Malaysia
              isLatLngRequired: true,
              getPlaceDetailWithLatLng: (prediction) {
                final lat = double.tryParse(prediction.lat ?? "0") ?? 0;
                final lng = double.tryParse(prediction.lng ?? "0") ?? 0;
                if (lat != 0 && lng != 0) {
                  _moveToLocation(lat, lng);
                }
              },
              itemClick: (prediction) {
                searchController.text = prediction.description ?? "";
                searchController.selection = TextSelection.fromPosition(
                  TextPosition(offset: searchController.text.length),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
