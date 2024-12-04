import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/solar_data_card.dart';
import '../widgets/chart_widgets.dart';

class DistrictInfoPage extends StatelessWidget {
  const DistrictInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final district = appState.selectedDistrict;
    final solarData = appState.solarData;

    if (district == null || solarData == null) {
      return const Scaffold(
        appBar: CustomAppBar(title: 'Bölge Bilgisi'),
        body: Center(child: Text('Bölge seçilmedi')),
      );
    }

    return Scaffold(
      appBar: CustomAppBar(title: district.name),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SolarDataCard(solarData: solarData),
            const SizedBox(height: 24),
            Text('Güneş Işınımı Değişimi', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            SolarRadiationChart(solarData: solarData),
            const SizedBox(height: 24),
            Text('Güneşlenme Süresi', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            SunshineHoursChart(solarData: solarData),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/energy_calculation');
              },
              child: const Text('Enerji Üretimini Hesapla'),
            ),
          ],
        ),
      ),
    );
  }
}
