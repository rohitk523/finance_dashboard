// lib/widgets/charts/investment_performance_chart.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../utils/currency_formatter.dart';

class InvestmentPerformanceChart extends StatelessWidget {
  final List<Map<String, dynamic>> performanceData;

  const InvestmentPerformanceChart({
    Key? key,
    required this.performanceData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Sort data by date
    final sortedData = List<Map<String, dynamic>>.from(performanceData)
      ..sort(
          (a, b) => (a['date'] as DateTime).compareTo(b['date'] as DateTime));

    // Calculate min and max values for better visualization
    double minY = 0;
    double maxY = 0;

    if (sortedData.isNotEmpty) {
      minY = sortedData
          .map((data) => data['value'] as double)
          .reduce((min, value) => min < value ? min : value);
      maxY = sortedData
          .map((data) => data['value'] as double)
          .reduce((max, value) => max > value ? max : value);

      // Add some padding
      minY = minY * 0.9;
      maxY = maxY * 1.1;
    }

    return sortedData.isEmpty
        ? Center(
            child: Text(
              'No performance data available',
              style: TextStyle(color: Colors.grey[600]),
            ),
          )
        : LineChart(
            LineChartData(
              gridData: FlGridData(
                show: true,
                drawVerticalLine: true,
                horizontalInterval: (maxY - minY) / 5,
                verticalInterval: 1,
                getDrawingHorizontalLine: (value) {
                  return FlLine(
                    color: Colors.grey[300] ?? Colors.grey,
                    strokeWidth: 1,
                  );
                },
                getDrawingVerticalLine: (value) {
                  return FlLine(
                    color: Colors.grey[300] ?? Colors.grey,
                    strokeWidth: 1,
                  );
                },
              ),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 30,
                    getTitlesWidget: (double value, TitleMeta meta) {
                      if (value.toInt() >= sortedData.length || value < 0) {
                        return const SizedBox.shrink();
                      }
                      final date =
                          sortedData[value.toInt()]['date'] as DateTime;
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          DateFormat('MMM').format(date),
                          style: const TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      );
                    },
                    interval: sortedData.length > 6 ? sortedData.length / 6 : 1,
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (double value, TitleMeta meta) {
                      return Text(
                        formatCurrency(value, showDecimal: false),
                        style: const TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      );
                    },
                    reservedSize: 42,
                  ),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: false,
                  ),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: false,
                  ),
                ),
              ),
              borderData: FlBorderData(
                show: true,
                border: Border.all(color: Colors.grey.shade300),
              ),
              minX: 0,
              maxX: sortedData.length - 1.0,
              minY: minY,
              maxY: maxY,
              lineBarsData: [
                LineChartBarData(
                  spots: List.generate(
                    sortedData.length,
                    (index) => FlSpot(
                      index.toDouble(),
                      sortedData[index]['value'] as double,
                    ),
                  ),
                  isCurved: true,
                  color: Colors.blue,
                  barWidth: 3,
                  isStrokeCapRound: true,
                  dotData: FlDotData(
                    show: true,
                    getDotPainter: (spot, percent, barData, index) {
                      return FlDotCirclePainter(
                        radius: 4,
                        color: Colors.blue,
                        strokeWidth: 2,
                        strokeColor: Colors.white,
                      );
                    },
                  ),
                  belowBarData: BarAreaData(
                    show: true,
                    color: Colors.blue.withOpacity(0.2),
                    gradient: LinearGradient(
                      colors: [
                        Colors.blue.withOpacity(0.4),
                        Colors.blue.withOpacity(0.0),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ],
              lineTouchData: LineTouchData(
                touchTooltipData: LineTouchTooltipData(
                  tooltipBgColor: Colors.blueAccent,
                  tooltipRoundedRadius: 8,
                  getTooltipItems: (List<LineBarSpot> lineBarsSpot) {
                    return lineBarsSpot.map((lineBarSpot) {
                      final data = sortedData[lineBarSpot.x.toInt()];
                      final date = data['date'] as DateTime;
                      return LineTooltipItem(
                        '${DateFormat('MMM yyyy').format(date)}\n',
                        const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        children: [
                          TextSpan(
                            text: formatCurrency(lineBarSpot.y),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      );
                    }).toList();
                  },
                ),
                handleBuiltInTouches: true,
                touchCallback:
                    (FlTouchEvent event, LineTouchResponse? touchResponse) {},
              ),
            ),
          );
  }
}
