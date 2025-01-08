// ignore_for_file: public_member_api_docs, sort_constructors_first, avoid_print
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../models/district.dart';
import '../models/solar_data.dart';

class AppState extends ChangeNotifier {
  static District? selectedDistrict;
  static SolarData? solarData;
  static List<dynamic> ilList = [];
  static List<dynamic> ilceList = [];
  static Map<String, SolarData> districtSolarData = {};
  bool isLoading = false;
  String? error;

  Future<void> getIlData() async {
    try {
      final ilData = await rootBundle.loadString('assets/json/il.json');
      ilList = jsonDecode(ilData);
    } catch (e) {
      error = "Error loading province data: $e";
      notifyListeners();
    }
  }

  Future<void> getIlceData() async {
    try {
      final ilceData = await rootBundle.loadString('assets/json/ilce.json');
      ilceList = jsonDecode(ilceData);
      
    } catch (e) {
      error = "Error loading district data: $e";
      notifyListeners();
    }
  }

  AppState() {
    _initializeData();
  }

  Future<void> _initializeData() async {
    try {
      isLoading = true;
      notifyListeners();
      
      await getIlData();
      await getIlceData();
      await fetch();
      
      error = null;
    } catch (e) {
      error = "Error initializing data: $e";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetch() async {
    if (ilList.isEmpty || ilceList.isEmpty) {
      error = "Province or district data is not loaded properly";
      notifyListeners();
      return;
    }

    try {
      districts.clear();
      districtSolarData.clear();

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
        // districtSolarData[district.ilce] = solarData;

        districtSolarData.addAll({district.ilce:solarData});
      }
      
      error = null;
    } catch (e) {
      error = "Error fetching data: $e";
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>?> searchInJsonFile(
      String postCode, String ilce) async {
    try {
      isLoading = true;
      notifyListeners();

      final result = ilceList.firstWhere(
        (entry) => entry['posta_code'] == postCode && entry['ilce'] == ilce,
        orElse: () => null,
      );

      error = null;
      return result as Map<String, dynamic>?;
    } catch (e) {
      error = "Error searching district: $e";
      notifyListeners();
      return null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  final List<District> districts = [];

  void setSelectedDistrict(District district) {
    try {
      print(district.latitude);
      print(district.longitude);
      print(district.sunshineHours['EKIM']);
      print(district.monthlyKWh['EKIM']);
      print(district.ilce);
      selectedDistrict = district;
      
      print(districtSolarData[district.ilce]);
      solarData = SolarData(monthlyKWh: district.monthlyKWh, sunshineHours: district.sunshineHours, ilce: district.ilce);
      error = null;
    } catch (e) {
      error = "Error selecting district: $e";
    }
    notifyListeners();
  }

  void setSolarData(SolarData data) {
    try {
      solarData = data;
      error = null;
    } catch (e) {
      error = "Error setting solar data: $e";
    }
    notifyListeners();
  }
}