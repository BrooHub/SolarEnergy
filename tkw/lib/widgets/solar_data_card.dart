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
            Text('Güneş Radyasyonu: ${solarData.monthlyKWh["EKIM"]} kWh/m²'),
            const SizedBox(height: 8),
            Text('Güneşlenme Saatleri: ${solarData.monthlyKWh["EKIM"]} saat'),
            const SizedBox(height: 8),
            Text('Enerji Potansiyeli: ${solarData.monthlyKWh["EKIM"]} kWh/kWp'),
          ],
        ),
      ),
    );
  }
}

