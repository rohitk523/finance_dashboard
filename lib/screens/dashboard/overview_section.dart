// lib/screens/dashboard/overview_section.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/transaction_provider.dart';
import '../../providers/investment_provider.dart';
import '../../providers/tax_provider.dart';
import '../../widgets/charts/income_expense_bar_chart.dart';
import '../../widgets/cards/tax_summary_card.dart';
import '../../utils/currency_formatter.dart';

class OverviewSection extends StatelessWidget {
  const OverviewSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final transactionProvider = Provider.of<TransactionProvider>(context);
    final investmentProvider = Provider.of<InvestmentProvider>(context);
    final taxProvider = Provider.of<TaxProvider>(context);

    final totalIncome = transactionProvider.totalIncome;
    final totalExpense = transactionProvider.totalExpense;
    final netSavings = totalIncome - totalExpense;
    final investmentValue = investmentProvider.totalInvestmentValue;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Financial summary cards
          Row(
            children: [
              Expanded(
                child: _buildSummaryCard(
                  context,
                  'Total Income',
                  formatCurrency(totalIncome),
                  Colors.green[100]!,
                  Colors.green,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildSummaryCard(
                  context,
                  'Total Expenses',
                  formatCurrency(totalExpense),
                  Colors.red[100]!,
                  Colors.red,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildSummaryCard(
                  context,
                  'Net Savings',
                  formatCurrency(netSavings),
                  Colors.blue[100]!,
                  Colors.blue,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildSummaryCard(
                  context,
                  'Investments',
                  formatCurrency(investmentValue),
                  Colors.purple[100]!,
                  Colors.purple,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),
          const Text(
            'Income vs Expenses',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 240,
            child: IncomeExpenseBarChart(
              incomeData: transactionProvider.monthlyIncome,
              expenseData: transactionProvider.monthlyExpense,
            ),
          ),

          const SizedBox(height: 24),
          const Text(
            'Tax Status',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          TaxSummaryCard(
            taxData: taxProvider.taxSummary,
            onViewDetails: () {
              Navigator.pushNamed(context, '/tax-returns');
            },
          ),

          const SizedBox(height: 24),
          const Text(
            'Recent Transactions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: transactionProvider.recentTransactions.length > 5
                ? 5
                : transactionProvider.recentTransactions.length,
            itemBuilder: (context, index) {
              final transaction = transactionProvider.recentTransactions[index];
              return ListTile(
                leading: Icon(
                  transaction.isIncome
                      ? Icons.arrow_upward
                      : Icons.arrow_downward,
                  color: transaction.isIncome ? Colors.green : Colors.red,
                ),
                title: Text(transaction.description),
                subtitle: Text(transaction.category),
                trailing: Text(
                  formatCurrency(transaction.amount),
                  style: TextStyle(
                    color: transaction.isIncome ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/transactions/detail',
                    arguments: transaction.id,
                  );
                },
              );
            },
          ),

          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/transactions');
            },
            child: const Text('View All Transactions'),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(BuildContext context, String title, String amount,
      Color backgroundColor, Color textColor) {
    return Card(
      elevation: 2,
      color: backgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: textColor,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              amount,
              style: TextStyle(
                color: textColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
