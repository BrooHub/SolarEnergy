import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/chart_widgets.dart';
import '../providers/app_state.dart';

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({super.key});

  @override
  Widget build(BuildContext context) {

    final solarData = AppState.solarData;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: const CustomAppBar(
          title: 'İstatistikler',
          bottom: TabBar(
            tabs: [
              Tab(text: 'Güneş Radyasyonu'),
              Tab(text: 'Enerji Potansiyeli'), 
              Tab(text: 'Karşılaştırma'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            solarData != null 
              ? SolarRadiationChart(solarData: solarData)
              : const Center(child: Text('Veri yok')),
            solarData != null
              ? SolarRadiationChart(solarData: solarData) 
              : const Center(child: Text('Veri yok')),
            solarData != null
              ? SolarRadiationChart(solarData: solarData)
              : const Center(child: Text('Veri yok')),
          ],
        ),
      ),
    );
  }
}
