class SolarData {
  // final double solarRadiation;
  // final double sunshineHours;
  // final double energyPotential;
  final String ilce;
  final Map<String, dynamic> monthlyKWh;
  final Map<String, dynamic> sunshineHours;

  SolarData({
    required this.monthlyKWh,
    required this.sunshineHours,
    required this.ilce,
    // required this.solarRadiation,
    // required this.sunshineHours,
    // required this.energyPotential,
  });
}
