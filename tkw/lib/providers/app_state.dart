import 'package:flutter/foundation.dart';
import '../models/district.dart';
import '../models/solar_data.dart';

class AppState extends ChangeNotifier {
  District? selectedDistrict;
  SolarData? solarData;

  // Temporary data for districts
  final List<District> districts = [
    District(name: 'Ankara', latitude: 39.9334, longitude: 32.8597),
    District(name: 'Istanbul', latitude: 41.0082, longitude: 28.9784),
    District(name: 'Izmir', latitude: 38.4237, longitude: 27.1428),
    District(name: 'Antalya', latitude: 36.8969, longitude: 30.7133),
    District(name: 'Adana', latitude: 37.0000, longitude: 35.3213),
  ];

  // Temporary solar data for districts
  final Map<String, SolarData> districtSolarData = {
    'Ankara': SolarData(solarRadiation: 4.2, sunshineHours: 7.5, energyPotential: 1600),
    'Istanbul': SolarData(solarRadiation: 3.8, sunshineHours: 6.8, energyPotential: 1450),
    'Izmir': SolarData(solarRadiation: 4.5, sunshineHours: 8.2, energyPotential: 1700),
    'Antalya': SolarData(solarRadiation: 5.1, sunshineHours: 9.0, energyPotential: 1900),
    'Adana': SolarData(solarRadiation: 4.8, sunshineHours: 8.5, energyPotential: 1800),
  };

  void setSelectedDistrict(District district) {
    selectedDistrict = district;
    solarData = districtSolarData[district.name];
    notifyListeners();
  }

  void setSolarData(SolarData data) {
    solarData = data;
    notifyListeners();
  }
}
