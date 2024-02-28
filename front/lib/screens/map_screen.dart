import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends StatefulWidget {
  final List filteredIgloos;
  final Position currentPosition;

  MapScreen({required this.filteredIgloos, required this.currentPosition});
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  List<Marker> markers = [];
  void _fetchMarkers() {
    for (var markerData in widget.filteredIgloos) {
      markers.add(
        Marker(
          point: LatLng(markerData['latitude'], markerData['longitude']),
          builder: (context) => Container(
            color: Colors.black,
            width: 200,
            height: 200,
            child: Icon(
              Icons.location_pin,
            ),
          ),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchMarkers();
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        center: LatLng(48.856614, 2.3522219),
        zoom: 15,
      ),
      children: [
        MarkerLayer(markers: markers),
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
        ),
      ],
    );
  }
}
