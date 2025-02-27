// lib/screens/dashboard/expenses_section.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/transaction_provider.dart';
import '../../widgets/charts/expense_pie_chart.dart';
import '../../utils/currency_formatter.dart';

class ExpensesSection extends StatelessWidget {
  const ExpensesSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final transactionProvider = Provider.of<TransactionProvider>(context);
    final expensesByCategory = transactionProvider.expensesByCategory;
    final totalExpenses = transactionProvider.totalExpense;

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
                        'Total Expenses',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        formatCurrency(totalExpenses),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Expense Breakdown',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 300,
                    child: ExpensePieChart(
                      expenseData: expensesByCategory,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Expense Categories',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: expensesByCategory.length,
            itemBuilder: (context, index) {
              final category = expensesByCategory.keys.elementAt(index);
              final amount = expensesByCategory[category] ?? 0;
              final percentage = (amount / totalExpenses) * 100;

              return ListTile(
                title: Text(category),
                subtitle: LinearProgressIndicator(
                  value: amount / totalExpenses,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _getCategoryColor(index),
                  ),
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      formatCurrency(amount),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${percentage.toStringAsFixed(1)}%',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  // Navigate to transactions filtered by this category
                },
              );
            },
          ),
          const SizedBox(height: 24),
          const Text(
            'Tax-Deductible Expenses',
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
                  _buildTaxDeductibleItem(
                    'Section 80C',
                    150000,
                    transactionProvider.taxDeductibleAmount['80C'] ?? 0,
                  ),
                  const SizedBox(height: 12),
                  _buildTaxDeductibleItem(
                    'Section 80D',
                    50000,
                    transactionProvider.taxDeductibleAmount['80D'] ?? 0,
                  ),
                  const SizedBox(height: 12),
                  _buildTaxDeductibleItem(
                    'Section 80G',
                    100000,
                    transactionProvider.taxDeductibleAmount['80G'] ?? 0,
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton(
                    onPressed: () {
                      // Navigate to tax planning screen
                    },
                    child: const Text('View Tax Planning Suggestions'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaxDeductibleItem(
      String section, double maxLimit, double currentAmount) {
    final percentage = (currentAmount / maxLimit) * 100;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(section),
            Text(
              '${formatCurrency(currentAmount)} / ${formatCurrency(maxLimit)}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: currentAmount / maxLimit,
          backgroundColor: Colors.grey[200],
          valueColor: AlwaysStoppedAnimation<Color>(
            percentage >= 100 ? Colors.green : Colors.orange,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          '${percentage.toStringAsFixed(1)}% utilized',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Color _getCategoryColor(int index) {
    final colors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.pink,
      Colors.amber,
      Colors.indigo,
      Colors.cyan,
    ];

    return colors[index % colors.length];
  }
}
