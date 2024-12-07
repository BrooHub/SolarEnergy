import 'package:flutter/material.dart';
import '../models/solar_data.dart';

class SolarDataCard extends StatelessWidget {
  final SolarData solarData;
  final String mounth;
  const SolarDataCard({super.key, required this.solarData,required this.mounth});

  @override
  Widget build(BuildContext context) {
    return Card(
      color:Colors.white,

      shadowColor: Colors.black,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Güneş Radyasyonu: ${solarData.monthlyKWh[mounth]} kWh/m²',style:const TextStyle(fontSize: 20)),
            const SizedBox(height: 8),
            Text('Güneşlenme Saatleri: ${solarData.sunshineHours[mounth]} saat',style:const TextStyle(fontSize: 20)),
            const SizedBox(height: 8),
            Text('Enerji Potansiyeli: ${solarData.monthlyKWh[mounth]} kWh/kWp',style:const TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }
}

