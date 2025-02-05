import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tkw/providers/app_state.dart';

class SolarCalculatorPage extends StatefulWidget {
  const SolarCalculatorPage({super.key});

  @override
  State<SolarCalculatorPage> createState() => _SolarCalculatorPageState();
}

class _SolarCalculatorPageState extends State<SolarCalculatorPage> {
  final _formKey = GlobalKey<FormState>();
  final _panelCapacityController = TextEditingController(text: '400');
  final _panelCountController = TextEditingController(text: '10');
  final _electricityPriceController = TextEditingController(text: '2.07');
  String _locationType = 'roof';
  bool _isLoading = false;

  // Hesaplama sonuçları
  double _dcCapacity = 0;
  double _acCapacity = 0;
  double _annualProduction = 0;
  double _annualIncome = 0;
  double _totalCost = 0;
  double _roi = 0;
  double _paybackPeriod = 0;
  double _co2Saved = 0;
  List<Map<String, dynamic>> _monthlyData = [];

  // Açıklama verileri
  final List<Map<String, String>> _resultDescriptions = [
    {
      'title': 'DC Kapasite',
      'description': 'Solar panel sisteminin teorik maksimum DC çıkış gücü',
      'formula': '(Panel Gücü × Panel Sayısı) / 1000'
    },
    {
      'title': 'AC Kapasite',
      'description': 'Şebekeye aktarılabilen gerçek AC güç kapasitesi',
      'formula': 'DC Kapasite × Ortalama Verimlilik Faktörü'
    },
    {
      'title': 'Toplam Maliyet',
      'description': 'Sistemin kurulum ve ekipman maliyetinin toplamı',
      'formula': 'DC Kapasite × 1000 × Maliyet Faktörü'
    },
    {
      'title': 'Yıllık Üretim',
      'description': 'Yılda üretilen toplam elektrik miktarı',
      'formula': 'Aylık Üretimlerin Toplamı'
    },
    {
      'title': 'Yıllık Gelir',
      'description': 'Üretilen elektriğin satışından elde edilen gelir',
      'formula': 'Yıllık Üretim × Elektrik Fiyatı'
    },
    {
      'title': 'ROI',
      'description': 'Yatırım Getiri Oranı (Return on Investment)',
      'formula': '(Yıllık Gelir / Toplam Maliyet) × 100'
    },
    {
      'title': 'Geri Ödeme Süresi',
      'description': 'Yatırımın kendini amorti etme süresi',
      'formula': 'Toplam Maliyet / Yıllık Gelir'
    },
    {
      'title': 'CO2 Tasarrufu',
      'description': 'Yıllık karbon salınım tasarrufu',
      'formula': 'Yıllık Üretim × 0.5 kg/kWh'
    },
  ];

