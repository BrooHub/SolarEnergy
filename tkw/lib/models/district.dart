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
    postaCode: json['posta_code'] ?? '',
    ilce: json['ilce'] ?? '',
    latitude: (json['latitude'] is double)
        ? json['latitude']
        : double.tryParse(json['latitude'].toString()) ?? 0.0,
    longitude: (json['longitude'] is double)
        ? json['longitude']
        : double.tryParse(json['longitude'].toString()) ?? 0.0,
    monthlyKWh: json['monthlyKWh'] != null
        ? Map<String, double>.from(json['monthlyKWh'])
        : {},
    sunshineHours: json['sunshineHours'] != null
        ? Map<String, double>.from(json['sunshineHours'])
        : {},
  );
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

  // factory District.fromMap(Map<String, dynamic> map) {
  //   return District(
  //     postaCode: map['postaCode'] as String,
  //     ilce: map['ilce'] as String,
  //     latitude: map['latitude'] as double,
  //     longitude: map['longitude'] as double,
  //     monthlyKWh: Map<String, double>.from((map['monthlyKWh'] as Map<String, double>),
  //     sunshineHours: Map<String, double>.from((map['sunshineHours'] as Map<String, double>),
  //   )));
  // }


  String toJson() => json.encode(toMap());

}

