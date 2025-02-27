// lib/widgets/cards/investment_card.dart

import 'package:flutter/material.dart';
import '../../models/investment_model.dart';
import '../../utils/currency_formatter.dart';

class InvestmentCard extends StatelessWidget {
  final Investment investment;
  final VoidCallback? onTap;

  const InvestmentCard({
    Key? key,
    required this.investment,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentValue = investment.currentValue;
    final investedAmount = investment.investedAmount;
    final profit = currentValue - investedAmount;
    final profitPercentage = (profit / investedAmount) * 100;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTypeIcon(),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          investment.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          investment.type,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        formatCurrency(currentValue),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color:
                              profit >= 0 ? Colors.green[50] : Colors.red[50],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '${profit >= 0 ? '+' : ''}${profitPercentage.toStringAsFixed(2)}%',
                          style: TextStyle(
                            color: profit >= 0 ? Colors.green : Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildInfoColumn('Invested', formatCurrency(investedAmount)),
                  _buildInfoColumn('Profit/Loss', formatCurrency(profit)),
                  _buildInfoColumn('Units', investment.units.toString()),
                  _buildInfoColumn(
                      'NAV/Price', formatCurrency(investment.latestPrice)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeIcon() {
    IconData iconData;
    Color iconColor;

    switch (investment.type) {
      case 'Equity':
        iconData = Icons.trending_up;
        iconColor = Colors.blue;
        break;
      case 'Mutual Fund':
        iconData = Icons.pie_chart;
        iconColor = Colors.purple;
        break;
      case 'Fixed Deposit':
        iconData = Icons.account_balance;
        iconColor = Colors.orange;
        break;
      case 'PPF':
        iconData = Icons.savings;
        iconColor = Colors.teal;
        break;
      case 'Gold':
        iconData = Icons.monetization_on;
        iconColor = Colors.amber;
        break;
      case 'Real Estate':
        iconData = Icons.home;
        iconColor = Colors.brown;
        break;
      default:
        iconData = Icons.attach_money;
        iconColor = Colors.green;
    }

    return CircleAvatar(
      radius: 20,
      backgroundColor: iconColor.withOpacity(0.2),
      child: Icon(
        iconData,
        color: iconColor,
        size: 20,
      ),
    );
  }

  Widget _buildInfoColumn(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
