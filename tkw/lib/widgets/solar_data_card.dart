import 'package:flutter/material.dart';
import '../models/solar_data.dart';

class SolarDataCard extends StatelessWidget {
  final SolarData solarData;

  const SolarDataCard({super.key, required this.solarData});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Güneş Radyasyonu: ${solarData.solarRadiation.toStringAsFixed(2)} kWh/m²'),
            const SizedBox(height: 8),
            Text('Güneşlenme Saatleri: ${solarData.sunshineHours.toStringAsFixed(2)} saat'),
            const SizedBox(height: 8),
            Text('Enerji Potansiyeli: ${solarData.energyPotential.toStringAsFixed(2)} kWh/kWp'),
          ],
        ),
      ),
    );
  }
}

