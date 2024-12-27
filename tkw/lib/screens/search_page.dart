import 'package:flutter/material.dart';
import 'package:tkw/models/solar_data.dart';
import 'package:tkw/widgets/text_card.dart';
import '../providers/app_state.dart';
import '../widgets/home_button.dart';
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Yılık',
            style: TextStyle(
                color: Color.fromARGB(255, 12, 65, 109),
                fontSize: 27,
                fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            // Dropdown for selecting `il`
            DropdownButtonFormField<Map<String, dynamic>>(
              dropdownColor: Colors.white,
              value: selectedIl,
              decoration: const InputDecoration(
                fillColor: Colors.black,
                labelText: 'Select (il)',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(24.0))),
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
            const SizedBox(height: 30),

            DropdownButtonFormField<Map<String, dynamic>>(
              dropdownColor: Colors.white,
              value: selectedIlce,
              decoration: const InputDecoration(
                labelText: 'Select (ilce)',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(24.0))),
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

            const SizedBox(height: 30),

            // Date Picker
            DropdownButtonFormField<String>(
              dropdownColor: Colors.white,
              value: selectedMonth,
              decoration: const InputDecoration(
                labelText: 'Select Month',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(24.0))),
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
            const SizedBox(height: 20),
            const Text("  Sonuç",
                style: TextStyle(
                    fontSize: 20, color: Color.fromARGB(255, 8, 50, 85))),
            if (activ) SolarDataCard(solarData: solar!, mounth: selectedMonth!),

            const SizedBox(height: 20),
            Row(
              children: [
                TextCard(text: 'Daha Fazla Sonuç \nGörmek İçin Tıklayın', onPressed: () {}),
                TextCard(text: 'Enerji Üretimini \nHesaplamak İçin \nTıklayın', onPressed: () {}),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: const HomeButton(),
    );
  }
}
