// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';

import '../models/district.dart';
import '../models/solar_data.dart';

class AppState extends ChangeNotifier {
  District? selectedDistrict;
  SolarData? solarData;
  static List<dynamic> ilList = [];
  static List<dynamic> ilceList = [];
  static Map<String, SolarData> districtSolarData = {};
  Future<void> getIlData() async {
    final ilData = await File(
            '/Users/main/Desktop/ABCDE/flutter/SolarEnergy/tkw/assets/json/il.json')
        .readAsString();
    ilList = jsonDecode(ilData);
  }

  Future<void> getIlceData() async {
    final ilceData = await File(
            '/Users/main/Desktop/ABCDE/flutter/SolarEnergy/tkw/assets/json/ilce.json')
        .readAsString();

    ilceList = jsonDecode(ilceData);
  }

  AppState({
    this.selectedDistrict,
    this.solarData,
  }) {
    _initializeData();
  }
  Future<void> _initializeData() async {
    await getIlData();
    await getIlceData();
    await fetch();
  }

  Future<void> fetch() async {

    if (ilList.isEmpty || ilceList.isEmpty) {
      print("ilList or ilceList is empty. Ensure data is loaded.");
      return;
    }

    for (var il in ilList) {
      final String ilName = il['id'].toString();

      final matchingIlces =
          ilceList.where((ilce) => ilce['posta_code'] == ilName);

      for (var ilce in matchingIlces) {
        districts.add(District.fromJson(ilce));
      }
    }

    for (var district in districts) {
      SolarData solarData = SolarData(
        ilce: district.ilce,
        monthlyKWh: district.monthlyKWh,
        sunshineHours: district.sunshineHours,
      );
      districtSolarData[district.ilce] = solarData;
    }
  }

  Future<Map<String, dynamic>?> searchInJsonFile(
      String postCode, String ilce) async {
    try {
      final result = ilceList.firstWhere(
        (entry) => entry['posta_code'] == postCode && entry['ilce'] == ilce,
        orElse: () => null,
      );

      return result as Map<String, dynamic>?;
    } catch (e) {
      // Handle any errors (e.g., file not found, decoding error)
      print("Error reading or parsing the file: $e");
      return null;
    }
  }

  final List<District> districts = [];

  void setSelectedDistrict(District district) {
    selectedDistrict = district;
    solarData = districtSolarData[district.ilce];
    notifyListeners();
  }

  void setSolarData(SolarData data) {
    solarData = data;
    notifyListeners();
  }
}
