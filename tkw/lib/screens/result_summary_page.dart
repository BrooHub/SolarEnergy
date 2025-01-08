import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/chart_widgets.dart';
import '../providers/app_state.dart';
import 'package:provider/provider.dart';

class ResultSummaryPage extends StatelessWidget {
  const ResultSummaryPage({super.key});

  @override
  Widget build(BuildContext context) {

    final solarData = AppState.solarData;

    // Calculate values based on solar data
    final estimatedProduction = solarData?.sunshineHours["Ekim"] ?? 0.0; // kWh
    const roi = 15.5; // %
    const paybackPeriod = 7.2; // years
    final co2Saved = estimatedProduction * 0.7; // Rough estimate: 0.7 kg CO2 per kWh

    return Scaffold(
      appBar: const CustomAppBar(title: 'Sonuç Özeti'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tahmini Enerji Üretimi', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text('Yıllık ${estimatedProduction.toStringAsFixed(2)} kWh', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 24),
            Text('Yatırım Getirisi (ROI)', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text('%${roi.toStringAsFixed(1)}', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 24),
            Text('Geri Ödeme Süresi', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text('${paybackPeriod.toStringAsFixed(1)} yıl', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 24),
            Text('Çevresel Etki', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text('Yıllık CO2 Tasarrufu: ${co2Saved.toStringAsFixed(2)} kg', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 24),
            if (solarData != null) SolarRadiationChart(solarData: solarData),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // Implement share functionality
              },
              child: const Text('Sonuçları Paylaş'),
            ),
          ],
        ),
      ),
    );
  }
}
