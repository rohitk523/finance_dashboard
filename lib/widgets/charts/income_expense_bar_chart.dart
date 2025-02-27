// lib/widgets/charts/income_expense_bar_chart.dart

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../utils/currency_formatter.dart';

class IncomeExpenseBarChart extends StatelessWidget {
  final List<Map<String, dynamic>> incomeData;
  final List<Map<String, dynamic>> expenseData;

  const IncomeExpenseBarChart({
    Key? key,
    required this.incomeData,
    required this.expenseData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (incomeData.isEmpty && expenseData.isEmpty) {
      return Center(
        child: Text(
          'No transaction data available',
          style: TextStyle(color: Colors.grey[600]),
        ),
      );
    }

    // Combine and sort data by date
    final allMonths = <DateTime>{};
    for (final data in incomeData) {
      allMonths.add(data['date'] as DateTime);
    }
    for (final data in expenseData) {
      allMonths.add(data['date'] as DateTime);
    }

    final sortedMonths = allMonths.toList()..sort((a, b) => a.compareTo(b));

    // Get the last 6 months (or less if not enough data)
    final displayMonths = sortedMonths.length > 6
        ? sortedMonths.sublist(sortedMonths.length - 6)
        : sortedMonths;

    // Calculate max Y value for better visualization
    double maxAmount = 0;
    for (final date in displayMonths) {
      final income = incomeData
          .where((data) => _isSameMonth(data['date'] as DateTime, date))
          .fold(0.0, (sum, data) => sum + (data['amount'] as double));

      final expense = expenseData
          .where((data) => _isSameMonth(data['date'] as DateTime, date))
          .fold(0.0, (sum, data) => sum + (data['amount'] as double));

      maxAmount = [maxAmount, income, expense]
          .reduce((curr, next) => curr > next ? curr : next);
    }

    // Add 10% padding to max amount
    maxAmount = maxAmount * 1.1;

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: maxAmount,
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Colors.blueGrey,
            tooltipRoundedRadius: 8,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              final date = displayMonths[group.x.toInt()];
              final value = rodIndex == 0
                  ? _getIncomeForMonth(date)
                  : _getExpenseForMonth(date);

              return BarTooltipItem(
                '${DateFormat('MMM yyyy').format(date)}\n',
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                children: [
                  TextSpan(
                    text: formatCurrency(value),
                    style: TextStyle(
                      color:
                          rodIndex == 0 ? Colors.green[100] : Colors.red[100],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value < 0 || value >= displayMonths.length) {
                  return const SizedBox.shrink();
                }
                final date = displayMonths[value.toInt()];
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
              reservedSize: 30,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                if (value == 0) {
                  return const SizedBox.shrink();
                }
                return Text(
                  formatCurrency(value, showDecimal: false),
                  style: const TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                );
              },
              interval: maxAmount / 5,
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
        gridData: FlGridData(
          show: true,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.grey[300] ?? Colors.grey,
              strokeWidth: 1,
            );
          },
          horizontalInterval: maxAmount / 5,
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: Colors.grey.shade300),
        ),
        barGroups: List.generate(
          displayMonths.length,
          (index) {
            final date = displayMonths[index];
            final incomeAmount = _getIncomeForMonth(date);
            final expenseAmount = _getExpenseForMonth(date);

            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: incomeAmount,
                  color: Colors.green,
                  width: 16,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4),
                    topRight: Radius.circular(4),
                  ),
                ),
                BarChartRodData(
                  toY: expenseAmount,
                  color: Colors.red,
                  width: 16,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4),
                    topRight: Radius.circular(4),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  double _getIncomeForMonth(DateTime date) {
    return incomeData
        .where((data) => _isSameMonth(data['date'] as DateTime, date))
        .fold(0.0, (sum, data) => sum + (data['amount'] as double));
  }

  double _getExpenseForMonth(DateTime date) {
    return expenseData
        .where((data) => _isSameMonth(data['date'] as DateTime, date))
        .fold(0.0, (sum, data) => sum + (data['amount'] as double));
  }

  bool _isSameMonth(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month;
  }
}
