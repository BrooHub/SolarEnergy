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
              gridData: const FlGridData(show: true),
              titlesData: FlTitlesData(
                leftTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
                
              ),
                topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
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
                        style: const TextStyle(color: Color.fromARGB(179, 0, 0, 0)),
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
                    FlSpot(0, solarData.monthlyKWh['OCAK']),
                    FlSpot(1, solarData.monthlyKWh['SUBAT']),
                    FlSpot(2, solarData.monthlyKWh["MART"]),
                    FlSpot(3, solarData.monthlyKWh["NISAN"]),
                    FlSpot(4, solarData.monthlyKWh["MAYIS"]),
                    FlSpot(5, solarData.monthlyKWh["HAZIRAN"]),
                    FlSpot(6, solarData.monthlyKWh["TEMMUZ"]),
                    FlSpot(7, solarData.monthlyKWh["AGUSTOS"]),
                    FlSpot(8, solarData.monthlyKWh["EYLUL"]),
                    FlSpot(9, solarData.monthlyKWh["EKIM"]),
                    FlSpot(10, solarData.monthlyKWh["KASIM"]),
                    FlSpot(11, solarData.monthlyKWh["ARALIK"]),
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
            backgroundColor: Colors.white,
            maxY: 12,
            barTouchData: BarTouchData(
              enabled: true,
              touchTooltipData: BarTouchTooltipData(
                tooltipPadding: const EdgeInsets.all(-5),
                tooltipMargin: 5,
                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                  return BarTooltipItem(
                    '${rod.toY.round()}',
                    const TextStyle(
                      color: Color.fromARGB(255, 86, 75, 75),
                      backgroundColor: Color.fromARGB(255, 255, 255, 255),
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
            ),
            
            titlesData: FlTitlesData(
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
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
            barGroups: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11].map((x) {
              String multiplier;
              switch (x) {
                case 0:
                  multiplier = solarData.sunshineHours["OCAK"].toString();
                  break;
                case 1:
                  multiplier = solarData.sunshineHours["SUBAT"].toString();
                  break;
                case 2:
                  multiplier = solarData.sunshineHours["MART"].toString();
                  break;
                case 3:
                  multiplier = solarData.sunshineHours["NISAN"].toString();
                  break;
                case 4:
                  multiplier = solarData.sunshineHours["MAYIS"].toString();
                  break;
                case 5:
                  multiplier = solarData.sunshineHours["HAZIRAN"].toString();
                  break;
                case 6:
                  multiplier = solarData.sunshineHours["TEMMUZ"].toString();
                  break;
                case 7:
                  multiplier = solarData.sunshineHours["AGUSTOS"].toString();
                  break;
                case 8:
                  multiplier = solarData.sunshineHours["EYLUL"].toString();
                  break;
                case 9:
                  multiplier = solarData.sunshineHours["EKIM"].toString();
                  break;
                case 10:
                  multiplier = solarData.sunshineHours["KASIM"].toString();
                  break;
                case 11:
                  multiplier = solarData.sunshineHours["ARALIK"].toString();
                  break;
                default:
                  multiplier = solarData.sunshineHours["ARALIK"].toString();
              }
              return BarChartGroupData(
                x: x,
                barRods: [
                  BarChartRodData(
                    toY: double.parse(multiplier),
                    gradient: const LinearGradient(
                      colors: [
                        Color.fromARGB(255, 113, 184, 220),
                        Color.fromARGB(255, 65, 139, 199)
                      ],
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
