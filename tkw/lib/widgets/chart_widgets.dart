import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/solar_data.dart';

// Responsive yükseklik fonksiyonu
double responsiveHeight(BuildContext context) {
  return MediaQuery.of(context).size.height * 0.25;
}

// SolarRadiationChart - Güneş Işınımı Grafiği
class SolarRadiationChart extends StatelessWidget {
  final SolarData solarData;

  const SolarRadiationChart({super.key, required this.solarData});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: responsiveHeight(context),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black38,
              blurRadius: 10,
              offset: Offset(2, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: LineChart(
            LineChartData(
              gridData: const FlGridData(show: false),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 22,
                    getTitlesWidget: (value, meta) {
                      String text = '';
                      switch (value.toInt()) {
                        case 0:
                          text = 'Oca';
                          break;
                        case 2:
                          text = 'Mar';
                          break;
                        case 4:
                          text = 'May';
                          break;
                        case 6:
                          text = 'Tem';
                          break;
                        case 8:
                          text = 'Eyl';
                          break;
                        case 10:
                          text = 'Kas';
                          break;
                      }
                      return Text(
                        text,
                        style: const TextStyle(color: Colors.white70),
                      );
                    },
                  ),
                ),
              ),
              borderData: FlBorderData(
                show: true,
                border: Border.all(color: Colors.white24, width: 1),
              ),
              lineBarsData: [
                LineChartBarData(
                  isCurved: true,
                  spots: [
                    FlSpot(0, solarData.solarRadiation * 0.8),
                    FlSpot(2, solarData.solarRadiation * 0.9),
                    FlSpot(4, solarData.solarRadiation * 1.0),
                    FlSpot(6, solarData.solarRadiation * 1.1),
                    FlSpot(8, solarData.solarRadiation * 1.0),
                    FlSpot(10, solarData.solarRadiation * 0.9),
                  ],
                  gradient: const LinearGradient(
                    colors: [Colors.orange, Colors.yellow],
                  ),
                  barWidth: 4,
                  isStrokeCapRound: true,
                  dotData: FlDotData(
                    show: true,
                    getDotPainter: (spot, percent, barData, index) {
                      return FlDotCirclePainter(
                        radius: 6,
                        color: Colors.white,
                        strokeWidth: 2,
                        strokeColor: Colors.orange,
                      );
                    },
                  ),
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      colors: [
                        Colors.orange.withOpacity(0.3),
                        Colors.yellow.withOpacity(0.1),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// SunshineHoursChart - Güneşlenme Süresi Grafiği
class SunshineHoursChart extends StatelessWidget {
  final SolarData solarData;

  const SunshineHoursChart({super.key, required this.solarData});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: responsiveHeight(context),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.white,
              blurRadius: 10,
              offset: Offset(2, 4),
            ),
          ],
        ),
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            maxY: 12,
            barTouchData: BarTouchData(
              enabled: true,
              touchTooltipData: BarTouchTooltipData(
                tooltipPadding: const EdgeInsets.all(8),
                tooltipMargin: 8,
                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                  return BarTooltipItem(
                    '${rod.toY.round()}',
                    const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
            ),
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 30,
                  getTitlesWidget: (value, meta) {
                    String text = '';
                    switch (value.toInt()) {
                      case 0:
                        text = 'Oca';
                        break;
                      case 2:
                        text = 'Mar';
                        break;
                      case 4:
                        text = 'May';
                        break;
                      case 6:
                        text = 'Tem';
                        break;
                      case 8:
                        text = 'Eyl';
                        break;
                      case 10:
                        text = 'Kas';
                        break;
                    }
                    return Text(
                      text,
                      style: const TextStyle(
                        color: Color.fromARGB(179, 0, 0, 0),
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    );
                  },
                ),
              ),
              leftTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
            ),
            borderData: FlBorderData(show: false),
            barGroups: [0, 2, 4, 6, 8, 10].map((x) {
              double multiplier;
              switch (x) {
                case 0:
                  multiplier = 0.8;
                  break;
                case 2:
                  multiplier = 0.9;
                  break;
                case 4:
                  multiplier = 1.0;
                  break;
                case 6:
                  multiplier = 1.1;
                  break;
                case 8:
                  multiplier = 1.0;
                  break;
                case 10:
                  multiplier = 0.9;
                  break;
                default:
                  multiplier = 1.0;
              }
              return BarChartGroupData(
                x: x,
                barRods: [
                  BarChartRodData(
                    toY: solarData.sunshineHours * multiplier,
                    gradient: const LinearGradient(
                      colors: [Colors.lightBlueAccent, Colors.blue],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(6)),
                  )
                ],
                showingTooltipIndicators: [0],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
