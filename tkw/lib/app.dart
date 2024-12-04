import 'package:flutter/material.dart';
import 'screens/map_page.dart';
import 'screens/district_info_page.dart';
import 'screens/energy_calculation_page.dart';
import 'screens/statistics_page.dart';
import 'screens/result_summary_page.dart';

class SolarEnergyExplorer extends StatelessWidget {
  const SolarEnergyExplorer({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Solar Energy Explorer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const MapPage(),
        '/district_info': (context) => const DistrictInfoPage(),
        '/energy_calculation': (context) => const EnergyCalculationPage(),
        '/statistics': (context) => const StatisticsPage(),
        '/result_summary': (context) => const ResultSummaryPage(),
      },
    );
  }
}
