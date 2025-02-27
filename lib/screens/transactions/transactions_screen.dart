// lib/screens/transactions/transactions_screen.dart
import 'package:flutter/material.dart';

class TransactionsScreen extends StatelessWidget {
  static const String routeName = '/transactions';

  const TransactionsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions'),
      ),
      body: const Center(
        child: Text('Transactions Screen - To be implemented'),
      ),
    );
  }
}
