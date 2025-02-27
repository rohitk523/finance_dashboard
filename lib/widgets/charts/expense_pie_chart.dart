// lib/widgets/charts/expense_pie_chart.dart

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../utils/currency_formatter.dart';

class ExpensePieChart extends StatefulWidget {
  final Map<String, double> expenseData;

  const ExpensePieChart({
    Key? key,
    required this.expenseData,
  }) : super(key: key);

  @override
  _ExpensePieChartState createState() => _ExpensePieChartState();
}

class _ExpensePieChartState extends State<ExpensePieChart> {
  int? _touchedIndex;

  @override
  Widget build(BuildContext context) {
    if (widget.expenseData.isEmpty) {
      return Center(
        child: Text(
          'No expense data available',
          style: TextStyle(color: Colors.grey[600]),
        ),
      );
    }

    return Row(
      children: [
        Expanded(
          flex: 3,
          child: PieChart(
            PieChartData(
              pieTouchData: PieTouchData(
                touchCallback: (FlTouchEvent event, pieTouchResponse) {
                  setState(() {
                    if (!event.isInterestedForInteractions ||
                        pieTouchResponse == null ||
                        pieTouchResponse.touchedSection == null) {
                      _touchedIndex = -1;
                      return;
                    }
                    _touchedIndex =
                        pieTouchResponse.touchedSection!.touchedSectionIndex;
                  });
                },
              ),
              borderData: FlBorderData(show: false),
              sectionsSpace: 2,
              centerSpaceRadius: 40,
              sections: _buildPieSections(),
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _buildLegends(),
            ),
          ),
        ),
      ],
    );
  }

  List<PieChartSectionData> _buildPieSections() {
    final total =
        widget.expenseData.values.fold(0.0, (sum, amount) => sum + amount);
    final sorted = widget.expenseData.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return List.generate(
      sorted.length > 5 ? 5 : sorted.length,
      (i) {
        final isTouched = i == _touchedIndex;
        final fontSize = isTouched ? 20.0 : 16.0;
        final radius = isTouched ? 110.0 : 100.0;
        final entry = sorted[i];
        final percentage = (entry.value / total) * 100;

        // Add "Others" category if there are more than 5 categories
        if (i == 4 && sorted.length > 5) {
          final othersTotal = sorted.sublist(4).fold(
                0.0,
                (sum, item) => sum + item.value,
              );
          final othersPercentage = (othersTotal / total) * 100;

          return PieChartSectionData(
            color: _getCategoryColor(i),
            value: othersTotal,
            title: '${othersPercentage.toStringAsFixed(1)}%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          );
        }

        return PieChartSectionData(
          color: _getCategoryColor(i),
          value: entry.value,
          title: '${percentage.toStringAsFixed(1)}%',
          radius: radius,
          titleStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        );
      },
    );
  }

  List<Widget> _buildLegends() {
    final total =
        widget.expenseData.values.fold(0.0, (sum, amount) => sum + amount);
    final sorted = widget.expenseData.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final legends = <Widget>[];

    for (int i = 0; i < (sorted.length > 5 ? 5 : sorted.length); i++) {
      final entry = sorted[i];
      final percentage = (entry.value / total) * 100;

      if (i == 4 && sorted.length > 5) {
        final othersTotal = sorted.sublist(4).fold(
              0.0,
              (sum, item) => sum + item.value,
            );
        final othersPercentage = (othersTotal / total) * 100;

        legends.add(
          _buildLegendItem(
            'Others',
            othersTotal,
            othersPercentage,
            _getCategoryColor(i),
            i == _touchedIndex,
          ),
        );
        break;
      }

      legends.add(
        _buildLegendItem(
          entry.key,
          entry.value,
          percentage,
          _getCategoryColor(i),
          i == _touchedIndex,
        ),
      );
    }

    return legends;
  }

  Widget _buildLegendItem(
    String category,
    double amount,
    double percentage,
    Color color,
    bool isHighlighted,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
      decoration: BoxDecoration(
        color: isHighlighted ? color.withOpacity(0.2) : Colors.transparent,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        children: [
          Container(
            width: 14,
            height: 14,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category,
                  style: TextStyle(
                    fontWeight:
                        isHighlighted ? FontWeight.bold : FontWeight.normal,
                    fontSize: 12,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${formatCurrency(amount)} (${percentage.toStringAsFixed(1)}%)',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[600],
                    fontWeight:
                        isHighlighted ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(int index) {
    final colors = [
      Colors.blue,
      Colors.red,
      Colors.orange,
      Colors.purple,
      Colors.green,
      Colors.amber,
      Colors.teal,
      Colors.pink,
      Colors.indigo,
      Colors.cyan,
    ];

    return colors[index % colors.length];
  }
}
