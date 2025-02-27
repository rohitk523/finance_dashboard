// lib/widgets/cards/tax_summary_card.dart

import 'package:flutter/material.dart';
import '../../utils/currency_formatter.dart';

class TaxSummaryCard extends StatelessWidget {
  final Map<String, dynamic> taxData;
  final VoidCallback onViewDetails;

  const TaxSummaryCard({
    Key? key,
    required this.taxData,
    required this.onViewDetails,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final financialYear = taxData['financialYear'] as String? ?? 'Current FY';
    final totalIncome = taxData['totalIncome'] as double? ?? 0.0;
    final taxableIncome = taxData['taxableIncome'] as double? ?? 0.0;
    final taxLiability = taxData['taxLiability'] as double? ?? 0.0;
    final totalDeductions = taxData['totalDeductions'] as double? ?? 0.0;
    final taxPaid = taxData['taxPaid'] as double? ?? 0.0;
    final remainingTax = taxLiability - taxPaid;
    final itrStatus = taxData['itrStatus'] as String? ?? 'Pending';

    return Card(
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'FY $financialYear',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    _buildStatusChip(itrStatus),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoCard(
                        'Total Income',
                        formatCurrency(totalIncome),
                        Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildInfoCard(
                        'Tax Liability',
                        formatCurrency(taxLiability),
                        remainingTax > 0 ? Colors.orange : Colors.green,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoCard(
                        'Total Deductions',
                        formatCurrency(totalDeductions),
                        Colors.purple,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildInfoCard(
                        'Remaining Tax',
                        formatCurrency(remainingTax),
                        remainingTax > 0 ? Colors.red : Colors.green,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                LinearProgressIndicator(
                  value: taxLiability > 0 ? taxPaid / taxLiability : 1.0,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    taxPaid >= taxLiability ? Colors.green : Colors.orange,
                  ),
                ),
                const SizedBox(height: 8),
                // Completing lib/widgets/cards/tax_summary_card.dart from where we left off
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Tax Paid: ${formatCurrency(taxPaid)}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      'of ${formatCurrency(taxLiability)}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          InkWell(
            onTap: onViewDetails,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'View Tax Details',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(
                    Icons.arrow_forward,
                    size: 16,
                    color: Colors.blue,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color backgroundColor;
    Color textColor;
    IconData iconData;

    switch (status.toLowerCase()) {
      case 'completed':
        backgroundColor = Colors.green.shade100;
        textColor = Colors.green.shade800;
        iconData = Icons.check_circle;
        break;
      case 'in progress':
        backgroundColor = Colors.blue.shade100;
        textColor = Colors.blue.shade800;
        iconData = Icons.sync;
        break;
      case 'review required':
        backgroundColor = Colors.orange.shade100;
        textColor = Colors.orange.shade800;
        iconData = Icons.warning;
        break;
      case 'error':
        backgroundColor = Colors.red.shade100;
        textColor = Colors.red.shade800;
        iconData = Icons.error;
        break;
      default: // pending
        backgroundColor = Colors.grey.shade100;
        textColor = Colors.grey.shade800;
        iconData = Icons.hourglass_empty;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            iconData,
            size: 14,
            color: textColor,
          ),
          const SizedBox(width: 4),
          Text(
            status,
            style: TextStyle(
              color: textColor,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