  Future<void> _calculateResults() async {
    if (!_formKey.currentState!.validate()) return;
    final district = AppState.selectedDistrict;
    if (district == null || district.monthlyKWh.isEmpty) return;

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 200));

    try {
      final panelCapacity = double.parse(_panelCapacityController.text);
      final panelCount = int.parse(_panelCountController.text);
      final electricityPrice = double.parse(_electricityPriceController.text);
      final monthlyKWh = district.monthlyKWh;

      final maxMonthlyKWh = monthlyKWh.values
          .map((e) => e as double)
          .reduce((a, b) => a > b ? a : b);
      final efficiency = _locationType == 'roof' ? 0.95 : 0.98;

      final monthlyFactors = monthlyKWh.values
          .map((kwh) => ((kwh as double) / maxMonthlyKWh) * efficiency)
          .toList();

      final costFactor =
          monthlyFactors.reduce((double a, double b) => a + b) / 12;

      // Kapasite hesaplamaları
      _dcCapacity = (panelCapacity * panelCount) / 1000;
      _acCapacity = _dcCapacity * costFactor;
      _totalCost = _dcCapacity * 1000 * costFactor;

      // Aylık üretim verileri
      _monthlyData = List.generate(12, (index) {
        const dailySunHours = 4.5;
        const daysInMonth = 30;

        final baseProduction = _dcCapacity * dailySunHours * daysInMonth;
        final production = baseProduction * monthlyFactors[index];

        return {
          'month': '${index + 1}',
          'production': production,
          'income': production * electricityPrice,
          'factor': monthlyFactors[index],
        };
      });

      // Yıllık toplamlar
      _annualProduction = _monthlyData
          .map((m) => m['production'] as double)
          .reduce((a, b) => a + b);
      _annualIncome = _annualProduction * electricityPrice;
      _roi = (_annualIncome / _totalCost) * 100;
      _paybackPeriod = _totalCost / _annualIncome;
      _co2Saved = _annualProduction * 0.5;
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showInfoDialog(BuildContext context, int index) {
    final info = _resultDescriptions[index];
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(info['title']!),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(info['description']!, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 15),
            Text('Hesaplama Formülü:',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.blue.shade800)),
            Text(info['formula']!,
                style: const TextStyle(fontFamily: 'monospace', fontSize: 14)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Kapat'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            title: Text('Güneş Enerjisi Hesaplama',
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade800, Colors.green.shade600],
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
                ]
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputForm() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Sistem Parametreleri',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.blue.shade800, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              _buildDropdownField(),
              const SizedBox(height: 16),
              _buildNumberInput(
                controller: _panelCapacityController,
                label: 'Panel Gücü (W)',
                icon: Icons.solar_power_rounded,
              ),
              const SizedBox(height: 16),
              _buildNumberInput(
                controller: _panelCountController,
                label: 'Panel Sayısı',
                icon: Icons.format_list_numbered_rounded,
              ),
              const SizedBox(height: 16),
              _buildNumberInput(
                controller: _electricityPriceController,
                label: 'Elektrik Fiyatı (₺/kWh)',
                icon: Icons.currency_lira_rounded,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _calculateResults,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                        'HESAPLA',
                        style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownField() {
    return DropdownButtonFormField<String>(
      value: _locationType,
      decoration: InputDecoration(
        labelText: 'Kurulum Tipi',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
        prefixIcon: const Icon(Icons.location_on_rounded),
      ),
      items: const [
        DropdownMenuItem(value: 'roof', child: Text('Çatı Kurulumu')),
        DropdownMenuItem(value: 'ground', child: Text('Arazi Kurulumu')),
      ],
      onChanged: (value) => setState(() => _locationType = value!),
    );
  }

  Widget _buildNumberInput({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Bu alan zorunludur';
        final number = double.tryParse(value);
        if (number == null) return 'Geçersiz sayı formatı';
        if (number <= 0) return 'Sıfırdan büyük olmalı';
        return null;
      },
    );
  }

  Widget _buildResultsCard() {
    final format = NumberFormat("#,###", "tr_TR");
    final results = [
      {'label': 'DC Kapasite', 'value': '${_dcCapacity.toStringAsFixed(1)} kW'},
      {'label': 'AC Kapasite', 'value': '${_acCapacity.toStringAsFixed(1)} kW'},
      {
        'label': 'Toplam Maliyet',
        'value': '${format.format(_totalCost.round())} ₺'
      },
      {
        'label': 'Yıllık Üretim',
        'value': '${format.format(_annualProduction.round())} kWh'
      },
      {
        'label': 'Yıllık Gelir',
        'value': '${format.format(_annualIncome.round())} ₺'
      },
      {'label': 'ROI', 'value': '${_roi.toStringAsFixed(1)} %'},
      {
        'label': 'Geri Ödeme ',
        'value': '${_paybackPeriod.toStringAsFixed(1)} Yıl'
      },
      {
        'label': 'CO2 Tasarrufu',
        'value': '${format.format(_co2Saved.round())} kg'
      },
    ];

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Hesaplama Sonuçları',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.green.shade800, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 2.2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
              ),
              itemCount: results.length,
              itemBuilder: (context, index) => GestureDetector(
                onTap: () => _showInfoDialog(context, index),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _getResultColor(index),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade200,
                        blurRadius: 4,
                        offset: const Offset(2, 2),
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            results[index]['label']!,
                            style: TextStyle(
                              color: Colors.blueGrey.shade800,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Icon(Icons.info_outline_rounded,
                              size: 18, color: Colors.blueGrey.shade600),
                        ],
                      ),
                      const Spacer(),
                      Text(
                        results[index]['value']!,
                        style: TextStyle(
                          color: Colors.blueGrey.shade900,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getResultColor(int index) {
    final colors = [
      Colors.blue.shade50,
      Colors.green.shade50,
      Colors.orange.shade50,
      Colors.purple.shade50,
      Colors.red.shade50,
      Colors.teal.shade50,
      Colors.yellow.shade50,
      Colors.pink.shade50,
    ];
    return colors[index % colors.length];
  }

  Widget _buildProductionChart() {
    if (_monthlyData.isEmpty) return const SizedBox.shrink();

    final maxFactor = _monthlyData
        .map((m) => m['factor'] as double)
        .reduce((a, b) => a > b ? a : b);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Aylık Performans',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.blue.shade800, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 300,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      tooltipPadding: const EdgeInsets.all(8),
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        final month = _monthlyData[group.x.toInt()];
                        return BarTooltipItem(
                          '${month['month']}. Ay\n'
                          'Üretim: ${NumberFormat('#,###').format(month['production'])} kWh\n'
                          'Verimlilik: ${(month['factor'] * 100).toStringAsFixed(1)}%',
                          const TextStyle(color: Colors.white),
                        );
                      },
                    ),
                  ),
                  titlesData: FlTitlesData(
                    topTitles: AxisTitles(),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: false,
                        getTitlesWidget: (value, meta) => Text(
                          _monthlyData[value.toInt()]['month'],
                          style: TextStyle(
                            color: Colors.blueGrey.shade600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                    rightTitles: AxisTitles(),
                    leftTitles: AxisTitles(),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: Colors.blueGrey.shade100,
                      strokeWidth: 1,
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: _monthlyData.asMap().entries.map((entry) {
                    final index = entry.key;
                    final data = entry.value;
                    final factor = data['factor'] as double;

                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: data['production'],
                          color: Color.lerp(
                            Colors.blue.shade200,
                            Colors.blue.shade800,
                            factor / maxFactor,
                          )!,
                          width: 20,
                          borderRadius: BorderRadius.circular(4),
                        )
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 15),
            _buildChartLegend(maxFactor),
          ],
        ),
      ),
    );
  }

  Widget _buildChartLegend(double maxFactor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildLegendItem('Düşük Verim (0%)', Colors.blue.shade200),
        const SizedBox(width: 15),
        _buildLegendItem(
            'Yüksek Verim (${(maxFactor * 100).toStringAsFixed(0)}%)',
            Colors.blue.shade800),
      ],
    );
  }

  Widget _buildLegendItem(String text, Color color) {
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
        const SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(
            color: Colors.blueGrey.shade800,
            fontSize: 12,
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
    super.dispose();
  }
}
