import 'package:flutter/material.dart';
import 'package:tkw/screens/district_info_page.dart';

import 'package:tkw/screens/web_site.dart';
import 'screens/result_summary_page.dart';
import 'screens/search_page.dart';
import 'screens/map_page.dart';
import 'screens/energy_calculation_page.dart';
import 'screens/statistics_page.dart';

class SolarEnergyExplorer extends StatelessWidget {
  const SolarEnergyExplorer({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Solar Energy Explorer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const MapPage(),
        '/home': (context) => const MapPage(),
        '/district_info_page':(context)=>const DistrictInfoPage(),
        '/energy_calculation': (context) => const EnergyCalculationPage(),
        '/statistics': (context) => const StatisticsPage(),
        '/result_summary': (context) => const SolarCalculatorPage(),
        '/web_view': (context) => const MyWebView(),
        '/search': (context) => const SearchPage(),
      },
    );
  }
}
