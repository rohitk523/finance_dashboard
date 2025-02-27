// lib/screens/transactions/transaction_detail_screen.dart
import 'package:flutter/material.dart';

class TransactionDetailScreen extends StatelessWidget {
  static const String routeName = '/transactions/detail';
  final String? transactionId;

  const TransactionDetailScreen({Key? key, this.transactionId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction Details'),
      ),
      body: Center(
        child:
            Text('Transaction Detail Screen - ID: ${transactionId ?? "None"}'),
      ),
    );
  }
}
