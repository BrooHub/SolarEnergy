// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../models/district.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/loading_indicator.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  bool isLoading = true;
  MapController mapController = MapController();

  static const LatLng _center = LatLng(39.9334, 32.8597); // Ankara coordinates

  @override
  void initState() {
    super.initState();
    // Simulate map loading
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  void _onTap(LatLng position) {
    final appState = Provider.of<AppState>(context, listen: false);
    // Find the nearest district
    District nearestDistrict = appState.districts.reduce((a, b) {
      double distA = (a.latitude - position.latitude).abs() + (a.longitude - position.longitude).abs();
      double distB = (b.latitude - position.latitude).abs() + (b.longitude - position.longitude).abs();
      return distA < distB ? a : b;
    });
    appState.setSelectedDistrict(nearestDistrict);
    _showDistrictInfo(nearestDistrict);
  }

  void _showDistrictInfo(District district) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(district.name, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              Text('Latitude: ${district.latitude.toStringAsFixed(4)}'),
              Text('Longitude: ${district.longitude.toStringAsFixed(4)}'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/district_info');
                },
                child: const Text('Detayları Görüntüle'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    return Scaffold(
      appBar: const CustomAppBar(title: 'Solar Energy Explorer'),
      body: Stack(
        children: [
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              onTap: (_, position) => _onTap(position),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: const ['a', 'b', 'c'],
              ),
              MarkerLayer(
                  markers: appState.districts.map((district) => Marker(
                  width: 80.0,
                  height: 80.0,
                  point: LatLng(district.latitude, district.longitude),
                  child: IconButton(
                    icon: const Icon(Icons.location_on),
                    color: Colors.red,
                    iconSize: 45.0,
                    onPressed: () {
                      appState.setSelectedDistrict(district);
                      _showDistrictInfo(district);
                    },
                  ),
                )).toList(),
              ),
            ],
          ),
          if (isLoading) const LoadingIndicator(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Center the map on Ankara
          mapController.move(_center, 7.0);
        },
        child: const Icon(Icons.my_location),
      ),
    );
  }
}
