// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

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
  static const LatLng _center = LatLng(37.5912, 36.9442); // Kahramanmaraş
  static const LatLng _ankaraLocation = LatLng(39.9334, 32.8597); // Ankara
  static const double _defaultZoom = 11.0; // Varsayılan zoom seviyesi
  static const double _detailZoom = 12.5; // Detaylı görünüm için zoom seviyesi

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        MapPage.isLoading = false;
      });
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      mapController.move(_ankaraLocation, _defaultZoom); // Başlangıçta Ankara'ya odaklan
    });
  }

  void _onSearchResultSelected(String ilceName) {
    Provider.of<AppState>(context, listen: false);
    final ilce = AppState.ilceList.firstWhere(
      (il) => il['ilce'] == ilceName,
      orElse: () => null,
    );

    if (ilce == null) return;

    if (AppState.selectedDistrict == null) {
      AppState.selectedDistrict = District(
        postaCode: ilce['posta_code'],
        ilce: ilceName,
        latitude: ilce['latitude'],
        longitude: ilce['longitude'],
        monthlyKWh: ilce['monthlyKWh'],
        sunshineHours: ilce['sunshineHours'],
      );
    } else {
      AppState.selectedDistrict!
        ..ilce = ilceName
        ..latitude = ilce['latitude']
        ..longitude = ilce['longitude']
        ..monthlyKWh = ilce['monthlyKWh']
        ..sunshineHours = ilce['sunshineHours']
        ..postaCode = ilce['posta_code'];
    }

    mapController.move(
      LatLng(ilce['latitude'], ilce['longitude']),
      _detailZoom,
    );

    if (!MapPage.isLoading) {
      Future.delayed(const Duration(milliseconds: 500), () {
        _showDialog(context, AppState.selectedDistrict!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                FlutterMap(
                  mapController: mapController,
                  options: MapOptions(
                    initialCenter: _ankaraLocation,
                    initialZoom: _defaultZoom,
                    minZoom: 5.0,
                    maxZoom: 18.0,
                    onTap: (_, __) {},
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
                                point: LatLng(
                                  district.latitude,
                                  district.longitude,
                                ),
                                child: IconButton(
                                  icon: const Icon(Icons.location_on),
                                  color: Colors.red,
                                  iconSize: 25.0,
                                  onPressed: () {
                                    appState.setSelectedDistrict(district);
                                    mapController.move(
                                      LatLng(district.latitude, district.longitude),
                                      _detailZoom,
                                    );
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
        ],
      ),
      floatingActionButton: FancyFab(
        mapController: mapController,
        center: _center,
        defaultZoom: _detailZoom, // Kahramanmaraş'a yönlendirirken kullanılacak zoom seviyesi
      ),
    );
  }

  void _showDialog(BuildContext context, District district) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            padding: const EdgeInsets.all(24), // Padding'i biraz artırdık
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  district.ilce,
                  style: const TextStyle(
                    fontSize: 26, // Font boyutunu biraz artırdık
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                _buildInfoCard(
                  'Ülke',
                  'Türkiye',
                ),
                const SizedBox(height: 12),
                _buildInfoCard(
                  'İl',
                  AppState.ilList[int.parse(district.postaCode) - 1]['il'],
                ),
                const SizedBox(height: 12),
                _buildInfoCard(
                  'Koordinatlar',
                  '${district.latitude.toStringAsFixed(4)}°N, ${district.longitude.toStringAsFixed(4)}°E',
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16), // Buton yüksekliğini artırdık
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          side: BorderSide(color: Colors.grey[300]!),
                        ),
                        child: const Text(
                          'Kapat',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.teal,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () { 
                          Navigator.pushNamed(context, '/result_summary');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          padding: const EdgeInsets.symmetric(vertical: 16), // Buton yüksekliğini artırdık
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Detayları Görüntüle',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoCard(String label, String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}