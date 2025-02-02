// ignore_for_file: library_private_types_in_public_api, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../models/district.dart';

import '../widgets/floating_button.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/search_bar.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});
  static bool isLoading = true;

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  MapController mapController = MapController();
  static const LatLng _center = LatLng(39.9334, 32.8597);
  @override
  void initState() {
    super.initState();
    // Simulate map loading
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        MapPage.isLoading = false;
      });
    });
  }

  void _onSearchResultSelected(String ilceName) {
    Provider.of<AppState>(context, listen: false);
    final ilce = AppState.ilceList.firstWhere(
      (il) => il['ilce'] == ilceName,
      orElse: () => null,
    );

    if (ilce == null) {
      print("No matching district found for '$ilceName'");
      return;
    }
    if (AppState.selectedDistrict == null) {
      AppState.selectedDistrict = District(
          postaCode: ilce['posta_code'],
          ilce: ilceName,
          latitude: ilce['latitude'],
          longitude: ilce['longitude'],
          monthlyKWh: ilce['monthlyKWh'],
          sunshineHours: ilce['sunshineHours']);
    } else {
      AppState.selectedDistrict?.ilce = ilceName;
      AppState.selectedDistrict?.latitude = ilce['latitude'];
      AppState.selectedDistrict?.longitude = ilce['longitude'];
      AppState.selectedDistrict?.monthlyKWh = ilce['monthlyKWh'];
      AppState.selectedDistrict?.sunshineHours = ilce['sunshineHours'];
      AppState.selectedDistrict?.postaCode = ilce['posta_code'];
    }

    final postaCode = int.parse(ilce['posta_code']);
    final city = AppState.ilList[postaCode - 1]['il'];
    final LatLng position = LatLng(
      ilce['latitude'],
      ilce['longitude'],
    );

    print("Matching City: $city");
    print("Matching District: $ilce");
    print("Position: $position");

    mapController.move(position, 10.0);

    if (MapPage.isLoading) {
      const LoadingIndicator();
    }
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _showDistrictInfo(AppState.selectedDistrict!);
      });
    });
  }

  void _onTap(LatLng position) {
    final appState = Provider.of<AppState>(context, listen: false);
    // Find the nearest district
    District nearestDistrict = appState.districts.reduce((a, b) {
      double distA = (a.latitude - position.latitude).abs() +
          (a.longitude - position.longitude).abs();
      double distB = (b.latitude - position.latitude).abs() +
          (b.longitude - position.longitude).abs();
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
          padding: const EdgeInsets.all(20),
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(district.ilce,
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              Text('Latitude: ${district.latitude.toStringAsFixed(4)}'),
              Text('Longitude: ${district.longitude.toStringAsFixed(4)}'),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(Colors.white)),
                onPressed: () {
                  Navigator.pushNamed(context, '/result_summary');
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
      body: Column(children: [
        Expanded(
          flex: 1,
          child: Stack(
            children: [
              FlutterMap(
                mapController: mapController,
                options: MapOptions(
                  onTap: (_, position) => _onTap(position),
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                    subdomains: const ['a', 'b', 'c'],
                  ),
                  MarkerLayer(
                    markers: appState.districts
                        .map((district) => Marker(
                              width: 50.0,
                              height: 50.0,
                              point:
                                  LatLng(district.latitude, district.longitude),
                              child: IconButton(
                                icon: const Icon(Icons.location_on),
                                color: Colors.red,
                                iconSize: 25.0,
                                onPressed: () {
                                  appState.setSelectedDistrict(district);

                                  _showDialog(context, district);
                                },
                              ),
                            ))
                        .toList(),
                  ),
                ],
              ),
              if (MapPage.isLoading) const LoadingIndicator(),
              MySearchBar(
                onSearchResultSelected: _onSearchResultSelected,
              ),
            ],
          ),
        ),
      ]),
      floatingActionButton: FancyFab(
        mapController: mapController,
        center: _center,
      ),
    );
  }

  void _showDialog(
      // ignore: non_constant_identifier_names
      BuildContext context,
      District district) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          content: Text(
            "Ülke: Türkiye \n Il: ${AppState.ilList[int.parse(district.postaCode) - 1]['il']} \n Ilçe: ${district.ilce} ",
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text(
                'iptal',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/result_summary');
              },
              child: const Text(
                'Sec',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        );
      },
    );
  }
}
