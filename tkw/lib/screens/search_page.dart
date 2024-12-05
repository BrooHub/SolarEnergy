import 'package:flutter/material.dart';
import 'package:tkw/models/solar_data.dart';
import '../providers/app_state.dart';
import '../widgets/solar_data_card.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  // Static Lists

  // Selected Values
  Map<String, dynamic>? selectedIl;
  Map<String, dynamic>? selectedIlce;
  SolarData? solar;
  bool activ = false;
  String? selectedMonth;
  List<String> months = [
    "OCAK",
    "SUBAT",
    "MART",
    "NISAN",
    "MAYIS",
    "HAZIRAN",
    "TEMMUZ",
    "AGUSTOS",
    "EYLUL",
    "EKIM",
    "KASIM",
    "ARALIK",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Aylık'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dropdown for selecting `il`
            DropdownButtonFormField<Map<String, dynamic>>(
              value: selectedIl,
              decoration: const InputDecoration(
                labelText: 'Select City (il)',
                border: OutlineInputBorder(),
              ),
              items: AppState.ilList.map((il) {
                return DropdownMenuItem<Map<String, dynamic>>(
                  value: il,
                  child: Text(il['il']),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedIl = value;
                  print(value);
                  selectedIlce = null;
                });
              },
            ),
            const SizedBox(height: 16),

            DropdownButtonFormField<Map<String, dynamic>>(
              value: selectedIlce,
              decoration: const InputDecoration(
                labelText: 'Select District (ilce)',
                border: OutlineInputBorder(),
              ),
              items: selectedIl == null
                  ? []
                  : AppState.ilceList
                      .where((ilce) =>
                          ilce['posta_code'] == selectedIl!['id'].toString())
                      .map((ilce) {
                      return DropdownMenuItem<Map<String, dynamic>>(
                        value: ilce,
                        child: Text(ilce['ilce']),
                      );
                    }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedIlce = value;
                  print(selectedIlce);
                });
              },
            ),

            const SizedBox(height: 16),

            // Date Picker
            DropdownButtonFormField<String>(
              value: selectedMonth,
              decoration: const InputDecoration(
                labelText: 'Select Month',
                border: OutlineInputBorder(),
              ),
              items: selectedIlce == null
                  ? []
                  : months.map((month) {
                      return DropdownMenuItem<String>(
                        value: month,
                        child: Text(month),
                      );
                    }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedMonth = value;
                  print(selectedMonth);
                  solar = SolarData(
                      monthlyKWh: selectedIlce!['monthlyKWh'],
                      sunshineHours: selectedIlce!['sunshineHours'],
                      ilce: selectedIl!['il']);
                  activ = true;
                });
              },
            ),
            const SizedBox(height: 16),

            if (activ) SolarDataCard(solarData: solar!, mounth: selectedMonth!),
          ],
        ),
      ),
    );
  }
}
