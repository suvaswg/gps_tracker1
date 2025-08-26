import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';

const kGoogleApiKey = "YOUR_GOOGLE_MAPS_API_KEY"; // 🔹 Replace with your API Key
final GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

class SafeZonesPage extends StatefulWidget {
  @override
  _SafeZonesPageState createState() => _SafeZonesPageState();
}

class _SafeZonesPageState extends State<SafeZonesPage> {
  late GoogleMapController _mapController;
  LatLng _center = const LatLng(3.1390, 101.6869); // Default: Kuala Lumpur
  final Set<Marker> _markers = {};
  final Set<Circle> _circles = {};
  int _zoneIdCounter = 1;

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  Future<void> _handleSearch() async {
    Prediction? p = await PlacesAutocomplete.show(
      context: context,
      apiKey: kGoogleApiKey,
      mode: Mode.overlay, // Fullscreen search
      language: "en",
      components: [Component(Component.country, "my")], // Limit to Malaysia
    );

    if (p != null) {
      PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(p.placeId!);
      final lat = detail.result.geometry!.location.lat;
      final lng = detail.result.geometry!.location.lng;

      setState(() {
        _center = LatLng(lat, lng);
        _mapController.animateCamera(
          CameraUpdate.newLatLngZoom(_center, 15),
        );
      });

      _showSafeZoneDialog(_center);
    }
  }

  void _showSafeZoneDialog(LatLng position) {
    final TextEditingController _nameController = TextEditingController();
    final TextEditingController _radiusController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Set Safe Zone"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: "Zone Name"),
            ),
            TextField(
              controller: _radiusController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Radius (meters)"),
            ),
          ],
        ),
        actions: [
          TextButton(
            child: Text("Cancel"),
            onPressed: () => Navigator.pop(ctx),
          ),
          ElevatedButton(
            child: Text("Save"),
            onPressed: () {
              final name = _nameController.text;
              final radius = double.tryParse(_radiusController.text) ?? 200;

              setState(() {
                _markers.add(
                  Marker(
                    markerId: MarkerId("zone_${_zoneIdCounter}"),
                    position: position,
                    infoWindow: InfoWindow(title: name),
                  ),
                );

                _circles.add(
                  Circle(
                    circleId: CircleId("circle_${_zoneIdCounter}"),
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

          // 🔹 Search Button (Floating on top)
          Positioned(
            top: 40,
            left: 16,
            right: 16,
            child: GestureDetector(
              onTap: _handleSearch,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(Icons.search, color: Colors.grey),
                    SizedBox(width: 8),
                    Text(
                      "Search location...",
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
