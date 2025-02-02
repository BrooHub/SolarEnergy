import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class District {
  String postaCode;
  String ilce;
  double latitude;
  double longitude;
  Map<String, dynamic> monthlyKWh;
  Map<String, dynamic> sunshineHours;

  District({
    required this.postaCode,
    required this.ilce,
    required this.latitude,
    required this.longitude,
    required this.monthlyKWh,
    required this.sunshineHours,
  });

  factory District.fromJson(Map<String, dynamic> json) {
    return District(
      postaCode: json['posta_code']?.toString() ?? '',
      ilce: json['ilce']?.toString() ?? '',
      latitude: _parseDouble(json['latitude']),
      longitude: _parseDouble(json['longitude']),
      monthlyKWh: _parseNumberMap(json['monthlyKWh']),
      sunshineHours: _parseNumberMap(json['sunshineHours']),
    );
  }

  static double _parseDouble(dynamic value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  static Map<String, double> _parseNumberMap(dynamic data) {
    final Map<String, double> result = {};
    if (data is Map) {
      data.forEach((key, value) {
        final k = key?.toString() ?? '';
        result[k] = _parseDouble(value);
      });
    }
    return result;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'postaCode': postaCode,
      'ilce': ilce,
      'latitude': latitude,
      'longitude': longitude,
      'monthlyKWh': monthlyKWh,
      'sunshineHours': sunshineHours,
    };
  }

  String toJson() => json.encode(toMap());
}
