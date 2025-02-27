// lib/widgets/cards/transaction_card.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/transaction_model.dart';
import '../../utils/currency_formatter.dart';

class TransactionCard extends StatelessWidget {
  final Transaction transaction;
  final VoidCallback? onTap;

  const TransactionCard({
    Key? key,
    required this.transaction,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              _buildCategoryIcon(),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transaction.description,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          transaction.category,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (transaction.isTaxDeductible == true)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green[50],
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: Colors.green.shade200),
                            ),
                            child: Text(
                              'Tax Benefit',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.green[800],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    formatCurrency(transaction.amount),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: transaction.isIncome ? Colors.green : Colors.red,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat('dd MMM, yyyy').format(transaction.date),
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
      ),
    );
  }

  Widget _buildCategoryIcon() {
    IconData iconData;
    Color iconColor;

    // You can expand this with more category-specific icons
    switch (transaction.category.toLowerCase()) {
      case 'food & dining':
        iconData = Icons.restaurant;
        iconColor = Colors.orange;
        break;
      case 'shopping':
        iconData = Icons.shopping_bag;
        iconColor = Colors.purple;
        break;
      case 'transportation':
        iconData = Icons.directions_car;
        iconColor = Colors.blue;
        break;
      case 'bills & utilities':
        iconData = Icons.receipt_long;
        iconColor = Colors.teal;
        break;
      case 'entertainment':
        iconData = Icons.movie;
        iconColor = Colors.red;
        break;
      case 'health & medical':
        iconData = Icons.medical_services;
        iconColor = Colors.pink;
        break;
      case 'investment':
        iconData = Icons.trending_up;
        iconColor = Colors.green;
        break;
      case 'salary':
        iconData = Icons.work;
        iconColor = Colors.indigo;
        break;
      case 'rent':
        iconData = Icons.home;
        iconColor = Colors.brown;
        break;
      case 'education':
        iconData = Icons.school;
        iconColor = Colors.cyan;
        break;
      default:
        iconData =
            transaction.isIncome ? Icons.arrow_upward : Icons.arrow_downward;
        iconColor = transaction.isIncome ? Colors.green : Colors.red;
    }

    return CircleAvatar(
      radius: 20,
      backgroundColor: iconColor.withOpacity(0.1),
      child: Icon(
        iconData,
        color: iconColor,
        size: 18,
      ),
    );
  }
}
