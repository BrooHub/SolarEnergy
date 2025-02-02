// ignore_for_file: depend_on_referenced_packages, constant_identifier_names

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/home_button.dart';

class SolarCalculatorPage extends StatefulWidget {
  const SolarCalculatorPage({super.key});
  
  @override
  State<SolarCalculatorPage> createState() => _SolarCalculatorPageState();
}

class _SolarCalculatorPageState extends State<SolarCalculatorPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 500),
  );
  final _formKey = GlobalKey<FormState>();
  final _panelCapacityController = TextEditingController(text: '400');
  final _panelCountController = TextEditingController(text: '10');
  final _electricityPriceController = TextEditingController(text: '1.2');
  String _locationType = 'roof';
  bool _isLoading = false;

  // Türkçe ay isimleri
  final List<String> _turkishMonths = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '11',
    '12'
  ];

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('tr_TR', null);
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  // Efficiency factors ve diğer sabitler aynı...
  static const Map<String, Map<String, dynamic>> EFFICIENCY_FACTORS = {
    'roof': {
      'efficiency': 0.95,
      'monthlyFactors': {
        0: 0.6,
        1: 0.7,
        2: 0.8,
        3: 0.9,
        4: 1.0,
        5: 1.0,
        6: 1.0,
        7: 0.95,
        8: 0.9,
        9: 0.8,
        10: 0.7,
        11: 0.6
      }
    },
    'ground': {
      'efficiency': 0.98,
      'monthlyFactors': {
        0: 0.65,
        1: 0.75,
        2: 0.85,
        3: 0.95,
        4: 1.0,
        5: 1.0,
        6: 1.0,
        7: 0.98,
        8: 0.92,
        9: 0.85,
        10: 0.75,
        11: 0.65
      }
    }
  };

  // Results
  double _dcCapacity = 0;
  double _acCapacity = 0;
  double _annualProduction = 0;
  double _annualIncome = 0;
  double _totalCost = 0;
  double _roi = 0;
  double _paybackPeriod = 0;
  double _co2Saved = 0;
  List<Map<String, dynamic>> _monthlyData = [];

  Future<void> _calculateResults() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // Animasyon efekti için kısa delay
    await Future.delayed(const Duration(milliseconds: 500));

    final panelCapacity = double.parse(_panelCapacityController.text);
    final panelCount = int.parse(_panelCountController.text);
    final electricityPrice = double.parse(_electricityPriceController.text);
    const systemCostPerWatt = 1.5;

    setState(() {
      _dcCapacity = (panelCapacity * panelCount) / 1000;
      _acCapacity =
          _dcCapacity * EFFICIENCY_FACTORS[_locationType]!['efficiency'];

      _monthlyData = List.generate(12, (month) {
        final baseProduction = _dcCapacity * 4.5 * 30;
        final factor =
            EFFICIENCY_FACTORS[_locationType]!['monthlyFactors'][month];
        final production = baseProduction * factor;
        final income = production * electricityPrice;

        return {
          'month': _turkishMonths[month],
          'production': production.round(),
          'income': income.round(),
        };
      });

      _annualProduction =
          _monthlyData.fold(0.0, (sum, month) => sum + month['production']);
      _annualIncome = _annualProduction * electricityPrice;
      _totalCost = _dcCapacity * 1000 * systemCostPerWatt;
      _roi = (_annualIncome / _totalCost) * 100;
      _paybackPeriod = _totalCost / _annualIncome;
      _co2Saved = _annualProduction * 0.5;
      _isLoading = false;
    });

    _animationController.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(


      body: CustomScrollView(

        slivers: [
          SliverAppBar.large(
            title: Text(
              'Güneş Enerjisi Hesaplayıcı',
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.yellow.shade200,
                      Colors.blue.shade200,
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildInputForm(),
                if (_dcCapacity > 0) ...[
                  const SizedBox(height: 24),
                  _buildResultsCard(),
                  const SizedBox(height: 24),
                  _buildProductionChart(),
                ],
              ]),
            ),
          ),
        ],
      ),

    );
  }

  Widget _buildInputForm() {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Sistem Bilgileri',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              _buildDropdownField(),
              const SizedBox(height: 16),
              _buildInputField(
                controller: _panelCapacityController,
                label: 'Panel Kapasitesi',
                suffix: 'W',
                icon: Icons.solar_power,
              ),
              const SizedBox(height: 16),
              _buildInputField(
                controller: _panelCountController,
                label: 'Panel Sayısı',
                suffix: 'adet',
                icon: Icons.grid_view,
              ),
              const SizedBox(height: 16),
              _buildInputField(
                controller: _electricityPriceController,
                label: 'Elektrik Fiyatı',
                suffix: 'TL/kWh',
                icon: Icons.bolt,
              ),
              const SizedBox(height: 24),
              _buildCalculateButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownField() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonFormField<String>(
        value: _locationType,
        decoration: InputDecoration(
          labelText: 'Lokasyon Tipi',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.grey.shade50,
          prefixIcon: const Icon(Icons.location_on),
        ),
        items: const [
          DropdownMenuItem(value: 'roof', child: Text('Çatı')),
          DropdownMenuItem(value: 'ground', child: Text('Arazi')),
        ],
        onChanged: (value) => setState(() => _locationType = value!),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String suffix,
    required IconData icon,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        suffixText: suffix,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Bu alan gerekli';
        }
        if (double.tryParse(value) == null) {
          return 'Geçerli bir sayı girin';
        }
        return null;
      },
    );
  }

  Widget _buildCalculateButton() {
    return ElevatedButton(
      onPressed: _isLoading ? null : _calculateResults,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        backgroundColor: Colors.teal,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: _isLoading
          ? const CircularProgressIndicator()
          : const Text(
              'Hesapla',
              style: TextStyle(fontSize: 22, color: Colors.white),
            ),
    );
  }

  Widget _buildResultsCard() {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sonuçlar',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            _buildResultGrid(),
          ],
        ),
      ),
    );
  }

  Widget _buildResultGrid() {
    final results = [
      {
        'icon': Icons.solar_power,
        'label': 'DC Güç',
        'value': '${_dcCapacity.toStringAsFixed(2)} kW'
      },
      {
        'icon': Icons.electric_bolt,
        'label': 'AC Güç',
        'value': '${_acCapacity.toStringAsFixed(2)} kW'
      },
      {
        'icon': Icons.power,
        'label': 'Yıllık Üretim',
        'value': '${NumberFormat('#,###').format(_annualProduction)} kWh'
      },
      {
        'icon': Icons.attach_money,
        'label': 'Yıllık Gelir',
        'value': '${NumberFormat('#,###').format(_annualIncome)} TL'
      },
      {
        'icon': Icons.calculate,
        'label': 'Toplam Maliyet',
        'value': '${NumberFormat('#,###').format(_totalCost)} USD'
      },
      {
        'icon': Icons.trending_up,
        'label': 'ROI',
        'value': '%${_roi.toStringAsFixed(2)}'
      },
      {
        'icon': Icons.access_time,
        'label': 'Geri Ödeme',
        'value': '${_paybackPeriod.toStringAsFixed(1)} yıl'
      },
      {
        'icon': Icons.eco,
        'label': 'CO2 Tasarrufu',
        'value': '${_co2Saved.toStringAsFixed(1)} kg/yıl'
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: results.length,
      itemBuilder: (context, index) {
        return _buildResultItem(
          icon: results[index]['icon'] as IconData,
          label: results[index]['label'] as String,
          value: results[index]['value'] as String,
        );
      },
    );
  }

  Widget _buildResultItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: Colors.blue.shade700),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductionChart() {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Aylık Üretim ve Gelir',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 300,
              
              child: BarChart(
                BarChartData(

                  alignment: BarChartAlignment.spaceAround,
                  maxY: _monthlyData
                          .map((m) => m['production'])
                          .reduce((a, b) => a > b ? a : b) *
                      1.2,
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() >= 0 &&
                              value.toInt() < _monthlyData.length) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                _monthlyData[value.toInt()]['month'].toString(),
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            );
                          }
                          return const Text('');
                        },
                        reservedSize: 40,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) => Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Text(
                            NumberFormat.compact().format(value),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.blue.shade700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        reservedSize: 30,
                      ),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) => Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            '${NumberFormat.compact().format(value)}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.green.shade700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        reservedSize: 50,
                      ),
                    ),
                    topTitles:
                        const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawHorizontalLine: true,
                    horizontalInterval: null,
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: Colors.grey.shade200,
                      strokeWidth: 1,
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  barGroups: List.generate(
                    _monthlyData.length,
                    (index) => BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          fromY: 0,
                          toY: _monthlyData[index]['production'].toDouble()<7000? _monthlyData[index]['production'].toDouble():7000,
                          color: Colors.blue.shade400,
                          width: 8,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(4),
                            topRight: Radius.circular(4),
                          ),
                        ),
                        BarChartRodData(
                          fromY: 0,
                          toY: _monthlyData[index]['income'].toDouble()<7000 ? _monthlyData[index]['income'].toDouble() : 7000,
                          color: Colors.green.shade400,
                          width: 8,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(4),
                            topRight: Radius.circular(4),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLegendItem('Üretim (kWh)', Colors.blue.shade400),
                const SizedBox(width: 24),
                _buildLegendItem('Gelir (TL)', Colors.green.shade400),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _panelCapacityController.dispose();
    _panelCountController.dispose();
    _electricityPriceController.dispose();
    _animationController.dispose();
    super.dispose();
  }
}
