// lib/screens/dashboard/investments_section.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/investment_provider.dart';
import '../../widgets/charts/investment_performance_chart.dart';
import '../../widgets/cards/investment_card.dart';
import '../../utils/currency_formatter.dart';

class InvestmentsSection extends StatelessWidget {
  const InvestmentsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final investmentProvider = Provider.of<InvestmentProvider>(context);
    final investmentsByType = investmentProvider.investmentsByType;
    final totalInvestmentValue = investmentProvider.totalInvestmentValue;
    final investmentPerformance = investmentProvider.investmentPerformance;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Investment Portfolio',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        formatCurrency(totalInvestmentValue),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildReturnMetric(
                        context,
                        'Overall Return',
                        '${investmentProvider.overallReturn.toStringAsFixed(2)}%',
                        investmentProvider.overallReturn >= 0
                            ? Colors.green
                            : Colors.red,
                      ),
                      _buildReturnMetric(
                        context,
                        'This Year',
                        '${investmentProvider.yearToDateReturn.toStringAsFixed(2)}%',
                        investmentProvider.yearToDateReturn >= 0
                            ? Colors.green
                            : Colors.red,
                      ),
                      _buildReturnMetric(
                        context,
                        'This Month',
                        '${investmentProvider.monthToDateReturn.toStringAsFixed(2)}%',
                        investmentProvider.monthToDateReturn >= 0
                            ? Colors.green
                            : Colors.red,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Performance',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 240,
            child: InvestmentPerformanceChart(
              performanceData: investmentPerformance,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Asset Allocation',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  ...investmentsByType.entries.map((entry) {
                    final type = entry.key;
                    final value = entry.value;
                    final percentage = (value / totalInvestmentValue) * 100;

                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: _getInvestmentTypeColor(type),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(type),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  formatCurrency(value),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '${percentage.toStringAsFixed(1)}%',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        LinearProgressIndicator(
                          value: value / totalInvestmentValue,
                          backgroundColor: Colors.grey[200],
                          valueColor: AlwaysStoppedAnimation<Color>(
                            _getInvestmentTypeColor(type),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    );
                  }).toList(),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Top Investments',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/investments');
                },
                child: const Text('View All'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...investmentProvider.topInvestments.map((investment) {
            return InvestmentCard(
              investment: investment,
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/investments/detail',
                  arguments: investment.id,
                );
              },
            );
          }).toList(),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/investments/add');
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
            ),
            child: const Text('Add New Investment'),
          ),
        ],
      ),
    );
  }

  Widget _buildReturnMetric(
      BuildContext context, String title, String value, Color valueColor) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }

  Color _getInvestmentTypeColor(String type) {
    switch (type) {
      case 'Equity':
        return Colors.blue;
      case 'Debt':
        return Colors.green;
      case 'Gold':
        return Colors.amber;
      case 'Real Estate':
        return Colors.brown;
      case 'Fixed Deposit':
        return Colors.purple;
      case 'PPF':
        return Colors.teal;
      case 'NPS':
        return Colors.indigo;
      default:
        return Colors.grey;
    }
  }
}
